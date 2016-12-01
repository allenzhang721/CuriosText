//
//  CurlAnimation.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 4/17/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
import UIKit

extension AniFactory {
    
    class func curl(_ appear: Bool, canvasSize: CGSize, container: Container, content: Content, contentsCount: Int, index: Int, descriptor: Descriptor, beganTime: Float) -> AniDescriptor {
        
        let duration = descriptor.config.duration
        let time = duration * 0.6
        let interdelay = duration * (1 - 0.6) / Float(contentsCount)
        let b = Float(index) * interdelay + beganTime + descriptor.config.delay
        
        let bt = [
            "position": CFTimeInterval(b),
            "opacity": CFTimeInterval(b),
            "transform": CFTimeInterval(b)]
        
        let ds = [
            "position": CFTimeInterval(time),
            "opacity": CFTimeInterval(time),
            "transform": CFTimeInterval(time)]
        
        // property value
        let length = sqrt(pow(Double(container.width), 2.0) + pow(Double(container.height), 2.0))
        
        let endc = appear ?
            CGPoint(x: 0 - CGFloat(length / 1.8), y: CGFloat(container.positionY)) :
            CGPoint(x: canvasSize.width + CGFloat(length / 1.8), y: -CGFloat(index) + CGFloat(container.positionY))
        
        let translation =
            CGPoint(x:endc.x - CGFloat(container.positionX), y: endc.y - CGFloat(container.positionY))
        
        let r = CGFloat(container.rotation) / 180.0 * CGFloat(M_PI)
        let tl = translation.x / abs(translation.x) * sqrt(pow(CGFloat(translation.x), 2.0) + pow(CGFloat(translation.y), 2.0))
        let tc = CGPoint(x: CGFloat(tl) * cos(r), y: -CGFloat(tl) * sin(r))
        
        let contentPostion = CGPoint(x: CGFloat(content.width / 2), y: CGFloat(content.height / 2))
        
        let mid = container.width / 2
        let c = mid + mid - content.positionX
        let tranlsPosition = appear ?
            CGPoint(x: CGFloat(c) + tc.x  , y: contentPostion.y + tc.y - CGFloat(index) * 10) :
            CGPoint(x: CGFloat(c) + tc.x, y: contentPostion.y + tc.y - CGFloat(contentsCount - 1 - index) * 10)
        
        let position = appear ? tranlsPosition : contentPostion
        let endPosition = appear ? contentPostion : tranlsPosition
        
        let beganTransform = !appear ?
            NSValue(caTransform3D: CATransform3DIdentity) :
            NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat(M_PI), 0.5, 1, 0))
        
        let endTransform = !appear ?
            NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat(M_PI), 0.5, 1, 0)) :
            NSValue(caTransform3D: CATransform3DIdentity)

        let vs: [String: [AnyObject]] = [
            "position": [
                NSValue(cgPoint: position), NSValue(cgPoint: endPosition)],
            "opacity": [1.0 as AnyObject, 1.0 as AnyObject],
            "transform": [
                beganTransform, endTransform
            ]
        ]
        let keyTime = [0, 1]
        let ks: [String: [NSNumber]] = [
            "position": keyTime as Array<NSNumber>,
            "opacity": keyTime as Array<NSNumber>,
            "transform": keyTime as Array<NSNumber>]
        
        return AniDescriptor(type: "CURL_\(appear ? "IN" : "OUT")", beganTimes: bt, durations: ds, values: vs, keyTimes: ks)
    }
}
