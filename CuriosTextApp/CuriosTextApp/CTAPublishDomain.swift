//
//  CTAPublishDomain.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/16.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation
import Qiniu

class CTAPublishDomain: CTABaseDomain {
    
    func tokensForKeys(keys: [String], completedBlock:(tokenList: [[String: AnyObject]]) -> Void) {
        
    }
    
    func upload(data: NSData, key: String, token: String, completedBlock:((QNResponseInfo, key: String, response:[String: AnyObject]) -> Void)?) {
        
    }
}