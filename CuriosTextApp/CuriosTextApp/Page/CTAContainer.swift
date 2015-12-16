//
//  CTAContainer.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/15/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation

final class CTAContainer: NSObject, NSCoding {
    
    private struct SerialKeys {
        static let x = "x"
        static let y = "y"
        static let width = "width"
        static let height = "height"
        static let rotation = "rotation"
        static let alpha = "alpha"
        static let scale = "scale"
        static let element = "element"
    }
    
    private(set) var x = 0.0
    private(set) var y = 0.0
    private(set) var width = 50.0
    private(set) var height = 50.0
    private(set) var rotation = 0.0
    private(set) var alpha = 1.0
    private(set) var scale = 1.0
    private(set) var element: CTAElement?
    
    required init?(coder aDecoder: NSCoder) {
        x = aDecoder.decodeDoubleForKey(SerialKeys.x)
        y = aDecoder.decodeDoubleForKey(SerialKeys.y)
        width = aDecoder.decodeDoubleForKey(SerialKeys.width)
        height = aDecoder.decodeDoubleForKey(SerialKeys.height)
        rotation = aDecoder.decodeDoubleForKey(SerialKeys.rotation)
        alpha = aDecoder.decodeDoubleForKey(SerialKeys.alpha)
        scale = aDecoder.decodeDoubleForKey(SerialKeys.scale)
        element = aDecoder.decodeObjectForKey(SerialKeys.element) as? CTAElement
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(x, forKey: SerialKeys.x)
        aCoder.encodeDouble(y, forKey: SerialKeys.y)
        aCoder.encodeDouble(width, forKey: SerialKeys.width)
        aCoder.encodeDouble(height, forKey: SerialKeys.height)
        aCoder.encodeDouble(rotation, forKey: SerialKeys.rotation)
        aCoder.encodeDouble(alpha, forKey: SerialKeys.alpha)
        aCoder.encodeDouble(scale, forKey: SerialKeys.scale)
        aCoder.encodeObject(element, forKey: SerialKeys.element)
    }
    
    init(x: Double, y: Double, width: Double, height: Double, rotation: Double, alpha: Double, scale: Double, element: CTAElement?) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.rotation = rotation
        self.alpha = alpha
        self.scale = scale
        self.element = element
        
    }
}