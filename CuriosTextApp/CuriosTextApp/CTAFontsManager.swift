//
//  CTAFontsManager.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/14/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
import UIKit

class CTAFontsManager {
    
   static let families: [String] = {
    
    let valildFamilies = UIFont.familyNames().filter {UIFont.fontNamesForFamilyName($0).count > 0}
//        let a = valildFamilies
        return valildFamilies
    }()
    
    class func defaultFamily() -> String {
        return CTAFontsManager.families[3]
    }
    
    class func defaultFontName() -> String {
        let name = fontNamesWithFamily(defaultFamily())![0]
        return name
    }
    
    class func fontNamesWithFamily(family: String) -> [String]? {
        return UIFont.fontNamesForFamilyName(family)
    }
    
    class func indexPathForFamily(family: String, fontName: String) -> NSIndexPath? {
        
        guard let familyIndex = CTAFontsManager.families.indexOf(family), let nameIndex = fontNamesWithFamily(family)?.indexOf(fontName) else {
            return nil
        }
        return NSIndexPath(forItem: nameIndex, inSection: familyIndex)
    }
    
    class func familyAndFontNameWith(indexPath: NSIndexPath) -> (String?, String?) {
        
        guard indexPath.section < CTAFontsManager.families.count  else {
            return (nil, nil)
        }
        
        let family = CTAFontsManager.families[indexPath.section]
        let fonts = CTAFontsManager.fontNamesWithFamily(family)!
        guard indexPath.item < fonts.count else {
            return (family, nil)
        }
        
        let font = fonts[indexPath.item]
        return (family, font)
    }
    
}