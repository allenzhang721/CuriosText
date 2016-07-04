//
//  CTACommentDomain.swift
//  CuriosTextApp
//
//  Created by allen on 16/6/30.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation
import SwiftyJSON

class CTACommentDomain: CTABaseDomain {
    
    static var _instance:CTACommentDomain?;
    
    static func getInstance() -> CTACommentDomain{
        if _instance == nil{
            _instance = CTACommentDomain();
        }
        return _instance!
    }
    
    func addPublishComment(userID:String, beUserID:String, publishID:String, commentMessage:String, compelecationBlock: (CTADomainInfo!) -> Void){
        CTAAddCommentRequest(userID: userID, beUserID: beUserID, publishID: publishID, commentMessage: commentMessage).startWithCompletionBlockWithSuccess { (response) in
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let listArray = json[key(.List)].array;
                    if listArray != nil{
                        let listJson = listArray![0]
                        let userModel = CTAViewUserModel.generateFrom(listJson)
                        compelecationBlock(CTADomainInfo(result: true, baseModel: userModel, successType: resultIndex))
                    }else {
                       compelecationBlock(CTADomainInfo(result: false, errorType: CTAAddCommentError(rawValue: 9)!))
                    }
                }else {
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAAddCommentError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func deletePublishComment(commentID:String, compelecationBlock: (CTADomainInfo!) -> Void){
        CTADeletePublishCommentRequest(commentID: commentID).startWithCompletionBlockWithSuccess { (response) in
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                }else {
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTADeleteCommentError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func publichCommentList(publishID:String, start:Int, size:Int, compelecationBlock: (CTADomainListInfo!) -> Void){
        CTAPublishCommentListRequest(publishID: publishID, start: start, size: size).startWithCompletionBlockWithSuccess { (response) in
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let listArray = json[key(.List)].array;
                    var commentArray: Array<CTACommentModel> = [];
                    if listArray != nil{
                        for i in 0..<listArray!.count {
                            let listJson = listArray![i];
                            let userModel = CTACommentModel.generateFrom(listJson)
                            commentArray.append(userModel);
                        }
                    }
                    compelecationBlock(CTADomainListInfo(result: true, modelArray: commentArray, successType: resultIndex))
                }else {
                    compelecationBlock(CTADomainListInfo(result: false, errorType: CTAPublishError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
}