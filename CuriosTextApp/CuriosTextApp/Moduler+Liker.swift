//
//  Moduler+Liker.swift
//  CuriosTextApp
//
//  Created by allen on 16/7/5.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation

private let moduleName = "LikersAction"
private enum Actions: String {
    case New = "likerListViewController:"
}

extension Moduler {
    
    static func module_likers(publishID:String) -> UIViewController {
        
        var paras: [String: AnyObject] = [:]
        paras["publishID"] = publishID
        
        let vc = Moduler.target(moduleName, performAction: Actions.New.rawValue, paras: paras)?.takeUnretainedValue() as! UIViewController
        return vc
    }
}