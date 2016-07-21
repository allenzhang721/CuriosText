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
        return CTARequestUrl.AddPublishComment.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)        : userID,
            key(.BeUserID)      : beUserID,
            key(.PublishID)     : publishID,
            key(.CommentMessage): commentMessage
        ];
        return self.getParameterString(dic, errorMessage: "CTAAddCommentRequest");
    }
}

class CTADeletePublishCommentRequest: CTABaseRequest {
    
    let commentID:String;
    
    init(commentID:String) {
        self.commentID = commentID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.DeletePublishComment.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.CommentID)        : commentID
        ];
        return self.getParameterString(dic, errorMessage: "CTADeletePublishComment");
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
        return CTARequestUrl.PublishCommentList.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.PublishID)    : publishID,
            key(.UserID)       : userID,
            key(.Start)        : start,
            key(.Size)         : size
        ];
        return self.getParameterString(dic, errorMessage: "CTAPublishCommentList");
    }
}