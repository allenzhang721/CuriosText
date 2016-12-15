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

    static func module_userList(_ userID:String, type:UserListType, delegate:UserListViewDelegate?) -> UIViewController {
        
        var paras: [String: AnyObject] = [:]
        paras["userID"] = userID as AnyObject?
        paras["type"] = type.rawValue as AnyObject
        paras["delegate"] = delegate
        
        let vc = Moduler.target(moduleName, performAction: Actions.New.rawValue, paras: paras as AnyObject?)?.takeUnretainedValue() as! UIViewController
        
        return vc
    }
}
