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
        let bounds = UIScreen.mainScreen().bounds
        let buttonW:CGFloat = 40.00
        let space = (bounds.width - buttonW*4)/10
        let viewW = buttonW+space*2
        
        let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: viewW, height: 49))
        
        let button = UIButton(frame: CGRect(x: space, y: 5, width: buttonW, height: buttonW))
        buttonView.addSubview(button)
        button.setImage(UIImage(named: "add_button"), forState: .Normal)
        button.setImage(UIImage(named: "add_button_selected"), forState: .Highlighted)
        button.addTarget(self, action: #selector(addButtonHandler(_:)), forControlEvents: .TouchUpInside)
        return buttonView
    }
    
    static func indexOfPlusButtonInTabBar() -> UInt {
        return 2
    }
    
    static func addButtonHandler(sender: UIButton){
        NSNotificationCenter.defaultCenter().postNotificationName("addPublishFile", object: nil)
    }
}
