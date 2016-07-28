//
//  AniNode.swift
//  PopApp
//
//  Created by Emiaostein on 4/3/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import Foundation
import UIKit

private let registedFonts: [String] = {
    var fonts = [String]()
    let families = UIFont.familyNames()
    for family in families {
        let ff = UIFont.fontNamesForFamilyName(family)
        for f in ff {
            fonts.append(f)
        }
    }
    return fonts
}()

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
        let indexPaths = nc.1
        let count = nc.0.contents.count
        let sectionCount = indexPaths.sort{$0.section > $1.section}.first!.section + 1
        
        var rowCountInSection = [Int: Int]()
        for i in 0..<sectionCount {
            let rowCount = indexPaths.filter{$0.section == i}.count
            rowCountInSection[i] = rowCount
        }
        
        let randomIndexs = (0..<count).map{$0}
        var anis = [Int: AniDescriptor]()
        for (i, content) in nc.0.contents.enumerate() {
            
            let row = indexPaths[i].row
            let section = indexPaths[i].section
            let rowCount = rowCountInSection[section]!
            //sectionCount, rowCountInSection, section, row
            // index =
            
            // TODO: 2. Need an Animation Type Factory.  -- EMIAOSTEIN, 4/04/16, 16:38
            if let a = AniFactory.animationWith(descriptor.type, canvasSize: canvasSize, container: c, content: content, contentsCount: nc.0.contents.count, index: i, inSection: section, rowAtSection: row, sectionCount: sectionCount, rowCountAtSection: rowCount,  descriptor: descriptor, addBeganTime: addBeganTime,randomIndexs: randomIndexs) {
                anis[i] = a
            }
        }
        let ac = AniContainer(container: nc.0, animations: anis)

        return ac
    }
    
    
    
    private func containersBy(container: Container, spliteType type: (TextSpliter.TextLineSpliteType, TextSpliter.TextSpliteType)) -> (Container, [NSIndexPath]) {
        let source = container.contents.first!.source
        
        var width = container.width
        var registedNames = [String]()
        
        if let font = source.attribute?[NSFontAttributeName] as? UIFont where CTAFontsManager.registedFontNames().contains(font.fontName) {
            
        } else {
            width += 100
        }
        
        let r = TextSpliter.spliteText(source.texts, withAttributes: source.attribute, inConstraintSize: CGSize(width: CGFloat(width), height: CGFloat.max), bySpliteType:type)
        let units = r.0
        let size = r.1
        let indexPaths = units.map{NSIndexPath(forItem: $0.row, inSection: $0.section)}
        
        var contents = [Content]()
        
        for u in units {
            
            let s = Source(type: .Text, text: u.text, attributes: u.attriubtes)
            let content = Content(cx: u.usedRect.midX, cy: u.usedRect.midY, width: u.usedRect.width, height: u.usedRect.height, source: s)
            
            contents.append(content)
        }

        let c = Container(cx: container.positionX, cy: container.positionY, width: size.width, height: size.height, rotation: container.rotation, identifier: container.identifier, contents: contents)
        
        return (c, indexPaths)
    }
}

//private extension Array {
//    
//    func fisherYatesShuffle() -> Array {
//        var n = count
//        while n > 0 {
//            let r = random() % (n - 1)
//            let last = n - 1
//            (self[r], self[last]) = (self[last], self[r])
//            
//        }
//    }
//}