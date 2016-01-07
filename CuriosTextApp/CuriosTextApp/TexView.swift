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
        attributedText?.drawInRect(CGRect(origin: rect.origin, size: CGSize(width: rect.size.width - insets.x * 2, height: rect.size.height - insets.y * 2)))
        CGContextRestoreGState(context)
    }

}
