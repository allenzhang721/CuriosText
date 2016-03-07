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
        }
    }
    
    var isVisible:Bool = false
    
    var cellImageView:UIImageView!
    
    var previewView: CTAPreviewCanvasView!
    
    var animationEnable:Bool = false{
        didSet{
            self.loadAnimation()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cellImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        self.cropImageRound(self.cellImageView)
        self.addImageShadow(self)
        self.addSubview(self.cellImageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadCell(){
        if publishModel != nil {
            let defaultImg = self.getDefaultIcon(self.bounds)
            let imagePath = CTAFilePath.publishFilePath+self.publishModel!.publishIconURL
            let imageURL = NSURL(string: imagePath)!
            self.cellImageView.kf_showIndicatorWhenLoading = true
            self.cellImageView.kf_setImageWithURL(imageURL, placeholderImage: defaultImg, optionsInfo: [.Transition(ImageTransition.Fade(1))]) { (image, error, cacheType, imageURL) -> () in
                if error != nil {
                    self.cellImageView.image = defaultImg
                }
                self.cellImageView.kf_showIndicatorWhenLoading = false
            }
        }else{
            let whiteImg = self.getWhiteBg(self.bounds)
            self.cellImageView.image = whiteImg
        }
    }
    
    func loadAnimation(){
        if self.animationEnable{
            
            debug_print("Load Animation", context: previewConttext)
            // add preview
            // refresh data
            let preview = CTAPreviewCanvasView(frame: bounds)
            preview.center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
            preview.datasource = self
            addSubview(preview)
            previewView = preview
            
            
        }
    }
    
    func playAnimation(){
        if self.animationEnable{
//            // preview play
//            previewView?.play()
            
            if let publishModel = publishModel {
                
                let purl = CTAFilePath.publishFilePath
                let url = purl + publishModel.publishURL
                debug_print("get Url = \(url)", context: previewConttext)
                BlackCatManager.sharedManager.retrieveDataWithURL(NSURL(string: url)!, optionsInfo: nil, progressBlock: nil, completionHandler: {[weak self] (data, error, cacheType, URL) in
                    
                    if let strongSelf = self {
                        if let data = data,
                            let page = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? CTAPage {
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                debug_print("--- Play Animation ---")
                                strongSelf.page = page
                                let url = NSURL(string: CTAFilePath.publishFilePath + publishModel.publishID)
                                
                                strongSelf.previewView.imageAccessBaseURL = url
                                strongSelf.previewView.imageAccess = downloadImage
                                strongSelf.previewView.reloadData() {
                                    strongSelf.previewView.play()
                                }
                            })
                        }
                    }
                    })
            }
        }
    }
    
    
    func pauseAnimation(){
        previewView.pause()
    }
    
    func stopAnimation(){
        previewView.stop()
    }
}

extension CTAFullPublishesCell: CTAPreviewCanvasViewDataSource {
    
    func canvasViewWithPage(view: CTAPreviewCanvasView) -> PageVMProtocol? {
        
        return page
    }
}