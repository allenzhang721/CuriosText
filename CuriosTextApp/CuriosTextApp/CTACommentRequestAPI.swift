//
//  CTACommentRequestAPI.swift
//  CuriosTextApp
//
//  Created by allen on 16/6/30.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation

class CTAAddCommentRequest: CTABaseRequest {
    
    let userID:String;
    let beUserID:String;
    let publishID:String;
    let commentMessage:String;
    
    init(userID:String, beUserID:String, publishID:String, commentMessage:String) {
        self.userID         = userID;
        self.beUserID       = beUserID;
        self.publishID      = publishID;
        self.commentMessage = commentMessage;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.addPublishComment.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)        : userID as AnyObject,
            key(.beUserID)      : beUserID as AnyObject,
            key(.publishID)     : publishID as AnyObject,
            key(.commentMessage): commentMessage as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAAddCommentRequest");
    }
}

class CTADeletePublishCommentRequest: CTABaseRequest {
    
    let commentID:String;
    
    init(commentID:String) {
        self.commentID = commentID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.deletePublishComment.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.commentID)        : commentID as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTADeletePublishComment");
    }
}

class CTAPublishCommentListRequest: CTABaseRequest {

    let publishID:String;
    let userID:String;
    let start:Int;
    let size:Int;
    
    init(publishID:String, userID:String, start:Int, size:Int) {
        self.publishID = publishID;
        self.userID    = userID;
        self.start     = start;
        self.size      = size;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.publishCommentList.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.publishID)    : publishID as AnyObject,
            key(.userID)       : userID as AnyObject,
            key(.start)        : start as AnyObject,
            key(.size)         : size as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAPublishCommentList");
    }
}
