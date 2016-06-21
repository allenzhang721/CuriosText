//
//  CTAImageCropProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/13.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit

func getIconData(image:UIImage) -> NSData{
    let newImage = compressIconImage(image)
    let newData = UIImageJPEGRepresentation(newImage, 0.5)
    return newData!
}

func compressJPGImage(image:UIImage, maxWidth:CGFloat = 1280.00, needScale:Bool = false) -> NSData{
    let newImage = compressImage(image, maxWidth: maxWidth, needScale: needScale)
    var newData:NSData?
    newData = UIImageJPEGRepresentation(newImage, 0.5)
    
    return newData!
}

func compressPNGImage(image:UIImage) -> NSData{
    let newImage = compressImage(image)
    let newData = UIImagePNGRepresentation(newImage)
    return newData!
}

func compressIconImage(image:UIImage) -> UIImage{
    let maxWidth:CGFloat = 600.0
    let maxHeight = maxWidth
    let imageSize = image.size
    let imageRate = imageSize.width / imageSize.height
    let maxRate = maxWidth / maxHeight
    var rate:CGFloat
    if maxRate > imageRate{
        rate = maxWidth / imageSize.width
    }else {
        rate = maxHeight / imageSize.height
    }
    let newSize = CGSize.init(width: rate*image.size.width, height: rate*image.size.height)
    let imgSize = CGSize.init(width: maxWidth, height: maxHeight)
    UIGraphicsBeginImageContextWithOptions(imgSize, false, 1)
    image.drawInRect(CGRect(x: (imgSize.width - newSize.width)/2, y: (imgSize.height - newSize.height)/2, width: newSize.width, height: newSize.height), blendMode: .Normal, alpha: 1.0)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}

func compressImage(image:UIImage, maxWidth:CGFloat = 1280.00, needScale:Bool = false) -> UIImage{
    let maxWidth = maxWidth
    let maxHeight = maxWidth
    let imageSize = image.size
    let imageScale = image.scale
    var imageW = imageSize.width
    var imageH = imageSize.height
    if needScale{
        imageW = imageW*imageScale
        imageH = imageH*imageScale
    }

    var rate:CGFloat
    let imageRate = imageW / imageH
    let maxRate = maxWidth / maxHeight
    if imageW > maxWidth*6 || imageH > maxHeight*6{
        if maxRate > imageRate{
            rate = maxHeight*6 / imageH
        }else {
            rate = maxWidth*6 / imageW
        }
    }else {
        if maxRate > imageRate{
            rate = maxWidth / imageW
        }else {
            rate = maxHeight / imageH
        }
    }
    var newImage:UIImage!
    if rate < 1{
        let newSize = CGSize.init(width: rate*imageW, height: rate*imageH)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1)
        image.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height), blendMode: .Normal, alpha: 1.0)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }else {
        newImage = image
    }
    return newImage
}

func addCellShadow(cell:UIView){
    cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: 0).CGPath
    cell.layer.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.67).CGColor
    cell.layer.shadowOffset = CGSize(width: 0, height: 2)
    cell.layer.shadowOpacity = 1
    cell.layer.shadowRadius = 13
}

protocol CTAImageControllerProtocol{
    func cropImageCircle(imageView:UIView)
    func cropImageRound(imageView:UIView)
    func addImageShadow(imageView:UIView)
    func getDefaultIcon(rect:CGRect) -> UIImage
    func getWhiteBg(rect:CGRect) -> UIImage
}

extension CTAImageControllerProtocol{
    func cropImageCircle(imageView:UIView){
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.layer.masksToBounds = true
    }
    
    func cropImageRound(imageView:UIView){
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.cornerRadius = 4.0
        imageView.clipsToBounds = true
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: 4).CGPath
        imageView.layer.mask = shapeLayer
    }
    
    func addImageShadow(imageView:UIView){
        imageView.layer.shadowPath = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: 4).CGPath
        imageView.layer.shadowColor = UIColor.blackColor().CGColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.shadowRadius = 5
    }
    
    func getDefaultIcon(rect:CGRect) -> UIImage {
        let rate = rect.size.width / 174.00
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        UIColor.whiteColor().setFill()
        UIRectFill(rect)
        let iconImage = UIImage(named: "defaultpublish-icon")
        let imgWidth = 22 * rate
        let imgHeight = 23 * rate
        iconImage?.drawInRect(CGRect(x: (rect.size.width - imgWidth)/2, y: (rect.size.height - imgHeight)/2, width: imgWidth, height: imgHeight), blendMode: .Normal, alpha: 1.0)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image;
    }
    
    func getWhiteBg(rect:CGRect) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        UIColor.whiteColor().setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image;
    }
}