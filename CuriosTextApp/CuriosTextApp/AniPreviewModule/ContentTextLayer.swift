//
//  ContentTextLayer.swift
//  PopApp
//
//  Created by Emiaostein on 4/7/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import UIKit

class ContentTextLayer: UILabel {
    
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
            print("Custom Drawing")
            
            //            super.drawTextInRect(rect)
            
        } else {
            
            print("Super Drawing")
            super.drawTextInRect(rect)
        }
        
        CGContextRestoreGState(context)
    }
}

//class TextLayer: CATextLayer {
//    
//}
