//
//  CTASwipeBackProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/2/19.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation
protocol CTASwipeBackProtocol{
    func initSwipe()
    func swipeBackHandler(sender: UISwipeGestureRecognizer)
}

extension CTASwipeBackProtocol where Self: UIViewController{
    func initSwipe(){
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: "swipeBackHandler:")
        self.view.addGestureRecognizer(swipeGesture)
    }
}