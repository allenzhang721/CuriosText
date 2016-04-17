//
//  OrbitalAnimation.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 4/17/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
import UIKit

extension AniFactory {
    
    class func orbital(appear: Bool, canvasSize: CGSize, container: Container, content: Content, contentsCount: Int, index: Int, descriptor: Descriptor, beganTime: Float) -> AniDescriptor {
        
        let duration = descriptor.config.duration
        let time = duration * 0.7
        let interdelay = duration * (1 - 0.7) / Float(contentsCount)
        let mid = CGFloat(contentsCount) / 2
        let b = Float(mid - abs(mid - CGFloat(index))) * interdelay + beganTime + descriptor.config.delay
        
        let bt = [
            "opacity": CFTimeInterval(b),
            "position": CFTimeInterval(b),
            "anchorPoint": CFTimeInterval(b),
            "transform.rotation.z": CFTimeInterval(b)]
        
        let ds = [
            "opacity": CFTimeInterval(time),
            "position": CFTimeInterval(time),
            "anchorPoint": CFTimeInterval(time),
            "transform.rotation.z": CFTimeInterval(time)]
        
        let opacity = appear ? [0, 1] : [1, 0]
        let rotation = appear ? [
            -1080 * CGFloat(M_PI/180),
            -720 * CGFloat(M_PI/180),
            -360 * CGFloat(M_PI/180),
            0
            ] :
        
        [
            0,
            -360 * CGFloat(M_PI/180),
            -720 * CGFloat(M_PI/180),
            -1080 * CGFloat(M_PI/180)
        ]
        
        let targetAnchorPoint = CGPoint(x: container.width / 2, y: container.height / 2)
        let offset = CGPoint(x: targetAnchorPoint.x - CGFloat(content.positionX), y: targetAnchorPoint.y - CGFloat(content.positionY))
        let aX = offset.x / CGFloat(content.width) + 0.5
        let aY = offset.y / CGFloat(content.height) + 0.5
        
        let contentPosition = CGPoint(x: content.width / 2, y: content.height / 2)
        let position = CGPoint(x: contentPosition.x + offset.x, y: contentPosition.y + offset.y)
        
        let anchorpoint = CGPoint(x: aX, y: aY)
        
        let vs: [String: [AnyObject]] = [
            "opacity": opacity,
            "position": [NSValue(CGPoint: position), NSValue(CGPoint: position)],
            "anchorPoint": [NSValue(CGPoint: anchorpoint), NSValue(CGPoint: anchorpoint)],
            "transform.rotation.z": rotation
        ]
        let keyTime = [0, 0.25, 0.5, 1]
        let ks: [String: [NSNumber]] = [
            "opacity": keyTime,
            "transform.rotation.z": keyTime]
        
        return AniDescriptor(type: "ORBITAL_\(appear ? "IN" : "OUT")", beganTimes: bt, durations: ds, values: vs, keyTimes: ks)
    }
}