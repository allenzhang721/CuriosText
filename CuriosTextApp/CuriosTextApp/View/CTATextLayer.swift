////
////  CTATextLayer.swift
////  CuriosTextApp
////
////  Created by Emiaostein on 12/15/15.
////  Copyright © 2015 botai. All rights reserved.
////
//
//import UIKit
//
//class CTATextLayer: CATextLayer {
//    
//    override class func defaultActionForKey(event: String) -> CAAction? {
//        
//        return NSNull()
//    }
//    
//    override func actionForLayer(layer: CALayer, forKey event: String) -> CAAction? {
//        
//        return NSNull()
//    }
//
//    override func drawInContext(ctx: CGContext) {
//        CGContextSaveGState(ctx)
//        CGContextTranslateCTM(ctx, 50, 0)
//        super.drawInContext(ctx)
//        CGContextRestoreGState(ctx)
//    }
//}
