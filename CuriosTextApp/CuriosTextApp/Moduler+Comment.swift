//
//  Moduler+Comment.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

private let moduleName = "CommentAction"
private enum Actions: String {
    case New = "commentViewController:"
}

extension Moduler {
    
    static func module_comment(_ publishID: String, userID:String, delegate:CommentViewDelegate?) -> UIViewController {
        
        var paras: [String: AnyObject] = [:]
        paras["publishID"] = publishID as AnyObject?
        paras["userID"] = userID as AnyObject?
        paras["delegate"] = delegate
        
        let vc = Moduler.target(moduleName, performAction: Actions.New.rawValue, paras: paras as AnyObject?)?.takeUnretainedValue() as! UIViewController
        
        return vc
    }
    
}
