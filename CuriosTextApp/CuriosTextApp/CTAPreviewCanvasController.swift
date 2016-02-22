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
    
    
    

    class func configPreviewView(view: CTAPreviewView, container: ContainerVMProtocol, animationBinder: CTAAnimationBinder?, loadAnimation: Bool = false) {
        
        view.clearViews()
        
        guard let binder = animationBinder else {
            configPreviewView(view, container: container)
            return
        }
        
        configPreviewView(view, container: container)
    }
    
    class func configPreviewView(view: CTAPreviewView, container: ContainerVMProtocol, needLoadContents: Bool = true) {
        
        
        debug_print(container.type, context: aniContext)
        
        guard needLoadContents else {
            return
        }
        
        switch container.type {
            
        case .Text:
            let inset = container.inset
            let size = container.size
            let text = (container as! TextContainerVMProtocol).textElement?.attributeString
            
            let textView = TextView(frame: CGRect(origin: CGPoint.zero, size: size))
            textView.insets = inset
            textView.attributedText = text
            textView.center = CGPoint(x: view.bounds.width / 2.0, y: view.bounds.height / 2.0)
            view.appendView(textView)
            
        case .Image:
//            let inset = container.inset
            let size = container.size
            let imageName = (container as! ImageContainerVMProtocol).imageElement?.resourceName
            
            let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: size))
            imageView.image = CTAStyleKit.imageOfTextSpacingNormal
            imageView.center = CGPoint(x: view.bounds.width / 2.0, y: view.bounds.height / 2.0)
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