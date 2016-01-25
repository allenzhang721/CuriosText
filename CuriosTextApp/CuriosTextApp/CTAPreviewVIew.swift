//
//  CTAPreviewVIew.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/20/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import pop

class CTAPreviewView: UIView {
    
    var views = [UIView]()
    
    func clearViews() {
        
        for view in views {
            view.pop_removeAllAnimations()
            view.removeFromSuperview()
        }
        
        views.removeAll()
    }
    
    func appendView(view: UIView) {
        addSubview(view)
        views.append(view)
    }
    
    func reload() {
        
        for view in views {
            view.removeFromSuperview()
            views.removeAll()
        }
        
        let string = "What can i do for you ?"
        
        for (i, c) in string.characters.enumerate() {
            
            let textView = TextView(frame: CGRect(x: 12 * (i % 10), y: 22 * (i < 10 ? 0 : 1), width: Int(bounds.width), height: 22))
            textView.text = String(c)
            addSubview(textView)
            views.append(textView)
        }
    }

    func play() {
        
        reload()
        let count = views.count
        for (i, view) in views.enumerate() {
            let index = (count - 1 - i)
            let animation = POPBasicAnimation(propertyNamed: kPOPLayerTranslationXY)
            animation.toValue = NSValue(CGPoint: CGPoint(x: 200 + 10 * index, y: 0))
            animation.beginTime = CACurrentMediaTime() + 0.03 * Double(index)
            animation.duration = 2.0
//            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            view.layer.pop_addAnimation(animation, forKey: "tranXY")
        }
        
    }
    
    func pause() {
        
        for (i, view) in views.enumerate() {
            
            if let animation = view.layer.pop_animationForKey("tranXY") as? POPBasicAnimation {
                
                animation.paused = true
            }
            
//            let animation = POPBasicAnimation(propertyNamed: kPOPLayerTranslationXY)
//            animation.toValue = NSValue(CGPoint: CGPoint(x: 50 + 50 * i, y: 0))
//            animation.beginTime = CACurrentMediaTime() + 1.0 * Double(i)
//            animation.duration = 2.0
//            view.layer.pop_addAnimation(animation, forKey: "tranXY")
        }
        
    }
    
    func stop() {
        
    }

}
