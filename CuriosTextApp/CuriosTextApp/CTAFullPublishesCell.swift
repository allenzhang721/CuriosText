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
    
    private let page = EditorFactory.generateRandomPage()
    
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
        let size = CGSize.init(width: self.frame.width, height: self.frame.height)
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.whiteColor().setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if publishModel != nil {
            let imagePath = CTAFilePath.publishFilePath+self.publishModel!.publishIconURL
            let imageURL = NSURL(string: imagePath)!
            self.cellImageView.kf_showIndicatorWhenLoading = true
            self.cellImageView.kf_setImageWithURL(imageURL, placeholderImage: image, optionsInfo: [.Transition(ImageTransition.Fade(1))]) { (image, error, cacheType, imageURL) -> () in
            }
        }else{
            self.cellImageView.image = image
        }
    }
    
    func loadAnimation(){
        if self.animationEnable{
            // add preview
            // refresh data
            let preview = CTAPreviewCanvasView(frame: bounds)
            preview.center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
            preview.datasource = self
            addSubview(preview)
            previewView = preview
//            previewView.reloadData()
        }
    }
    
    func playAnimation(){
        if self.animationEnable{
            // preview play
            previewView.reloadData()
            previewView.play()
        }
    }
    
    func pauseAnimation(){
        
    }
    
    func stopAnimation(){
        
    }
}

extension CTAFullPublishesCell: CTAPreviewCanvasViewDataSource {
    
    func canvasViewWithPage(view: CTAPreviewCanvasView) -> PageVMProtocol {
        
        return page
    }
}