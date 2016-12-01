//
//  CTAPage.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/15/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation

final class CTAPage:NSObject, NSCoding {
    
    let containerQueue = DispatchQueue(label: "com.botai.CuriosText.pageUpdateQueue", attributes: [])
    
    fileprivate struct SerialKeys {
        static let width = "width"
        static let height = "height"
        static let backgroundColor = "backgroundColor"
        static let containers = "containers"
        static let animations = "animations"
        static let filterName = "filterName"
    }
    
    fileprivate(set) var backgroundColor = "FFFFFF"
    fileprivate(set) var width = 414.0
    fileprivate(set) var height = 414.0
    fileprivate(set) var containers = [CTAContainer]()
    fileprivate(set) var animatoins = [CTAAnimation]()
    fileprivate(set) var filterName = ""
    
    
    required init?(coder aDecoder: NSCoder) {
        width = aDecoder.decodeDouble(forKey: SerialKeys.width)
        height = aDecoder.decodeDouble(forKey: SerialKeys.height)
        containers = aDecoder.decodeObject(forKey: SerialKeys.containers) as! [CTAContainer]
        animatoins = aDecoder.decodeObject(forKey: SerialKeys.animations) as! [CTAAnimation]
        backgroundColor = aDecoder.decodeObject(forKey: SerialKeys.backgroundColor) as? String ?? "FFFFFF"
        filterName = aDecoder.decodeObject(forKey: SerialKeys.filterName) as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(width, forKey: SerialKeys.width)
        aCoder.encode(height, forKey: SerialKeys.height)
        aCoder.encode(backgroundColor, forKey: SerialKeys.backgroundColor)
        aCoder.encode(containers, forKey: SerialKeys.containers)
        aCoder.encode(animatoins, forKey: SerialKeys.animations)
        aCoder.encode(filterName, forKey: SerialKeys.filterName)
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
    
    func changeFilterName(_ s: String) {
        filterName = s
    }
    
    func changeBackColor(_ hex: String) {
        backgroundColor = hex
    }
    
    func append(_ container: CTAContainer) {
//        dispatch_sync(containerQueue) {
            containers.append(container)
//        }
    }
    
    func insert(_ container: CTAContainer, atIndex index: Int = 0) {
//        dispatch_sync(containerQueue) {
            containers.insert(container, at: index)
//        }
    }
    
    func removeAt(_ index: Int) {
//        dispatch_sync(containerQueue) {
        
            let container = self.containers.remove(at: index)
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
            containers.removeSubrange(1..<containers.count)
        }
        
//        backgroundColor = temp.backgroundColor
        containers.append(contentsOf: temp.containers)
        animatoins = temp.animatoins
    }
    
    func replaceBy(containers container: [CTAContainer], animations anis: [CTAAnimation] ) {
        self.containers = container
        self.animatoins = anis
    }
    
    func removeAnimationAtIndex(_ i: Int, completedHandler:(() -> ())?) {
//        dispatch_sync(containerQueue) {
        
            DispatchQueue.main.async(execute: {
                self.animatoins.remove(at: i)
                completedHandler?()
            })
//        }
    }
    
    func appendAnimation(_ a: CTAAnimation, completedHandler:(() -> ())?) {
        
//        dispatch_sync(containerQueue) {
            DispatchQueue.main.async(execute: {
                self.animatoins.append(a)
                completedHandler?()
            })
//        }
    }
}

extension CTAPage {
    
    func removeLastImageContainer() {
            if let container = self.containers.first as? ImageContainerVMProtocol, container.type == .image {
                let container = self.containers.remove(at: 0)
                let anis = self.animatoins.filter{container.iD != $0.targetiD}
                self.animatoins = anis
            }
    }
    
    func cleanEmptyContainers() -> CTAPage {
        
        let c = containers.filter{ $0.type != .text ? true : !($0.textElement!.isEmpty) }
        let ids = c.map{$0.iD}
        let a = animatoins.filter{ids.contains($0.targetiD)}
        
//        containers = c
//        animatoins = a
        
        return CTAPage(containers: c, anis: a, background: backgroundColor, filterName: filterName)
    }
}
