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
    
    override func drawText(in rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        context?.translateBy(x: insets.x, y: insets.y)
        let arect = CGRect(origin: rect.origin, size: CGSize(width: rect.size.width - insets.x * 2, height: rect.size.height - insets.y * 2))
        
//        attributedText?.drawInRect(CGRect(origin: rect.origin, size: CGSize(width: rect.size.width - insets.x * 2, height: rect.size.height - insets.y * 2)))
        if let attr = attributedText {
            let storage = NSTextStorage(attributedString: attr)
            let container = NSTextContainer(size: arect.size)
            let manager = NSLayoutManager()
            manager.addTextContainer(container)
            storage.addLayoutManager(manager)
            container.lineFragmentPadding = 0
            manager.drawGlyphs(forGlyphRange: manager.glyphRange(for: container), at: arect.origin)
        } else {
            
            super.drawText(in: rect)
        }
        
        context?.restoreGState()
    }
}
