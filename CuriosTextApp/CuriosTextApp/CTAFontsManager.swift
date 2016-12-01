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
    fileprivate static var validFamilies = [String]()
    static var familiyDisplayNameDic = [String: String]()
    static var familiyFixRectRatio = [String: [String: CGFloat]]()  // [familyName: [width: 0.1, height: 0.1]]
    
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
    
    class func cleanCacheFamily() {
        FontManager.cleanCacheFamily()
    }
    
    class func cleanCacheFamilyList() {
        FontManager.cleanFontFamilyList()
    }
    
    class func customFamilyDisplayNameBy(_ familyName: String) -> String? {
        guard let displayName = CTAFontsManager.familiyDisplayNameDic[familyName] else { return nil }
        
        return displayName
    }
    
    class func registedFontNames() -> [String] {
        var names = [String]()
        let families = CTAFontsManager.families
        for fa in families {
            if let fonts = fontNamesWithFamily(fa) {
                for f in fonts {
                    names.append(f)
                }
            }
        }
        return names
    }
    
    class func defaultFamily() -> String {
        return CTAFontsManager.families[0]
    }
    
    class func defaultFontName() -> String {
        let name = fontNamesWithFamily(defaultFamily())![0]
        return name
    }
    
    class func fontNamesWithFamily(_ family: String) -> [String]? {
        return UIFont.fontNames(forFamilyName: family)
    }
    
    class func indexPathForFamily(_ family: String, fontName: String) -> IndexPath? {
        
        guard let familyIndex = CTAFontsManager.families.index(of: family), let nameIndex = fontNamesWithFamily(family)?.index(of: fontName) else {
            return nil
        }
        return IndexPath(item: nameIndex, section: familyIndex)
    }
    
    class func familyAndFontNameWith(_ indexPath: IndexPath) -> (String?, String?) {
        
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
    
    class func updateSection(_ section: Int, withItem newItem: Int) {
        
        if let indexSection = (indexPaths.index{ $0.section == section }) {
            
            indexPaths[indexSection] = CTAIndexPath(section: section, item: newItem)
        }
    }
    
    class func itemAtSection(_ section: Int) -> Int? {
        
        guard section < CTAFontsManager.families.count else {
            return nil
        }
        
        let index = (indexPaths.filter {$0.section == section})
        guard index.count > 0 else {
            return nil
        }
        
        return index.first?.item
        
    }
    
    class func registerFontAt(_ fileUrl: URL) {
        
        FontManager.registerFontAt(fileUrl)
    }
    /*
     
     let familyName: String
     let fullName: String
     let postscriptName: String
     let copyRight: String
     let style: String
     let size: String
     let version: String
     */
    class func registerFontWith(_ familyName: String, fullName: String, postscriptName: String, copyRight: String, style: String, size: String, version: String) {
        
        let info = FontInfo(familyName: familyName, fullName: fullName, postscriptName: postscriptName, copyRight: copyRight, style: style, size: size, version: version)
        
        FontManager.registerFontWith(info)
    }
    
    class func unregisterFontWith(_ familyName: String, fullName: String, postscriptName: String, copyRight: String, style: String, size: String, version: String) {
        
        let info = FontInfo(familyName: familyName, fullName: fullName, postscriptName: postscriptName, copyRight: copyRight, style: style, size: size, version: version)
        
        FontManager.registerFontWith(info)
    }
    
    class func reloadData() {
        
        let vf = UIFont.familyNames
        let fs = FontManager.registeredFamilies()
        let valf = fs.filter{ vf.contains($0) }
        validFamilies = valf
    }
    
    class func registerFonts() -> [String] {
        
        let fontsName = "Fonts"
        let path = Bundle.main.bundleURL
        let url = path.appendingPathComponent(fontsName)
        let fontUrls = try! FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.init(rawValue: 0))
        
        let urls = fontUrls.filter{ $0.pathExtension == "ttf" }
        
        let beforeFamilyName = UIFont.familyNames
        if CTFontManagerRegisterFontsForURLs(urls as CFArray, .process, nil) {
            let newFamilyName = UIFont.familyNames.filter{ !beforeFamilyName.contains($0) }
            
            return newFamilyName
        } else {
            return []
        }
        
    }
    
}
