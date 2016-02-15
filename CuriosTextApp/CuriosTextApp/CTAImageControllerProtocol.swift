//
//  CTAImageCropProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/13.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit

func compressIconImage(image:UIImage) -> NSData{
    let newImage = compressImage(image, maxWidth: 600)
    let newData = UIImageJPEGRepresentation(newImage, 0.3)
    return newData!
}

func compressJPGImage(image:UIImage) -> NSData{
    let newImage = compressImage(image)
    let newData = UIImageJPEGRepresentation(newImage, 0.1)
    return newData!
}

func compressPNGImage(image:UIImage) -> NSData{
    let newImage = compressImage(image)
    let newData = UIImagePNGRepresentation(newImage)
    return newData!
}

func compressImage(image:UIImage, maxWidth:CGFloat = UIScreen.mainScreen().bounds.width * 3) -> UIImage{
    let maxWidth = maxWidth
    let maxHeight = maxWidth
    let imageSize = image.size
    var rate:CGFloat
    let imageRate = imageSize.width / imageSize.height
    let maxRate = maxWidth / maxHeight
    if image.size.width > maxWidth*8 || image.size.height > maxHeight*8{
        if maxRate > imageRate{
            rate = maxHeight*8 / imageSize.height
        }else {
            rate = maxWidth*8 / imageSize.width
        }
    }else {
        if maxRate > imageRate{
            rate = maxWidth / imageSize.width
        }else {
            rate = maxHeight / imageSize.height
        }
    }
    let newSize = CGSize.init(width: rate*image.size.width, height: rate*image.size.height)
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1)
    image.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.width), blendMode: .Normal, alpha: 1.0)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}

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
        let rate = rect.size.width / 174.00
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        UIColor.whiteColor().setFill()
        UIRectFill(rect)
        let iconImage = UIImage(named: "defaultpublish-icon")
        let imgWidth = 50 * rate
        let imgHeight = 52 * rate
        iconImage?.drawInRect(CGRect(x: (rect.size.width - imgWidth)/2, y: (rect.size.height - imgHeight)/2, width: imgWidth, height: imgHeight), blendMode: .Normal, alpha: 1.0)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image;
    }
}