//
//  Moduler+PublishDetail.swift
//  CuriosTextApp
//
//  Created by allen on 16/7/5.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation

private let moduleName = "PublishDetailAction"
private enum Actions: String {
    case New = "publishDetailVieController:"
}

extension Moduler {
    
    static func module_publishDetail(selectedPublishID:String, publishArray:Array<CTAPublishModel>, delegate:PublishDetailViewDelegate, type:PublishDetailType, viewUser:CTAViewUserModel? = nil) -> UIViewController {
        
        var paras: [String: AnyObject] = [:]
        paras["selectedPublishID"] = selectedPublishID
        paras["publishArray"] = publishArray
        paras["delegate"] = delegate
        paras["type"] = String(type)
        paras["viewUser"] = viewUser
        
        let vc = Moduler.target(moduleName, performAction: Actions.New.rawValue, paras: paras)?.takeUnretainedValue() as! UIViewController
        return vc
    }
}