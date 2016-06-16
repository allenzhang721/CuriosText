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
    
    class func rootTabViewController() -> UIViewController {
        
        let tabVC = CYLTabBarController()
        
        let home = HomeViewController()
        let recommand = RecommandViewController()
        let notiCenter = NotiCenterViewController()
        let user = UserViewController()
        let controllers = [home, recommand, notiCenter, user].map { vc -> UINavigationController in
            
            let navi = UINavigationController(rootViewController: vc)
            return navi
        }
        
        let attributes: [[NSObject: AnyObject]] = [
            [
                CYLTabBarItemTitle : "首页",
                CYLTabBarItemImage : "home_normal",
                CYLTabBarItemSelectedImage : "home_highlight",],
            [
                CYLTabBarItemTitle : "推荐",
                CYLTabBarItemImage : "home_normal",
                CYLTabBarItemSelectedImage : "home_highlight",],
            [
                CYLTabBarItemTitle : "通知",
                CYLTabBarItemImage : "home_normal",
                CYLTabBarItemSelectedImage : "home_highlight",],
            [
                CYLTabBarItemTitle : "个人",
                CYLTabBarItemImage : "home_normal",
                CYLTabBarItemSelectedImage : "home_highlight",]
        ]
        
        tabVC.tabBarItemsAttributes = attributes
        tabVC.viewControllers = controllers
        return tabVC
    }
}