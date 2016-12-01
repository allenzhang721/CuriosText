//
//  MoveInAnimation.swift
//  PopApp
//
//  Created by Emiaostein on 4/4/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import Foundation
import UIKit

extension AniFactory {
    
    class func moveIn(_ canvasSize: CGSize, container: Container, content: Content, contentsCount: Int, index: Int, inSection section: Int, rowAtSection row: Int, sectionCount: Int, rowCountAtSection: Int, descriptor: Descriptor, beganTime: Float, direction: Int = 0) -> AniDescriptor {
        
    let duration = descriptor.config.duration
    let time = duration * 0.6
//    let interdelay = duration * (1 - 0.6) / Float(contentsCount)
//    let b = direction == 0 ? Float(index) * interdelay + beganTime + descriptor.config.delay : Float(contentsCount - 1 - index) * interdelay + beganTime + descriptor.config.delay
    let sectionInterdelay = duration * (1 - 0.6) / Float(sectionCount)
    let interdelay = sectionInterdelay / Float(rowCountAtSection)
        let b = direction == 0 ? Float(row) * interdelay + sectionInterdelay * Float(section) + beganTime + descriptor.config.delay :
        Float(rowCountAtSection - 1 - row) * interdelay + sectionInterdelay * Float(section) + beganTime + descriptor.config.delay
    
        let bt = [
            "position": CFTimeInterval(b),
            "opacity": CFTimeInterval(b),
            "transform": CFTimeInterval(b)]

        let ds = [
            "position": CFTimeInterval(time),
            "opacity": CFTimeInterval(time),
            "transform": CFTimeInterval(time)]
        
        // property value
        let position: CGPoint
        let nextPosition: CGPoint
        if direction == 0 { // From Right to Left Move In
            let length = sqrt(pow(Double(container.width), 2.0) + pow(Double(container.height), 2.0))
            let endc = CGPoint(x: canvasSize.width + CGFloat(length) / 2.0, y: CGFloat(container.positionY)) // finish center
            let translation = CGPoint(x: endc.x - CGFloat(container.positionX), y: endc.y - CGFloat(container.positionY)) // 位移 x > 0
            let r = CGFloat(container.rotation) / 180.0 * CGFloat(M_PI)
            let tl = sqrt(pow(Double(translation.x), 2.0) + pow(Double(translation.y), 2.0)) // 在 canvas 上的实际平行距离
            let tc = CGPoint(x: CGFloat(tl) * cos(r), y: -CGFloat(tl) * sin(r))
            position = CGPoint(x: CGFloat(content.width / 2), y: CGFloat(content.height / 2))
            nextPosition = CGPoint(x: position.x + tc.x, y: position.y + tc.y)
        } else { // From Left to Right Move In
            let length = sqrt(pow(Double(container.width), 2.0) + pow(Double(container.height), 2.0)) // Container 对角线
            let endc = CGPoint(x: 0 - CGFloat(length) / 2.0, y: CGFloat(container.positionY)) // finish center
            let translation = CGPoint(x: CGFloat(container.positionX) - endc.x, y: endc.y - CGFloat(container.positionY)) // 位移
            let r = CGFloat(container.rotation) / 180.0 * CGFloat(M_PI)
            let tl = sqrt(pow(Double(translation.x), 2.0) + pow(Double(translation.y), 2.0))
            let tc = CGPoint(x: CGFloat(tl) * cos(r), y: -CGFloat(tl) * sin(r))
            position = CGPoint(x: CGFloat(content.width / 2), y: CGFloat(content.height / 2))
            nextPosition = CGPoint(x: position.x - tc.x, y: position.y + tc.y)
            
        }
        
        
        let vs: [String: [AnyObject]] = [
            "position": [
             NSValue(cgPoint: position), NSValue(cgPoint: nextPosition)],
            "opacity": [1.0 as AnyObject, 0.0 as AnyObject],
            "transform": [
                NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1)),
                NSValue(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1)),
            ]
        ]
        
        let ks: [String: [NSNumber]] = [
            "position": [1, 0],
            "opacity": [1, 0],
            "transform": [1, 0]]
        
        return AniDescriptor(type: "MOVE_IN", beganTimes: bt, durations: ds, values: vs, keyTimes: ks)
    }
}
