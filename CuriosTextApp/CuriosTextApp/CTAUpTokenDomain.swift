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
            _instance = CTAUpTokenDomain();
        }
        return _instance!
    }
    
    func uploadFilePath(_ compelecationBlock: @escaping (CTADomainListInfo!) -> Void)  {
        
        CTAUploadFileRequest().startWithCompletionBlockWithSuccess { (response) -> Void in
            switch response.result {
            case .success(let json):
                let json:JSON = JSON(json)
                let result = self.checkJsonResult(json)
                if result {
                    let publishFilePath = json[key(.publishFilePath)].string ?? ""
                    let userFilePath = json[key(.userFilePath)].string ?? ""
                    let resourceFilePath = json[key(.resourceFilePath)].string ?? ""
                    let dic:Dictionary<String, String> = [
                        key(.publishFilePath) : publishFilePath,
                        key(.userFilePath)    : userFilePath,
                        key(.resourceFilePath): resourceFilePath
                    ];
                    compelecationBlock(CTADomainListInfo(result: true, modelDic: dic, successType: 0))
                } else {
                   compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func userUpToken(_ list:Array<CTAUpTokenModel>, compelecationBlock: @escaping (CTADomainListInfo!) -> Void)  {
        
        CTAUserUpTokenRequest(list: list).startWithCompletionBlockWithSuccess { (response) -> Void in
            switch response.result {
            case .success(let json):
                let json:JSON = JSON(json)
                let result = self.checkJsonResult(json)
                if result {
                    let upTokenArray: Array<CTAUpTokenModel> = self.uptokenListResult(json)
                    compelecationBlock(CTADomainListInfo(result: true, modelArray: upTokenArray, successType: 0))
                } else {
                    compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    /**
     <#Description#>
     
     - parameter list:
     - parameter compelecationBlock:  
     */
    func publishUpToken(_ list:Array<CTAUpTokenModel>, compelecationBlock: @escaping (CTADomainListInfo!) -> Void)  {
        
        CTAPublishUpTokenRequest(list: list).startWithCompletionBlockWithSuccess { (response) -> Void in
            switch response.result {
            case .success(let json):
                let json:JSON = JSON(json)
                let result = self.checkJsonResult(json)
                if result {
                    let upTokenArray: Array<CTAUpTokenModel> = self.uptokenListResult(json)
                    compelecationBlock(CTADomainListInfo(result: true, modelArray: upTokenArray, successType: 0))
                } else {
                    compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func resourceUpToken(_ list:Array<CTAUpTokenModel>, compelecationBlock: @escaping (CTADomainListInfo!) -> Void)  {
        
        CTAResourceUpTokenRequest(list: list).startWithCompletionBlockWithSuccess { (response) in
            switch response.result {
            case .success(let json):
                let json:JSON = JSON(json)
                let result = self.checkJsonResult(json)
                if result {
                    let upTokenArray: Array<CTAUpTokenModel> = self.uptokenListResult(json)
                    compelecationBlock(CTADomainListInfo(result: true, modelArray: upTokenArray, successType: 0))
                } else {
                    compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func uptokenListResult(_ json:JSON) -> Array<CTAUpTokenModel>{
        let listArray = json[key(.list)].array;
        var upTokenArray: Array<CTAUpTokenModel> = [];
        if listArray != nil{
            for i in 0..<listArray!.count {
                let listJson = listArray![i];
                let tokenModel = CTAUpTokenModel.generateFrom(listJson);
                upTokenArray.append(tokenModel);
            }
        }
        return upTokenArray
    }
    
}
