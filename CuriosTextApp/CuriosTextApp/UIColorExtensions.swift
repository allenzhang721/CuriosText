//
//  UIColorExtensions.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/12/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    
    func toHex() -> (String, CGFloat) {
        
        let component = CGColorGetComponents(CGColor)
        let r = component[0]
        let g = component[1]
        let b = component[2]
        let a = component[3]
        
        let hex = NSString(format: "#%02lX%02lX%02lX", lroundf(Float(r * CGFloat(255.0))), lroundf(Float(g * CGFloat(255.0))), lroundf(Float(b * CGFloat(255.0)))) as String
        return (hex, a)
    }
}

extension UIColor {
    
    class func randomColor() -> UIColor {
        
        return UIColor(
            red: CGFloat(random() % 255) / 255.0,
            green: CGFloat(random() % 255) / 255.0,
            blue: CGFloat(random() % 255) / 255.0,
            alpha: 1)
    }
}