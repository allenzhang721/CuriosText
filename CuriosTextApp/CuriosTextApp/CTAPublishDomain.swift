//
//  CTAPublishDomain.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/16.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation
import Qiniu
import SwiftyJSON

class CTAPublishDomain: CTABaseDomain {
    
    func tokensForKeys(keys: [String], completedBlock:(tokenList: [[String: AnyObject]]) -> Void) {
        
    }
    
    func upload(data: NSData, key: String, token: String, completedBlock:((QNResponseInfo, key: String, response:[String: AnyObject]) -> Void)?) {
        
    }
    
    static func publishID(compelecationBlock: (String?) -> Void)  {
        
        CTAPublishIDRequest.init().startWithCompletionBlockWithSuccess { (response) -> Void in
            
            var uuid:String!;
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let result = checkJsonResult(json)
                if result{
                    let data = json[key(.Data)].string
                    compelecationBlock(data)
                } else{
                    uuid = NSUUID().UUIDString
                    uuid = changeUUID(uuid);
                    compelecationBlock(uuid)
                }
            case .Failure( _):
                uuid = NSUUID().UUIDString
                uuid = changeUUID(uuid);
                compelecationBlock(uuid)
            }
        }
    }
    
    static func createPublishFile(phone: String, areaCode: String, passwd: String, compelecationBlock: (CTAPublishModel?, ErrorType?) -> Void)  {
        
    }
    
    static func deletePublishFile(publishID:String, compelecationBlock: (ErrorType?) -> Void){
        
        CTADeletePublishRequest.init(publishID: publishID).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    compelecationBlock(CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(CTAPublishDeleteError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func userPublishList(userID:String, beUserID:String, start:Int, size:Int = 20, compelecationBlock: (Array<CTAPublishModel>?, ErrorType?) -> Void){
    
        CTAUserPublishListRequest.init(userID: userID, beUserID: beUserID, start: start, size:size).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    let publishArray = publishListResult(json)
                    compelecationBlock(publishArray, CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(nil, CTAPublishListError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(nil, CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func userLikePublishList(userID:String, beUserID:String, start:Int, size:Int = 20, compelecationBlock: (Array<CTAPublishModel>?, ErrorType?) -> Void){
        
        CTAUserLikePublishListRequest.init(userID: userID, beUserID: beUserID, start: start, size:size).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    let publishArray = publishListResult(json)
                    compelecationBlock(publishArray, CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(nil, CTAPublishListError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(nil, CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func userRebuildPublishList(userID:String, beUserID:String, start:Int, size:Int = 20, compelecationBlock: (Array<CTAPublishModel>?, ErrorType?) -> Void){
        
        CTAUserRebuildPublishListRequest.init(userID: userID, beUserID: beUserID, start: start, size:size).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    let publishArray = publishListResult(json)
                    compelecationBlock(publishArray, CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(nil, CTAPublishListError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(nil, CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func userFollowPublishList(userID:String, beUserID:String, start:Int, size:Int = 20, compelecationBlock: (Array<CTAPublishModel>?, ErrorType?) -> Void){
        
        CTAUserFollowPublishListRequest.init(userID: userID, beUserID: beUserID, start: start, size:size).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    let publishArray = publishListResult(json)
                    compelecationBlock(publishArray, CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(nil, CTAPublishListError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(nil, CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func newPublishList(userID:String, start:Int, size:Int = 20, compelecationBlock: (Array<CTAPublishModel>?, ErrorType?) -> Void){
        
        CTANewPublishListRequest.init(userID: userID, start: start, size:size).startWithCompletionBlockWithSuccess { (response) -> Void in
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    let publishArray = publishListResult(json)
                    compelecationBlock(publishArray, CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(nil, CTAPublishListError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(nil, CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func hotPublishList(userID:String, start:Int, size:Int = 20, compelecationBlock: (Array<CTAPublishModel>?, ErrorType?) -> Void){
        
        CTAHotPublishListRequest.init(userID: userID, start: start, size:size).startWithCompletionBlockWithSuccess { (response) -> Void in
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    let publishArray = publishListResult(json)
                    compelecationBlock(publishArray, CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(nil, CTAPublishListError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(nil, CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func publishListResult(json:JSON) -> Array<CTAPublishModel>{
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
    
    static func likePublish(userID:String, publishID:String, compelecationBlock: (ErrorType?) -> Void){
        
        CTALikePublishRequest.init(userID: userID, publishID: publishID).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    compelecationBlock(CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(CTAUserPublishError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func unLikePublish(userID:String, publishID:String, compelecationBlock: (ErrorType?) -> Void){
        
        CTAUnLikePublishRequest.init(userID: userID, publishID: publishID).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    compelecationBlock(CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(CTAUserPublishError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func rebuildPublish(userID:String, publishID:String, compelecationBlock: (ErrorType?) -> Void){
        
        CTARebuildPublishRequest.init(userID: userID, publishID: publishID).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    compelecationBlock(CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(CTAUserPublishError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func sharePublish(userID:String, publishID:String, sharePlatform:Int,compelecationBlock: (ErrorType?) -> Void){
        
        CTASharePublishRequest.init(userID: userID, publishID: publishID, sharePlatform:sharePlatform).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    compelecationBlock(CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(CTAUserPublishError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
}