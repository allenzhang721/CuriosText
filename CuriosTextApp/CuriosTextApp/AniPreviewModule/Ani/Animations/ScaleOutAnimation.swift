//
//  ScaleOutAnimation.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 4/14/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
import UIKit

extension AniFactory {
    
    class func scaleOut(_ canvasSize: CGSize, container: Container, content: Content, contentsCount: Int, index: Int, descriptor: Descriptor, beganTime: Float) -> AniDescriptor {
        
        let duration = descriptor.config.duration
        let time = duration * 0.6
        let interdelay = duration * (1 - 0.6) / Float(contentsCount)
        let b = Float(contentsCount - 1 - index) * interdelay + beganTime + descriptor.config.delay
        
        
        let bt = [ // beganTime
            "opacity": CFTimeInterval(b),
            "transform": CFTimeInterval(b),
            "mask.colors": CFTimeInterval(b)]
        
        let ds = [ //duration
            "opacity": CFTimeInterval(time),
            "transform": CFTimeInterval(time),
            "mask.colors": CFTimeInterval(time)]
        
        let vs: [String: [AnyObject]] = [
            "opacity": [ 1.0 as AnyObject, 0.0 as AnyObject,],
            "transform": [
                NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1)),
                NSValue(caTransform3D: CATransform3DMakeScale(0.5, 0.5, 1)),
                
            ],
            "mask.colors": [
                [UIColor.black.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.black.cgColor] as [AnyObject] as AnyObject,
                [UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor] as [AnyObject] as AnyObject,
            ]
        ]
        
        let ks: [String: [NSNumber]] = [
            //            "position": [0, 1],
            "opacity": [0, 1],
            "transform": [0, 1],
            "mask.colors": [0, 1]]
        
        return AniDescriptor(type: "SCALE_OUT", beganTimes: bt, durations: ds, values: vs, keyTimes: ks)
    }
}
