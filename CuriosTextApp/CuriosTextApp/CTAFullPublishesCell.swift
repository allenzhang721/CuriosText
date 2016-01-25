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
    
    var publishModel:CTAPublishModel?{
        didSet{
            self.reloadCell()
        }
    }
    
    var isVisible:Bool = false
    
    var cellImageView:UIImageView!
    
    var animationEnable:Bool = false{
        didSet{
            self.reloadAnimation()
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
    
    func reloadAnimation(){
        if self.animationEnable{
            
        }
    }
    
    func playAnimation(){
        if self.animationEnable{
            
        }
    }
    
    func pauseAnimation(){
        
    }
    
    func stopAnimation(){
        
    }
}