//
//  CTAContainer.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/15/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation
import UIKit

final class CTAContainer: NSObject, NSCoding, ContainerVMProtocol {
    
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
    
    private(set) var x = 0.0
    private(set) var y = 0.0
    private(set) var width = 50.0
    private(set) var height = 50.0
    private(set) var rotation = 0.0
    private(set) var alpha = 1.0
    private(set) var contentScale = 1.0
    private(set) var contentInset = CGPoint.zero
    private(set) var element: CTAElement?
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

// MARK: - contentsTypeRetrivevable
extension CTAContainer {
    
    var type: CTAContentsType {
        switch element {
    
        case is CTATextElement:
            return .Text
            
        default:
            return .Empty
        }
    }
}

// MARK: - ContainerViewModel
extension CTAContainer {
    
    var center: CGPoint {
        get {
            return CGPoint(x: x, y: y)
        }
        
        set {
            x = Double(newValue.x)
            y = Double(newValue.y)
        }
    }
    
    var size: CGSize {
        
        get {
            return CGSize(width: width, height: height)
        }
        
        set {
            width = Double(newValue.width)
            height = Double(newValue.height)
        }
        
    }
    
    var radius: CGFloat {
     
        get {
            return CGFloat(rotation)
        }
        
        set {
            rotation = Double(newValue)
        }
    }
    
    var scale: CGFloat {
        
        get {
            return CGFloat(contentScale)
        }
        
        set {
            
            contentScale = Double(newValue)
            
            
        }
    }
    
    var inset: CGPoint {
        return contentInset
    }
    
    func updateWithScale(ascale: CGFloat, constraintSzie: CGSize) {
        
        scale = ascale
        element!.scale = ascale
        let newResult = element!.resultWithScale(ascale, constraintSzie: constraintSzie)
        let contentSize = CGSize(width: ceil(newResult.size.width), height: ceil(newResult.size.height))
        let inset = CGPoint(x: floor(newResult.inset.x), y: newResult.inset.y)
        // new content size
        let nextSize = CGSize(width: contentSize.width - 2 * inset.x, height: contentSize.height - 2 * inset.y)
        
        size = nextSize
        contentInset = inset
    }
}


// MARK: - TextModifiable, ViewModifiable
extension CTAContainer: TextContainerVMProtocol {
    
    var textElement: protocol<CTAElement, TextModifiable> {
        guard let te = element as? CTATextElement else {
            fatalError("This Contaienr do not contain Text Element")
        }
        
        return te
    }
    
    // TODO: CTAContainer, Calculate the position and origion if occur rotation -- Emiaostein; 2015-12-18-14:49
}