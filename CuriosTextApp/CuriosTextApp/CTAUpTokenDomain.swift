//
//  CTAUploadDomain.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/14.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation
import SwiftyJSON

class CTAUpTokenDomain: CTABaseDomain {
    
    static var _instance:CTAUpTokenDomain?;
    
    static func getInstance() -> CTAUpTokenDomain{
        if _instance == nil{
            _instance = CTAUpTokenDomain.init();
        }
        return _instance!
    }
    
    func uploadFilePath(compelecationBlock: (CTADomainListInfo!) -> Void)  {
        
        CTAUploadFileRequest.init().startWithCompletionBlockWithSuccess { (response) -> Void in
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let result = self.checkJsonResult(json)
                if result {
                    let publishFilePath = json[key(.PublishFilePath)].string ?? ""
                    let userFilePath = json[key(.UserFilePath)].string ?? ""
                    let dic:Dictionary<String, AnyObject> = [
                        key(.PublishFilePath) : publishFilePath,
                        key(.UserFilePath)    : userFilePath
                    ];
                    compelecationBlock(CTADomainListInfo.init(result: true, modelDic: dic, successType: 0))
                } else {
                   compelecationBlock(CTADomainListInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainListInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func userUpToken(list:Array<CTAUpTokenModel>, compelecationBlock: (CTADomainListInfo!) -> Void)  {
        
        CTAUserUpTokenRequest.init(list: list).startWithCompletionBlockWithSuccess { (response) -> Void in
            switch response.result {
            case .Success(let json):
                print(json)
                let json:JSON = JSON(json)
                let result = self.checkJsonResult(json)
                if result {
                    let upTokenArray: Array<CTAUpTokenModel> = self.uptokenListResult(json)
                    compelecationBlock(CTADomainListInfo.init(result: true, modelArray: upTokenArray, successType: 0))
                } else {
                    compelecationBlock(CTADomainListInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainListInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func publishUpToken(list:Array<CTAUpTokenModel>, compelecationBlock: (CTADomainListInfo!) -> Void)  {
        
        CTAPublishUpTokenRequest.init(list: list).startWithCompletionBlockWithSuccess { (response) -> Void in
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let result = self.checkJsonResult(json)
                if result {
                    let upTokenArray: Array<CTAUpTokenModel> = self.uptokenListResult(json)
                    compelecationBlock(CTADomainListInfo.init(result: true, modelArray: upTokenArray, successType: 0))
                } else {
                    compelecationBlock(CTADomainListInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainListInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func uptokenListResult(json:JSON) -> Array<CTAUpTokenModel>{
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