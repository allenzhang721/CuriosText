//
//  CTAPublishRequestAPI.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/9.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation

class CTAPublishIDRequest: CTABaseRequest {
    
    override func requestUrl() -> String {
        return CTARequestUrl.GetPublishID.description;
    }
}

class CTACreatePublishRequest: CTABaseRequest {
    
    let userID:String;
    let title:String;
    let publishDesc:String;
    let publishIconURL:String;
    let previewIconURL:String;
    let publishURL:String;
    
    init(userID:String, title:String, desc:String, iconURL:String, previewURL:String, pulishURL:String) {
        self.userID         = userID;
        self.title          = title;
        self.publishDesc    = desc;
        self.publishIconURL = iconURL;
        self.previewIconURL = previewURL;
        self.publishURL     = pulishURL;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.CreatePublish.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)        : userID,
            key(.Title)         : title,
            key(.PublishDesc)   : publishDesc,
            key(.PublishIconURL): publishIconURL,
            key(.PreviewIconURL): previewIconURL,
            key(.PublishURL)    : publishURL
        ];
        return self.getParameterString(dic, errorMessage: "CTACreatePublishRequest");
    }
}

class CTADeletePublishRequest: CTABaseRequest {
    let publishID:String;
    
    init(publishID:String) {
        self.publishID = publishID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.DeletePublish.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.PublishID): publishID
        ];
        return self.getParameterString(dic, errorMessage: "CTADeletePublishRequest");
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
        return CTARequestUrl.UserPublishList.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)  : userID,
            key(.BeUserID): beUserID,
            key(.Start)   : start,
            key(.Size)    : size
        ];
        return self.getParameterString(dic, errorMessage: "CTAUserPublishListRequest");
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
        return CTARequestUrl.UserLikePublishList.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)  : userID,
            key(.BeUserID): beUserID,
            key(.Start)   : start,
            key(.Size)    : size
        ];
        return self.getParameterString(dic, errorMessage: "CTAUserLikePublishListRequest");
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
        return CTARequestUrl.UserRebuildPublishList.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)  : userID,
            key(.BeUserID): beUserID,
            key(.Start)   : start,
            key(.Size)    : size
        ];
        return self.getParameterString(dic, errorMessage: "CTAUserRebuildPublishListRequest");
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
        return CTARequestUrl.UserFollowPublishList.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)  : userID,
            key(.BeUserID): beUserID,
            key(.Start)   : start,
            key(.Size)    : size
        ];
        return self.getParameterString(dic, errorMessage: "CTAUserFollowPublishListRequest");
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
        return CTARequestUrl.NewPubulishList.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)  : userID,
            key(.Start)   : start,
            key(.Size)    : size
        ];
        return self.getParameterString(dic, errorMessage: "CTANewPublishListRequest");
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
        return CTARequestUrl.HotPublishList.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)  : userID,
            key(.Start)   : start,
            key(.Size)    : size
        ];
        return self.getParameterString(dic, errorMessage: "CTAHotPublishListRequest");
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
        return CTARequestUrl.LikePublish.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)  : userID,
            key(.PublishID)   : publishID
        ];
        return self.getParameterString(dic, errorMessage: "CTALikePublishRequest");
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
        return CTARequestUrl.UnLikePublish.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)  : userID,
            key(.PublishID)   : publishID
        ];
        return self.getParameterString(dic, errorMessage: "CTAUnLikePublishRequest");
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
        return CTARequestUrl.RebuildPublish.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)  : userID,
            key(.PublishID)   : publishID
        ];
        return self.getParameterString(dic, errorMessage: "CTARebuildPublishRequest");
    }
}

class CTASharePublishRequest: CTABaseRequest {
    let userID:String;
    let publishID:String;
    let sharePlatform:Int
    
    init(userID:String, publishID:String, sharePlatform:Int = 0) {
        self.userID        = userID;
        self.publishID     = publishID;
        self.sharePlatform = sharePlatform;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.SharePublish.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)       : userID,
            key(.PublishID)    : publishID,
            key(.SharePlatform): sharePlatform
        ];
        return self.getParameterString(dic, errorMessage: "CTASharePublishRequest");
    }
}