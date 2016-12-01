//
//  TextSpliter.swift
//  TextSpliteSample
//
//  Created by Emiaostein on 4/6/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import Foundation
import UIKit

class TextSpliter {
    enum TextLineSpliteType {
        case allatOnce
        case byLine
    }
    
    enum TextSpliteType {
        case byObject
        case byCharacter
    }
    
    struct TextUnit {
        let text: String
        let attriubtes: [String: AnyObject]?
        let usedRect: CGRect
        let lineFragmentRect: CGRect
        let usedLineFragmentRect: CGRect
        let constraintSize: CGSize
        let section: Int
        let row: Int
    }
    
    class func spliteAttributeText(_ text: NSAttributedString, inConstraintSize size: CGSize) -> [TextUnit] {
        
        return []
    }
    
    class func spliteText(_ text: String, withAttributes attributes: [String: AnyObject]?, inConstraintSize size: CGSize, bySpliteType type: (TextLineSpliteType, TextSpliteType) = (.allatOnce, .byObject)) -> ([TextUnit], CGSize, Int) { // units, size, sectionCount, []
        
        let constraintSize = size
        let storage = NSTextStorage(string: text, attributes: attributes)
        let container = NSTextContainer(size: constraintSize)
        let manager = NSLayoutManager()
        manager.addTextContainer(container)
        storage.addLayoutManager(manager)
        container.lineFragmentPadding = 0
        
        let glyphCount = manager.numberOfGlyphs
        
        var sectionCount  = 0
        var inSize = CGSize.zero
        var units = [TextUnit]()
        
        switch type {
        case (.allatOnce, .byObject):
            
            let usedRect = manager.usedRect(for: container)
            
            
//            let r = manager.characterRangeForGlyphRange(glyphRange, actualGlyphRange: nil)
            //                let start = text.startIndex.advancedBy(r.location)
            //                let end = text.startIndex.advancedBy(r.location + r.length)
            
            let alineFragmentRect = CGRect(origin: CGPoint.zero, size: size)
            let usedlineFragmentRect = usedRect
            
            let t = text
            
            let lf = alineFragmentRect
            let ulf = usedlineFragmentRect
            let ur = ulf
            let cs = CGSize(width: constraintSize.width, height: usedRect.height)
            let unit = TextUnit(text: t, attriubtes: attributes, usedRect: ur, lineFragmentRect: lf, usedLineFragmentRect: ulf, constraintSize: cs, section: 0, row: 0)
            
            inSize = cs
            units.append(unit)
            
            
            
//            manager.enumerateLineFragmentsForGlyphRange(NSMakeRange(0, glyphCount), usingBlock: { (alineFragmentRect, usedlineFragmentRect, container, glyphRange, stop) in
//                
//                let r = manager.characterRangeForGlyphRange(glyphRange, actualGlyphRange: nil)
//                //                let start = text.startIndex.advancedBy(r.location)
//                //                let end = text.startIndex.advancedBy(r.location + r.length)
//                let t = (text as NSString).substringWithRange(r)
//                
//                let lf = alineFragmentRect
//                let ulf = usedlineFragmentRect
//                let ur = ulf
//                let cs = CGSize(width: constraintSize.width, height: usedRect.height)
//                let unit = TextUnit(text: t, attriubtes: attributes, usedRect: ur, lineFragmentRect: lf, usedLineFragmentRect: ulf, constraintSize: cs, section: 0, row: 0)
//                
//                inSize = cs
//                units.append(unit)
//            })
            
        case (.allatOnce, .byCharacter):
            
            //            var section = 0
            //            var row = 0
            let text = text as NSString
            let usedRect = manager.usedRect(for: container)
            manager.enumerateLineFragments(forGlyphRange: NSMakeRange(0, glyphCount), using: { (alineFragmentRect, usedlineFragmentRect, container, glyphRange, stop) in
                
                let location = glyphRange.location
                let length = glyphRange.length
                
                var nextLocation = location
                for l in location..<(location + length) {
                    
                    if l < nextLocation {
                        continue
                    }
                    
                    let r = NSMakeRange(l, 1)
                    
                    var p = r
                    let characterRange = manager.characterRange(forGlyphRange: r, actualGlyphRange: &p)
                    
                    if characterRange.length > 0 {
                        nextLocation = l + characterRange.length
                    }
                    //                    let start = text.startIndex.advancedBy(p.location)
                    //                    let end = text.startIndex.advancedBy(p.location + p.length)
                    let t = (text as NSString).substring(with: p)
                    
                    if t == " " || t == "\n" {
                        continue
                    }
                    
                    let lf = alineFragmentRect
                    let ulf = usedlineFragmentRect
                    let ur = manager.boundingRect(forGlyphRange: r, in: container)
                    
                    let cs = CGSize(width: constraintSize.width, height: usedRect.height)
                    let unit = TextUnit(text: t, attriubtes: attributes, usedRect: ur, lineFragmentRect: lf, usedLineFragmentRect: ulf, constraintSize: cs, section: 0, row: l)
                    
                    inSize = cs
                    units.append(unit)
                    
                    //                    row += 1
                }
                
                //                section += 1
                //                row = 0
            })
            
            
        case (.byLine, .byObject):
            
            var section = 0
            let row = 0
            let usedRect = manager.usedRect(for: container)
            manager.enumerateLineFragments(forGlyphRange: NSMakeRange(0, glyphCount), using: { (alineFragmentRect, usedlineFragmentRect, container, glyphRange, stop) in
                
                let r = manager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
                //                let start = text.startIndex.advancedBy(r.location)
                //                let end = text.startIndex.advancedBy(r.location + r.length)
                let t = (text as NSString).substring(with: r)
                
                if t == " " || t == "\n" {
                    return
                }
                
                let lf = alineFragmentRect
                let ulf = usedlineFragmentRect
                let ur = ulf
                let cs = CGSize(width: constraintSize.width, height: usedRect.height)
                let unit = TextUnit(text: t, attriubtes: attributes, usedRect: ur, lineFragmentRect: lf, usedLineFragmentRect: ulf, constraintSize: cs, section: section, row: row)
                
                inSize = cs
                units.append(unit)
                
                section += 1
                sectionCount += 1
            })
            
        case (.byLine, .byCharacter):
            
            var section = 0
            var row = 0
            let text = text as NSString
            let usedRect = manager.usedRect(for: container)
            manager.enumerateLineFragments(forGlyphRange: NSMakeRange(0, glyphCount), using: { (alineFragmentRect, usedlineFragmentRect, container, glyphRange, stop) in
                
                let location = glyphRange.location
                let length = glyphRange.length
                
                var nextLocation = location
                for l in location..<(location + length) {
                    
                    if l < nextLocation {
                        continue
                    }
                    
                    let r = NSMakeRange(l, 1)
                    
                    var p = r
                    let characterRange = manager.characterRange(forGlyphRange: r, actualGlyphRange: &p)
                    
                    if characterRange.length > 0 {
                        nextLocation = l + characterRange.length
                    }
                    //                    let start = text.startIndex.advancedBy(p.location)
                    //                    let end = text.startIndex.advancedBy(p.location + p.length)
                    let t = (text as NSString).substring(with: p)
                    
                    if t == " " || t == "\n" {
                        continue
                    }
                    
                    let lf = alineFragmentRect
                    let ulf = usedlineFragmentRect
                    let ur = manager.boundingRect(forGlyphRange: r, in: container)
                    
                    let cs = CGSize(width: constraintSize.width, height: usedRect.height)
                    let unit = TextUnit(text: t, attriubtes: attributes, usedRect: ur, lineFragmentRect: lf, usedLineFragmentRect: ulf, constraintSize: cs, section: section, row: row)
                    
                    inSize = cs
                    units.append(unit)
                    
                    row += 1
                }
                
                section += 1
                sectionCount += 1
                row = 0
            })
        }
        
        return (units, inSize, sectionCount)
    }
}

