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

func asyncImage(imagePicker: ((UIImage) -> ()) -> (), position: CGPoint, rotation: CGFloat, size: CGSize) -> Promise<Drawable> {
    
    return Promise { fullfill, reject in
        imagePicker { image in
            let drawable = ImageDrawing(position: position, size: size, rotation: rotation, image: image)
            fullfill(drawable)
        }
    }
}

func retriveImageBy(imgeID: String, baseURL: NSURL, local: Bool) -> ((UIImage) -> ()) -> () {
    
    func finished(f: (UIImage) -> ()) {
        
//        debug_print(baseURL.URLByAppendingPathComponent(imgeID).path!, context: defaultContext)
        if local {
            let image = UIImage(contentsOfFile: baseURL.URLByAppendingPathComponent(imgeID).path!)!
            f(image)
        } else {
            let imageURL = baseURL.URLByAppendingPathComponent(imgeID)
//            let imageURL = NSURL(string: "https://d13yacurqjgara.cloudfront.net/users/458522/screenshots/2561596/untitled-1_1x.jpg")!
            KingfisherManager.sharedManager.retrieveImageWithURL(imageURL, optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                
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

func draw(page: CTAPage, atBegan: Bool, baseURL: NSURL, local: Bool, completedHandler:(Result<UIImage>) -> ()) {
    
    let animations = atBegan ? page.animatoins : page.animatoins.reverse()
    let needContainers = page.containers
        .filter { container -> Bool in
            
            if let animation = (animations.filter{$0.targetiD == container.iD}).first {
                return atBegan ? animation.name.shouldVisalbeBeforeBegan() : animation.name.shouldVisableAfterEnd()
            } else {
                return true
            }
        }.map{$0 as ContainerVMProtocol}
    
    
    
   let promises = needContainers.map { container -> Promise<Drawable> in
        
        let position = container.center
        let rotation = container.radius
        let size = container.size
        
        if let textContainer = container as? TextContainerVMProtocol where container.type == .Text {
            let attributeText = textContainer.textElement!.attributeString
            
            return Promise { fullfill, reject in
                let textDraw = TextDrawing(position: position, size: size, rotation: rotation, attributeString: attributeText)
                fullfill(textDraw)
            }
        } else if let imageContainer = container as? ImageContainerVMProtocol where container.type == .Image {
            let imageName = imageContainer.imageElement!.resourceName
            
            return asyncImage(retriveImageBy(imageName, baseURL: baseURL, local: local), position: position, rotation: rotation, size: size)
        }
        
        fatalError("Container can not map to Promise<Drawable>")
    }

    drawing(promises, size: page.size) { (r) in
        completedHandler(r)
    }
}