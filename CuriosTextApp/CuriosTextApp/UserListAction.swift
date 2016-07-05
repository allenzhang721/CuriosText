//
//  UserListAction.swift
//  CuriosTextApp
//
//  Created by allen on 16/7/3.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation

class UserListAction: NSObject{
    
    class func userListViewController(paras: [String: AnyObject]) -> UIViewController {
        
        guard let userID = paras["userID"] as? String else { fatalError() }
        guard let type = paras["type"] as? String else { fatalError() }
        
        let vc = UserListViewController()
        vc.viewUserID = userID
        vc.type       = UserListType(rawValue: type)!
        
        return vc
    }
}