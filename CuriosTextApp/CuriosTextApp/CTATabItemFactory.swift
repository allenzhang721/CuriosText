////
////  CTATabItemFactory.swift
////  CuriosTextApp
////
////  Created by Emiaostein on 1/7/16.
////  Copyright © 2016 botai. All rights reserved.
////
//
//import Foundation
//
//class CTASelectorTabItem {
//    
//    let type: CTASelectorType
//    
//    init(type: CTASelectorType) {
//        self.type = type
//    }
//}
//
//enum CTASelectorType: String {
//    
//    case Fonts, Size, Rotator, Aligments, TextSpacing, Colors, Animation
//}
//
//final class CTATabItemFactory {
//    
//    static let shareInstance = CTATabItemFactory()
//
//   let textTabItems: [CTATabItem] = {
//        
//        var items = [CTATabItem]()
//        let count = 7
//        for i in 0..<count {
//            var item: CTASelectorTabItem
//            switch i {
//                
//            case 0:
//                item = CTASelectorTabItem(type: .Fonts)
//            case 1:
//                item = CTASelectorTabItem(type: .Size)
//            case 2:
//                item = CTASelectorTabItem(type: .Rotator)
//            case 3:
//                item = CTASelectorTabItem(type: .Aligments)
//            case 4:
//                item = CTASelectorTabItem(type: .TextSpacing)
//            case 5:
//                item = CTASelectorTabItem(type: .Colors)
//            case 6:
//                item = CTASelectorTabItem(type: .Animation)
//            default:
//                item = CTASelectorTabItem(type: .Size)
//            }
//            
//            let tabItem = CTATabItem(userInfo: item)
//            items.append(tabItem)
//        }
//        
//        return items
//    }()
//}