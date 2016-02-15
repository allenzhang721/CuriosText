//
//  CTAContainerViewModel.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 2/15/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

enum CTAContentsType {
    
    case Empty, Text
}

protocol ContainerVMProtocol: viewPropertiesModifiable, contentsTypeRetrivevable, ContainerIdentifiable {
    
}

extension ContainerVMProtocol {
    
    var featureTypes: [CTAContainerFeatureType] {
        
        switch type {
            
        case .Text:
            let textTypes: [CTAContainerFeatureType] = [
                .Fonts,
                .Size,
                .Rotator,
                .Aligments,
                .TextSpacing,
                .Colors,
                .Animation
            ]
            
            return textTypes
            
        default:
            return []
        }
    }
}

protocol ImageContainerVMProtocol: ContainerVMProtocol {
    
    var imageElement: protocol<CTAElement>? {get}
}

protocol TextContainerVMProtocol: ContainerVMProtocol {
    
    var textElement: protocol<CTAElement, TextModifiable>? { get }
    
    func updateWithFontFamily(family: String, FontName name: String, constraintSize: CGSize)
    func updateWithTextAlignment(alignment: NSTextAlignment)
    func updateWithTextSpacing(lineSpacing: CGFloat, textSpacing: CGFloat, constraintSize: CGSize)
    func updateWithColor(hex: String, alpha: CGFloat)
}

// MARK: - ContainerEdit Protocols

protocol ContainerIdentifiable {
    
    var iD: String { get }
}

protocol TextRetrievable: class {
    
    var attributeString: NSAttributedString { get }
    var fontSize: CGFloat { get }
    var fontScale: CGFloat { get }
    var shadowOffset: CGPoint { get }
    var shadowBlurRadius: CGFloat { get }
    
    func attributeStringWithFontScale(scale: CGFloat) -> NSAttributedString
    func attributeStringWithAlignment(alignment: NSTextAlignment) -> NSAttributedString
}

extension TextRetrievable {
    
    func rectInset() -> CGPoint {
        return CGPoint(x: 50.0 / 17.0 * fontSize * fontScale, y: 0)
    }
    
    func textSizeWithConstraintSize(size: CGSize) -> CGSize {
        
        return attributeString.boundingRectWithSize(size, options: .UsesLineFragmentOrigin, context: nil).size
    }
    
    func textFrameWithTextSize(textsize size: CGSize) -> CGRect {
        
        let origin = CGPoint(x: 0 - rectInset().x, y: 0 - rectInset().y)
        let size = CGSize(width: size.width + rectInset().x * 2 + shadowOffset.x + shadowBlurRadius, height: size.height + rectInset().y + 2 + shadowOffset.y + shadowBlurRadius)
        return CGRect(origin: origin, size: size)
    }
    
    func textResultWithScale(scale: CGFloat, constraintSzie: CGSize) -> (CGPoint, CGSize, CGRect, NSAttributedString) {
        let inset = CGPoint(x: 50.0 / 17.0 * fontSize * scale, y: 0)
        let str = attributeStringWithFontScale(scale)
        let textSize = str.boundingRectWithSize(constraintSzie, options: .UsesLineFragmentOrigin, context: nil).size
        let origin = CGPoint(x: 0 - inset.x, y: 0 - inset.y)
        let size = CGSize(width: textSize.width + inset.x * 2 + shadowOffset.x + shadowBlurRadius, height: textSize.height + inset.y + 2 + shadowOffset.y + shadowBlurRadius)
        let rect = CGRect(origin: origin, size: size)
        
        return (inset, textSize, rect, str)
    }
    
    func textResultWithAlignment(alignment: NSTextAlignment) -> NSAttributedString {
        return attributeStringWithAlignment(alignment)
    }
}

protocol TextModifiable: TextRetrievable {
    
    var fontScale: CGFloat { get set }
    var fontFamily: String { get set }
    var fontName: String { get set }
    var alignment: NSTextAlignment { get set }
    var lineSpacing: CGFloat { get set }
    var textSpacing: CGFloat { get set }
    var colorHex: String { get set }
    var colorAlpha: CGFloat { get set }
    
    func resultWithFontFamily(family: String, fontName name: String, constraintSize: CGSize) -> (inset: CGPoint, size: CGSize)
    
    func resultWithLineSpacing(lineSpacing: CGFloat, textSpacing: CGFloat, constraintSize: CGSize) -> (inset: CGPoint, size: CGSize)
}

protocol ViewPropertiesRetrivevale:class {
    
    //    var origion: (x: Double, y: Double) { get }
    var center: CGPoint { get }
    var size: CGSize { get } // real size + inset
    var scale: CGFloat { get }
    var radius: CGFloat { get }
    var inset: CGPoint { get }
    
    func updateWithScale(ascale: CGFloat, constraintSzie: CGSize)
}

protocol viewPropertiesModifiable: ViewPropertiesRetrivevale {
    
    //    var origion: (x: Double, y: Double) { get set }
    var center: CGPoint { set get }
    var size: CGSize { get set }
    var scale: CGFloat { get set }
    var radius: CGFloat { get set }
}

protocol contentsTypeRetrivevable {
    
    var type: CTAContentsType { get }
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
extension CTAContainer: ContainerVMProtocol {
    
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
    
    var textElement: protocol<CTAElement, TextModifiable>? {
        guard let te = element as? CTATextElement else {
            return nil
            fatalError("This Contaienr do not contain Text Element")
        }
        
        return te
    }
    
    func updateWithFontFamily(family: String, FontName name: String, constraintSize: CGSize) {
        
        guard let textElement = textElement else {
            fatalError("This Contaienr do not contain Text Element")
        }
        
        textElement.fontFamily = family
        textElement.fontName = name
        
        let newResult = textElement.resultWithFontFamily(family, fontName: name, constraintSize: constraintSize)
        let contentSize = CGSize(width: ceil(newResult.size.width), height: ceil(newResult.size.height))
        let inset = CGPoint(x: floor(newResult.inset.x), y: newResult.inset.y)
        // new content size
        let nextSize = CGSize(width: contentSize.width - 2 * inset.x, height: contentSize.height - 2 * inset.y)
        
        size = nextSize
        contentInset = inset
    }
    
    func updateWithTextAlignment(alignment: NSTextAlignment) {
        guard let textElement = textElement else {
            fatalError("This Contaienr do not contain Text Element")
        }
        
        textElement.alignment = alignment
        
    }
    
    func updateWithTextSpacing(lineSpacing: CGFloat, textSpacing: CGFloat, constraintSize: CGSize) {
        guard let textElement = textElement else {
            fatalError("This Contaienr do not contain Text Element")
        }
        
        textElement.lineSpacing = lineSpacing
        textElement.textSpacing = textSpacing
        
        let newResult = textElement.resultWithLineSpacing(lineSpacing, textSpacing: textSpacing, constraintSize: constraintSize)
        let contentSize = CGSize(width: ceil(newResult.size.width), height: ceil(newResult.size.height))
        let inset = CGPoint(x: floor(newResult.inset.x), y: newResult.inset.y)
        // new content size
        let nextSize = CGSize(width: contentSize.width - 2 * inset.x, height: contentSize.height - 2 * inset.y)
        
        size = nextSize
        contentInset = inset
    }
    
    func updateWithColor(hex: String, alpha: CGFloat) {
        
        guard let textElement = textElement else {
            fatalError("This Contaienr do not contain Text Element")
        }
        
        textElement.colorHex = hex
        textElement.colorAlpha = alpha
        
    }
    
    // TODO: CTAContainer, Calculate the position and origion if occur rotation -- Emiaostein; 2015-12-18-14:49
}