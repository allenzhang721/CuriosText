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
    static let needShadow = prefix + "needShadow"
    static let needStroke = prefix + "needStroke"
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
    var fontScale = 1.5
    var textColorHex = "#FFFFFF"
    var textColorAlpha = 1.0
    var textKern = 0.0
    var textlineSpacing = 0.0
    var textAligiment = NSTextAlignment.left
    var textShadowOn = false
    var textShadowOffset = CGPoint.zero
    var textShadowBlurRadius = 0.0
    var textShadowColorHex = "#000000"
    var textShadowColorAplha = 1.0
    var textStrokeColorHex = "#000000" //TODO: Stroke Color  -- Emiaostein, 7/7/16, 14:52
    var textStrokeWidth = -2.0 // 0.0 is no stroke, postion value is stroke only, negative is stroke and fill, typic value is -3.0
    var needStroke = false
    var needShadow = false
    
    var font: UIFont {
        
        let family = fontFamily
        let name = fontName
        let size = fontSize
        let scaleMatrix = NSValue(cgAffineTransform: CGAffineTransform(scaleX: CGFloat(fontScale), y: CGFloat(fontScale)))
        
        let fontAttributes: [String: AnyObject] = [
            UIFontDescriptorFamilyAttribute: family as AnyObject,
            UIFontDescriptorNameAttribute: name as AnyObject,
            UIFontDescriptorSizeAttribute: size as AnyObject,
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
        
        let textColor = UIColor(hexString: textColorHex, alpha: Float(textColorAlpha)) ?? UIColor.black

        var attribe = [
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: paragraphStyle,
            NSForegroundColorAttributeName: textColor,
            NSKernAttributeName: NSNumber(value: textKern as Double),
        ]
        
        if needStroke {
            let strokeColorHex = textColorHex == "#000000" ? "#FFFFFF" : "#000000"
            let strokeColor = UIColor(hexString: strokeColorHex) ?? UIColor.red
            attribe[NSStrokeWidthAttributeName] = textStrokeWidth as NSObject?
            attribe[NSStrokeColorAttributeName] = strokeColor
        }
        
        if needShadow {
            let shadow = NSShadow()
            let shadowColor = UIColor(hexString: textShadowColorHex) ?? UIColor.blue
            shadow.shadowBlurRadius = 0.0
            shadow.shadowColor = shadowColor
            shadow.shadowOffset = CGSize(width: 1, height: 1)
            attribe[NSShadowAttributeName] = shadow
        }
        
        return attribe
    }
    
    func fontWithFontFamily(_ family: String, fontName name: String) -> UIFont {
        
        let afamily = family
        let aname = name
        let size = fontSize
        let scaleMatrix = NSValue(cgAffineTransform: CGAffineTransform(scaleX: CGFloat(fontScale), y: CGFloat(fontScale)))
        
        let fontAttributes: [String: AnyObject] = [
            UIFontDescriptorFamilyAttribute: afamily as AnyObject,
            UIFontDescriptorNameAttribute: aname as AnyObject,
            UIFontDescriptorSizeAttribute: size as AnyObject,
            UIFontDescriptorMatrixAttribute: scaleMatrix,
        ]
        
        let fontdes = UIFontDescriptor(fontAttributes: fontAttributes)
        return UIFont(descriptor: fontdes, size: -1)
        
    }
    
    func fontWithFontScale(_ scale: CGFloat) -> UIFont {
        
        let family = fontFamily
        let name = fontName
        let size = fontSize
        let scaleMatrix = NSValue(cgAffineTransform: CGAffineTransform(scaleX: scale, y: scale))
        
        let fontAttributes: [String: AnyObject] = [
            UIFontDescriptorFamilyAttribute: family as AnyObject,
            UIFontDescriptorNameAttribute: name as AnyObject,
            UIFontDescriptorSizeAttribute: size as AnyObject,
            UIFontDescriptorMatrixAttribute: scaleMatrix,
        ]
        
        let fontdes = UIFontDescriptor(fontAttributes: fontAttributes)
        return UIFont(descriptor: fontdes, size: -1)
    }
    
    func textAttributesWithFontScale(_ scale: CGFloat) -> [String: AnyObject] {
        
        let afont = fontWithFontScale(scale)
        let paragraphStyle: NSParagraphStyle = {
            let p = NSMutableParagraphStyle()
            p.lineSpacing = CGFloat(textlineSpacing)
            p.alignment = textAligiment
            return p
        }()
        
        let textColor: UIColor = {
            
            return UIColor.white
        }()
        
        return [
            NSFontAttributeName: afont,
            NSParagraphStyleAttributeName: paragraphStyle,
            NSForegroundColorAttributeName: textColor,
            NSKernAttributeName: NSNumber(value: textKern as Double)
        ]
    }
    
    func textAttributesWithFontScaleWithFontFamily(_ family: String, fontName name: String) -> [String: AnyObject] {
        
        let afont = fontWithFontFamily(family, fontName: name)
        let paragraphStyle: NSParagraphStyle = {
            let p = NSMutableParagraphStyle()
            p.lineSpacing = CGFloat(textlineSpacing)
            p.alignment = textAligiment
            return p
        }()
        
        let textColor: UIColor = {
            
            return UIColor.white
        }()
        
        return [
            NSFontAttributeName: afont,
            NSParagraphStyleAttributeName: paragraphStyle,
            NSForegroundColorAttributeName: textColor,
            NSKernAttributeName: NSNumber(value: textKern as Double)
        ]
        
    }
    
    func textAttributesWithTextAlignment(_ alignment: NSTextAlignment) -> [String: AnyObject] {
        
        let afont = font
        let paragraphStyle: NSParagraphStyle = {
            let p = NSMutableParagraphStyle()
            p.lineSpacing = CGFloat(textlineSpacing)
            p.alignment = alignment
            return p
        }()
        
        let textColor: UIColor = {
            
            return UIColor.white
        }()
        
        return [
            NSFontAttributeName: afont,
            NSParagraphStyleAttributeName: paragraphStyle,
            NSForegroundColorAttributeName: textColor,
            NSKernAttributeName: NSNumber(value: textKern as Double)
        ]
        
    }
    
//    func textAttributesWithNeedShadow(needShadow: Bool, needStroke:) -> [String: AnyObject] {
//        
//    }
    
    func textAttributesWithLineSpacing(_ lineSpacing: CGFloat, textSpacing: CGFloat) -> [String: AnyObject] {
        
        let afont = font
        let paragraphStyle: NSParagraphStyle = {
            let p = NSMutableParagraphStyle()
            p.lineSpacing = CGFloat(lineSpacing)
            p.alignment = textAligiment
            return p
        }()
        
        let textColor: UIColor = {
            
            return UIColor.white
        }()
        
        return [
            NSFontAttributeName: afont,
            NSParagraphStyleAttributeName: paragraphStyle,
            NSForegroundColorAttributeName: textColor,
            NSKernAttributeName: NSNumber(value: Float(textSpacing) as Float)
        ]
    }
    
    func textAttributesWithColor(_ color: UIColor) -> [String: AnyObject] {
        
        let afont = font
        let paragraphStyle: NSParagraphStyle = {
            let p = NSMutableParagraphStyle()
            p.lineSpacing = CGFloat(textlineSpacing)
            p.alignment = textAligiment
            return p
        }()
        
        var attribte = [
            NSFontAttributeName: afont,
            NSParagraphStyleAttributeName: paragraphStyle,
            NSForegroundColorAttributeName: color,
            NSKernAttributeName: NSNumber(value: Float(textKern) as Float)
        ]
        
        if needStroke {
            let strokeColorHex = textColorHex == "#000000" ? "#FFFFFF" : "#000000"
            let strokeColor = UIColor(hexString: strokeColorHex) ?? UIColor.red
            attribte[NSStrokeWidthAttributeName] = textStrokeWidth as NSObject?
            attribte[NSStrokeColorAttributeName] = strokeColor
        }
        
        if needShadow {
            let shadow = NSShadow()
            let shadowColor = UIColor(hexString: textShadowColorHex) ?? UIColor.blue
            shadow.shadowBlurRadius = 0.0
            shadow.shadowColor = shadowColor
            shadow.shadowOffset = CGSize(width: 1, height: 1)
            attribte[NSShadowAttributeName] = shadow
        }
        
        return attribte
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(fontFamily, forKey: TextAttributeName.fontFamily)
        aCoder.encode(fontName, forKey: TextAttributeName.fontName)
        aCoder.encode(fontSize, forKey: TextAttributeName.fontSize)
        aCoder.encode(fontScale, forKey: TextAttributeName.fontMatrixScale)
        aCoder.encode(textColorHex, forKey: TextAttributeName.ForegroundColor)
        aCoder.encode(textColorAlpha, forKey: TextAttributeName.ForegroundColorA)
        aCoder.encode(textKern, forKey: TextAttributeName.kern)
        aCoder.encode(textlineSpacing, forKey: TextAttributeName.paragraphLineSpacing)
        aCoder.encode(textAligiment.rawValue, forKey: TextAttributeName.paragraphAlignment)
        aCoder.encode(textShadowOn, forKey: TextAttributeName.shadowOn)
        aCoder.encode(textShadowOffset, forKey: TextAttributeName.shadowOffset)
        aCoder.encode(textShadowBlurRadius, forKey: TextAttributeName.shadowBlurRadius)
        aCoder.encode(textShadowColorHex, forKey: TextAttributeName.shadowColor)
        aCoder.encode(textShadowColorAplha, forKey: TextAttributeName.shadowColorA)
        aCoder.encode(needShadow, forKey: TextAttributeName.needShadow)
        aCoder.encode(needStroke, forKey: TextAttributeName.needStroke)
    }
    
    init?(coder aDecoder: NSCoder) {
        fontFamily = aDecoder.decodeObject(forKey: TextAttributeName.fontFamily) as! String
        fontName = aDecoder.decodeObject(forKey: TextAttributeName.fontName) as! String
        fontSize = aDecoder.decodeDouble(forKey: TextAttributeName.fontSize)
        fontScale = aDecoder.decodeDouble(forKey: TextAttributeName.fontMatrixScale)
        textColorHex = aDecoder.decodeObject(forKey: TextAttributeName.ForegroundColor) as! String
        textColorAlpha = aDecoder.decodeDouble(forKey: TextAttributeName.ForegroundColorA)
        textKern = aDecoder.decodeDouble(forKey: TextAttributeName.kern)
        textlineSpacing = aDecoder.decodeDouble(forKey: TextAttributeName.paragraphLineSpacing)
        textAligiment = NSTextAlignment(rawValue: aDecoder.decodeInteger(forKey: TextAttributeName.paragraphAlignment))!
        textShadowOn = aDecoder.decodeBool(forKey: TextAttributeName.shadowOn)
        textShadowOffset = aDecoder.decodeCGPoint(forKey: TextAttributeName.shadowOffset)
        textShadowBlurRadius = aDecoder.decodeDouble(forKey: TextAttributeName.shadowBlurRadius)
        textShadowColorHex = aDecoder.decodeObject(forKey: TextAttributeName.shadowColor) as! String
        textShadowColorAplha = aDecoder.decodeDouble(forKey: TextAttributeName.shadowColorA)
        needShadow = aDecoder.decodeBool(forKey: TextAttributeName.needShadow) ?? false
        needStroke = aDecoder.decodeBool(forKey: TextAttributeName.needStroke) ?? false
    }
    
    override init() {
    }
}


final class CTATextElement: NSObject, CTAElement {
    
    fileprivate struct SerialKeys {
        static fileprivate let prefix = "com.botai.curiosText.TextElment."
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
    fileprivate(set) var text = ""
    
    var attributes = CTATextAttributes()
    
    var resourceName: String {
        return ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: SerialKeys.text) as! String
        attributes = aDecoder.decodeObject(forKey: SerialKeys.attributes) as! CTATextAttributes
        //        x = aDecoder.decodeDoubleForKey(SerialKeys.x)
        //        y = aDecoder.decodeDoubleForKey(SerialKeys.y)
        //        width = aDecoder.decodeDoubleForKey(SerialKeys.width)
        //        height = aDecoder.decodeDoubleForKey(SerialKeys.height)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: SerialKeys.text)
        aCoder.encode(attributes, forKey: SerialKeys.attributes)
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
    
    var insets: CGPoint {
        let inset = CGPoint(x: 20.0 / 17.0 * fontSize * scale, y: 20.0 / 17.0 * fontSize * scale)
        return inset
    }
    
    func resultWithText(_ text: String, constraintSize: CGSize) -> (inset: CGPoint, size: CGSize) {
        
        let inset = insets
        let str = attributeStringWithText(text)
        
        let constraintSize = constraintSize
        let storage = NSTextStorage(attributedString: str)
        let container = NSTextContainer(size: constraintSize)
        let manager = NSLayoutManager()
        manager.addTextContainer(container)
        storage.addLayoutManager(manager)
        container.lineFragmentPadding = 0
        let textSize = manager.usedRect(for: container).size
        
//        let textSize = str.boundingRectWithSize(constraintSize, options: .UsesLineFragmentOrigin, context: nil).size
        let size = CGSize(width: textSize.width + inset.x * 2 + shadowOffset.x + shadowBlurRadius, height: textSize.height + inset.y * 2 + shadowOffset.y + shadowBlurRadius)
        
        return (inset, size)
    }
    
    
    func resultWithScale(_ scale: CGFloat, preScale: CGFloat, containerSize: CGSize, constraintSzie: CGSize) -> (inset: CGPoint, size: CGSize) {
        
        let inset = insets
        let str = attributeStringWithFontScale(scale)
        
        let constraintSize = constraintSzie
        let storage = NSTextStorage(attributedString: str)
        let container = NSTextContainer(size: constraintSize)
        let manager = NSLayoutManager()
        manager.addTextContainer(container)
        storage.addLayoutManager(manager)
        container.lineFragmentPadding = 0
        let textSize = manager.usedRect(for: container).size

        let size = CGSize(width: textSize.width + inset.x * 2 + shadowOffset.x + shadowBlurRadius, height: textSize.height + inset.y * 2 + shadowOffset.y + shadowBlurRadius)
        
        return (inset, size)
    }
    
    func resultWithFontFamily(_ family: String, fontName name: String, constraintSize: CGSize) -> (inset: CGPoint, size: CGSize) {
        
        let inset = insets
        let str = attributeStringWithFontScale(scale)
        
        let constraintSize = constraintSize
        let storage = NSTextStorage(attributedString: str)
        let container = NSTextContainer(size: constraintSize)
        let manager = NSLayoutManager()
        manager.addTextContainer(container)
        storage.addLayoutManager(manager)
        container.lineFragmentPadding = 0
        let textSize = manager.usedRect(for: container).size
        
        let size = CGSize(width: textSize.width + inset.x * 2 + shadowOffset.x + shadowBlurRadius, height: textSize.height + inset.y * 2 + shadowOffset.y + shadowBlurRadius)
        
        return (inset, size)
    }
    
    func resultWithLineSpacing(_ lineSpacing: CGFloat, textSpacing: CGFloat, constraintSize: CGSize) -> (inset: CGPoint, size: CGSize) {
        
        let inset = insets
        let str = attributeStringWithLineSpacing(lineSpacing, textSpacing: textSpacing)
        
        let constraintSize = constraintSize
        let storage = NSTextStorage(attributedString: str)
        let container = NSTextContainer(size: constraintSize)
        let manager = NSLayoutManager()
        manager.addTextContainer(container)
        storage.addLayoutManager(manager)
        container.lineFragmentPadding = 0
        let textSize = manager.usedRect(for: container).size
        
//        let textSize = str.boundingRectWithSize(constraintSize, options: .UsesLineFragmentOrigin, context: nil).size
        let size = CGSize(width: textSize.width + inset.x * 2 + shadowOffset.x + shadowBlurRadius, height: textSize.height + inset.y * 2 + shadowOffset.y + shadowBlurRadius)
        
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
            return text.isEmpty ? LocalStrings.editTextPlaceHolder.description : text
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
    
    var needShadow: Bool {
        get {
            return attributes.needShadow
        }
        
        set {
            attributes.needShadow = newValue
        }
    }
    var needStroke: Bool {
        get {
            return attributes.needStroke
        }
        
        set {
            attributes.needStroke = newValue
        }
    }
    
    
    
    func attributeStringWithText(_ atext: String) -> NSAttributedString {
        
        return NSAttributedString(string: atext, attributes: attributes.textAttributes)
    }
    
    func attributeStringWithFontScale(_ scale: CGFloat) -> NSAttributedString {
        
        return NSAttributedString(string: texts, attributes: attributes.textAttributesWithFontScale(scale))
    }
    
    func attributeStringWithFontFamily(_ family: String, fontName name: String) -> NSAttributedString {
        
        return NSAttributedString(string: texts, attributes: attributes.textAttributesWithFontScaleWithFontFamily(family, fontName: name))
    }
    
    func attributeStringWithAlignment(_ alignment: NSTextAlignment) -> NSAttributedString {
        
        return NSAttributedString(string: texts, attributes: attributes.textAttributesWithTextAlignment(alignment))
    }
    
    func attributeStringWithLineSpacing(_ lineSpacing: CGFloat, textSpacing: CGFloat) -> NSAttributedString {
        
        return NSAttributedString(string: texts, attributes: attributes.textAttributesWithLineSpacing(lineSpacing, textSpacing: textSpacing))
    }
    
//    func attributeStringWithNeedShadow(needShadow: Bool, needStroke: Bool) -> NSAttributedString {
//        
//        return NSAttributedString(string: texts, attributes: attributes)
//    }
    
}
