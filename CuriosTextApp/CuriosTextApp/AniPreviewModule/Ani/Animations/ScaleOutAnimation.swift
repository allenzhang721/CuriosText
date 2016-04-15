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
    
    class func scaleOut(canvasSize: CGSize, container: Container, content: Content, contentsCount: Int, index: Int, descriptor: Descriptor, beganTime: Float) -> AniDescriptor {
        
        let duration = descriptor.config.duration
        let time = duration * 0.6
        let interdelay = duration * (1 - 0.6) / Float(contentsCount)
        let b = Float(contentsCount - 1 - index) * interdelay + beganTime + descriptor.config.delay
        
        
        let bt = [ // beganTime
            "opacity": CFTimeInterval(b),
            "transform": CFTimeInterval(b),
            "maskGradient.colors": CFTimeInterval(b)]
        
        let ds = [ //duration
            "opacity": CFTimeInterval(time),
            "transform": CFTimeInterval(time),
            "maskGradient.colors": CFTimeInterval(time)]
        
        let vs: [String: [AnyObject]] = [
            "opacity": [ 1.0, 0.0,],
            "transform": [
                NSValue(CATransform3D: CATransform3DMakeScale(1.0, 1.0, 1)),
                NSValue(CATransform3D: CATransform3DMakeScale(0.5, 0.5, 1)),
                
            ],
            "maskGradient.colors": [
                [UIColor.blackColor().CGColor, UIColor.blackColor().CGColor],
                [UIColor.blackColor().CGColor, UIColor.clearColor().CGColor],
            ]
        ]
        
        let ks: [String: [NSNumber]] = [
            //            "position": [0, 1],
            "opacity": [0, 1],
            "transform": [0, 1],
            "maskGradient.colors": [0, 1]]
        
        return AniDescriptor(type: "SCALE_OUT", beganTimes: bt, durations: ds, values: vs, keyTimes: ks)
    }
}