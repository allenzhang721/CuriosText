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
        static let backgroundColor = "backgroundColor"
        static let containers = "containers"
        static let animations = "animations"
        static let filterName = "filterName"
    }
    
    private(set) var backgroundColor = "FFFFFF"
    private(set) var width = 414.0
    private(set) var height = 414.0
    private(set) var containers = [CTAContainer]()
    private(set) var animatoins = [CTAAnimation]()
    private(set) var filterName = ""
    
    
    required init?(coder aDecoder: NSCoder) {
        width = aDecoder.decodeDoubleForKey(SerialKeys.width)
        height = aDecoder.decodeDoubleForKey(SerialKeys.height)
        containers = aDecoder.decodeObjectForKey(SerialKeys.containers) as! [CTAContainer]
        animatoins = aDecoder.decodeObjectForKey(SerialKeys.animations) as! [CTAAnimation]
        backgroundColor = aDecoder.decodeObjectForKey(SerialKeys.backgroundColor) as? String ?? "FFFFFF"
        filterName = aDecoder.decodeObjectForKey(SerialKeys.filterName) as? String ?? ""
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(width, forKey: SerialKeys.width)
        aCoder.encodeDouble(height, forKey: SerialKeys.height)
        aCoder.encodeObject(backgroundColor, forKey: SerialKeys.backgroundColor)
        aCoder.encodeObject(containers, forKey: SerialKeys.containers)
        aCoder.encodeObject(animatoins, forKey: SerialKeys.animations)
        aCoder.encodeObject(filterName, forKey: SerialKeys.filterName)
    }
    
    init(containers: [CTAContainer], anis: [CTAAnimation] = [], background: String = "FFFFFF", filterName: String = "") {
        self.containers = containers
        self.animatoins = anis
        self.backgroundColor = background
        self.filterName = filterName
        super.init()
    }
    
    subscript(idx: Int) -> CTAContainer {
        var container: CTAContainer!
        
//        dispatch_sync(containerQueue) {
            container = self.containers[idx]
//        }
        
        return container
    }
    
    func changeFilterName(s: String) {
        filterName = s
    }
    
    func changeBackColor(hex: String) {
        backgroundColor = hex
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
        
//        backgroundColor = temp.backgroundColor
        containers.appendContentsOf(temp.containers)
        animatoins = temp.animatoins
    }
    
    func replaceBy(containers container: [CTAContainer], animations anis: [CTAAnimation] ) {
        self.containers = container
        self.animatoins = anis
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
        
        return CTAPage(containers: c, anis: a, background: backgroundColor, filterName: filterName)
    }
}
