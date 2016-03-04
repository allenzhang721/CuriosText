//
//  AsyncDrawing+Container.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 3/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
import PromiseKit

func asyncImage(imagePicker: ((UIImage) -> ()) -> (), position: CGPoint, rotation: CGFloat, size: CGSize) -> Promise<Drawable> {
    
    return Promise { fullfill, reject in
        imagePicker { image in
            let drawable = ImageDrawing(position: position, size: size, rotation: rotation, image: image)
            fullfill(drawable)
        }
    }
}

func retriveImageBy(imgeID: String, baseURL: NSURL) -> ((UIImage) -> ()) -> () {
    
    func finished(f: (UIImage) -> ()) {
        
//        debug_print(baseURL.URLByAppendingPathComponent(imgeID).path!, context: defaultContext)
        let image = UIImage(contentsOfFile: baseURL.URLByAppendingPathComponent(imgeID).path!)!
        
        f(image)
    }
    
    return finished
    
}

func draw(page: CTAPage, atBegan: Bool, baseURL: NSURL, completedHandler:(Result<UIImage>) -> ()) {
    
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
            
            return asyncImage(retriveImageBy(imageName, baseURL: baseURL), position: position, rotation: rotation, size: size)
        }
        
        fatalError("Container can not map to Promise<Drawable>")
    }

    drawing(promises, size: page.size) { (r) in
        completedHandler(r)
    }
}