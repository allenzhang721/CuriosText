//
//  Moduler+UserList.swift
//  CuriosTextApp
//
//  Created by allen on 16/7/3.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation

private let moduleName = "UserListAction"
private enum Actions: String {
    case New = "userListViewController:"
}

extension Moduler {

    static func module_userList(userID:String, type:UserListType) -> UIViewController {
        
        var paras: [String: AnyObject] = [:]
        paras["userID"] = userID
        paras["type"] = String(type)
        
        let vc = Moduler.target(moduleName, performAction: Actions.New.rawValue, paras: paras)?.takeUnretainedValue() as! UIViewController
        
        return vc
    }
}