//
//  ContainerFactory.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/18/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation
import UIKit

class ContainerFactory {
    
    class func containerBy(containerVM: containerVMProtocol) -> CTAContainerLayer {
        
        switch containerVM.type {
        case .Empty:
            return ContainerFactory.containerWithEmptyBy(containerVM)
            
        case .Text:
            
            return ContainerFactory.containerWithTextBy(containerVM)
        }
        
    }
}

extension ContainerFactory {
    
    private class func containerWithEmptyBy(viewPro: viewPropertiesRetrivevale) -> CTAContainerLayer {
        
        let layer = CTAContainerLayer()
        layer.frame = CGRect(x: viewPro.origion.x, y: viewPro.origion.y, width: viewPro.size.width, height: viewPro.size.height)
        
        layer.backgroundColor = UIColor.blackColor().CGColor
        
        return layer
    }
    
    private class func containerWithTextBy(containerVM: protocol< TextRetrievable, viewPropertiesRetrivevale>) -> CTAContainerLayer {
        
        let containerlayer = self.containerWithEmptyBy(containerVM)
        
        // TextLayer
        let textLayer = CTATextLayer()
        textLayer.frame = CGRectInset(containerlayer.bounds, -50, 0)
        textLayer.string = ContainerFactory.demoString()
        
        containerlayer.addSublayer(textLayer)
        
        return containerlayer
    }
    
    //    class func containerWithImgBy(imgModel: TextRetrievable) -> CTAContainer {
    //        
    //    }
    
    class func demoString() -> NSAttributedString
    {
        // Create the attributed string
        let demoString = NSMutableAttributedString(string:"for youThanks For Using Attributed String Creatoreh")
        
        // Declare the fonts
        let demoStringFont1 = UIFont(name:"Zapfino", size:12.0)
        
        // Declare the colors
        let demoStringColor1 = UIColor(red: 0.000000, green: 0.000000, blue: 0.000000, alpha: 1.000000)
        
        // Declare the paragraph styles
        let demoStringParaStyle1 = NSMutableParagraphStyle()
        demoStringParaStyle1.tabStops = [NSTextTab(textAlignment: NSTextAlignment.Left, location: 28.000000, options: [:]), NSTextTab(textAlignment: NSTextAlignment.Left, location: 56.000000, options: [:]), NSTextTab(textAlignment: NSTextAlignment.Left, location: 84.000000, options: [:]), NSTextTab(textAlignment: NSTextAlignment.Left, location: 112.000000, options: [:]), NSTextTab(textAlignment: NSTextAlignment.Left, location: 140.000000, options: [:]), NSTextTab(textAlignment: NSTextAlignment.Left, location: 168.000000, options: [:]), NSTextTab(textAlignment: NSTextAlignment.Left, location: 196.000000, options: [:]), NSTextTab(textAlignment: NSTextAlignment.Left, location: 224.000000, options: [:]), NSTextTab(textAlignment: NSTextAlignment.Left, location: 252.000000, options: [:]), NSTextTab(textAlignment: NSTextAlignment.Left, location: 280.000000, options: [:]), NSTextTab(textAlignment: NSTextAlignment.Left, location: 308.000000, options: [:]), NSTextTab(textAlignment: NSTextAlignment.Left, location: 336.000000, options: [:]), ]
        
        
        // Create the attributes and add them to the string
        demoString.addAttribute(NSUnderlineColorAttributeName, value:demoStringColor1, range:NSMakeRange(0,51))
        demoString.addAttribute(NSParagraphStyleAttributeName, value:demoStringParaStyle1, range:NSMakeRange(0,51))
        demoString.addAttribute(NSFontAttributeName, value:demoStringFont1!, range:NSMakeRange(0,51))
        
        return NSAttributedString(attributedString:demoString)
    }
    
}