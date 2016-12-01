//
//  CTAPublishRequestAPI.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/9.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation

class CTACreatePublishRequest: CTABaseRequest {
    
    let publishID:String;
    let userID:String;
    let title:String;
    let publishDesc:String;
    let publishIconURL:String;
    let previewIconURL:String;
    let publishURL:String;
    
    init(publishID:String, userID:String, title:String, publishDesc:String, publishIconURL:String, previewIconURL:String, publishURL:String) {
        self.publishID      = publishID;
        self.userID         = userID;
        self.title          = title;
        self.publishDesc    = publishDesc;
        self.publishIconURL = publishIconURL;
        self.previewIconURL = previewIconURL;
        self.publishURL     = publishURL;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.createPublish.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.publishID)     : publishID as AnyObject,
            key(.userID)        : userID as AnyObject,
            key(.title)         : title as AnyObject,
            key(.publishDesc)   : publishDesc as AnyObject,
            key(.publishIconURL): publishIconURL as AnyObject,
            key(.previewIconURL): previewIconURL as AnyObject,
            key(.publishURL)    : publishURL as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTACreatePublishRequest");
    }
}

class CTADeletePublishRequest: CTABaseRequest {
    let userID:String;
    let publishID:String;
    
    init(publishID:String, userID:String) {
        self.publishID = publishID;
        self.userID    = userID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.deletePublish.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.publishID): publishID as AnyObject,
            key(.userID)   : userID as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTADeletePublishRequest");
    }
}

class CTAUserPublishListRequest: CTABaseRequest {
    let userID:String;
    let beUserID:String;
    let start:Int;
    let size:Int;
    
    init(userID:String, beUserID:String, start:Int, size:Int = 20) {
        self.userID   = userID;
        self.beUserID = beUserID
        self.start    = start;
        self.size     = size;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.userPublishList.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)  : userID as AnyObject,
            key(.beUserID): beUserID as AnyObject,
            key(.start)   : start as AnyObject,
            key(.size)    : size as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAUserPublishListRequest");
    }
}

class CTAUserLikePublishListRequest: CTABaseRequest {
    let userID:String;
    let beUserID:String;
    let start:Int;
    let size:Int;
    
    init(userID:String, beUserID:String, start:Int, size:Int = 20) {
        self.userID   = userID;
        self.beUserID = beUserID
        self.start    = start;
        self.size     = size;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.userLikePublishList.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)  : userID as AnyObject,
            key(.beUserID): beUserID as AnyObject,
            key(.start)   : start as AnyObject,
            key(.size)    : size as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAUserLikePublishListRequest");
    }
}

class CTAUserRebuildPublishListRequest: CTABaseRequest {
    let userID:String;
    let beUserID:String;
    let start:Int;
    let size:Int;
    
    init(userID:String, beUserID:String, start:Int, size:Int = 20) {
        self.userID   = userID;
        self.beUserID = beUserID
        self.start    = start;
        self.size     = size;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.userRebuildPublishList.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)  : userID as AnyObject,
            key(.beUserID): beUserID as AnyObject,
            key(.start)   : start as AnyObject,
            key(.size)    : size as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAUserRebuildPublishListRequest");
    }
}

class CTAUserFollowPublishListRequest: CTABaseRequest {
    let userID:String;
    let beUserID:String;
    let start:Int;
    let size:Int;
    
    init(userID:String, beUserID:String, start:Int, size:Int = 20) {
        self.userID   = userID;
        self.beUserID = beUserID
        self.start    = start;
        self.size     = size;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.userFollowPublishList.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)  : userID as AnyObject,
            key(.beUserID): beUserID as AnyObject,
            key(.start)   : start as AnyObject,
            key(.size)    : size as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAUserFollowPublishListRequest");
    }
}

class CTANewPublishListRequest: CTABaseRequest {
    let userID:String;
    let start:Int;
    let size:Int;
    
    init(userID:String, start:Int, size:Int = 20) {
        self.userID   = userID;
        self.start    = start;
        self.size     = size;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.newPubulishList.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)  : userID as AnyObject,
            key(.start)   : start as AnyObject,
            key(.size)    : size as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTANewPublishListRequest");
    }
}

class CTAHotPublishListRequest: CTABaseRequest {
    let userID:String;
    let start:Int;
    let size:Int;
    
    init(userID:String, start:Int, size:Int = 20) {
        self.userID   = userID;
        self.start    = start;
        self.size     = size;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.hotPublishList.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)  : userID as AnyObject,
            key(.start)   : start as AnyObject,
            key(.size)    : size as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAHotPublishListRequest");
    }
}

class CTASetHotPublishRequest: CTABaseRequest{
    let publishID:String;
    
    init(publishID:String) {
        self.publishID   = publishID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.setHotPublish.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.publishID)  : publishID as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTASetHotPublishRequest");
    }
}

class CTALikePublishRequest: CTABaseRequest {
    let userID:String;
    let publishID:String;
    
    init(userID:String, publishID:String) {
        self.userID    = userID;
        self.publishID = publishID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.likePublish.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)  : userID as AnyObject,
            key(.publishID)   : publishID as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTALikePublishRequest");
    }
}

class CTAUnLikePublishRequest: CTABaseRequest {
    let userID:String;
    let publishID:String;
    
    init(userID:String, publishID:String) {
        self.userID    = userID;
        self.publishID = publishID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.unLikePublish.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)  : userID as AnyObject,
            key(.publishID)   : publishID as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAUnLikePublishRequest");
    }
}

class CTARebuildPublishRequest: CTABaseRequest {
    let userID:String;
    let publishID:String;
    
    init(userID:String, publishID:String) {
        self.userID    = userID;
        self.publishID = publishID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.rebuildPublish.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)  : userID as AnyObject,
            key(.publishID)   : publishID as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTARebuildPublishRequest");
    }
}

class CTASharePublishRequest: CTABaseRequest {
    let userID:String;
    let publishID:String;
    let sharePlatform:Int;
    
    init(userID:String, publishID:String, sharePlatform:Int = 0) {
        self.userID        = userID;
        self.publishID     = publishID;
        self.sharePlatform = sharePlatform;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.sharePublish.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)       : userID as AnyObject,
            key(.publishID)    : publishID as AnyObject,
            key(.sharePlatform): sharePlatform as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTASharePublishRequest");
    }
}

class CTAReportPublishRequest: CTABaseRequest {
    let userID:String;
    let publishID:String;
    let reportType:Int;
    let reportMessage:String;
    
    init(userID:String, publishID:String, reportType:Int, reportMessage:String) {
        self.userID        = userID;
        self.publishID     = publishID;
        self.reportType    = reportType;
        self.reportMessage = reportMessage;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.reportPublish.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)       : userID as AnyObject,
            key(.publishID)    : publishID as AnyObject,
            key(.reportType)   : reportType as AnyObject,
            key(.reportMessage): reportMessage as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAReportPublishRequest");
    }
}

class CTAPublishDetailRequest: CTABaseRequest {
    let userID:String;
    let publishID:String;
    
    init(userID:String, publishID:String) {
        self.userID        = userID;
        self.publishID     = publishID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.publishDetail.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)       : userID as AnyObject,
            key(.publishID)    : publishID as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAPublishDetailRequest");
    }
}

class CTAPublishLikeUserListRequest: CTABaseRequest {
    let userID:String;
    let publishID:String;
    let start:Int;
    let size:Int;
    
    init(userID:String, publishID:String, start:Int, size:Int) {
        self.userID        = userID;
        self.publishID     = publishID;
        self.start         = start;
        self.size          = size;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.publishLikeUserList.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)       : userID as AnyObject,
            key(.publishID)    : publishID as AnyObject,
            key(.start)        : start as AnyObject,
            key(.size)         : size as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAPublishLikeUserList");
    }
}
