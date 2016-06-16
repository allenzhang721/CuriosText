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
    
    static func commentViewController(userID: String) -> UIViewController {
        
        var paras: [String: AnyObject] = [:]
        paras["userID"] = userID
        
        let vc = Moduler.target(moduleName, performAction: Actions.New.rawValue, paras: paras)?.takeUnretainedValue() as! UIViewController
        
        return vc
    }
    
}
