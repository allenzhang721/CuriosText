//
//  CTAContainer.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/15/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation
import UIKit

enum CTAContainerFeatureType: String {

    case Templates, Filters
    case Size, Rotator
    case Fonts, Aligments, TextSpacing, Colors, Animation, ShadowAndStroke //Text
    case Empty
}

final class CTAContainer: NSObject, NSCoding {
    
    private struct SerialKeys {
        static let x = "x"
        static let y = "y"
        static let width = "width"
        static let height = "height"
        static let rotation = "rotation"
        static let alpha = "alpha"
        static let scale = "contentScale"
        static let element = "element"
        static let iD = "iD"
    }
    
    var x = 0.0
    var y = 0.0
    var width = 50.0
    var height = 50.0
    var rotation = 0.0
    var alpha = 1.0
    var contentScale = 1.0
    var contentInset = CGPoint.zero
    var element: CTAElement?
    let iD: String
    
    required init?(coder aDecoder: NSCoder) {
        x = aDecoder.decodeDoubleForKey(SerialKeys.x)
        y = aDecoder.decodeDoubleForKey(SerialKeys.y)
        width = aDecoder.decodeDoubleForKey(SerialKeys.width)
        height = aDecoder.decodeDoubleForKey(SerialKeys.height)
        rotation = aDecoder.decodeDoubleForKey(SerialKeys.rotation)
        alpha = aDecoder.decodeDoubleForKey(SerialKeys.alpha)
        contentScale = aDecoder.decodeDoubleForKey(SerialKeys.scale)
        element = aDecoder.decodeObjectForKey(SerialKeys.element) as? CTAElement
        iD = aDecoder.decodeObjectForKey(SerialKeys.iD) as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(x, forKey: SerialKeys.x)
        aCoder.encodeDouble(y, forKey: SerialKeys.y)
        aCoder.encodeDouble(width, forKey: SerialKeys.width)
        aCoder.encodeDouble(height, forKey: SerialKeys.height)
        aCoder.encodeDouble(rotation, forKey: SerialKeys.rotation)
        aCoder.encodeDouble(alpha, forKey: SerialKeys.alpha)
        aCoder.encodeDouble(contentScale, forKey: SerialKeys.scale)
        aCoder.encodeObject(element, forKey: SerialKeys.element)
        aCoder.encodeObject(iD, forKey: SerialKeys.iD)
    }
    
    init(x: Double, y: Double, width: Double, height: Double, rotation: Double, alpha: Double, scale: Double, inset: CGPoint, element: CTAElement?) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.rotation = rotation
        self.alpha = alpha
        self.contentScale = scale
        self.element = element
        self.contentInset = inset
        self.iD = CTAIDGenerator.generateID()
    }
}

