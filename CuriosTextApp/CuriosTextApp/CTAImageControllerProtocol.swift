//
//  CTAImageCropProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/13.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit

protocol CTAImageControllerProtocol{
    func cropImageCircle(imageView:UIView)
    func cropImageRound(imageView:UIView)
    func addImageShadow(imageView:UIView)
    func getDefaultIcon(size:CGRect) -> UIImage
}

extension CTAImageControllerProtocol{
    func cropImageCircle(imageView:UIView){
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.layer.masksToBounds = true
    }
    
    func cropImageRound(imageView:UIView){
        imageView.contentMode = .ScaleAspectFill
        //imageView.layer.cornerRadius = 4.0
        //imageView.clipsToBounds = true
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: 4).CGPath
        imageView.layer.mask = shapeLayer
    }
    
    func addImageShadow(imageView:UIView){
        imageView.layer.shadowPath = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: 4).CGPath
        imageView.layer.shadowColor = UIColor.blackColor().CGColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 10)
        imageView.layer.shadowOpacity = 0.4
        imageView.layer.shadowRadius = 5
    }
    
    func getDefaultIcon(rect:CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        UIColor.whiteColor().setFill()
        UIRectFill(rect)
        let iconImage = UIImage(named: "defaultpublish-icon")
        iconImage?.drawInRect(CGRect(x: (rect.size.width - 50)/2, y: (rect.size.height - 52)/2, width: 50, height: 52), blendMode: .Normal, alpha: 1.0)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image;
    }
}