//
//  AsyncDrawing+Container.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 3/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
import PromiseKit
import Kingfisher

func asyncImage(_ imagePicker: (@escaping (UIImage) -> ()) -> (), position: CGPoint, rotation: CGFloat, size: CGSize, alpha: CGFloat) -> Promise<Drawable> {
    
    return Promise { fullfill, reject in
        imagePicker { image in
            let drawable = ImageDrawing(position: position, size: size, rotation: rotation, alpha: alpha, image: image)
            fullfill(drawable)
        }
    }
}

func retriveImageBy(_ imgeID: String, baseURL: URL, imageAccess:((String) -> UIImage?)? = nil ,local: Bool) -> (@escaping (UIImage) -> ()) -> () {
    
    func finished(_ f:  @escaping (UIImage) -> ()) {
        if local {
            if let imageAccess = imageAccess, let image = imageAccess(imgeID) {
                f(image)
            } else {
                f(UIImage())
            }
            
        } else {
            let imageURL = baseURL.appendingPathComponent(imgeID)
//            let imageURL = NSURL(string: "https://d13yacurqjgara.cloudfront.net/users/458522/screenshots/2561596/untitled-1_1x.jpg")!
          KingfisherManager.shared.retrieveImage(with: imageURL, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                
                if let image = image {
                    f(image)
                } else {
                    f(UIImage())
                }
            })
        }  
    }
    
    return finished
    
}

func drawPageWithNoImage(_ page: CTAPage, containImage: Bool = true) -> UIImage? {
    let count = page.containers.count
    guard (containImage && count > 1) || (!containImage && count >= 1) else {return nil}
    if containImage {
    let noImageContainers = page.containers.dropFirst()
    let noImageDrawables = noImageContainers.map{$0 as ContainerVMProtocol}.map { (container) -> Drawable in
           let textContainer = container as! TextContainerVMProtocol
                
                let position = container.center
                let rotation = container.radius
                let size = container.size
                let alpha = container.alphaValue
                
                let attributeText = textContainer.textElement!.attributeString
                
                return TextDrawing(position: position, size: size, rotation: rotation, alpha: alpha, attributeString: attributeText)
    }
    
    UIGraphicsBeginImageContextWithOptions(page.size, false, UIScreen.main.scale)
    
//     back ground
//    let path = UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: page.size))
//    UIColor.blackColor().setFill()
//    path.fill()
    
    for d in noImageDrawables {
        if let d = d as? TextDrawable {
            drawingText(d)
        } else if let d = d as? ImageDrawable {
            drawingImage(d)
        }
    }
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
        
    } else {
        let noImageContainers = page.containers
        let noImageDrawables = noImageContainers.map{$0 as ContainerVMProtocol}.map { (container) -> Drawable in
            let textContainer = container as! TextContainerVMProtocol
            
            let position = container.center
            let rotation = container.radius
            let size = container.size
            
            let attributeText = textContainer.textElement!.attributeString
            
            return TextDrawing(position: position, size: size, rotation: rotation, alpha: textContainer.alphaValue, attributeString: attributeText)
        }
        
        UIGraphicsBeginImageContextWithOptions(page.size, false, UIScreen.main.scale)
        
//         back ground
//            let path = UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: page.size))
//            UIColor.blackColor().setFill()
//            path.fill()
        
        for d in noImageDrawables {
            if let d = d as? TextDrawable {
                drawingText(d)
            } else if let d = d as? ImageDrawable {
                drawingImage(d)
            }
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

func draws(_ page: CTAPage, atBegan: Bool, filterWithVisible: Bool = true, baseURL: URL, imageAccess:((String) -> UIImage?)? = nil ,local: Bool, completedHandler:@escaping (AResult<UIImage>) -> ()) {
    
    let animations = atBegan ? page.animatoins : page.animatoins.reversed()
    let needContainers = filterWithVisible ? page.containers
        .filter { container -> Bool in
            
            if let animation = (animations.filter{$0.targetiD == container.iD}).first {
                return atBegan ? animation.name.shouldVisalbeBeforeBegan() : animation.name.shouldVisableAfterEnd()
            } else {
                return true
            }
    }.map{$0 as ContainerVMProtocol} : page.containers.map{$0 as ContainerVMProtocol}
 
   let promises = needContainers.map { container -> Promise<Drawable> in
        
        let position = container.center
        let rotation = container.radius
        let size = container.size
        let alpha = container.alphaValue
        
        if let textContainer = container as? TextContainerVMProtocol, container.type == .text {
            let attributeText = textContainer.textElement!.attributeString
            
            return Promise { fullfill, reject in
                let textDraw = TextDrawing(position: position, size: size, rotation: rotation, alpha: alpha, attributeString: attributeText)
                fullfill(textDraw)
            }
        } else if let imageContainer = container as? ImageContainerVMProtocol, container.type == .image {
            let imageName = imageContainer.imageElement!.resourceName
            let alpha = container.alphaValue
            return asyncImage(retriveImageBy(imageName, baseURL: baseURL, imageAccess: imageAccess ,local: local), position: position, rotation: rotation, size: size, alpha: alpha)
        }
        
        fatalError("Container can not map to Promise<Drawable>")
    }

    let backgroundColor = UIColor(hexString: page.backgroundColor) ?? UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    
    drawing(promises, size: page.size, backgroundColor: backgroundColor) { (r) in
        completedHandler(r)
    }
}
