//
//  CTAPublishDomain.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/16.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation
import SwiftyJSON

class CTAPublishDomain: CTABaseDomain {
    
    static var _instance:CTAPublishDomain?;
    
    static func getInstance() -> CTAPublishDomain{
        if _instance == nil{
            _instance = CTAPublishDomain();
        }
        return _instance!
    }
    
    var protocolID:String = "";
    
    func createPublishFile(_ publishID:String, userID:String, title:String, publishDesc:String, publishIconURL:String, previewIconURL:String, publishURL:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void)  {
        CTACreatePublishRequest(publishID: publishID, userID: userID, title: title, publishDesc: publishDesc, publishIconURL: publishIconURL, previewIconURL: previewIconURL, publishURL: publishURL).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAPublishDeleteError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func deletePublishFile(_ publishID:String, userID:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void){
        
        CTADeletePublishRequest(publishID: publishID, userID: userID).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAPublishDeleteError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func userPublishList(_ userID:String, beUserID:String, start:Int, size:Int = 20, compelecationBlock: @escaping (CTADomainListInfo!) -> Void){
    
        CTAUserPublishListRequest(userID: userID, beUserID: beUserID, start: start, size:size).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let publishArray = self.publishListResult(json)
                    compelecationBlock(CTADomainListInfo(result: true, modelArray: publishArray, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainListInfo(result: false, errorType: CTAPublishListError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func userLikePublishList(_ userID:String, beUserID:String, start:Int, size:Int = 20, compelecationBlock: @escaping (CTADomainListInfo!) -> Void){
        
        CTAUserLikePublishListRequest(userID: userID, beUserID: beUserID, start: start, size:size).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let publishArray = self.publishListResult(json)
                    compelecationBlock(CTADomainListInfo(result: true, modelArray: publishArray, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainListInfo(result: false, errorType: CTAPublishListError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func userRebuildPublishList(_ userID:String, beUserID:String, start:Int, size:Int = 20, compelecationBlock: @escaping (CTADomainListInfo!) -> Void){
        
        CTAUserRebuildPublishListRequest(userID: userID, beUserID: beUserID, start: start, size:size).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let publishArray = self.publishListResult(json)
                    compelecationBlock(CTADomainListInfo(result: true, modelArray: publishArray, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainListInfo(result: false, errorType: CTAPublishListError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func userFollowPublishList(_ userID:String, beUserID:String, start:Int, size:Int = 20, compelecationBlock: @escaping (CTADomainListInfo!) -> Void){
        
        CTAUserFollowPublishListRequest(userID: userID, beUserID: beUserID, start: start, size:size).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let publishArray = self.publishListResult(json)
                    compelecationBlock(CTADomainListInfo(result: true, modelArray: publishArray, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainListInfo(result: false, errorType: CTAPublishListError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func newPublishList(_ userID:String, start:Int, size:Int = 20, compelecationBlock: @escaping (CTADomainListInfo!) -> Void){
        
        CTANewPublishListRequest(userID: userID, start: start, size:size).startWithCompletionBlockWithSuccess { (response) -> Void in
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let publishArray = self.publishListResult(json)
                    compelecationBlock(CTADomainListInfo(result: true, modelArray: publishArray, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainListInfo(result: false, errorType: CTAPublishListError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func hotPublishList(_ userID:String, start:Int, size:Int = 20, compelecationBlock: @escaping (CTADomainListInfo!) -> Void){
        
        CTAHotPublishListRequest(userID: userID, start: start, size:size).startWithCompletionBlockWithSuccess { (response) -> Void in
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let publishArray = self.publishListResult(json)
                    compelecationBlock(CTADomainListInfo(result: true, modelArray: publishArray, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainListInfo(result: false, errorType: CTAPublishListError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func setPublishHot(_ publishID:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void){
        CTASetHotPublishRequest(publishID: publishID).startWithCompletionBlockWithSuccess { (response) in
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAPublishHotError(rawValue: resultIndex)!))
                }
            case .failure(_):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func publishListResult(_ json:JSON) -> Array<CTAPublishModel>{
        let listArray = json[key(.list)].array;
        var publishArray: Array<CTAPublishModel> = [];
        if listArray != nil{
            let count = listArray!.count
            for i in 0..<count {
                let listJson = listArray![i];
                let publishModel = CTAPublishModel.generateFrom(listJson);
                publishArray.append(publishModel);
            }
        }
        return publishArray
    }
    
    func likePublish(_ userID:String, publishID:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void){
        
        CTALikePublishRequest(userID: userID, publishID: publishID).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAUserPublishError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func unLikePublish(_ userID:String, publishID:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void){
        
        CTAUnLikePublishRequest(userID: userID, publishID: publishID).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAUserPublishError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func rebuildPublish(_ userID:String, publishID:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void){
        
        CTARebuildPublishRequest(userID: userID, publishID: publishID).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAUserPublishError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func sharePublish(_ userID:String, publishID:String, sharePlatform:Int,compelecationBlock: @escaping (CTADomainInfo!) -> Void){
        
        CTASharePublishRequest(userID: userID, publishID: publishID, sharePlatform:sharePlatform).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAUserPublishError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func reportPublish(_ userID:String, publishID:String, reportType:Int, reportMessage:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void){
        CTAReportPublishRequest(userID: userID, publishID: publishID, reportType: reportType, reportMessage: reportMessage).startWithCompletionBlockWithSuccess { (response) -> Void in
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAUserPublishError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func publishDetai(_ userID:String, publishID:String, compelecationBlock:@escaping (CTADomainInfo!) -> Void){
        CTAPublishDetailRequest(userID: userID, publishID: publishID).startWithCompletionBlockWithSuccess { (response) in
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let publishModel = CTAPublishModel.generateFrom(json);
                    compelecationBlock(CTADomainInfo(result: true, baseModel: publishModel, successType: resultIndex))
                } else {
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAPublishError(rawValue: resultIndex)!))
                }
            case .failure(_):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func publishLikeUserList(_ userID:String, publishID:String, start:Int, size:Int = 20, compelecationBlock: @escaping (CTADomainListInfo!) -> Void){
        CTAPublishLikeUserListRequest(userID: userID, publishID: publishID, start: start, size: size).startWithCompletionBlockWithSuccess { (response) in
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result{
                    let listArray = json[key(.list)].array;
                    var userArray: Array<CTAViewUserModel> = [];
                    if listArray != nil{
                        for i in 0..<listArray!.count {
                            let listJson = listArray![i];
                            let userModel = CTAViewUserModel.generateFrom(listJson)
                            userArray.append(userModel);
                        }
                    }
                    compelecationBlock(CTADomainListInfo(result: true, modelArray: userArray, successType: resultIndex))
                }else {
                    compelecationBlock(CTADomainListInfo(result: false, errorType: CTAPublishError(rawValue: resultIndex)!))
                }
            case .failure(_):
                compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
}
