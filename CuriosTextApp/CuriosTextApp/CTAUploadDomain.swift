//
//  CTAUploadDomain.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/14.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation
import SwiftyJSON

class CTAUploadDomain: CTABaseDomain {
    
    static func uploadFilePath(compelecationBlock: (Dictionary<String, AnyObject>?, ErrorType?) -> Void)  {
        
        CTAUploadFileRequest.init().startWithCompletionBlockWithSuccess { (response) -> Void in
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let result = checkJsonResult(json)
                if result {
                    let publishFilePath = json[key(.PublishFilePath)].string ?? ""
                    let userFilePath = json[key(.UserFilePath)].string ?? ""
                    let dic:Dictionary<String, AnyObject> = [
                        key(.PublishFilePath) : publishFilePath,
                        key(.UserFilePath)    : userFilePath
                    ];
                    compelecationBlock(dic, CTARequestSuccess(rawValue: 0)!)
                } else {
                   compelecationBlock(nil, CTAInternetError(rawValue: 1)!)
                }
            case .Failure( _):
                compelecationBlock(nil, CTAInternetError(rawValue: 1)!)
            }
        }
    }
}