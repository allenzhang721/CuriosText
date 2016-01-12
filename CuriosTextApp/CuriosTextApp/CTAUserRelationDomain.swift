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
    
    static var _instance:CTAUserRelationDomain?;
    
    static func getInstance() -> CTAUserRelationDomain{
        if _instance == nil{
            _instance = CTAUserRelationDomain.init();
        }
        return _instance!
    }
    
    func followUser(userID:String, relationUserID:String, compelecationBlock: (CTADomainInfo!) -> Void){
        
        CTAFollowUserRequest.init(userID: userID, relationUserID: relationUserID).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo.init(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAUserRelationError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func unFollowUser(userID:String, relationUserID:String, compelecationBlock: (CTADomainInfo!) -> Void){
        
        CTAUnFollowUserRequest.init(userID: userID, relationUserID: relationUserID).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo.init(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAUserRelationError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func blockUser(userID:String, relationUserID:String, compelecationBlock: (CTADomainInfo!) -> Void){
        
        CTABlockUserRequest.init(userID: userID, relationUserID: relationUserID).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo.init(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAUserRelationError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func unBlockUser(userID:String, relationUserID:String, compelecationBlock: (CTADomainInfo!) -> Void){
        
        CTAUnBlockUserRequest.init(userID: userID, relationUserID: relationUserID).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo.init(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAUserRelationError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func userFollowList(userID:String, beUserID:String, start:Int, size:Int, compelecationBlock: (CTADomainListInfo!) -> Void){
        
        CTAUserFollowListRequest.init(userID: userID, beUserID: beUserID, start: start, size: size).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let userArray = self.userRelationListResult(json)
                    compelecationBlock(CTADomainListInfo.init(result: true, modelArray: userArray, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainListInfo.init(result: false, errorType: CTAUserRelationListError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainListInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func userBefollowList(userID:String, beUserID:String, start:Int, size:Int, compelecationBlock: (CTADomainListInfo!) -> Void){
        
        CTAUserBeFollowListRequest.init(userID: userID, beUserID: beUserID, start: start, size: size).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let userArray = self.userRelationListResult(json)
                    compelecationBlock(CTADomainListInfo.init(result: true, modelArray: userArray, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainListInfo.init(result: false, errorType: CTAUserRelationListError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainListInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func userRelationListResult(json:JSON) -> Array<CTAViewUserModel>{
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