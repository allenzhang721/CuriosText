//
//  CTAHUDLabel.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 3/2/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAHUDLabel: UILabel {
    
    var showGradient: Bool = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if showGradient {
            backgroundColor = UIColor(patternImage: HUDHelper.imageOfGrandient(frame: bounds))
        }
    }
}

public class HUDHelper : NSObject {
    
    //// Drawing Methods
    
    public class func drawGrandient(frame frame: CGRect = CGRectMake(68, 47, 106, 55)) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Color Declarations
        let gradientColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        let gradientColor2 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 0.000)
        let gradientColor3 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        //// Gradient Declarations
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [gradientColor.CGColor, gradientColor.blendedColorWithFraction(0.5, ofColor: gradientColor3).CGColor, gradientColor3.CGColor, gradientColor2.CGColor], [0, 0.3, 0.51, 1])!
        
        //// Rectangle Drawing
        let rectangleRect = CGRectMake(frame.minX + floor(frame.width * 0.00000 + 0.5), frame.minY + floor(frame.height * 0.00000 + 0.5), floor(frame.width * 1.00000 + 0.5) - floor(frame.width * 0.00000 + 0.5), floor(frame.height * 1.00000 + 0.5) - floor(frame.height * 0.00000 + 0.5))
        let rectanglePath = UIBezierPath(rect: rectangleRect)
        CGContextSaveGState(context)
        rectanglePath.addClip()
        CGContextDrawLinearGradient(context, gradient,
                                             CGPointMake(rectangleRect.maxX, rectangleRect.midY),
                                             CGPointMake(rectangleRect.minX, rectangleRect.midY),
                                             CGGradientDrawingOptions())
        CGContextRestoreGState(context)
    }
    
    //// Generated Images
    
    public class func imageOfGrandient(frame frame: CGRect = CGRectMake(68, 47, 106, 55)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        HUDHelper.drawGrandient(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        
        let imageOfGrandient = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageOfGrandient
    }
    
}



extension UIColor {
    func blendedColorWithFraction(fraction: CGFloat, ofColor color: UIColor) -> UIColor {
        var r1: CGFloat = 1.0, g1: CGFloat = 1.0, b1: CGFloat = 1.0, a1: CGFloat = 1.0
        var r2: CGFloat = 1.0, g2: CGFloat = 1.0, b2: CGFloat = 1.0, a2: CGFloat = 1.0
        
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return UIColor(red: r1 * (1 - fraction) + r2 * fraction,
                       green: g1 * (1 - fraction) + g2 * fraction,
                       blue: b1 * (1 - fraction) + b2 * fraction,
                       alpha: a1 * (1 - fraction) + a2 * fraction);
    }
}

