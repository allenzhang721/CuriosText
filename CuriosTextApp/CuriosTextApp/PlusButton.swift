//
//  PlusButton.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import CYLTabBarController

class PlusButton: CYLPlusButton, CYLPlusButtonSubclassing {
    
    static func plusButton() -> AnyObject! {
        
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 49, height: 49))
        v.backgroundColor = UIColor.redColor()
        return v
    }
    
    static func indexOfPlusButtonInTabBar() -> UInt {
        return 2
    }

}
