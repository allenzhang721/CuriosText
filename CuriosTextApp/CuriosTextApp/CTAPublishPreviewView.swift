//
//  CTAPublishPreviewView.swift
//  CuriosTextApp
//
//  Created by allen on 16/6/20.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit
import Kingfisher

class CTAPublishPreviewView: UIView, CTAImageControllerProtocol{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    fileprivate var page: CTAPage?
    
    fileprivate var canvas: AniCanvas?
    
    var cellImageView:UIImageView!
    
    var previewView: AniPlayCanvasView!
    
    var animationEnable:Bool = false
    
    var isLoadComplete:Bool = false
    
    var isLoading:Bool = false
    
    var isLoadingCancel:Bool = false
    
    var loadErrorCount:Int = 0
    
    var loadCompeteHandler:(() -> Void)?
    
    var loadAgainHandler:(() -> Void)?
    
    var imgLoaded:Bool = false
    
    var isPlaying:Bool = false
    
    var isPause:Bool = false
    
    var delegate:CTAPublishPreviewViewDelegate?
    
    var publishModel:CTAPublishModel?
    
    func initView(){
        self.cellImageView = UIImageView(frame: self.bounds)
        self.addSubview(self.cellImageView)
    }
    
    func releaseImg(){
        self.cellImageView.image = nil
        self.imgLoaded = false
    }
    
    func releasePreviewView(){
        if self.isLoadComplete{
            self.previewView.dataSource = nil
            self.previewView.aniDataSource = nil
            self.previewView.reloadData({
            })
            self.isLoadComplete = false
        }else if self.isLoading{
            self.isLoadingCancel = true
        }
        self.publishModel = nil
        self.isPlaying = false
        self.isPause = false
    }
    
    func loadImg() {
        self.cellImageView.frame = self.bounds
        self.bringSubview(toFront: self.cellImageView)
        if self.publishModel != nil {
            let defaultImg:UIImage = self.getDefaultIcon(self.bounds)
            self.imgLoaded = false
            var previewIconURL = ""
            if self.animationEnable{
                previewIconURL = self.publishModel!.publishIconURL
            }else {
                previewIconURL = self.publishModel!.previewIconURL
                if previewIconURL == "" {
                    previewIconURL = self.publishModel!.publishIconURL
                }
            }
            let imagePath = CTAFilePath.publishFilePath+previewIconURL
            let imageURL = URL(string: imagePath)!
            self.cellImageView.kf.setImage(with: imageURL, placeholder: defaultImg, options: [.transition(ImageTransition.fade(1))]) { (image, error, cacheType, imageURL) -> () in
                if error != nil {
                    self.cellImageView.image = defaultImg
                }else{
                    self.imgLoaded = true
                }
            }
        }else {
            self.releaseImg()
        }
    }
    
    func loadPreviewView(){
        if self.delegate != nil{
            self.delegate?.beginLoad()
        }
        self.isPlaying = false
        self.isPause = false
        self.loadErrorCount = 0
        self.isLoading = false
        self.isLoadComplete = false
        self.loadAnimation()
    }
    
    func loadAnimation(){
        if self.animationEnable{
            if self.isLoading{
                self.loadAgainHandler = self.loadAnimation
                return
            }
            if self.publishModel != nil {
                self.isLoadComplete = false
                let purl = CTAFilePath.publishFilePath
                let url = purl + publishModel!.publishURL
                self.isLoading = true
                self.loadAgainHandler = nil
                self.bringSubview(toFront: self.cellImageView)
                BlackCatManager.sharedManager.retrieveDataWithURL(URL(string: url)!, optionsInfo: nil, progressBlock: nil, completionHandler: {[weak self](data, error, cacheType, URL) -> () in
                    if let strongSelf = self{
                        if !strongSelf.isLoadingCancel{
                            if let data = data,
                                let page = NSKeyedUnarchiver.unarchiveObject(with: data) as? CTAPage {
                                DispatchQueue.main.async(execute: { () -> Void in
                                    if let publishModel = strongSelf.publishModel {
                                        strongSelf.page = page
                                        let acanvas = page.toAniCanvas()
                                        strongSelf.canvas = acanvas
                                        // get Image
                                        let url = Foundation.URL(string: CTAFilePath.publishFilePath + publishModel.publishID)!
                                        for c in acanvas.containers {
                                            if let content = c.contents.first, content.type == .Image {
                                                let imageName = content.content.source.ImageName
                                                let imageURL = url.appendingPathComponent(imageName)
                                                KingfisherManager.shared.retrieveImage(with: imageURL, options: nil, progressBlock: nil, completionHandler: {[weak self] (image, error, cacheType, imageURL) in
                                                    guard let sf = self else { return }
                                                    if sf.isLoadingCancel{
                                                        sf.isLoadingCancel = false
                                                        return
                                                    }
                                                    if error != nil {
                                                        sf.readyFailed()
                                                    }else {
                                                        let retriver = { (name: String,  handler: (String, UIImage?) -> ()) in
                                                            handler(name, image)
                                                        }
                                                        c.imageRetriver = retriver
                                                        sf.readyPreView(acanvas, publishModel: publishModel, completed: sf.readyCompleted)
                                                    }
                                                    })
                                                break
                                            }
                                        }
                                    }
                                })
                            }
                        }else {
                            strongSelf.isLoadingCancel = false
                        }
                    }
                })
            }
        }
    }
    
    //  -- EMIAOSTEIN, 10/04/16, 11:54
    func readyPreView(_ canvas: AniCanvas, publishModel: CTAPublishModel, completed:@escaping () -> ()) {
        DispatchQueue.main.async { [weak self] in
            guard let sf = self else {return}
            if sf.previewView == nil {
                let previewView = AniPlayCanvasView(frame: CGRect(origin: CGPoint.zero, size: canvas.size))
                let scale = min(sf.bounds.size.width / canvas.size.width, sf.bounds.size.height / canvas.size.height)
                previewView.center = CGPoint(x: sf.bounds.midX, y: sf.bounds.midY)
                previewView.transform = CGAffineTransform(scaleX: scale, y: scale)
                
                previewView.completedBlock = {[weak self] in
                    self?.playComplete()
                }
                sf.addSubview(previewView)
                sf.sendSubview(toBack: previewView)
                sf.previewView = previewView
            }
            
            let previewView = sf.previewView
            previewView?.backgroundColor = UIColor(hexString: canvas.canvas.backgroundColor)
            previewView?.dataSource = canvas
            previewView?.changeDataSource()
            previewView?.aniDataSource = canvas
            previewView?.reloadData { [weak self] in
                if let sf = self {
                    sf.previewView.ready()
                    completed()
                }
            }
        }
    }
    
    func readyCompleted() -> () {
        self.isLoading = false
        DispatchQueue.main.async(execute: {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.bringSubview(toFront: strongSelf.previewView)
            strongSelf.previewView.alpha = 0
            UIView.animate(withDuration: 0.2, animations: {
                strongSelf.previewView.alpha = 1
            })
            if strongSelf.delegate != nil{
                strongSelf.delegate?.loadComplete()
            }
            strongSelf.isLoadComplete = true
            if strongSelf.loadCompeteHandler != nil {
                strongSelf.loadCompeteHandler!()
                strongSelf.loadCompeteHandler = nil
            }
            if strongSelf.loadAgainHandler != nil {
                strongSelf.loadAgainHandler = nil
            }
        })
    }
    
    func readyFailed() -> (){
        self.isLoading = false
        DispatchQueue.main.async(execute: {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.bringSubview(toFront: strongSelf.cellImageView)
            strongSelf.isLoadComplete = false
            if strongSelf.loadErrorCount < 3{
                strongSelf.loadErrorCount += 1
                strongSelf.loadAnimation()
            }else {
                if strongSelf.delegate != nil{
                    strongSelf.delegate?.loadFailed()
                }
                strongSelf.loadCompeteHandler = nil
                if strongSelf.loadAgainHandler != nil {
                    strongSelf.loadAgainHandler!()
                    strongSelf.loadAgainHandler = nil
                }
            }
        })
    }
    
    func playAnimation(){
        if self.isLoadComplete{
            if self.publishModel != nil {
                if !self.isPlaying{
                    if !self.isPause{
                        self.previewView.ready()
                    }
                    self.previewView.play()
                    self.isPlaying = true
                    self.isPause = false
                }
            }
        }else {
            self.loadCompeteHandler = self.playAnimation
        }
    }
    
    func playComplete(){
        if self.isLoadComplete{
            self.isPause = false
            let time: TimeInterval = TimeInterval(5.0)
            let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delay) { [weak self] in
                guard let sf = self else {return}
                if sf.isPlaying {
                    sf.isPlaying = false
                    sf.playAnimation()
                }
            }
        }
    }
    
    func pauseAnimation(){
        if self.isLoadComplete{
            if self.publishModel != nil && self.isPlaying{
                if self.isPlaying {
                    self.previewView.pause()
                }
                self.isPlaying = false
                self.isPause = true
            }
        }
        
    }
    
    func stopAnimation(){
        if self.isLoadComplete{
            if self.publishModel != nil && self.isPlaying{
                self.previewView.ready()
                self.isPlaying = false
                self.isPause = false
            }
        }
    }

    func getPublishImg(_ completionHandler: @escaping ((_ img: UIImage?) -> ())){
        if self.isLoadComplete{
            if self.publishModel != nil {
                let url = URL(string: CTAFilePath.publishFilePath + self.publishModel!.publishID)
                draws(self.page!, atBegan: false, baseURL: url!, imageAccess: nil, local: false) { (response) -> () in
                    switch response {
                    case .success(let image):
                        completionHandler(image)
                    default:
                        let defaultImg = self.getDefaultIcon(self.bounds)
                        completionHandler(defaultImg)
                    }
                }
//              draw(<#T##page: CTAPage##CTAPage#>, atBegan: <#T##Bool#>, baseURL: <#T##URL#>, local: <#T##Bool#>, completedHandler: <#T##(Result<UIImage>) -> ()#>)
//              
//              draw(sf.page, atBegan: false, baseURL: sf.document.cacheImagePath, imageAccess: sf.document.imageBy ,local: true)

            }else {
                let defaultImg = self.getDefaultIcon(self.bounds)
                completionHandler(defaultImg)
            }
        }else {
            if self.imgLoaded{
                let img = self.cellImageView.image
                completionHandler(img)
            }else {
                let defaultImg = self.getDefaultIcon(self.bounds)
                completionHandler(defaultImg)
            }
        }
    }
    
    func getPage() -> CTAPage?{
        if self.isLoadComplete{
            if self.publishModel != nil {
                return self.page
            }else {
                return nil
            }
        }else {
            return nil
        }
    }
}

extension CTAPublishPreviewView: CTAPreviewCanvasViewDataSource {
    
    func canvasViewWithPage(_ view: CTAPreviewCanvasView) -> PageVMProtocol? {
        
        return page
    }
}

protocol CTAPublishPreviewViewDelegate {
    func beginLoad();
    func loadComplete();
    func loadFailed();
}
