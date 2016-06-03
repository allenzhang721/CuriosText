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
    
    private var page: CTAPage?
    
    private var canvas: AniCanvas?
    
    var publishModel:CTAPublishModel?{
        didSet{
            self.reloadCell()
            self.loadAnimation()
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
    
    func setViewColor(color:UIColor){
        if self.cellColorView == nil {
            let cellBoud = CGRect(x: -1, y: -1, width: self.bounds.width+2, height: self.bounds.height+2)
            self.cellColorView = UIView(frame: cellBoud)
            self.cropImageRound(self.cellColorView!)
            self.addSubview(self.cellColorView!)
            self.bringSubviewToFront(self.cellColorView!)
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
        self.isPlaying = false
        self.isPause = false
        self.loadErrorCount = 0
        self.isLoading = false
        self.bringSubviewToFront(self.cellImageView)
        if self.cellColorView != nil {
            self.bringSubviewToFront(self.cellColorView!)
        }
        if publishModel != nil {
            self.imgLoaded = false
            let defaultImg = self.getDefaultIcon(self.bounds)
            let imagePath = CTAFilePath.publishFilePath+self.publishModel!.publishIconURL
            let imageURL = NSURL(string: imagePath)!
            self.cellImageView.kf_setImageWithURL(imageURL, placeholderImage: defaultImg, optionsInfo: [.Transition(ImageTransition.Fade(1))]) { (image, error, cacheType, imageURL) -> () in
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
        let whiteImg = self.getWhiteBg(self.bounds)
        self.cellImageView.image = whiteImg
        if self.isLoadComplete{
            self.previewView.dataSource = nil
            self.previewView.aniDataSource = nil
            self.previewView.reloadData({
            })
        }
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
                self.bringSubviewToFront(self.cellImageView)
                if self.cellColorView != nil {
                    self.bringSubviewToFront(self.cellColorView!)
                }
                self.isLoading = true
                self.loadAgainHandler = nil
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
                sf.cropImageRound(previewView)
                sf.bringSubviewToFront(sf.cellImageView)
                if sf.cellColorView != nil {
                    sf.bringSubviewToFront(sf.cellColorView!)
                }
            }
            
            let previewView = sf.previewView
            previewView.backgroundColor = UIColor(hexString: canvas.canvas.backgroundColor)
            previewView.dataSource = canvas
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
            strongSelf.isLoadComplete = true
            strongSelf.bringSubviewToFront(strongSelf.previewView)
            if strongSelf.cellColorView != nil {
                strongSelf.bringSubviewToFront(strongSelf.cellColorView!)
            }
            if strongSelf.loadCompeteHandler != nil {
                strongSelf.loadCompeteHandler!()
                strongSelf.loadCompeteHandler = nil
            }
            if strongSelf.loadAgainHandler != nil {
                strongSelf.loadAgainHandler!()
                strongSelf.loadAgainHandler = nil
            }
        })
    }
    
    func readyFailed() -> (){
        self.isLoading = false
        dispatch_async(dispatch_get_main_queue(), {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.isLoadComplete = false
            strongSelf.bringSubviewToFront(strongSelf.cellImageView)
            if strongSelf.cellColorView != nil {
                strongSelf.bringSubviewToFront(strongSelf.cellColorView!)
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
        self.isPlaying = false
        self.isPause = false
        let time: NSTimeInterval = NSTimeInterval(1.0)
        let delay = dispatch_time(DISPATCH_TIME_NOW,
                                  Int64(time * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) { [weak self] in
            self?.playAnimation()
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
    
    func getEndImg(completionHandler: ((img: UIImage?) -> ())){
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

extension CTAFullPublishesCell: CTAPreviewCanvasViewDataSource {
    
    func canvasViewWithPage(view: CTAPreviewCanvasView) -> PageVMProtocol? {
        
        return page
    }
}