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
    
    func appendView(_ view: UIView) {
        addSubview(view)
        views.append(view)
    }
    
    func reload() {
        
        for view in views {
            view.removeFromSuperview()
            views.removeAll()
        }
        
        let string = "What can i do for you ?"
        
        for (i, c) in string.characters.enumerated() {
            
            let textView = TextView(frame: CGRect(x: 12 * (i % 10), y: 22 * (i < 10 ? 0 : 1), width: Int(bounds.width), height: 22))
            textView.textColor = UIColor.white
            textView.text = String(c)
            addSubview(textView)
            views.append(textView)
        }
    }

    func play() {
        
        reload()
        let count = views.count
        for (i, view) in views.enumerated() {
            let index = (count - 1 - i)
            let animation = POPBasicAnimation(propertyNamed: kPOPLayerTranslationXY)
            animation?.toValue = NSValue(cgPoint: CGPoint(x: 200 + 10 * index, y: 0))
            animation?.beginTime = CACurrentMediaTime() + 0.03 * Double(index)
            animation?.duration = 2.0
//            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            view.layer.pop_add(animation, forKey: "tranXY")
        }
        
    }
    
    func pause() {
        
        for (i, view) in views.enumerated() {
            
            if let animation = view.layer.pop_animation(forKey: "tranXY") as? POPBasicAnimation {
                
                animation.isPaused = true
            }
        }
        
    }
    
    func stop() {
        
    }

}
