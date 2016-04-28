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
        let needMaskType = animationType.needMask()
        
        var maskLayer: CALayer?
        switch needMaskType {
        case .None:
            layer.mask = nil
        case .Normal(let shape):
            switch shape {
            case .Rect:
                let alayer = CALayer()
                alayer.frame = layer.bounds
                alayer.backgroundColor = UIColor.blackColor().CGColor
                maskLayer = alayer
            case .Oval:
                let alayer = CAShapeLayer()
                let dia = sqrt(pow(layer.bounds.width, 2) + pow(layer.bounds.height, 2))
                let rect = CGRect(x: 0, y: 0, width: dia, height: dia)
                alayer.frame = rect
                alayer.path = UIBezierPath(ovalInRect: rect).CGPath
                alayer.strokeColor = UIColor.blackColor().CGColor
                alayer.fillColor = UIColor.clearColor().CGColor
                maskLayer = alayer
            }
        case .Gradient(let shape):
            switch shape {
            case .Rect:
                let gradientLayer = CAGradientLayer()
                let h = layer.bounds.height
                let height = layer.bounds.height * 1.4
                gradientLayer.frame = UIEdgeInsetsInsetRect(CGRect(origin: CGPoint.zero, size: CGSize(width: layer.bounds.width, height: height)), UIEdgeInsets(top: -layer.bounds.height * 0.2, left: 0, bottom: -layer.bounds.height * 0.2, right: 0))
                gradientLayer.colors = [UIColor.blackColor().CGColor, UIColor.blackColor().CGColor, UIColor.clearColor().CGColor, UIColor.clearColor().CGColor]
                gradientLayer.locations = [0, 0.2 / 1.4, 1.2 / 1.4, 1]
                maskLayer = gradientLayer
            case .Oval:
                ()
//                let dia = sqrt(pow(layer.bounds.width, 2) + pow(layer.bounds.height, 2))
//                alayer.frame = CGRect(x: 0, y: 0, width: dia, height: dia)
//                alayer.fillColor = UIColor.blackColor().CGColor
//                
//                let gradientLayer = CAGradientLayer()
//                gradientLayer.frame = CGRect(x: 0, y: 0, width: dia, height: dia)
//                let shapeLayer
//                
//                maskLayer = gradientLayer
            }
        }
            
        
        if let mask = maskLayer {
            layer.mask = mask
//            layer.addSublayer(mask)
            mask.position = CGPoint(x: layer.bounds.midX, y: layer.bounds.midY)
            
            let maskGradientKeyPaths = keyPaths.filter{ $0.hasPrefix("mask.") }
            var maskAnims = [CAAnimation]()
            for k in maskGradientKeyPaths {
                let keyPath = k.componentsSeparatedByString(".").last!
                let beganTime = beganTimes[k] ?? 0
                let duration = durations[k] ?? 0.3
                let value = values[k]
                let keyTime = keyTimes[k]
                
                if let first = keyTime?.first as? Int {
                    switch first {
                    case 0:
                        mask.setValue(value?.first, forKeyPath: k)
                    default:
                        mask.setValue(value?.last, forKeyPath: k)
                    }
                }
                
                let anim = CAKeyframeAnimation(keyPath:keyPath)
                anim.values = value
                anim.keyTimes = keyTime
                anim.duration = duration
                anim.beginTime = beganTime
                anim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
                
                maskAnims.append(anim)
                
                if let last = keyTime?.last as? Int {
                    switch last {
                    case 0:
                        mask.setValue(value?.first, forKeyPath: k)
                    default:
                        mask.setValue(value?.last, forKeyPath: k)
                    }
                }
            }
            
            let animGroup = QCMethod.groupAnimations(maskAnims, fillMode:fillMode)
            animGroup.removedOnCompletion = true
            mask.addAnimation(animGroup, forKey: "\(type)maskAnimation")
        }
        
        let layerKeyPaths = keyPaths.filter { !$0.hasPrefix("mask.") }
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