//
//  CTAColorsManger.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/12/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
import UIKit

final class CTAColorItem {
    
    let color: UIColor
    let colorHex: String
    let colorHexAlpha: CGFloat
    
    init(color: UIColor) {
        self.color = color
        let r = color.toHex()
        colorHex = r.0
        colorHexAlpha = r.1
    }
}

final class CTAColorsManger {
    
    static let colorsCatagory = ["red", "yellow", "blue", "green", "orange", "indigo", "purple", "black"]
    
//    "salamander", "intoDreams", "cynicide", "birdsofParadise", "brokenGlass", "vintagePattern", "sunset", "rosanne", "joyful", "starSeeker", "cloudyDay", "monoPolygons"
    
    static let colors: [String: ContiguousArray<CTAColorItem>] = {
        
        var c = [String: ContiguousArray<CTAColorItem>]()

        for catagory in colorsCatagory {
            
            var items = ContiguousArray<CTAColorItem>()
            
            for i in 0..<7 {
              let color =  CTAStyleKit.performSelector(Selector("\(catagory)\(i + 2)")).takeUnretainedValue() as! UIColor
                let item = CTAColorItem(color: color)
                items.append(item)
            }
            
            c[catagory] = items
        }

        return c
    }()
    
    class func colorAtIndexPath(indexPath: NSIndexPath) -> CTAColorItem? {
        
        let key = CTAColorsManger.colorsCatagory[indexPath.section]
        let color = CTAColorsManger.colors[key]![indexPath.item]
        return color
    }
}