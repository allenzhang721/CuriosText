//
//  TextElement.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/23/15.
//  Copyright © 2015 botai. All rights reserved.
//

import UIKit

class TextView: UILabel, TextElement {

    var insets: CGPoint = CGPoint.zero
    
    override func drawTextInRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, insets.x, insets.y)
        let arect = CGRect(origin: rect.origin, size: CGSize(width: rect.size.width - insets.x * 2, height: rect.size.height - insets.y * 2))
        
//        attributedText?.drawInRect(CGRect(origin: rect.origin, size: CGSize(width: rect.size.width - insets.x * 2, height: rect.size.height - insets.y * 2)))
        if let attr = attributedText {
            let storage = NSTextStorage(attributedString: attr)
            let container = NSTextContainer(size: arect.size)
            let manager = NSLayoutManager()
            manager.addTextContainer(container)
            storage.addLayoutManager(manager)
            container.lineFragmentPadding = 0
            manager.drawGlyphsForGlyphRange(manager.glyphRangeForTextContainer(container), atPoint: arect.origin)
        } else {
            
            super.drawTextInRect(rect)
        }
        
        CGContextRestoreGState(context)
    }
}
