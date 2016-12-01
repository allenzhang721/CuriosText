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
    
    static func module_publishDetail(_ selectedPublishID:String, publishArray:Array<CTAPublishModel>, delegate:PublishDetailViewDelegate, type:PublishDetailType, viewUserID:String = "") -> UIViewController {
        
        var paras: [String: AnyObject] = [:]
        paras["selectedPublishID"] = selectedPublishID as AnyObject?
        paras["publishArray"] = publishArray as AnyObject?
        paras["delegate"] = delegate
        paras["type"] = type as AnyObject
        paras["viewUserID"] = viewUserID as AnyObject?
        
        let vc = Moduler.target(moduleName, performAction: Actions.New.rawValue, paras: paras as AnyObject?)?.takeUnretainedValue() as! UIViewController
        return vc
    }
}
