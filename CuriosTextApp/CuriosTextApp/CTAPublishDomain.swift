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
            _instance = CTAPublishDomain.init();
        }
        return _instance!
    }
    
    var protocolID:String = "";
    
    func publishID(compelecationBlock: (String?) -> Void)  {
        
        CTAPublishIDRequest.init().startWithCompletionBlockWithSuccess { (response) -> Void in
            
            var uuid:String!;
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let result = self.checkJsonResult(json)
                if result{
                    let data = json[key(.Data)].string
                    compelecationBlock(data)
                } else{
                    uuid = NSUUID().UUIDString
                    uuid = self.changeUUID(uuid);
                    compelecationBlock(uuid)
                }
            case .Failure( _):
                uuid = NSUUID().UUIDString
                uuid = self.changeUUID(uuid);
                compelecationBlock(uuid)
            }
        }
    }
    
    func createPublishFile(publishID:String, userID:String, title:String, publishDesc:String, publishIconURL:String, previewIconURL:String, publishURL:String, compelecationBlock: (CTADomainInfo!) -> Void)  {
        CTACreatePublishRequest.init(publishID: publishID, userID: userID, title: title, publishDesc: publishDesc, publishIconURL: publishIconURL, previewIconURL: previewIconURL, publishURL: publishURL).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo.init(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAPublishDeleteError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func deletePublishFile(publishID:String, compelecationBlock: (CTADomainInfo!) -> Void){
        
        CTADeletePublishRequest.init(publishID: publishID).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo.init(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAPublishDeleteError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func userPublishList(userID:String, beUserID:String, start:Int, size:Int = 20, compelecationBlock: (CTADomainListInfo!) -> Void){
    
        CTAUserPublishListRequest.init(userID: userID, beUserID: beUserID, start: start, size:size).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let publishArray = self.publishListResult(json)
                    compelecationBlock(CTADomainListInfo.init(result: true, modelArray: publishArray, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainListInfo.init(result: false, errorType: CTAPublishListError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainListInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func userLikePublishList(userID:String, beUserID:String, start:Int, size:Int = 20, compelecationBlock: (CTADomainListInfo!) -> Void){
        
        CTAUserLikePublishListRequest.init(userID: userID, beUserID: beUserID, start: start, size:size).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let publishArray = self.publishListResult(json)
                    compelecationBlock(CTADomainListInfo.init(result: true, modelArray: publishArray, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainListInfo.init(result: false, errorType: CTAPublishListError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainListInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func userRebuildPublishList(userID:String, beUserID:String, start:Int, size:Int = 20, compelecationBlock: (CTADomainListInfo!) -> Void){
        
        CTAUserRebuildPublishListRequest.init(userID: userID, beUserID: beUserID, start: start, size:size).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let publishArray = self.publishListResult(json)
                    compelecationBlock(CTADomainListInfo.init(result: true, modelArray: publishArray, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainListInfo.init(result: false, errorType: CTAPublishListError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainListInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func userFollowPublishList(userID:String, beUserID:String, start:Int, size:Int = 20, compelecationBlock: (CTADomainListInfo!) -> Void){
        
        CTAUserFollowPublishListRequest.init(userID: userID, beUserID: beUserID, start: start, size:size).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let publishArray = self.publishListResult(json)
                    compelecationBlock(CTADomainListInfo.init(result: true, modelArray: publishArray, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainListInfo.init(result: false, errorType: CTAPublishListError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainListInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func newPublishList(userID:String, start:Int, size:Int = 20, compelecationBlock: (CTADomainListInfo!) -> Void){
        
        CTANewPublishListRequest.init(userID: userID, start: start, size:size).startWithCompletionBlockWithSuccess { (response) -> Void in
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let publishArray = self.publishListResult(json)
                    compelecationBlock(CTADomainListInfo.init(result: true, modelArray: publishArray, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainListInfo.init(result: false, errorType: CTAPublishListError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainListInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func hotPublishList(userID:String, start:Int, size:Int = 20, compelecationBlock: (CTADomainListInfo!) -> Void){
        
        CTAHotPublishListRequest.init(userID: userID, start: start, size:size).startWithCompletionBlockWithSuccess { (response) -> Void in
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let publishArray = self.publishListResult(json)
                    compelecationBlock(CTADomainListInfo.init(result: true, modelArray: publishArray, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainListInfo.init(result: false, errorType: CTAPublishListError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainListInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func publishListResult(json:JSON) -> Array<CTAPublishModel>{
        let listArray = json[key(.List)].array;
        var publishArray: Array<CTAPublishModel> = [];
        if listArray != nil{
            for var i = 0 ; i < listArray!.count; i++ {
                let listJson = listArray![i];
                let publishModel = CTAPublishModel.generateFrom(listJson);
                publishArray.append(publishModel);
            }
        }
        return publishArray
    }
    
    func likePublish(userID:String, publishID:String, compelecationBlock: (CTADomainInfo!) -> Void){
        
        CTALikePublishRequest.init(userID: userID, publishID: publishID).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo.init(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAUserPublishError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func unLikePublish(userID:String, publishID:String, compelecationBlock: (CTADomainInfo!) -> Void){
        
        CTAUnLikePublishRequest.init(userID: userID, publishID: publishID).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo.init(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAUserPublishError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func rebuildPublish(userID:String, publishID:String, compelecationBlock: (CTADomainInfo!) -> Void){
        
        CTARebuildPublishRequest.init(userID: userID, publishID: publishID).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo.init(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAUserPublishError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func sharePublish(userID:String, publishID:String, sharePlatform:Int,compelecationBlock: (CTADomainInfo?) -> Void){
        
        CTASharePublishRequest.init(userID: userID, publishID: publishID, sharePlatform:sharePlatform).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo.init(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAUserPublishError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
}