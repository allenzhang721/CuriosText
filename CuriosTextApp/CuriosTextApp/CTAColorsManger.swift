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

struct CTAIndexPath {
    
    let section: Int
    let item: Int
}

final class CTAColorsManger {
    
    static let colorsCatagory = ["one", "two", "three", "four", "five"]
    static var indexPaths = [CTAIndexPath]()
    
//    "salamander", "intoDreams", "cynicide", "birdsofParadise", "brokenGlass", "vintagePattern", "sunset", "rosanne", "joyful", "starSeeker", "cloudyDay", "monoPolygons"
    
    static let colors: [String: ContiguousArray<CTAColorItem>] = {
        
        var c = [String: ContiguousArray<CTAColorItem>]()

        for (asection, catagory) in colorsCatagory.enumerated() {
            
            var items = ContiguousArray<CTAColorItem>()
            
            for i in 0..<9 {
              let color =  CTAStyleKit.perform(Selector("\(catagory)\(i)")).takeUnretainedValue() as! UIColor
                let item = CTAColorItem(color: color)
                items.append(item)
            }
            CTAColorsManger.indexPaths.append(CTAIndexPath(section: asection, item: 0))
            c[catagory] = items
        }
        
        return c
    }()
    
    class func updateSection(_ section: Int, withItem newItem: Int) {
        
        if let indexSection = (indexPaths.index{ $0.section == section }) {
            
            indexPaths[indexSection] = CTAIndexPath(section: section, item: newItem)
        }
    }
    
    class func itemAtSection(_ section: Int) -> Int? {
        
        guard section < colorsCatagory.count else {
            return nil
        }
        
        let index = (indexPaths.filter {$0.section == section})
        guard index.count > 0 else {
            return nil
        }
        
        return index.first?.item
        
    }
    
    class func colorAtIndexPath(_ indexPath: IndexPath) -> CTAColorItem? {
        let key = CTAColorsManger.colorsCatagory[indexPath.section]
        let color = CTAColorsManger.colors[key]![indexPath.item]
        return color
    }
    
    class func indexPathOfColor(_ colorHex: String) -> IndexPath? {
        
        for (section,catagory) in colorsCatagory.enumerated() {
            
            let items = colors[catagory]!
            
            for (i, item) in items.enumerated() {
                if item.colorHex == colorHex {
                    return IndexPath(item: i, section: section)
                }
            }
        }
        return nil
    }
}
