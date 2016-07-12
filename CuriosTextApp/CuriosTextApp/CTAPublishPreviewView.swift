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
    
    private var page: CTAPage?
    
    private var canvas: AniCanvas?
    
    var cellImageView:UIImageView!
    
    var previewView: AniPlayCanvasView!
    
    var animationEnable:Bool = false
    
    var isLoadComplete:Bool = false
    
    var isLoading:Bool = false
    
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
    }
    
    func releasePreviewView(){
        if self.isLoadComplete{
            self.previewView.dataSource = nil
            self.previewView.aniDataSource = nil
            self.previewView.reloadData({
            })
            self.isLoadComplete = false
        }
        self.publishModel = nil
    }
    
    func loadImg() {
        self.cellImageView.frame = self.bounds
        self.bringSubviewToFront(self.cellImageView)
        if self.publishModel != nil {
            var defaultImg:UIImage?
            if self.cellImageView.image != nil {
                defaultImg = self.cellImageView.image
            }else {
                defaultImg = self.getDefaultIcon(self.bounds)
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
            let imageURL = NSURL(string: imagePath)!
            self.cellImageView.kf_setImageWithURL(imageURL, placeholderImage: defaultImg, optionsInfo: [.Transition(ImageTransition.Fade(1))]) { (image, error, cacheType, imageURL) -> () in
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
                self.bringSubviewToFront(self.cellImageView)
                BlackCatManager.sharedManager.retrieveDataWithURL(NSURL(string: url)!, optionsInfo: nil, progressBlock: nil, completionHandler: {[weak self](data, error, cacheType, URL) -> () in
                    if let strongSelf = self {
                        if let data = data,
                            let page = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? CTAPage {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                if let publishModel = strongSelf.publishModel {
                                    strongSelf.page = page
                                    let acanvas = page.toAniCanvas()
                                    strongSelf.canvas = acanvas
                                    // get Image
                                    let url = NSURL(string: CTAFilePath.publishFilePath + publishModel.publishID)!
                                    for c in acanvas.containers {
                                        if let content = c.contents.first where content.type == .Image {
                                            let imageName = content.content.source.ImageName
                                            let imageURL = url.URLByAppendingPathComponent(imageName)
                                            KingfisherManager.sharedManager.retrieveImageWithURL(imageURL, optionsInfo: nil, progressBlock: nil, completionHandler: {[weak self] (image, error, cacheType, imageURL) in
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
    func readyPreView(canvas: AniCanvas, publishModel: CTAPublishModel, completed:() -> ()) {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            guard let sf = self else {return}
            if sf.previewView == nil {
                let previewView = AniPlayCanvasView(frame: CGRect(origin: CGPoint.zero, size: canvas.size))
                let scale = min(sf.bounds.size.width / canvas.size.width, sf.bounds.size.height / canvas.size.height)
                previewView.center = CGPoint(x: sf.bounds.midX, y: sf.bounds.midY)
                previewView.transform = CGAffineTransformMakeScale(scale, scale)
                
                previewView.completedBlock = {[weak self] in
                    self?.playComplete()
                }
                sf.addSubview(previewView)
                sf.sendSubviewToBack(previewView)
                sf.previewView = previewView
            }
            
            let previewView = sf.previewView
            previewView.backgroundColor = UIColor(hexString: canvas.canvas.backgroundColor)
            previewView.dataSource = canvas
            previewView.changeDataSource()
            previewView.aniDataSource = canvas
            previewView.reloadData { [weak self] in
                if let sf = self {
                    sf.previewView.ready()
                    completed()
                }
            }
        }
    }
    
    func readyCompleted() -> () {
        self.isLoading = false
        dispatch_async(dispatch_get_main_queue(), {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.bringSubviewToFront(strongSelf.previewView)
            strongSelf.previewView.alpha = 0
            UIView.animateWithDuration(0.2, animations: {
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
        dispatch_async(dispatch_get_main_queue(), {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.bringSubviewToFront(strongSelf.cellImageView)
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
            let time: NSTimeInterval = NSTimeInterval(5.0)
            let delay = dispatch_time(DISPATCH_TIME_NOW,
                                      Int64(time * Double(NSEC_PER_SEC)))
            dispatch_after(delay, dispatch_get_main_queue()) { [weak self] in
                guard let sf = self else {return}
                sf.isPlaying = false
                sf.playAnimation()
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

    func getPublishImg(completionHandler: ((img: UIImage?) -> ())){
        if self.isLoadComplete{
            if self.publishModel != nil {
                let url = NSURL(string: CTAFilePath.publishFilePath + self.publishModel!.publishID)
                draw(self.page!, atBegan: false, baseURL: url!, local: false) { (response) -> () in
                    switch response {
                    case .Success(let image):
                        completionHandler(img: image)
                    default:
                        let defaultImg = self.getDefaultIcon(self.bounds)
                        completionHandler(img: defaultImg)
                    }
                }
            }else {
                let defaultImg = self.getDefaultIcon(self.bounds)
                completionHandler(img: defaultImg)
            }
        }else {
            if self.imgLoaded{
                let img = self.cellImageView.image
                completionHandler(img: img)
            }else {
                let defaultImg = self.getDefaultIcon(self.bounds)
                completionHandler(img: defaultImg)
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
    
    func canvasViewWithPage(view: CTAPreviewCanvasView) -> PageVMProtocol? {
        
        return page
    }
}

protocol CTAPublishPreviewViewDelegate {
    func beginLoad();
    func loadComplete();
    func loadFailed();
}