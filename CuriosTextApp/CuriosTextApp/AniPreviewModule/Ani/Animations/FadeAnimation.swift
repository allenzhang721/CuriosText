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
    
    class func fade(_ appear: Bool, canvasSize: CGSize, container: Container, content: Content, contentsCount: Int, index: Int, descriptor: Descriptor, beganTime: Float, isRandom: Bool = true) -> AniDescriptor {
        let i = isRandom ? Int(arc4random()) % contentsCount : index
        let duration = descriptor.config.duration
        let time = duration * 0.4
        let interdelay = duration * (1 - 0.4) / Float(contentsCount)
        let b = Float(i) * interdelay + beganTime + descriptor.config.delay
    
        let bt = [
            "opacity": CFTimeInterval(b),
            "transform": CFTimeInterval(b)]
        
        let ds = [
            "opacity": CFTimeInterval(time),
            "transform": CFTimeInterval(time)]
        
        let opacity = appear ? [0, 1] : [1, 0]
        
        let beganTransform = appear ?
            NSValue(caTransform3D: CATransform3DMakeScale(1.5, 1.5, 1)) :
            NSValue(caTransform3D: CATransform3DIdentity)
        
        let endTransform = appear ?
            NSValue(caTransform3D: CATransform3DIdentity) :
            NSValue(caTransform3D: CATransform3DMakeScale(1.5, 1.5, 1))
        
        let vs: [String: [AnyObject]] = [
            "opacity": opacity as Array<AnyObject>,
            "transform": [
                beganTransform, endTransform
            ]
        ]
        let keyTime = [0, 1]
        let ks: [String: [NSNumber]] = [
            "opacity": keyTime as Array<NSNumber>,
            "transform": keyTime as Array<NSNumber>]
        
        return AniDescriptor(type: "FADE_\(appear ? "IN" : "OUT")", beganTimes: bt, durations: ds, values: vs, keyTimes: ks)
    }
}
