//
//  CTAStringElement.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/15/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation
import UIKit

struct TextAttributeName {
    static let prefix = "com.botai.curiosText.TextElment.TextAttributeName."
    static let fontFamily = UIFontDescriptorFamilyAttribute
    static let fontName = UIFontDescriptorNameAttribute
    static let fontSize = UIFontDescriptorSizeAttribute
    static let fontMatrix = UIFontDescriptorMatrixAttribute
    static let fontMatrixScale = prefix + "fontMatrixScale"
    static let ForegroundColor = NSForegroundColorAttributeName
    static let ForegroundColorR = prefix + "ForegroundColorR"
    static let ForegroundColorG = prefix + "ForegroundColorG"
    static let ForegroundColorB = prefix + "ForegroundColorB"
    static let ForegroundColorA = prefix + "ForegroundColorA"
    static let kern = NSKernAttributeName
    static let paragraph = NSParagraphStyleAttributeName
    static let paragraphLineSpacing = prefix + "paragraphLineSapcing"
    static let paragraphAlignment = prefix + "paragraphAlignment"
    static let shadowOn = prefix + "shadowOn"
    static let shadow = NSShadowAttributeName
    static let shadowOffset = prefix + "shadowOffset"
    static let shadowOffsetWidth = prefix + "shadowOffsetWidth"
    static let shadowOffsetHeight = prefix + "shadowOffsetHeight"
    static let shadowColor = prefix + "shadowColor"
    static let shadowColorR = prefix + "shadowColorR"
    static let shadowColorG = prefix + "shadowColorG"
    static let shadowColorB = prefix + "shadowColorB"
    static let shadowColorA = prefix + "shadowColorA"
    static let shadowBlurRadius = "CTATextAttributeshadowBlurRadius"
}

let defaultTextAttributes: [String: AnyObject] = [
    
    TextAttributeName.fontFamily: "Iowan Old Style",
    TextAttributeName.fontName: "IowanOldStyle-BoldItalic",
    TextAttributeName.fontSize: NSNumber(integer: Int(UIFont.labelFontSize())),
    TextAttributeName.fontMatrix: [
        TextAttributeName.fontMatrixScale: 3.0],
    TextAttributeName.ForegroundColor: [
        TextAttributeName.ForegroundColorR: 1.0,
        TextAttributeName.ForegroundColorG: 1.0,
        TextAttributeName.ForegroundColorB: 1.0,
        TextAttributeName.ForegroundColorA: 1.0],
    TextAttributeName.kern: NSNumber(integer: 0),
    TextAttributeName.paragraph: [
        TextAttributeName.paragraphLineSpacing: 0.0,
        TextAttributeName.paragraphAlignment: NSTextAlignment.Right.rawValue],
    TextAttributeName.shadowOn: NSNumber(bool: false),
    TextAttributeName.shadow: [
        TextAttributeName.shadowOffset: [
            TextAttributeName.shadowOffsetWidth: 0,
            TextAttributeName.shadowOffsetHeight: 0],
        TextAttributeName.shadowColor: [
            TextAttributeName.shadowColorR: 0.0,
            TextAttributeName.shadowColorG: 0.0,
            TextAttributeName.shadowColorB: 0.0,
            TextAttributeName.shadowColorA: 1.0],
        TextAttributeName.shadowBlurRadius: NSNumber(integer: 0)
    ]
]

final class CTATextAttributes:NSObject, NSCoding {
    
    var fontFamily: String = "Iowan Old Style"
    var fontName: String = "IowanOldStyle-BoldItalic"
    var fontSize = Double(UIFont.labelFontSize())
    var fontScale = 1.0
    var textColorHex = "#FFFFFF"
    var textColorAlpha = 1.0
    var textKern = 0.0
    var textlineSpacing = 0.0
    var textAligiment = NSTextAlignment.Left
    var textShadowOn = false
    var textShadowOffset = CGPoint.zero
    var textShadowBlurRadius = 0.0
    var textShadowColorHex = "#000000"
    var textShadowColorAplha = 1.0
    
    var font: UIFont {
        
        let family = fontFamily
        let name = fontName
        let size = fontSize
        let scaleMatrix = NSValue(CGAffineTransform: CGAffineTransformMakeScale(CGFloat(fontScale), CGFloat(fontScale)))

        let fontAttributes: [String: AnyObject] = [
            UIFontDescriptorFamilyAttribute: family,
            UIFontDescriptorNameAttribute: name,
            UIFontDescriptorSizeAttribute: size,
            UIFontDescriptorMatrixAttribute: scaleMatrix,
        ]
        
        let fontdes = UIFontDescriptor(fontAttributes: fontAttributes)
        return UIFont(descriptor: fontdes, size: -1)
    }
    
    var textAttributes: [String: AnyObject] {
        
        let paragraphStyle: NSParagraphStyle = {
            let p = NSMutableParagraphStyle()
            p.lineSpacing = CGFloat(textlineSpacing)
            p.alignment = textAligiment
            return p
        }()
        
        let textColor: UIColor = {
            
            return UIColor.whiteColor()
        }()
        
        return [
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: paragraphStyle,
            NSForegroundColorAttributeName: textColor,
            NSKernAttributeName: NSNumber(double: textKern)
        ]
    }
    
    func fontWithFontScale(scale: CGFloat) -> UIFont {
        
        let family = fontFamily
        let name = fontName
        let size = fontSize
        let scaleMatrix = NSValue(CGAffineTransform: CGAffineTransformMakeScale(scale, scale))
        
        let fontAttributes: [String: AnyObject] = [
            UIFontDescriptorFamilyAttribute: family,
            UIFontDescriptorNameAttribute: name,
            UIFontDescriptorSizeAttribute: size,
            UIFontDescriptorMatrixAttribute: scaleMatrix,
        ]
        
        let fontdes = UIFontDescriptor(fontAttributes: fontAttributes)
        return UIFont(descriptor: fontdes, size: -1)
    }
    
    func textAttributesWithFontScale(scale: CGFloat) -> [String: AnyObject] {
        
        let afont = fontWithFontScale(scale)
        let paragraphStyle: NSParagraphStyle = {
            let p = NSMutableParagraphStyle()
            p.lineSpacing = CGFloat(textlineSpacing)
            p.alignment = textAligiment
            return p
        }()
        
        let textColor: UIColor = {
            
            return UIColor.whiteColor()
        }()
        
        return [
            NSFontAttributeName: afont,
            NSParagraphStyleAttributeName: paragraphStyle,
            NSForegroundColorAttributeName: textColor,
            NSKernAttributeName: NSNumber(double: textKern)
        ]
        
        
    }
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(fontFamily, forKey: TextAttributeName.fontFamily)
        aCoder.encodeObject(fontName, forKey: TextAttributeName.fontName)
        aCoder.encodeDouble(fontSize, forKey: TextAttributeName.fontSize)
        aCoder.encodeDouble(fontScale, forKey: TextAttributeName.fontMatrixScale)
        aCoder.encodeObject(textColorHex, forKey: TextAttributeName.ForegroundColor)
        aCoder.encodeDouble(textColorAlpha, forKey: TextAttributeName.ForegroundColorA)
        aCoder.encodeDouble(textKern, forKey: TextAttributeName.kern)
        aCoder.encodeDouble(textlineSpacing, forKey: TextAttributeName.paragraphLineSpacing)
        aCoder.encodeInteger(textAligiment.rawValue, forKey: TextAttributeName.paragraphAlignment)
        aCoder.encodeBool(textShadowOn, forKey: TextAttributeName.shadowOn)
        aCoder.encodeCGPoint(textShadowOffset, forKey: TextAttributeName.shadowOffset)
        aCoder.encodeDouble(textShadowBlurRadius, forKey: TextAttributeName.shadowBlurRadius)
        aCoder.encodeObject(textShadowColorHex, forKey: TextAttributeName.shadowColor)
        aCoder.encodeDouble(textShadowColorAplha, forKey: TextAttributeName.shadowColorA)
    }
    
    init?(coder aDecoder: NSCoder) {
        fontFamily = aDecoder.decodeObjectForKey(TextAttributeName.fontFamily) as! String
        fontName = aDecoder.decodeObjectForKey(TextAttributeName.fontName) as! String
        fontSize = aDecoder.decodeDoubleForKey(TextAttributeName.fontSize)
        fontScale = aDecoder.decodeDoubleForKey(TextAttributeName.fontMatrixScale)
        textColorHex = aDecoder.decodeObjectForKey(TextAttributeName.ForegroundColor) as! String
        textColorAlpha = aDecoder.decodeDoubleForKey(TextAttributeName.ForegroundColorA)
        textKern = aDecoder.decodeDoubleForKey(TextAttributeName.kern)
        textlineSpacing = aDecoder.decodeDoubleForKey(TextAttributeName.paragraphLineSpacing)
        textAligiment = NSTextAlignment(rawValue: aDecoder.decodeIntegerForKey(TextAttributeName.paragraphAlignment))!
        textShadowOn = aDecoder.decodeBoolForKey(TextAttributeName.shadowOn)
        textShadowOffset = aDecoder.decodeCGPointForKey(TextAttributeName.shadowOffset)
        textShadowBlurRadius = aDecoder.decodeDoubleForKey(TextAttributeName.shadowBlurRadius)
        textShadowColorHex = aDecoder.decodeObjectForKey(TextAttributeName.shadowColor) as! String
        textShadowColorAplha = aDecoder.decodeDoubleForKey(TextAttributeName.shadowColorA)
    }
    
    override init() {
    }
}


final class CTATextElement: NSObject, CTAElement, TextModifiable {
    
    private struct SerialKeys {
        static private let prefix = "com.botai.curiosText.TextElment."
        static let x = prefix + "x"
        static let y = prefix + "y"
        static let width = prefix + "width"
        static let height = prefix + "height"
        static let text = prefix + "text"
        static let attributes = prefix + "attributes"
    }
    
//    private(set) var attributeString: NSAttributedString!
//    private(set) var x = 0.0
//    private(set) var y = 0.0
//    private(set) var width = 0.0
//    private(set) var height = 0.0
    private(set) var text = ""
    var attributes = CTATextAttributes()
    
    var resourceName: String {
        return ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey(SerialKeys.text) as! String
        attributes = aDecoder.decodeObjectForKey(SerialKeys.attributes) as! CTATextAttributes
//        x = aDecoder.decodeDoubleForKey(SerialKeys.x)
//        y = aDecoder.decodeDoubleForKey(SerialKeys.y)
//        width = aDecoder.decodeDoubleForKey(SerialKeys.width)
//        height = aDecoder.decodeDoubleForKey(SerialKeys.height)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: SerialKeys.text)
        aCoder.encodeObject(attributes, forKey: SerialKeys.attributes)
//        aCoder.encodeDouble(x, forKey: SerialKeys.x)
//        aCoder.encodeDouble(y, forKey: SerialKeys.y)
//        aCoder.encodeDouble(width, forKey: SerialKeys.width)
//        aCoder.encodeDouble(height, forKey: SerialKeys.height)
        
    }
    
    init(
        text: String,
        attributes: CTATextAttributes = CTATextAttributes()
//        x: Double,
//        y: Double,
//        width: Double,
//        height: Double
        ) {
        
        self.text = text
        self.attributes = attributes
//        self.x = x
//        self.y = y
//        self.width = width
//        self.height = height
    }
}

// MARK: - ViewPropertiesModifiable
//extension CTATextElement {
//    var position: (x: Double, y: Double) {
//        
//        get {
//            return (x: x, y: y)
//        }
//     
//        set {
//            self.x = newValue.x
//            self.y = newValue.y
//        }
//    }
//    var size: (width: Double, height: Double) {
//     
//        get {
//            return (width: width, height: height)
//        }
//        
//        set {
//            self.width = newValue.width
//            self.height = newValue.height
//        }
//    }
//    
//    var radius: Double {
//        get {
//            return 0.0
//        }
//        
//        set {
//            ()
//        }
//    }
//}

// MARK: - TextModify
extension CTATextElement {
    
    var attributeString: NSAttributedString {
        
        return NSAttributedString(string: text, attributes: attributes.textAttributes)
    }
    
    var fontSize: CGFloat {
        return CGFloat(attributes.fontSize)
        
    }
    
    var fontScale: CGFloat {
        get {
            return CGFloat(attributes.fontScale)
        }
        
        set {
            attributes.fontScale = Double(newValue)
        }
    }
    var shadowOffset: CGPoint {
        return attributes.textShadowOffset
    }
    var shadowBlurRadius: CGFloat {
        return CGFloat(attributes.textShadowBlurRadius)
    }
    
    func attributeStringWithFontScale(scale: CGFloat) -> NSAttributedString {
        
        return NSAttributedString(string: text, attributes: attributes.textAttributesWithFontScale(scale))
    }

}