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
    
    func createPublishFile(publishID:String, userID:String, title:String, publishDesc:String, publishIconURL:String, previewIconURL:String, publishURL:String, compelecationBlock: (CTADomainInfo!) -> Void)  {
        CTACreatePublishRequest(publishID: publishID, userID: userID, title: title, publishDesc: publishDesc, publishIconURL: publishIconURL, previewIconURL: previewIconURL, publishURL: publishURL).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAPublishDeleteError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func deletePublishFile(publishID:String, userID:String, compelecationBlock: (CTADomainInfo!) -> Void){
        
        CTADeletePublishRequest(publishID: publishID, userID: userID).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAPublishDeleteError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func userPublishList(userID:String, beUserID:String, start:Int, size:Int = 20, compelecationBlock: (CTADomainListInfo!) -> Void){
    
        CTAUserPublishListRequest(userID: userID, beUserID: beUserID, start: start, size:size).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let publishArray = self.publishListResult(json)
                    compelecationBlock(CTADomainListInfo(result: true, modelArray: publishArray, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainListInfo(result: false, errorType: CTAPublishListError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func userLikePublishList(userID:String, beUserID:String, start:Int, size:Int = 20, compelecationBlock: (CTADomainListInfo!) -> Void){
        
        CTAUserLikePublishListRequest(userID: userID, beUserID: beUserID, start: start, size:size).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let publishArray = self.publishListResult(json)
                    compelecationBlock(CTADomainListInfo(result: true, modelArray: publishArray, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainListInfo(result: false, errorType: CTAPublishListError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func userRebuildPublishList(userID:String, beUserID:String, start:Int, size:Int = 20, compelecationBlock: (CTADomainListInfo!) -> Void){
        
        CTAUserRebuildPublishListRequest(userID: userID, beUserID: beUserID, start: start, size:size).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let publishArray = self.publishListResult(json)
                    compelecationBlock(CTADomainListInfo(result: true, modelArray: publishArray, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainListInfo(result: false, errorType: CTAPublishListError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func userFollowPublishList(userID:String, beUserID:String, start:Int, size:Int = 20, compelecationBlock: (CTADomainListInfo!) -> Void){
        
        CTAUserFollowPublishListRequest(userID: userID, beUserID: beUserID, start: start, size:size).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let publishArray = self.publishListResult(json)
                    compelecationBlock(CTADomainListInfo(result: true, modelArray: publishArray, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainListInfo(result: false, errorType: CTAPublishListError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func newPublishList(userID:String, start:Int, size:Int = 20, compelecationBlock: (CTADomainListInfo!) -> Void){
        
        CTANewPublishListRequest(userID: userID, start: start, size:size).startWithCompletionBlockWithSuccess { (response) -> Void in
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let publishArray = self.publishListResult(json)
                    compelecationBlock(CTADomainListInfo(result: true, modelArray: publishArray, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainListInfo(result: false, errorType: CTAPublishListError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func hotPublishList(userID:String, start:Int, size:Int = 20, compelecationBlock: (CTADomainListInfo!) -> Void){
        
        CTAHotPublishListRequest(userID: userID, start: start, size:size).startWithCompletionBlockWithSuccess { (response) -> Void in
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let publishArray = self.publishListResult(json)
                    compelecationBlock(CTADomainListInfo(result: true, modelArray: publishArray, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainListInfo(result: false, errorType: CTAPublishListError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func setPublishHot(publishID:String, compelecationBlock: (CTADomainInfo!) -> Void){
        CTASetHotPublishRequest(publishID: publishID).startWithCompletionBlockWithSuccess { (response) in
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAPublishHotError(rawValue: resultIndex)!))
                }
            case .Failure(_):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func publishListResult(json:JSON) -> Array<CTAPublishModel>{
        let listArray = json[key(.List)].array;
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
    
    func likePublish(userID:String, publishID:String, compelecationBlock: (CTADomainInfo!) -> Void){
        
        CTALikePublishRequest(userID: userID, publishID: publishID).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAUserPublishError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func unLikePublish(userID:String, publishID:String, compelecationBlock: (CTADomainInfo!) -> Void){
        
        CTAUnLikePublishRequest(userID: userID, publishID: publishID).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAUserPublishError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func rebuildPublish(userID:String, publishID:String, compelecationBlock: (CTADomainInfo!) -> Void){
        
        CTARebuildPublishRequest(userID: userID, publishID: publishID).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAUserPublishError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func sharePublish(userID:String, publishID:String, sharePlatform:Int,compelecationBlock: (CTADomainInfo?) -> Void){
        
        CTASharePublishRequest(userID: userID, publishID: publishID, sharePlatform:sharePlatform).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAUserPublishError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func reportPublish(userID:String, publishID:String, reportType:Int, reportMessage:String, compelecationBlock: (CTADomainInfo?) -> Void){
        CTAReportPublishRequest(userID: userID, publishID: publishID, reportType: reportType, reportMessage: reportMessage).startWithCompletionBlockWithSuccess { (response) -> Void in
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAUserPublishError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func publishDetai(userID:String, publishID:String, compelecationBlock:(CTADomainInfo?) -> Void){
        CTAPublishDetailRequest(userID: userID, publishID: publishID).startWithCompletionBlockWithSuccess { (response) in
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let publishModel = CTAPublishModel.generateFrom(json);
                    compelecationBlock(CTADomainInfo(result: true, baseModel: publishModel, successType: resultIndex))
                } else {
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAPublishError(rawValue: resultIndex)!))
                }
            case .Failure(_):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func publishLikeUserList(userID:String, publishID:String, start:Int, size:Int = 20, compelecationBlock: (CTADomainListInfo!) -> Void){
        CTAPublishLikeUserListRequest(userID: userID, publishID: publishID, start: start, size: size).startWithCompletionBlockWithSuccess { (response) in
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result{
                    let listArray = json[key(.List)].array;
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
            case .Failure(_):
                compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
}