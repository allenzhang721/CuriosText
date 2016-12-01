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
    
    func configAnimationOn(_ layer: CALayer) {
        
        let fillMode : String = kCAFillModeBoth
        let c = layer
        
        guard let animationType = CTAAnimationType(rawValue: type) else { return }
        let keyPaths = animationType.AnimationKeys()
        let needMaskType = animationType.needMask()
        
        var maskLayer: CALayer?
        switch needMaskType {
        case .none:
            layer.mask = nil
        case .normal(let shape):
            switch shape {
            case .rect:
                let alayer = CALayer()
                alayer.frame = layer.bounds
                alayer.backgroundColor = UIColor.black.cgColor
                maskLayer = alayer
            case .oval:
                let alayer = CAShapeLayer()
                let dia = sqrt(pow(layer.bounds.width, 2) + pow(layer.bounds.height, 2))
                let rect = CGRect(x: 0, y: 0, width: dia, height: dia)
                alayer.frame = rect
                alayer.path = UIBezierPath(ovalIn: rect).cgPath
                alayer.strokeColor = UIColor.black.cgColor
                alayer.fillColor = UIColor.clear.cgColor
                maskLayer = alayer
            }
        case .gradient(let shape):
            switch shape {
            case .rect:
                let gradientLayer = CAGradientLayer()
//                _ = layer.bounds.height
                let height = layer.bounds.height * 1.4
                gradientLayer.frame = UIEdgeInsetsInsetRect(CGRect(origin: CGPoint.zero, size: CGSize(width: layer.bounds.width, height: height)), UIEdgeInsets(top: -layer.bounds.height * 0.2, left: 0, bottom: -layer.bounds.height * 0.2, right: 0))
                gradientLayer.colors = [UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor]
                
                gradientLayer.locations = [0, NSNumber(floatLiteral: 0.2 / 1.4), NSNumber(floatLiteral: 1.2 / 1.4), 1]
                maskLayer = gradientLayer
            case .oval:
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
                let keyPath = k.components(separatedBy: ".").last!
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
            animGroup?.isRemovedOnCompletion = true
            mask.add(animGroup!, forKey: "\(type)maskAnimation")
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
        animGroup?.isRemovedOnCompletion = true
        c.add(animGroup!, forKey: "\(type)Animation")
    }
}
