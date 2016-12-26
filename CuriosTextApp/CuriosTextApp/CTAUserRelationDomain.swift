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
            _instance = CTAUserRelationDomain();
        }
        return _instance!
    }
    
    func followUser(_ userID:String, relationUserID:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void){
        
        CTAFollowUserRequest(userID: userID, relationUserID: relationUserID).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAUserRelationError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func unFollowUser(_ userID:String, relationUserID:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void){
        
        CTAUnFollowUserRequest(userID: userID, relationUserID: relationUserID).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAUserRelationError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func blockUser(_ userID:String, relationUserID:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void){
        
        CTABlockUserRequest(userID: userID, relationUserID: relationUserID).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAUserRelationError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func unBlockUser(_ userID:String, relationUserID:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void){
        
        CTAUnBlockUserRequest(userID: userID, relationUserID: relationUserID).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAUserRelationError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func userFollowList(_ userID:String, beUserID:String, start:Int, size:Int, compelecationBlock: @escaping (CTADomainListInfo!) -> Void){
        
        CTAUserFollowListRequest(userID: userID, beUserID: beUserID, start: start, size: size).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let userArray = self.userRelationListResult(json)
                    compelecationBlock(CTADomainListInfo(result: true, modelArray: userArray, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainListInfo(result: false, errorType: CTAUserRelationListError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func userBefollowList(_ userID:String, beUserID:String, start:Int, size:Int, compelecationBlock: @escaping (CTADomainListInfo!) -> Void){
        
        CTAUserBeFollowListRequest(userID: userID, beUserID: beUserID, start: start, size: size).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let userArray = self.userRelationListResult(json)
                    compelecationBlock(CTADomainListInfo(result: true, modelArray: userArray, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainListInfo(result: false, errorType: CTAUserRelationListError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func userRelationListResult(_ json:JSON) -> Array<CTAViewUserModel>{
        let listArray = json[key(.list)].array;
        var userArray: Array<CTAViewUserModel> = [];
        if listArray != nil{
            for i in 0..<listArray!.count {
                let listJson = listArray![i];
                let userModel = CTAViewUserModel.generateFrom(listJson)
                userArray.append(userModel);
            }
        }
        return userArray
    }
}
