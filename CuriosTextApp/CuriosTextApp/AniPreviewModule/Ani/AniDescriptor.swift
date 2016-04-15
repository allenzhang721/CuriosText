//
//  AniDescriptor.swift
//  PopApp
//
//  Created by Emiaostein on 4/3/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import Foundation
import UIKit
import pop
var v: AnyObject? = nil
struct AniDescriptor {
    
    let type: String
    let beganTimes: [String: CFTimeInterval]
    let durations: [String: CFTimeInterval]
    let values: [String: [AnyObject]]
    let keyTimes: [String: [NSNumber]]
    
    func configAnimationOn(layer: CALayer) {
        
        let fillMode : String = kCAFillModeBoth
        let c = layer
        
        guard let animationType = CTAAnimationType(rawValue: type) else { return }
        let keyPaths = animationType.AnimationKeys()
        let needMask = animationType.needMask()
        
        if !needMask {
            layer.mask = nil
        } else {
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = layer.bounds
            gradientLayer.colors = [UIColor.blackColor().CGColor, UIColor.blackColor().CGColor]
            
            layer.mask = gradientLayer
            
            let maskGradientKeyPaths = keyPaths.filter{ $0.hasPrefix("maskGradient.") }
            var maskGradientAnims = [CAAnimation]()
            for k in maskGradientKeyPaths {
                let keyPath = k.componentsSeparatedByString(".").last!
                let beganTime = beganTimes[k] ?? 0
                let duration = durations[k] ?? 0.3
                let value = values[k]
                let keyTime = keyTimes[k]
                
                let anim = CAKeyframeAnimation(keyPath:keyPath)
                anim.values = value
                anim.keyTimes = keyTime
                anim.duration = duration
                anim.beginTime = beganTime
                anim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
                
                maskGradientAnims.append(anim)
                
                if let last = keyTime?.last as? Int {
                    switch last {
                    case 0:
                        gradientLayer.setValue(value?.first, forKeyPath: k)
                    default:
                        gradientLayer.setValue(value?.last, forKeyPath: k)
                    }
                }
            }
            
            let animGroup = QCMethod.groupAnimations(maskGradientAnims, fillMode:fillMode)
            animGroup.removedOnCompletion = true
            gradientLayer.addAnimation(animGroup, forKey: "\(type)GradientAnimation")
        }
        
        
        let layerKeyPaths = keyPaths.filter { !$0.hasPrefix("maskGradient.") }
        var anims = [CAAnimation]()
        for k in layerKeyPaths {
            let beganTime = beganTimes[k] ?? 0
            let duration = durations[k] ?? 0.3
            let value = values[k]
            let keyTime = keyTimes[k]
            
            let anim = CAKeyframeAnimation(keyPath:k)
            anim.values = value
            anim.keyTimes = keyTime
            anim.duration = duration
            anim.beginTime = beganTime
            anim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut) 
            
            anims.append(anim)
            if k != "transform" {
                if let last = keyTime?.last as? Int {
                    switch last {
                    case 0:
                        c.setValue(value?.first, forKeyPath: k)
                    default:
                        c.setValue(value?.last, forKeyPath: k)
                    }
                }
                
            } else {
            }
        }

        let animGroup = QCMethod.groupAnimations(anims, fillMode:fillMode)
        animGroup.removedOnCompletion = true
        c.addAnimation(animGroup, forKey: "\(type)Animation")
    }
}