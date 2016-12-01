//
//  CTAPublishesFullCell.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/21.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit
import Kingfisher

class CTAFullPublishesCell: UIView, CTAImageControllerProtocol {
    
    fileprivate var page: CTAPage?
    
    fileprivate var canvas: AniCanvas?
    
    var publishModel:CTAPublishModel?{
        didSet{
            self.reloadCell()
            self.reLoadAnimation()
        }
    }
    
    var isVisible:Bool = false
    
    var cellImageView:UIImageView!
    
    var previewView: AniPlayCanvasView!
    
    var animationEnable:Bool = false
    
    var isLoadComplete:Bool = false
    
    var loadCompeteHandler:(() -> Void)?
    
    var loadAgainHandler:(() -> Void)?
    
    var imgLoaded:Bool = false
    
    var isPlaying:Bool = false
    
    var isPause:Bool = false
    
    var cellColorView:UIView?
    
    var isLoading:Bool = false
    
    var loadErrorCount:Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cellImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        self.cropImageRound(self.cellImageView)
        self.addSubview(self.cellImageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addShadow(){
        self.addImageShadow(self)
    }
    
    func setViewColor(_ color:UIColor){
        if self.cellColorView == nil {
            let cellBoud = CGRect(x: -1, y: -1, width: self.bounds.width+2, height: self.bounds.height+2)
            self.cellColorView = UIView(frame: cellBoud)
            self.cropImageRound(self.cellColorView!)
            self.addSubview(self.cellColorView!)
            self.bringSubview(toFront: self.cellColorView!)
        }
        self.cellColorView?.backgroundColor = color
    }
    
    func removeViewColor(){
        if self.cellColorView != nil {
            self.cellColorView!.removeFromSuperview()
            self.cellColorView = nil
        }
    }
    
    func reloadCell(){
        self.bringSubview(toFront: self.cellImageView)
        if self.cellColorView != nil {
            self.bringSubview(toFront: self.cellColorView!)
        }
        if publishModel != nil {
            var defaultImg = self.getDefaultIcon(self.bounds)
            if self.imgLoaded{
                defaultImg = self.cellImageView.image!
            }
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
        }else{
            self.resetCell()
        }
    }
    
    func resetCell(){
        let whiteImg = self.getDefaultIcon(self.bounds)
        self.cellImageView.image = whiteImg
        if self.isLoadComplete{
            self.previewView.dataSource = nil
            self.previewView.aniDataSource = nil
            self.previewView.reloadData({
            })
            self.isLoadComplete = false
        }
    }
    
    func reLoadAnimation(){
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
                self.bringSubview(toFront: self.cellImageView)
                if self.cellColorView != nil {
                    self.bringSubview(toFront: self.cellColorView!)
                }
                self.isLoading = true
                self.loadAgainHandler = nil
                BlackCatManager.sharedManager.retrieveDataWithURL(URL(string: url)!, optionsInfo: nil, progressBlock: nil, completionHandler: {[weak self](data, error, cacheType, URL) -> () in
                    if let strongSelf = self {
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
                sf.cropImageRound(previewView)
                sf.bringSubview(toFront: sf.cellImageView)
                if sf.cellColorView != nil {
                    sf.bringSubview(toFront: sf.cellColorView!)
                }
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
            if strongSelf.cellColorView != nil {
                strongSelf.bringSubview(toFront: strongSelf.cellColorView!)
            }
            strongSelf.previewView.alpha = 0
            UIView.animate(withDuration: 0.2, animations: { 
                strongSelf.previewView.alpha = 1
            })
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
            strongSelf.isLoadComplete = false
            strongSelf.bringSubview(toFront: strongSelf.cellImageView)
            if strongSelf.cellColorView != nil {
                strongSelf.bringSubview(toFront: strongSelf.cellColorView!)
            }
            if strongSelf.loadErrorCount < 3{
                strongSelf.loadErrorCount += 1
                strongSelf.loadAnimation()
            }else {
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
            self.isPlaying = false
            self.isPause = false
            let time: TimeInterval = TimeInterval(1.0)
            let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delay) { [weak self] in
                self?.playAnimation()
            }
        }
    }

    func pauseAnimation(){
        if self.isLoadComplete{
            if self.publishModel != nil {
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
            if self.publishModel != nil {
                self.previewView.ready()
                self.isPlaying = false
                self.isPause = false
            }
        }
    }
    
    func getEndImg(_ completionHandler: @escaping ((_ img: UIImage?) -> ())){
        if self.isLoadComplete{
            if self.publishModel != nil {
                let url = URL(string: CTAFilePath.publishFilePath + self.publishModel!.publishID)
              draws(self.page!, atBegan: false, baseURL: url!, local: false) { (response) -> () in
                    switch response {
                    case .success(let image):
                        completionHandler(image)
                    default:
                        let defaultImg = self.getDefaultIcon(self.bounds)
                        completionHandler(defaultImg)
                    }
                }
              
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

extension CTAFullPublishesCell: CTAPreviewCanvasViewDataSource {
    
    func canvasViewWithPage(_ view: CTAPreviewCanvasView) -> PageVMProtocol? {
        
        return page
    }
}
