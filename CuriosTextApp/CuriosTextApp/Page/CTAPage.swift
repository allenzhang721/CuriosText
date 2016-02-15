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
    
    private(set) var width = 320.0
    private(set) var height = 320.0
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
        
        dispatch_sync(containerQueue) {
            container = self.containers[idx]
        }
        
        return container
    }
    
    func append(container: CTAContainer) {
        dispatch_sync(containerQueue) {
            self.containers += [container]
        }
    }
    
    func removeAt(index: Int) {
        dispatch_sync(containerQueue) {
            self.containers.removeAtIndex(index)
        }
    }
    
    func removeAll() {
        dispatch_sync(containerQueue) {
            self.containers = [CTAContainer]()
        }
    }
}
