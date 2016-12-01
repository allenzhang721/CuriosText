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
    case Fonts, Aligments, TextSpacing, Colors, Animation, Alpha, ShadowAndStroke //Text
    case Empty
}

final class CTAContainer: NSObject, NSCoding {
    
    fileprivate struct SerialKeys {
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
        x = aDecoder.decodeDouble(forKey: SerialKeys.x)
        y = aDecoder.decodeDouble(forKey: SerialKeys.y)
        width = aDecoder.decodeDouble(forKey: SerialKeys.width)
        height = aDecoder.decodeDouble(forKey: SerialKeys.height)
        rotation = aDecoder.decodeDouble(forKey: SerialKeys.rotation)
        alpha = aDecoder.decodeDouble(forKey: SerialKeys.alpha)
        contentScale = aDecoder.decodeDouble(forKey: SerialKeys.scale)
        element = aDecoder.decodeObject(forKey: SerialKeys.element) as? CTAElement
        iD = aDecoder.decodeObject(forKey: SerialKeys.iD) as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(x, forKey: SerialKeys.x)
        aCoder.encode(y, forKey: SerialKeys.y)
        aCoder.encode(width, forKey: SerialKeys.width)
        aCoder.encode(height, forKey: SerialKeys.height)
        aCoder.encode(rotation, forKey: SerialKeys.rotation)
        aCoder.encode(alpha, forKey: SerialKeys.alpha)
        aCoder.encode(contentScale, forKey: SerialKeys.scale)
        aCoder.encode(element, forKey: SerialKeys.element)
        aCoder.encode(iD, forKey: SerialKeys.iD)
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

