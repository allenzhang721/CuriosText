//
//  CTAPage.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/15/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation

final class CTAPage:NSObject, NSCoding {
    
    let containerQueue = dispatch_queue_create("com.botai.CuriosText.pageUpdateQueue", DISPATCH_QUEUE_SERIAL)
    
    private struct SerialKeys {
        static let width = "width"
        static let height = "height"
        static let containers = "containers"
        static let animations = "animations"
    }
    
    private(set) var width = 414.0
    private(set) var height = 414.0
    private(set) var containers = [CTAContainer]()
    private(set) var animatoins = [CTAAnimation]()
    
    
    required init?(coder aDecoder: NSCoder) {
        width = aDecoder.decodeDoubleForKey(SerialKeys.width)
        height = aDecoder.decodeDoubleForKey(SerialKeys.height)
        containers = aDecoder.decodeObjectForKey(SerialKeys.containers) as! [CTAContainer]
        animatoins = aDecoder.decodeObjectForKey(SerialKeys.animations) as! [CTAAnimation]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(width, forKey: SerialKeys.width)
        aCoder.encodeDouble(height, forKey: SerialKeys.height)
        aCoder.encodeObject(containers, forKey: SerialKeys.containers)
        aCoder.encodeObject(animatoins, forKey: SerialKeys.animations)
    }
    
    init(containers: [CTAContainer], anis: [CTAAnimation] = []) {
        self.containers = containers
        self.animatoins = anis
        super.init()
    }
    
    subscript(idx: Int) -> CTAContainer {
        var container: CTAContainer!
        
//        dispatch_sync(containerQueue) {
            container = self.containers[idx]
//        }
        
        return container
    }
    
    func append(container: CTAContainer) {
//        dispatch_sync(containerQueue) {
            containers.append(container)
//        }
    }
    
    func insert(container: CTAContainer, atIndex index: Int = 0) {
//        dispatch_sync(containerQueue) {
            containers.insert(container, atIndex: index)
//        }
    }
    
    func removeAt(index: Int) {
//        dispatch_sync(containerQueue) {
        
            let container = self.containers.removeAtIndex(index)
            let anis = self.animatoins.filter{container.iD != $0.targetiD}
            self.animatoins = anis
//        }
    }
    
    func removeAll() {
//        dispatch_sync(containerQueue) {
            self.containers = [CTAContainer]()
//        }
    }
    
    func replaceBy(template temp: CTAPage) {
        if containers.count > 1 {
            containers.removeRange(1..<containers.count)
        }
        
        containers.appendContentsOf(temp.containers)
        animatoins = temp.animatoins
        
    }
    
    func removeAnimationAtIndex(i: Int, completedHandler:(() -> ())?) {
//        dispatch_sync(containerQueue) {
        
            
            dispatch_async(dispatch_get_main_queue(), {
                self.animatoins.removeAtIndex(i)
                completedHandler?()
            })
//        }
    }
    
    func appendAnimation(a: CTAAnimation, completedHandler:(() -> ())?) {
        
//        dispatch_sync(containerQueue) {
            dispatch_async(dispatch_get_main_queue(), {
                self.animatoins.append(a)
                completedHandler?()
            })
//        }
    }
}

extension CTAPage {
    
    func removeLastImageContainer() {
            if let container = self.containers.first as? ImageContainerVMProtocol where container.type == .Image {
                let container = self.containers.removeAtIndex(0)
                let anis = self.animatoins.filter{container.iD != $0.targetiD}
                self.animatoins = anis
            }
    }
    
    func cleanEmptyContainers() -> CTAPage {
        
        let c = containers.filter{ $0.type != .Text ? true : !($0.textElement!.isEmpty) }
        let ids = c.map{$0.iD}
        let a = animatoins.filter{ids.contains($0.targetiD)}
        
//        containers = c
//        animatoins = a
        
        return CTAPage(containers: c, anis: a)
    }
}
