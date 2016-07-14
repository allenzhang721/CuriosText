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
    
    func unReadNoticeCount(userID:String, compelecationBlock: (CTADomainInfo!) -> Void){
        CTAUnreadNoticeCountRequest(userID: userID).startWithCompletionBlockWithSuccess { (response) in
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let count = json[key(.NoticeCount)].int ?? 0;
                    compelecationBlock(CTADomainInfo(result: true, successType: count))
                }else {
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func noticeList(userID:String, start:Int, size:Int, compelecationBlock: (CTADomainListInfo!) -> Void){
        CTANoticeListRequest(userID: userID, start: start, size: size).startWithCompletionBlockWithSuccess { (response) in
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let listArray = json[key(.List)].array;
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
            case .Failure( _):
                compelecationBlock(CTADomainListInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func deleteNotice(noticeID:String, compelecationBlock: (CTADomainInfo!) -> Void){
        CTADeleteNoticeRequest(noticeID: noticeID).startWithCompletionBlockWithSuccess { (response) in
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                }else {
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestNoticeError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func clearNotices(userID:String, compelecationBlock: (CTADomainInfo!) -> Void){
        CTAClearNoticesRequest(userID: userID).startWithCompletionBlockWithSuccess { (response) in
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                }else {
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }

        }
    }
}