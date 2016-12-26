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
    
    func addPublishComment(_ userID:String, beUserID:String, publishID:String, commentMessage:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void){
        CTAAddCommentRequest(userID: userID, beUserID: beUserID, publishID: publishID, commentMessage: commentMessage).startWithCompletionBlockWithSuccess { (response) in
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let listArray = json[key(.list)].array;
                    if listArray != nil{
                        let listJson = listArray![0]
                        let commentModel = CTACommentModel.generateFrom(listJson)
                        compelecationBlock(CTADomainInfo(result: true, baseModel: commentModel, successType: resultIndex))
                    }else {
                       compelecationBlock(CTADomainInfo(result: false, errorType: CTAAddCommentError(rawValue: 9)!))
                    }
                }else {
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAAddCommentError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func deletePublishComment(_ commentID:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void){
        CTADeletePublishCommentRequest(commentID: commentID).startWithCompletionBlockWithSuccess { (response) in
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                }else {
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTADeleteCommentError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func publichCommentList(_ publishID:String, userID:String, start:Int, size:Int, compelecationBlock: @escaping (CTADomainListInfo!) -> Void){
        CTAPublishCommentListRequest(publishID: publishID, userID: userID, start: start, size: size).startWithCompletionBlockWithSuccess { (response) in
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let listArray = json[key(.list)].array;
                    var commentArray: Array<CTACommentModel> = [];
                    if listArray != nil{
                        for i in 0..<listArray!.count {
                            let listJson = listArray![i];
                            let commentModel = CTACommentModel.generateFrom(listJson)
                            commentArray.append(commentModel);
                        }
                    }
                    compelecationBlock(CTADomainListInfo(result: true, modelArray: commentArray, successType: resultIndex))
                }else {
                    compelecationBlock(CTADomainListInfo(result: false, errorType: CTAPublishError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
}
