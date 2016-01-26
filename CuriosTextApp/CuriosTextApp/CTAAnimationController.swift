//
//  CTAAnimationController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/22/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
import UIKit
import pop

protocol CTAAnimationControllerDelegate: class {
    
    func controllerAnimationDidFinished(con: CTAAnimationController)
}

class CTAAnimationController: NSObject {
    
    weak var delegate: CTAAnimationControllerDelegate?
    private var views: [UIView]?
    let iD: String
    var binder: CTAAnimationBinder
    weak var preView: CTAPreviewView?
    var container: ContainerVMProtocol
    var canvasSize: CGSize
    private var playing: Bool = false
    
    var duration: Float {
        return binder.config.duration + binder.config.delay
    }
    
    init(preView: CTAPreviewView?, binder: CTAAnimationBinder, container: ContainerVMProtocol, canvasSize: CGSize) {
        
        self.preView = preView
        self.binder = binder
        self.container = container
        self.canvasSize = canvasSize
        self.iD = CTAIDGenerator.generateID()
    }
    
    func play() {
        
        if views == nil {
            self.views = CTAAnimationController.createViews(binder, container: container)
        }
        
        playing = true
        
        let time: NSTimeInterval = NSTimeInterval(duration)
        let delay = dispatch_time(DISPATCH_TIME_NOW,
            Int64(time * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) { [weak self] in
            
            if let sf = self where sf.playing == true {
                sf.playing = false
                sf.delegate?.controllerAnimationDidFinished(sf)
            }
            
        }
        
        if let apreView = preView {
            apreView.clearViews()
            for (i, v) in views!.enumerate() {
                binder.configAnimationFor(v, index: i)
            }
            
            for v in views! {
                
               apreView.appendView(v)
            }
        }
    }
    
    func pause() {
        
    }
    
    func stop() {
        
        guard let views = views else {
            return
        }
        
        playing = false
        
        for v in views {
            v.pop_removeAllAnimations()
        }
    }
    
    class func createViews(binder: CTAAnimationBinder, container: ContainerVMProtocol) -> [UIView] {
        var aviews = [UIView]()
        
        switch container {
        case let textContainer as TextContainerVMProtocol:
            let inset = textContainer.inset
            let size = textContainer.size
            let text = textContainer.textElement?.attributeString
            
            let textView = TextView(frame: CGRect(origin: CGPoint.zero, size: size))
            textView.insets = inset
            textView.attributedText = text
            textView.center = CGPoint(x: container.size.width / 2.0, y: container.size.height / 2.0)
            aviews.append(textView)
            
        default:
            ()
        }
        
        return aviews
    }
}