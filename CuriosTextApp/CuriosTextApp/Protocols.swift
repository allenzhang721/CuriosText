//
//  Protocols.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/18/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation
import UIKit

enum CTAContentsType {
    
    case Empty, Text
//    , Image
}

protocol PageVMProtocol {
    
    var containerVMs: [ContainerVMProtocol] { get }
}

extension PageVMProtocol {
    
    func containerByID(id: String) -> ContainerVMProtocol? {
        
        guard let index = (containerVMs.indexOf{$0.iD == id}) else {
            return nil
        }
        return containerVMs[index]
    }
}

protocol ContainerVMProtocol: viewPropertiesModifiable, contentsTypeRetrivevable, ContainerIdentifiable {
    
}

protocol TextContainerVMProtocol: ContainerVMProtocol {
    
    var textElement: protocol<CTAElement, TextModifiable> { get }
}

//typealias ContainerVMProtocol = protocol<>



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
}

protocol TextModifiable: TextRetrievable {
    
    var fontScale: CGFloat { get set }
}

protocol ViewPropertiesRetrivevale:class {
    
//    var origion: (x: Double, y: Double) { get }
    var position: (x: Double, y: Double) { get }
    var size: (width: Double, height: Double) { get }
    var radius: Double { get }
}

protocol viewPropertiesModifiable: ViewPropertiesRetrivevale {
    
//    var origion: (x: Double, y: Double) { get set }
    var position: (x: Double, y: Double) { set get }
    var size: (width: Double, height: Double) { get set }
    var radius: Double { get set }
}

protocol contentsTypeRetrivevable {
    
    var type: CTAContentsType { get }
}
