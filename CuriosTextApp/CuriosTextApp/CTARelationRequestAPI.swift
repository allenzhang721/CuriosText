//
//  CTARelationRequestAPI.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/9.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation

class CTAFollowUserRequest: CTABaseRequest {
    
    let userID:String;
    let relationUserID:String;
    
    init(userID:String, relationUserID:String) {
        self.userID         = userID;
        self.relationUserID = relationUserID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.followUser.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)       : userID as AnyObject,
            key(.relationUserID)    : relationUserID as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAFollowUserRequest");
    }
}

class CTAUnFollowUserRequest: CTABaseRequest {
    
    let userID:String;
    let relationUserID:String;
    
    init(userID:String, relationUserID:String) {
        self.userID         = userID;
        self.relationUserID = relationUserID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.unFollowUser.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)       : userID as AnyObject,
            key(.relationUserID)    : relationUserID as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAUnFollowUserRequest");
    }
}


class CTABlockUserRequest: CTABaseRequest {
    
    let userID:String;
    let relationUserID:String;
    
    init(userID:String, relationUserID:String) {
        self.userID         = userID;
        self.relationUserID = relationUserID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.blockUser.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)       : userID as AnyObject,
            key(.relationUserID)    : relationUserID as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTABlockUserRequest");
    }
}

class CTAUnBlockUserRequest: CTABaseRequest {
    
    let userID:String;
    let relationUserID:String;
    
    init(userID:String, relationUserID:String) {
        self.userID         = userID;
        self.relationUserID = relationUserID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.unBlockUser.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)       : userID as AnyObject,
            key(.relationUserID)    : relationUserID as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAUnBlockUserRequest");
    }
}

class CTAUserFollowListRequest: CTABaseRequest {
    
    let userID:String;
    let beUserID:String;
    let start:Int;
    let size:Int;
    
    init(userID:String, beUserID:String, start:Int, size:Int) {
        self.userID   = userID;
        self.beUserID = beUserID;
        self.start    = start;
        self.size     = size;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.userFollowList.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)  : userID as AnyObject,
            key(.beUserID): beUserID as AnyObject,
            key(.start): start as AnyObject,
            key(.size): size as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAUserFollowListRequest");
    }
}

class CTAUserBeFollowListRequest: CTABaseRequest {
    
    let userID:String;
    let beUserID:String;
    let start:Int;
    let size:Int;
    
    init(userID:String, beUserID:String, start:Int, size:Int) {
        self.userID   = userID;
        self.beUserID = beUserID;
        self.start    = start;
        self.size     = size;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.userBeFollowList.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)  : userID as AnyObject,
            key(.beUserID): beUserID as AnyObject,
            key(.start): start as AnyObject,
            key(.size): size as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAUserBeFollowListRequest");
    }
}

