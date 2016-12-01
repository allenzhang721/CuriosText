//
//  CTANoticeRequestAPI.swift
//  CuriosTextApp
//
//  Created by allen on 16/6/30.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation

class CTAUnreadNoticeCountRequest: CTABaseRequest{
    
    let userID:String;
    
    init(userID:String) {
        self.userID = userID
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.unReadNoticeCount.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.userID) : userID as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAUnreadNoticeCount");
    }
}

class CTANoticeListRequest: CTABaseRequest {
    
    let userID:String;
    let start:Int;
    let size:Int;
    
    init(userID:String, start:Int, size:Int) {
        self.userID = userID;
        self.start  = start;
        self.size   = size;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.noticeList.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)    : userID as AnyObject,
            key(.start)     : start as AnyObject,
            key(.size)      : size as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTANoticeList");
    }
}

class CTADeleteNoticeRequest: CTABaseRequest {
    let noticeID:String;
    
    init(noticeID:String) {
        self.noticeID = noticeID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.deleteNotice.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.noticeID)        : noticeID as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTADeleteNoticeRequest");
    }
}

class CTAClearNoticesRequest: CTABaseRequest {
    let userID:String;
    
    init(userID:String) {
        self.userID = userID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.clearNotices.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)        : userID as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAClearNoticesRequest");
    }
}

class CTASetNoticesReadedRequest: CTABaseRequest {
    let userID:String;
    
    init(userID:String) {
        self.userID = userID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.setNoticesReaded.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)        : userID as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTASetNoticesReadedRequest");
    }
}
