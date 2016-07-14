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
        return CTARequestUrl.UnReadNoticeCount.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID) : userID
        ];
        return self.getParameterString(dic, errorMessage: "CTAUnreadNoticeCount");
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
        return CTARequestUrl.NoticeList.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)    : userID,
            key(.Start)     : start,
            key(.Size)      : size
        ];
        return self.getParameterString(dic, errorMessage: "CTANoticeList");
    }
}

class CTADeleteNoticeRequest: CTABaseRequest {
    let noticeID:String;
    
    init(noticeID:String) {
        self.noticeID = noticeID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.DeleteNotice.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.NoticeID)        : noticeID
        ];
        return self.getParameterString(dic, errorMessage: "CTADeleteNoticeRequest");
    }
}

class CTAClearNoticesRequest: CTABaseRequest {
    let userID:String;
    
    init(userID:String) {
        self.userID = userID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.ClearNotices.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)        : userID
        ];
        return self.getParameterString(dic, errorMessage: "CTAClearNoticesRequest");
    }
}