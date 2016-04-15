//
//  AniNode.swift
//  PopApp
//
//  Created by Emiaostein on 4/3/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import Foundation
import UIKit

enum AniNodeFinderResult {
    case Success(Int, Container)
    case NotFound
}

class AniNode {
    var duration: Float = 0.0
    let animations: [Animation]?
    var nextNode: AniNode?
    
    private var containers: [NSIndexPath: AniContainer] = [:]
    
    init(animations: [Animation]? = nil) {
        self.animations = animations
    }
    
    func startWith(canvasSize: CGSize, finder:(containerID: String) -> AniNodeFinderResult) -> (duration: Float, containers: [NSIndexPath: AniContainer]) {
        
        guard let animations = animations where animations.count > 0 else {
            return (0, [:])
        }
        
        duration = 0.0
        containers.removeAll()

        for a in animations {
            
            switch finder(containerID: a.targetID) {
            case .Success(let i , let c):
                if let type = CTAAnimationType(rawValue: a.descriptor.type) {
                    containers[NSIndexPath(forItem: i, inSection: 0)] = generateContaienrBy(canvasSize, addBeganTime: 0, type: type, descriptor: a.descriptor, c: c)
                    let currentDuration = a.descriptor.config.duration + a.descriptor.config.delay
                    duration = max(currentDuration, duration)
                }
                
            default:
                ()
            }
        }
        
        return (duration, containers)
    }
    
    func generateContaienrBy(canvasSize: CGSize, addBeganTime: Float, type: CTAAnimationType, descriptor: Descriptor, c: Container) -> AniContainer {

        let nc = containersBy(c, spliteType: TextSpliter.defaultSpliteBy(type))
        
        var anis = [Int: AniDescriptor]()
        for (i, content) in nc.contents.enumerate() {
            
            // TODO: 2. Need an Animation Type Factory.  -- EMIAOSTEIN, 4/04/16, 16:38
            if let a = AniFactory.animationWith(descriptor.type, canvasSize: canvasSize, container: c, content: content, contentsCount: nc.contents.count, index: i, descriptor: descriptor, addBeganTime: addBeganTime) {
                anis[i] = a
            }
        }
        let ac = AniContainer(container: nc, animations: anis)

        return ac
    }
    
    private func containersBy(container: Container, spliteType type: (TextSpliter.TextLineSpliteType, TextSpliter.TextSpliteType)) -> Container {
        let source = container.contents.first!.source
        let r = TextSpliter.spliteText(source.texts, withAttributes: source.attribute, inConstraintSize: CGSize(width: CGFloat(container.width), height: CGFloat.max), bySpliteType:type)
        let units = r.0
        let size = r.1
        
        var contents = [Content]()
        
        for u in units {
            
            let s = Source(type: .Text, text: u.text, attributes: u.attriubtes)
            let content = Content(cx: Int(u.usedRect.midX) + 1, cy: Int(u.usedRect.midY) + 1, width: Int(u.usedRect.width) + 1, height: Int(u.usedRect.height) + 1, source: s)
            
            contents.append(content)
        }

        let c = Container(cx: container.positionX, cy: container.positionY, width: Int(size.width), height: Int(size.height), rotation: container.rotation, identifier: container.identifier, contents: contents)
        
        return c
    }
}