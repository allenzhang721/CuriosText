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

//let defaultTextAttributes: [String: AnyObject] = [
//    
//    TextAttributeName.fontFamily: CTAFontsManager.defaultFamily(),
//    TextAttributeName.fontName: CTAFontsManager.defaultFontName(),
//    TextAttributeName.fontSize: NSNumber(integer: Int(UIFont.labelFontSize())),
//    TextAttributeName.fontMatrix: [
//        TextAttributeName.fontMatrixScale: 3.0],
//    TextAttributeName.ForegroundColor: [
//        TextAttributeName.ForegroundColorR: 1.0,
//        TextAttributeName.ForegroundColorG: 1.0,
//        TextAttributeName.ForegroundColorB: 1.0,
//        TextAttributeName.ForegroundColorA: 1.0],
//    TextAttributeName.kern: NSNumber(integer: 0),
//    TextAttributeName.paragraph: [
//        TextAttributeName.paragraphLineSpacing: 0.0,
//        TextAttributeName.paragraphAlignment: NSTextAlignment.Right.rawValue],
//    TextAttributeName.shadowOn: NSNumber(bool: false),
//    TextAttributeName.shadow: [
//        TextAttributeName.shadowOffset: [
//            TextAttributeName.shadowOffsetWidth: 0,
//            TextAttributeName.shadowOffsetHeight: 0],
//        TextAttributeName.shadowColor: [
//            TextAttributeName.shadowColorR: 0.0,
//            TextAttributeName.shadowColorG: 0.0,
//            TextAttributeName.shadowColorB: 0.0,
//            TextAttributeName.shadowColorA: 1.0],
//        TextAttributeName.shadowBlurRadius: NSNumber(integer: 0)
//    ]
//]

final class CTATextAttributes:NSObject, NSCoding {
    
    var fontFamily: String = CTAFontsManager.defaultFamily()
    var fontName: String = CTAFontsManager.defaultFontName()
    var fontSize = Double(34)
    var fontScale = 1.0
    var textColorHex = "#000000"
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
        
        let textColor = UIColor(hexString: textColorHex, alpha: Float(textColorAlpha)) ?? UIColor.blackColor()
        
        return [
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: paragraphStyle,
            NSForegroundColorAttributeName: textColor,
            NSKernAttributeName: NSNumber(double: textKern)
        ]
    }
    
    func fontWithFontFamily(family: String, fontName name: String) -> UIFont {
        
        let afamily = family
        let aname = name
        let size = fontSize
        let scaleMatrix = NSValue(CGAffineTransform: CGAffineTransformMakeScale(CGFloat(fontScale), CGFloat(fontScale)))
        
        let fontAttributes: [String: AnyObject] = [
            UIFontDescriptorFamilyAttribute: afamily,
            UIFontDescriptorNameAttribute: aname,
            UIFontDescriptorSizeAttribute: size,
            UIFontDescriptorMatrixAttribute: scaleMatrix,
        ]
        
        let fontdes = UIFontDescriptor(fontAttributes: fontAttributes)
        return UIFont(descriptor: fontdes, size: -1)
        
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
    
    func textAttributesWithFontScaleWithFontFamily(family: String, fontName name: String) -> [String: AnyObject] {
        
        let afont = fontWithFontFamily(family, fontName: name)
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
    
    func textAttributesWithTextAlignment(alignment: NSTextAlignment) -> [String: AnyObject] {
        
        let afont = font
        let paragraphStyle: NSParagraphStyle = {
            let p = NSMutableParagraphStyle()
            p.lineSpacing = CGFloat(textlineSpacing)
            p.alignment = alignment
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
    
    func textAttributesWithLineSpacing(lineSpacing: CGFloat, textSpacing: CGFloat) -> [String: AnyObject] {
        
        let afont = font
        let paragraphStyle: NSParagraphStyle = {
            let p = NSMutableParagraphStyle()
            p.lineSpacing = CGFloat(lineSpacing)
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
            NSKernAttributeName: NSNumber(float: Float(textSpacing))
        ]
    }
    
    func textAttributesWithColor(color: UIColor) -> [String: AnyObject] {
        
        let afont = font
        let paragraphStyle: NSParagraphStyle = {
            let p = NSMutableParagraphStyle()
            p.lineSpacing = CGFloat(textlineSpacing)
            p.alignment = textAligiment
            return p
        }()
        
//        let textColor: UIColor = {
//            
//            return UIColor.whiteColor()
//        }()
        
        return [
            NSFontAttributeName: afont,
            NSParagraphStyleAttributeName: paragraphStyle,
            NSForegroundColorAttributeName: color,
            NSKernAttributeName: NSNumber(float: Float(textKern))
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


final class CTATextElement: NSObject, CTAElement {
    
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
    
    var scale: CGFloat {
        set {
            fontScale = newValue
        }
        
        get {
            return fontScale
        }
    }
    
    func resultWithText(text: String, constraintSize: CGSize) -> (inset: CGPoint, size: CGSize) {
        
        let inset = CGPoint(x: 20.0 / 17.0 * fontSize * scale, y: 0)
        let str = attributeStringWithText(text)
        let textSize = str.boundingRectWithSize(constraintSize, options: .UsesLineFragmentOrigin, context: nil).size
        let size = CGSize(width: textSize.width + inset.x * 2 + shadowOffset.x + shadowBlurRadius, height: textSize.height + inset.y * 2 + shadowOffset.y + shadowBlurRadius)
        
        return (inset, size)
    }
    
    
    func resultWithScale(scale: CGFloat, preScale: CGFloat, containerSize: CGSize, constraintSzie: CGSize) -> (inset: CGPoint, size: CGSize) {
        
        let inset = CGPoint(x: 20.0 / 17.0 * fontSize * scale, y: 0)
        let str = attributeStringWithFontScale(scale)
        let textSize = str.boundingRectWithSize(constraintSzie, options: .UsesLineFragmentOrigin, context: nil).size
        let size = CGSize(width: textSize.width + inset.x * 2 + shadowOffset.x + shadowBlurRadius, height: textSize.height + inset.y * 2 + shadowOffset.y + shadowBlurRadius)
        
//        print("need TextSize = \(textSize)")
        
        return (inset, size)
    }
    
    func resultWithFontFamily(family: String, fontName name: String, constraintSize: CGSize) -> (inset: CGPoint, size: CGSize) {
        
        let inset = CGPoint(x: 20.0 / 17.0 * fontSize * scale, y: 0)
        let str = attributeStringWithFontScale(scale)
        let textSize = str.boundingRectWithSize(constraintSize, options: .UsesLineFragmentOrigin, context: nil).size
        let size = CGSize(width: textSize.width + inset.x * 2 + shadowOffset.x + shadowBlurRadius, height: textSize.height + inset.y * 2 + shadowOffset.y + shadowBlurRadius)
        
        //        print("need TextSize = \(textSize)")
        
        return (inset, size)
    }
    
    func resultWithLineSpacing(lineSpacing: CGFloat, textSpacing: CGFloat, constraintSize: CGSize) -> (inset: CGPoint, size: CGSize) {
        
        let inset = CGPoint(x: 20.0 / 17.0 * fontSize * scale, y: 0)
        let str = attributeStringWithLineSpacing(lineSpacing, textSpacing: textSpacing)
        let textSize = str.boundingRectWithSize(constraintSize, options: .UsesLineFragmentOrigin, context: nil).size
        let size = CGSize(width: textSize.width + inset.x * 2 + shadowOffset.x + shadowBlurRadius, height: textSize.height + inset.y * 2 + shadowOffset.y + shadowBlurRadius)
        
        //        print("need TextSize = \(textSize)")
        
        return (inset, size)
        
    }
}

// MARK: - TextModify
extension CTATextElement: TextModifiable {
    
    var attributeString: NSAttributedString {
        
        return NSAttributedString(string: texts, attributes: attributes.textAttributes)
    }
    
    var textAttributes: [String: AnyObject] {
        
        return attributes.textAttributes
    }
    
    var fontSize: CGFloat {
        return CGFloat(attributes.fontSize)
    }
    
    var texts: String {
     
        get {
            return text.isEmpty ? LocalStrings.EditTextPlaceHolder.description : text
        }
        
        set {
            text = newValue
        }
    }
    
    var isEmpty: Bool {
        return text.isEmpty
    }
    
    var fontScale: CGFloat {
        get {
            return CGFloat(attributes.fontScale)
        }
        
        set {
            attributes.fontScale = Double(newValue)
        }
    }
    
    var fontFamily: String {
        get {
            return attributes.fontFamily
        }
        
        set {
            attributes.fontFamily = newValue
        }
    }
    var fontName: String {
        get {
            return attributes.fontName
        }
        
        set {
            attributes.fontName = newValue
        }
        
    }
    
    var alignment: NSTextAlignment {
     
        get {
            return attributes.textAligiment
        }
        
        set {
            attributes.textAligiment = newValue
        }
    }
    
    var lineSpacing: CGFloat {
        get {
            return CGFloat(attributes.textlineSpacing)
        }
        
        set {
            attributes.textlineSpacing = Double(newValue)
        }
    }
    
    var textSpacing: CGFloat{
        get {
            return CGFloat(attributes.textKern)
        }
        
        set {
            attributes.textKern = Double(newValue)
        }
    }
    
    var colorHex: String {
        get {
            return attributes.textColorHex
        }
        
        set {
            attributes.textColorHex = newValue
        }
        
    }
    var colorAlpha: CGFloat {
        get {
            return CGFloat(attributes.textColorAlpha)
        }
        
        set {
            attributes.textColorAlpha = Double(newValue)
        }
    }
    
    var shadowOffset: CGPoint {
        return attributes.textShadowOffset
    }
    var shadowBlurRadius: CGFloat {
        return CGFloat(attributes.textShadowBlurRadius)
    }
    
    func attributeStringWithText(atext: String) -> NSAttributedString {
        
        return NSAttributedString(string: atext, attributes: attributes.textAttributes)
    }
    
    func attributeStringWithFontScale(scale: CGFloat) -> NSAttributedString {
        
        return NSAttributedString(string: texts, attributes: attributes.textAttributesWithFontScale(scale))
    }
    
    func attributeStringWithFontFamily(family: String, fontName name: String) -> NSAttributedString {
        
        return NSAttributedString(string: texts, attributes: attributes.textAttributesWithFontScaleWithFontFamily(family, fontName: name))
    }
    
    func attributeStringWithAlignment(alignment: NSTextAlignment) -> NSAttributedString {
        
        return NSAttributedString(string: texts, attributes: attributes.textAttributesWithTextAlignment(alignment))
    }
    
    func attributeStringWithLineSpacing(lineSpacing: CGFloat, textSpacing: CGFloat) -> NSAttributedString {
        
        return NSAttributedString(string: texts, attributes: attributes.textAttributesWithLineSpacing(lineSpacing, textSpacing: textSpacing))
    }
    
}