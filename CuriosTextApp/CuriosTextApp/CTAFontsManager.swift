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
    
    static var indexPaths = [CTAIndexPath]()
    private static var validFamilies = [String]()
    static var familiyDisplayNameDic = [String: String]()
    
//   static let families: [String] = {
//    
////    let valildFamilies = UIFont.familyNames().filter {UIFont.fontNamesForFamilyName($0).count > 0}
//    let valildFamilies = CTAFontsManager.registerFonts().sort(<)
////        let a = valildFamilies
//    for (s, f) in valildFamilies.enumerate() {
//        CTAFontsManager.indexPaths.append(CTAIndexPath(section: s, item: 0))
//    }
//        return valildFamilies
//    }()
    
    static var families: [String] {
        return validFamilies
    }
    
    class func customFamilyDisplayNameBy(familyName: String) -> String? {
        guard let displayName = CTAFontsManager.familiyDisplayNameDic[familyName] else { return nil }
        
        return displayName
    }
    
    class func defaultFamily() -> String {
        return CTAFontsManager.families[0]
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
    
    class func updateSection(section: Int, withItem newItem: Int) {
        
        if let indexSection = (indexPaths.indexOf{ $0.section == section }) {
            
            indexPaths[indexSection] = CTAIndexPath(section: section, item: newItem)
        }
    }
    
    class func itemAtSection(section: Int) -> Int? {
        
        guard section < CTAFontsManager.families.count else {
            return nil
        }
        
        let index = (indexPaths.filter {$0.section == section})
        guard index.count > 0 else {
            return nil
        }
        
        return index.first?.item
        
    }
    
    class func registerFontAt(fileUrl: NSURL) {
        
        FontManager.registerFontAt(fileUrl)
    }
    
    class func reloadData() {
        
        let vf = UIFont.familyNames()
        let fs = FontManager.registeredFamilies()
        let valf = fs.filter{ vf.contains($0) }
        validFamilies = valf
    }
    
    class func registerFonts() -> [String] {
        
        let fontsName = "Fonts"
        let path = NSBundle.mainBundle().bundleURL
        let url = path.URLByAppendingPathComponent(fontsName)
        let fontUrls = try! NSFileManager.defaultManager().contentsOfDirectoryAtURL(url, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.init(rawValue: 0))
        
        let urls = fontUrls.filter{ $0.pathExtension == "ttf" }
        
        let beforeFamilyName = UIFont.familyNames()
        if CTFontManagerRegisterFontsForURLs(urls, .Process, nil) {
            let newFamilyName = UIFont.familyNames().filter{ !beforeFamilyName.contains($0) }
            
            return newFamilyName
        } else {
            return []
        }
        
    }
    
}