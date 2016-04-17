//
//  FadeAnimation.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 4/17/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
import UIKit

extension AniFactory {
    
    class func fade(appear: Bool, canvasSize: CGSize, container: Container, content: Content, contentsCount: Int, index: Int, descriptor: Descriptor, beganTime: Float) -> AniDescriptor {
        
        let duration = descriptor.config.duration
        let time = duration * 0.4
        let interdelay = duration * (1 - 0.4) / Float(contentsCount)
        let b = Float(index) * interdelay + beganTime + descriptor.config.delay
        
        
        let bt = [
            "opacity": CFTimeInterval(b),
            "transform": CFTimeInterval(b)]
        
        let ds = [
            "opacity": CFTimeInterval(time),
            "transform": CFTimeInterval(time)]
        
        let opacity = appear ? [0, 1] : [1, 0]
        
        let beganTransform = appear ?
            NSValue(CATransform3D: CATransform3DMakeScale(1.5, 1.5, 1)) :
            NSValue(CATransform3D: CATransform3DIdentity)
        
        let endTransform = appear ?
            NSValue(CATransform3D: CATransform3DIdentity) :
            NSValue(CATransform3D: CATransform3DMakeScale(1.5, 1.5, 1))
        
        
        
        let vs: [String: [AnyObject]] = [
            "opacity": opacity,
            "transform": [
                beganTransform, endTransform
            ]
        ]
        let keyTime = [0, 1]
        let ks: [String: [NSNumber]] = [
            "opacity": keyTime,
            "transform": keyTime]
        
        return AniDescriptor(type: "FADE_\(appear ? "IN" : "OUT")", beganTimes: bt, durations: ds, values: vs, keyTimes: ks)
    }
}