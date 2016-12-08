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
      tabVC.imageInsets = UIEdgeInsets(top: 4.5, left: 0, bottom: -4.5, right: 0)
        let controllers = [home, recommand, notiCenter, user].map { vc -> UINavigationController in
            
            let navi = UINavigationController(rootViewController: vc)
            return navi
        }
        
        let attributes: [[AnyHashable: Any]] = [
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
//      tabVC.tabBarHeight = 38.0
      
        return tabVC
    }
    
    class func customizeTabBarAppearance(_ tabVC:CYLTabBarController){
        let normalAttrs:[String:AnyObject] = [
            NSForegroundColorAttributeName:CTAStyleKit.normalColor
        ]
        
        let selectedAttrs:[String:AnyObject] = [
            NSForegroundColorAttributeName:CTAStyleKit.selectedColor
        ]
        
        let tabBarItem = UITabBarItem.appearance();
        tabBarItem.setTitleTextAttributes(normalAttrs, for: UIControlState())
        tabBarItem.setTitleTextAttributes(selectedAttrs, for: .selected)
//      tabBarItem.imageInsets = UIEdgeInsets(top: 4.5, left: 0, bottom: -4.5, right: 0)

        let tabBar = UITabBar.appearance()
        tabBar.barTintColor = CTAStyleKit.commonBackgroundColor
//      tabBar.itemPositioning = .centered
      
        let navigation = UINavigationBar.appearance();
        let navAttrs:[String:AnyObject] = [
            NSFontAttributeName:UIFont.boldSystemFont(ofSize: 18),
            NSForegroundColorAttributeName:CTAStyleKit.normalColor
        ]

        navigation.tintColor = CTAStyleKit.commonBackgroundColor
        navigation.isTranslucent = false
        navigation.titleTextAttributes = navAttrs
    }
}
