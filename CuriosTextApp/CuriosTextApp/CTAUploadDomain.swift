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
    
    static func userUpToken(list:Array<CTAUpTokenModel>, compelecationBlock: (Array<CTAUpTokenModel>?, ErrorType?) -> Void)  {
        
        CTAUserUpTokenRequest.init(list: list).startWithCompletionBlockWithSuccess { (response) -> Void in
            switch response.result {
            case .Success(let json):
                print(json)
                let json:JSON = JSON(json)
                let result = checkJsonResult(json)
                if result {
                    let upTokenArray: Array<CTAUpTokenModel> = uptokenListResult(json)
                    compelecationBlock(upTokenArray, CTARequestSuccess(rawValue: 0)!)
                } else {
                    compelecationBlock(nil, CTAInternetError(rawValue: 1)!)
                }
            case .Failure( _):
                compelecationBlock(nil, CTAInternetError(rawValue: 1)!)
            }
        }
    }
    
    static func publishUpToken(list:Array<CTAUpTokenModel>, compelecationBlock: (Array<CTAUpTokenModel>?, ErrorType?) -> Void)  {
        
        CTAPublishUpTokenRequest.init(list: list).startWithCompletionBlockWithSuccess { (response) -> Void in
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let result = checkJsonResult(json)
                if result {
                    let upTokenArray: Array<CTAUpTokenModel> = uptokenListResult(json)
                    compelecationBlock(upTokenArray, CTARequestSuccess(rawValue: 0)!)
                } else {
                    compelecationBlock(nil, CTAInternetError(rawValue: 1)!)
                }
            case .Failure( _):
                compelecationBlock(nil, CTAInternetError(rawValue: 1)!)
            }
        }
    }
    
    static func uptokenListResult(json:JSON) -> Array<CTAUpTokenModel>{
        let listArray = json[key(.List)].array;
        var upTokenArray: Array<CTAUpTokenModel> = [];
        if listArray != nil{
            for var i = 0 ; i < listArray!.count; i++ {
                let listJson = listArray![i];
                let tokenModel = CTAUpTokenModel.generateFrom(listJson);
                upTokenArray.append(tokenModel);
            }
        }
        return upTokenArray
    }
    
}