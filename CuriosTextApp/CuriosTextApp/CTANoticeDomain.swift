//
//  CTANoticeDomain.swift
//  CuriosTextApp
//
//  Created by allen on 16/6/30.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation
import SwiftyJSON

class CTANoticeDomain: CTABaseDomain {
    
    static var _instance:CTANoticeDomain?;
    
    static func getInstance() -> CTANoticeDomain{
        if _instance == nil{
            _instance = CTANoticeDomain();
        }
        return _instance!
    }
    
    func unReadNoticeCount(_ userID:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void){
        CTAUnreadNoticeCountRequest(userID: userID).startWithCompletionBlockWithSuccess { (response) in
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let count = json[key(.noticeCount)].int ?? 0;
                    compelecationBlock(CTADomainInfo(result: true, successType: count))
                }else {
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func noticeList(_ userID:String, start:Int, size:Int, compelecationBlock: @escaping (CTADomainListInfo!) -> Void){
        CTANoticeListRequest(userID: userID, start: start, size: size).startWithCompletionBlockWithSuccess { (response) in
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let listArray = json[key(.list)].array;
                    var noticeArray: Array<CTANoticeModel> = [];
                    if listArray != nil{
                        for i in 0..<listArray!.count {
                            let listJson = listArray![i];
                            let noticeModel = CTANoticeModel.generateFrom(listJson)
                            noticeArray.append(noticeModel);
                        }
                    }
                    compelecationBlock(CTADomainListInfo(result: true, modelArray: noticeArray, successType: resultIndex))
                }else {
                    compelecationBlock(CTADomainListInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func deleteNotice(_ noticeID:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void){
        CTADeleteNoticeRequest(noticeID: noticeID).startWithCompletionBlockWithSuccess { (response) in
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                }else {
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestNoticeError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func clearNotices(_ userID:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void){
        CTAClearNoticesRequest(userID: userID).startWithCompletionBlockWithSuccess { (response) in
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                }else {
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }

        }
    }
    
    func setNoticesReaded(_ userID:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void){
        CTASetNoticesReadedRequest(userID: userID).startWithCompletionBlockWithSuccess { (response) in
            switch response.result{
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                }else {
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
}
