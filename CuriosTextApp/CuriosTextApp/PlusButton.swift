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
    
    static func plusButton() -> Any! {
        let bounds = UIScreen.main.bounds
        let buttonW:CGFloat = 40.00
        let space = (bounds.width - buttonW*4)/10
        let viewW = buttonW+space*2
        
//        let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: viewW, height: 49))
      
        let button = PlusButton(frame: CGRect(x: space, y: 0, width: buttonW, height: buttonW))
//        buttonView.addSubview(button)
//      button.setTitle("Add", for: .normal)
//      button.setTitle("Ing", for: .highlighted)
//      button.isUserInteractionEnabled = false
        button.setImage(UIImage(named: "add_button"), for: .normal)
        button.setImage(UIImage(named: "add_button_selected"), for: .highlighted)
        button.addTarget(button, action: #selector(PlusButton.addButtonHandler(_:)), for: .touchUpInside)
//      button.backgroundColor = UIColor.yellow
//      buttonView.backgroundColor = UIColor.blue
//      let sw = UISwitch(frame: CGRect(x: space, y: 0, width: buttonW, height: buttonW))
//      buttonView.addSubview(sw)
      
        return button
    }
    
    static func indexOfPlusButtonInTabBar() -> UInt {
        return 2
    }
    
    func addButtonHandler(_ sender: UIButton){
        NotificationCenter.default.post(name: Notification.Name(rawValue: "addPublishFile"), object: nil)
    }
}
