//
//  RootAction.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
import CYLTabBarController

class RootAction: NSObject {
    
    class func rootTabViewController() -> UITabBarController {
        
        let tabVC = CYLTabBarController()
        self.customizeTabBarAppearance(tabVC)
        
        let home = HomeViewController()
        let recommand = RecommandViewController()
        let notiCenter = UIStoryboard(name: "NotiCenter", bundle: nil).instantiateInitialViewController() as! NotiCenterViewController
        let user = UserViewController()
        let controllers = [home, recommand, notiCenter, user].map { vc -> UINavigationController in
            
            let navi = UINavigationController(rootViewController: vc)
            return navi
        }
        
        let attributes: [[NSObject: AnyObject]] = [
            [
                CYLTabBarItemImage : "home_button",
                CYLTabBarItemSelectedImage : "home_button_selected",],
            [
                CYLTabBarItemImage : "new_button",
                CYLTabBarItemSelectedImage : "new_button_selected",],
            [
                CYLTabBarItemImage : "notic_button",
                CYLTabBarItemSelectedImage : "notic_button_selected",],
            [
                CYLTabBarItemImage : "user_button",
                CYLTabBarItemSelectedImage : "user_button_selected",]
            ]
        tabVC.tabBarItemsAttributes = attributes
        tabVC.viewControllers = controllers
        return tabVC
    }
    
    class func customizeTabBarAppearance(tabVC:CYLTabBarController){
        let normalAttrs:[String:AnyObject] = [
            NSForegroundColorAttributeName:CTAStyleKit.normalColor
        ]
        
        let selectedAttrs:[String:AnyObject] = [
            NSForegroundColorAttributeName:CTAStyleKit.selectedColor
        ]
        
        let tabBarItem = UITabBarItem.appearance();
        tabBarItem.setTitleTextAttributes(normalAttrs, forState: .Normal)
        tabBarItem.setTitleTextAttributes(selectedAttrs, forState: .Selected)

        let tabBar = UITabBar.appearance()
        tabBar.barTintColor = CTAStyleKit.commonBackgroundColor
        
        let navigation = UINavigationBar.appearance();
        let navAttrs:[String:AnyObject] = [
            NSFontAttributeName:UIFont.boldSystemFontOfSize(18),
            NSForegroundColorAttributeName:CTAStyleKit.normalColor
        ]

        navigation.tintColor = CTAStyleKit.commonBackgroundColor
        navigation.translucent = false
        navigation.titleTextAttributes = navAttrs
    }
}