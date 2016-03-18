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
    
    var publishModel:CTAPublishModel?{
        didSet{
            self.reloadCell()
            self.loadAnimation()
        }
    }
    
    var isVisible:Bool = false
    
    var cellImageView:UIImageView!
    
    var previewView: CTAPreviewCanvasView!
    
    var animationEnable:Bool = false
    
    var isLoadComplete:Bool = false
    
    var loadCompeteHandler:(() -> Void)?
    
    var imgLoaded:Bool = false
    
    var isPlaying:Bool = false
    
    var cellColorView:UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cellImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
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
            let cellBoud = CGRect.init(x: -1, y: -1, width: self.bounds.width+2, height: self.bounds.height+2)
            self.cellColorView = UIView.init(frame: cellBoud)
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
            self.setDefaultImg()
        }
    }
    
    func setDefaultImg(){
        let whiteImg = self.getWhiteBg(self.bounds)
        self.cellImageView.image = whiteImg
    }
    
    func loadAnimation(){
        if self.animationEnable{
            if self.publishModel != nil {
                if self.previewView == nil {
                    let preview = CTAPreviewCanvasView(frame: bounds)
                    preview.center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
                    preview.datasource = self
                    self.addSubview(preview)
                    self.previewView = preview
                    self.previewView.hidden = true
                    self.previewView.backgroundColor = UIColor.whiteColor()
                    self.cropImageRound(self.previewView)
                    self.bringSubviewToFront(self.cellImageView)
                    if self.cellColorView != nil {
                        self.bringSubviewToFront(self.cellColorView!)
                    }
                }
                self.isLoadComplete = false
                let purl = CTAFilePath.publishFilePath
                let url = purl + publishModel!.publishURL
                self.previewView.hidden = true
                self.cellImageView.hidden = false
                BlackCatManager.sharedManager.retrieveDataWithURL(NSURL(string: url)!, optionsInfo: nil, progressBlock: nil, completionHandler: {[weak self](data, error, cacheType, URL) -> () in
                    if let strongSelf = self {
                        if let data = data,
                            let page = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? CTAPage {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                if let publishModel = strongSelf.publishModel {
                                    strongSelf.page = page
                                    let url = NSURL(string: CTAFilePath.publishFilePath + publishModel.publishID)
                                    strongSelf.previewView.imageAccessBaseURL = url
                                    strongSelf.previewView.imageAccess = downloadImage
                                    strongSelf.previewView.reloadData() {
                                        dispatch_async(dispatch_get_main_queue(), {
                                            strongSelf.isLoadComplete = true
                                            strongSelf.previewView.hidden = false
                                            strongSelf.cellImageView.hidden = true
                                            if strongSelf.loadCompeteHandler != nil {
                                                strongSelf.loadCompeteHandler!()
                                                strongSelf.loadCompeteHandler = nil
                                            }
                                        })
                                    }
                                }
                            })
                        }
                    }
                })
            }
        }
    }
    
    func playAnimation(){
        if self.isLoadComplete{
            if self.publishModel != nil {
                if !self.isPlaying{
                    self.previewView.play()
                    self.isPlaying = true
                }
            }
        }else {
            self.loadCompeteHandler = self.playAnimation
        }
    }
    
    
    func pauseAnimation(){
        if self.isLoadComplete{
            if self.publishModel != nil {
                if self.isPlaying {
                    self.previewView.pause()
                }
                self.isPlaying = false
            }
        }
        
    }
    
    func stopAnimation(){
        if self.isLoadComplete{
            if self.publishModel != nil {
                if self.isPlaying {
                    self.previewView.stop()
                }
                self.isPlaying = false
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
}

extension CTAFullPublishesCell: CTAPreviewCanvasViewDataSource {
    
    func canvasViewWithPage(view: CTAPreviewCanvasView) -> PageVMProtocol? {
        
        return page
    }
}