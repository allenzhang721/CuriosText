//
//  CTATextContainerViewModel.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 2/15/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

protocol TextContainerVMProtocol: ContainerVMProtocol {
    
    var textElement: protocol<CTAElement, TextModifiable>? { get }
    
    func updateWithText(text: String, constraintSize: CGSize)
    func updateWithFontFamily(family: String, FontName name: String, constraintSize: CGSize)
    func updateWithTextAlignment(alignment: NSTextAlignment)
    func updateWithTextSpacing(lineSpacing: CGFloat, textSpacing: CGFloat, constraintSize: CGSize)
    func updateWithColor(hex: String, alpha: CGFloat)
    func updatewithNeedShadow(needShadow: Bool, needStroke: Bool)
}

protocol TextRetrievable: class {
    
    var attributeString: NSAttributedString { get }
    var textAttributes: [String: AnyObject] { get }
    var fontSize: CGFloat { get }
    var fontScale: CGFloat { get }
    var shadowOffset: CGPoint { get }
    var shadowBlurRadius: CGFloat { get }
    
    func attributeStringWithFontScale(scale: CGFloat) -> NSAttributedString
    func attributeStringWithAlignment(alignment: NSTextAlignment) -> NSAttributedString
//    func attributeStringWithNeedShadow(needShadow: Bool, needStroke: Bool) -> NSAttributedString
}

extension TextRetrievable {
    
    //TODO: Rect Inset
    func rectInset() -> CGPoint {
        return CGPoint(x: 50.0 / 17.0 * fontSize * fontScale, y: 0)
    }
    
    func textSizeWithConstraintSize(size: CGSize) -> CGSize {
        
        
        let constraintSize = size
        let storage = NSTextStorage(attributedString: attributeString)
        let container = NSTextContainer(size: constraintSize)
        let manager = NSLayoutManager()
        manager.addTextContainer(container)
        storage.addLayoutManager(manager)
        container.lineFragmentPadding = 0
        let textSize = manager.usedRectForTextContainer(container).size
        
        return textSize
//        return attributeString.boundingRectWithSize(size, options: .UsesLineFragmentOrigin, context: nil).size
    }
    
    func textFrameWithTextSize(textsize size: CGSize) -> CGRect {
        
        let origin = CGPoint(x: 0 - rectInset().x, y: 0 - rectInset().y)
        let size = CGSize(width: size.width + rectInset().x * 2 + shadowOffset.x + shadowBlurRadius, height: size.height + rectInset().y + 2 + shadowOffset.y + shadowBlurRadius)
        return CGRect(origin: origin, size: size)
    }
    
    func textResultWithScale(scale: CGFloat, constraintSzie: CGSize) -> (CGPoint, CGSize, CGRect, NSAttributedString) {
        let inset = CGPoint(x: 50.0 / 17.0 * fontSize * scale, y: 0)
        let str = attributeStringWithFontScale(scale)
        
        let constraintSize = constraintSzie
        let storage = NSTextStorage(attributedString: str)
        let container = NSTextContainer(size: constraintSize)
        let manager = NSLayoutManager()
        manager.addTextContainer(container)
        storage.addLayoutManager(manager)
        container.lineFragmentPadding = 0
        let textSize = manager.usedRectForTextContainer(container).size
        
//        let textSize = str.boundingRectWithSize(constraintSzie, options: .UsesLineFragmentOrigin, context: nil).size
        let origin = CGPoint(x: 0 - inset.x, y: 0 - inset.y)
        let size = CGSize(width: textSize.width + inset.x * 2 + shadowOffset.x + shadowBlurRadius, height: textSize.height + inset.y + 2 + shadowOffset.y + shadowBlurRadius)
        let rect = CGRect(origin: origin, size: size)
        
        return (inset, textSize, rect, str)
    }
    
    func textResultWithAlignment(alignment: NSTextAlignment) -> NSAttributedString {
        return attributeStringWithAlignment(alignment)
    }
    
//    func attributeStringWithNeedShadow(needShadow: Bool, needStroke: Bool) -> NSAttributedString {
//        return attributeStringWithNeedShadow(needShadow, needStroke: needStroke)
//    }
}

protocol TextModifiable: TextRetrievable {
    
    var isEmpty: Bool { get }
    var texts: String { get set }
    var fontScale: CGFloat { get set }
    var fontFamily: String { get set }
    var fontName: String { get set }
    var alignment: NSTextAlignment { get set }
    var lineSpacing: CGFloat { get set }
    var textSpacing: CGFloat { get set }
    var colorHex: String { get set }
    var colorAlpha: CGFloat { get set }
    var needShadow: Bool { get set}
    var needStroke: Bool { get set }
    
    func resultWithText(text: String, constraintSize: CGSize) -> (inset: CGPoint, size: CGSize)
    
    func resultWithFontFamily(family: String, fontName name: String, constraintSize: CGSize) -> (inset: CGPoint, size: CGSize)
    
    func resultWithLineSpacing(lineSpacing: CGFloat, textSpacing: CGFloat, constraintSize: CGSize) -> (inset: CGPoint, size: CGSize)
}


// MARK: - TextModifiable, ViewModifiable
extension CTAContainer: TextContainerVMProtocol {
    
    var textElement: protocol<CTAElement, TextModifiable>? {
        guard let te = element as? CTATextElement else {
//            fatalError("This Contaienr do not contain Text Element")
            return nil
        }
        
        return te
    }
    
    func updateWithText(text: String, constraintSize: CGSize) {
        
        guard let textElement = textElement else {
            fatalError("This Contaienr do not contain Text Element")
        }
        
        textElement.texts = text
        let aText = text.isEmpty ? LocalStrings.EditTextPlaceHolder.description : text
        let newResult = textElement.resultWithText(aText, constraintSize: constraintSize)
        let contentSize = CGSize(width: ceil(newResult.size.width), height: ceil(newResult.size.height))
        let inset = CGPoint(x: floor(newResult.inset.x), y: newResult.inset.y)
        // new content size
        let nextSize = CGSize(width: contentSize.width - 2 * inset.x, height: contentSize.height - 2 * inset.y)
        
        size = nextSize
        contentInset = inset
        
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
    
    func updatewithNeedShadow(needShadow: Bool, needStroke: Bool) {
        guard let textElement = textElement else {
            fatalError("This Contaienr do not contain Text Element")
        }
        
        textElement.needShadow = needShadow
        textElement.needStroke = needStroke
    }
    
    // TODO: CTAContainer, Calculate the position and origion if occur rotation -- Emiaostein; 2015-12-18-14:49
}