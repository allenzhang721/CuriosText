//
//  CTATabItemFactory.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/7/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

class CTASelectorTabItem {
    
    let type: CTASelectorType
    
    init(type: CTASelectorType) {
        self.type = type
    }
}

final class CTATabItemFactory {
    
    static let shareInstance = CTATabItemFactory()

   let textTabItems: [CTATabItem] = {
        
        var items = [CTATabItem]()
        
        for i in 0..<3 {
            var item: CTASelectorTabItem
            switch i {
                
            case 0:
                item = CTASelectorTabItem(type: .Fonts)
            case 1:
                item = CTASelectorTabItem(type: .Size)
            case 2:
                item = CTASelectorTabItem(type: .Rotator)
            default:
                item = CTASelectorTabItem(type: .Size)
            }
            
            let tabItem = CTATabItem(userInfo: item)
            items.append(tabItem)
        }
        
        return items
    }()
}