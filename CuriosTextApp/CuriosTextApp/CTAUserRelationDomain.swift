//
//  CTAUserRelationDomain.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/21.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation
import SwiftyJSON

class CTAUserRelationDomain: CTABaseDomain {
    
    static func followUser(userID:String, relationUserID:String, compelecationBlock: (ErrorType?) -> Void){
        
        CTAFollowUserRequest.init(userID: userID, relationUserID: relationUserID).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    compelecationBlock(CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(CTAUserRelationError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func unFollowUser(userID:String, relationUserID:String, compelecationBlock: (ErrorType?) -> Void){
        
        CTAUnFollowUserRequest.init(userID: userID, relationUserID: relationUserID).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    compelecationBlock(CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(CTAUserRelationError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func blockUser(userID:String, relationUserID:String, compelecationBlock: (ErrorType?) -> Void){
        
        CTABlockUserRequest.init(userID: userID, relationUserID: relationUserID).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    compelecationBlock(CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(CTAUserRelationError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func unBlockUser(userID:String, relationUserID:String, compelecationBlock: (ErrorType?) -> Void){
        
        CTAUnBlockUserRequest.init(userID: userID, relationUserID: relationUserID).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    compelecationBlock(CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(CTAUserRelationError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func userFollowList(userID:String, beUserID:String, start:Int, size:Int, compelecationBlock: (Array<CTAViewUserModel>?, ErrorType?) -> Void){
        
        CTAUserFollowListRequest.init(userID: userID, beUserID: beUserID, start: start, size: size).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    let userArray = userRelationListResult(json)
                    compelecationBlock(userArray,CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(nil, CTAUserRelationListError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(nil, CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func userBefollowList(userID:String, beUserID:String, start:Int, size:Int, compelecationBlock: (Array<CTAViewUserModel>?, ErrorType?) -> Void){
        
        CTAUserBeFollowListRequest.init(userID: userID, beUserID: beUserID, start: start, size: size).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    let userArray = userRelationListResult(json)
                    compelecationBlock(userArray,CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(nil, CTAUserRelationListError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(nil, CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func userRelationListResult(json:JSON) -> Array<CTAViewUserModel>{
        let listArray = json[key(.List)].array;
        var userArray: Array<CTAViewUserModel> = [];
        if listArray != nil{
            for var i = 0 ; i < listArray!.count; i++ {
                let listJson = listArray![i];
                let userModel = CTAViewUserModel.generateFrom(listJson)
                userArray.append(userModel);
            }
        }
        return userArray
    }
}