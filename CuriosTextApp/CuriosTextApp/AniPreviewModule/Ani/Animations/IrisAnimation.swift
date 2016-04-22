//
//  IrisAnimation.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 4/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

extension AniFactory {
    
    class func iris(appear: Bool, canvasSize: CGSize, container: Container, content: Content, contentsCount: Int, index: Int, descriptor: Descriptor, beganTime: Float) -> AniDescriptor {
        
        let duration = descriptor.config.duration
        let time = duration * 0.6
        let interdelay = duration * (1 - 0.6) / Float(contentsCount)
        let b = appear ? Float(index) * interdelay + beganTime + descriptor.config.delay : Float(contentsCount - 1 - index) * interdelay + beganTime + descriptor.config.delay
     
        let key1 = "mask.fillColor"
        
//        if appear {
        
        let bt = [ // beganTime
            key1: CFTimeInterval(b),
            "mask.transform": CFTimeInterval(b)]
        
        let ds = [ //duration
            key1: CFTimeInterval(time),
            "mask.transform": CFTimeInterval(time)]
        
        let beganScale: CGFloat = appear ? 0.0 : 1.0
        let endScale: CGFloat = appear ? 1.0 : 0.0
        let vs: [String: [AnyObject]] = [
            key1: [UIColor.blackColor().CGColor, UIColor.blackColor().CGColor],
            "mask.transform": [
                NSValue(CATransform3D: CATransform3DMakeScale(beganScale, beganScale, 1)),
                NSValue(CATransform3D: CATransform3DMakeScale(endScale, endScale, 1)),
                
            ],
        ]
        
        let beganKeyTime = 0
        let endKeyTime = 1
        let ks: [String: [NSNumber]] = [
            key1: [beganTime, endKeyTime],
            "mask.transform": [beganKeyTime, endKeyTime]]
        
        
        
        return AniDescriptor(type: "IRIS_\(appear ? "IN" : "OUT")", beganTimes: bt, durations: ds, values: vs, keyTimes: ks)
            
//        } else {
//            
//            let bt = [ // beganTime
//                "mask.lineWidth": CFTimeInterval(b)]
//            
//            let ds = [ //duration
//                "mask.lineWidth": CFTimeInterval(time)]
//            
//            
//            let length = sqrt(pow(Double(container.width), 2.0) + pow(Double(container.height), 2.0))
//            let vs: [String: [AnyObject]] = [
//                "mask.lineWidth": [
//                    length,
//                    1.0,
//                ],
//                ]
//            
//            let beganKeyTime = 0
//            let endKeyTime = 1
//            let ks: [String: [NSNumber]] = [
//                "mask.lineWidth": [beganKeyTime, endKeyTime]]
//
//            return AniDescriptor(type: "IRIS_\(appear ? "IN" : "OUT")", beganTimes: bt, durations: ds, values: vs, keyTimes: ks)
//            
//        }
    }
    
}