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
    }
    
    private(set) var width = 512.0
    private(set) var height = 512.0
    private var containers = [CTAContainer]()
    
    required init?(coder aDecoder: NSCoder) {
        width = aDecoder.decodeDoubleForKey(SerialKeys.width)
        height = aDecoder.decodeDoubleForKey(SerialKeys.height)
        containers = aDecoder.decodeObjectForKey(SerialKeys.containers) as! [CTAContainer]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(width, forKey: SerialKeys.width)
        aCoder.encodeDouble(height, forKey: SerialKeys.height)
        aCoder.encodeObject(containers, forKey: SerialKeys.containers)
    }
    
    override init() {
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
    
    func removeAll() {
        dispatch_sync(containerQueue) {
            self.containers = [CTAContainer]()
        }
    }
}