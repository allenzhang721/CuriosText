//
//  CTAPreviewCanvasController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/21/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
import UIKit

final class CTAPreviewCanvasController {
    
//    var headNode: CTAAnimationPlayNode?
    
    func play() {
        
//        headNode?.play()
    }
    
    
    

    class func configPreviewView(view: CTAPreviewView, container: ContainerVMProtocol, animationBinder: CTAAnimationBinder?, publishID: String, loadAnimation: Bool = false) {
        
        view.clearViews()
        
//        guard let binder = animationBinder else {
//            configPreviewView(view, container: container, publishID: publishID)
//            return
//        }
//        
//        configPreviewView(view, container: container, publishID: publishID)
    }
    
    class func configPreviewView(view: CTAPreviewView, container: ContainerVMProtocol, publishID: String, cache: CTACache?, needLoadContents: Bool = true) {
        
        
//        debug_print(container.type, context: aniContext)
        
        guard needLoadContents else {
            return
        }
        
        switch container.type {
            
        case .Text:
            let inset = container.inset
            let size = container.size
            let text = (container as! TextContainerVMProtocol).textElement?.attributeString
            
            let textView = TextView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: size.width + inset.x * 2, height: size.height + inset.y * 2)))
            textView.insets = inset
            textView.attributedText = text

            textView.center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
            
            view.appendView(textView)
            
        case .Image:
//            let inset = container.inset
            let size = container.size
//            let imageName = (container as! ImageContainerVMProtocol).imageElement?.resourceName
            
            let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: size))
//            let url = CTAFilePath.publishFilePath + "\(publishID)/" + (container as!ImageContainerVMProtocol).imageElement!.resourceName
            let imageName = (container as!ImageContainerVMProtocol).imageElement!.resourceName
            let image = cache?.imageForKey(imageName)
            imageView.image = image
            
            imageView.center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
            view.appendView(imageView)
            
        default:
            ()
            
            
        }
    }
    
    
    
    func configPreviewView(view: CTAPreviewView, container: ContainerVMProtocol, animationBinder: CTAAnimationBinder) {
        
        
    }
    
    
    func generateAnimationPlays(ani: [CTAAnimationBinder]) {
        

        
        CTAPreviewCanvasController.splits(ani)
        
        
    }
    
    class func splits(array: [CTAAnimationBinder]) -> [[CTAAnimationBinder]] {
        
        let count = array.count
        guard count > 1 else {
            return [array]
        }
        
        var result = [[CTAAnimationBinder]]()
        var began = 0
        
        for (i, b) in array.enumerate() {
            
            guard i > 0 else {
                continue
            }
            
            if i < count - 1 {
                
                guard b.config.withFormer == false else {continue}
                
                let s = array[began..<i]
                began = i
                result += [Array(s)]
            } else {
                
                let s = ((b.config.withFormer == false) ? [Array(array[began..<i]),[b]] : [Array(array[began...i])])
                result += s
            }
        }
        
        return result
    }
    
}