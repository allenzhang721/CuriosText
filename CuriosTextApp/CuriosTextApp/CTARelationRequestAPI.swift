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
        return CTARequestUrl.FollowUser.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)       : userID,
            key(.RelationUserID)    : relationUserID
        ];
        return self.getParameterString(dic, errorMessage: "CTAFollowUserRequest");
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
        return CTARequestUrl.UnFollowUser.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)       : userID,
            key(.RelationUserID)    : relationUserID
        ];
        return self.getParameterString(dic, errorMessage: "CTAUnFollowUserRequest");
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
        return CTARequestUrl.BlockUser.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)       : userID,
            key(.RelationUserID)    : relationUserID
        ];
        return self.getParameterString(dic, errorMessage: "CTABlockUserRequest");
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
        return CTARequestUrl.UnBlockUser.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)       : userID,
            key(.RelationUserID)    : relationUserID
        ];
        return self.getParameterString(dic, errorMessage: "CTAUnBlockUserRequest");
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
        return CTARequestUrl.UserFollowList.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)  : userID,
            key(.BeUserID): beUserID,
            key(.Start): start,
            key(.Size): size
        ];
        return self.getParameterString(dic, errorMessage: "CTAUserFollowListRequest");
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
        return CTARequestUrl.UserBeFollowList.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)  : userID,
            key(.BeUserID): beUserID,
            key(.Start): start,
            key(.Size): size
        ];
        return self.getParameterString(dic, errorMessage: "CTAUserBeFollowListRequest");
    }
}

