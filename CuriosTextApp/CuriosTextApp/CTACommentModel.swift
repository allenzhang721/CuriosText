//
//  CTACommentModel.swift
//  CuriosTextApp
//
//  Created by allen on 16/6/30.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation
import SwiftyJSON

final class CTACommentModel: CTABaseModel {
    
    let commentID:String;
    let userModel:CTAUserModel;
    let beCommentedNickName:String;
    let beCommentedUserID:String;
    let commentData:NSDate;
    let commentMessage:String;
    let publishID:String
    
    init(commentID:String, userID:String, nikeName:String, userDesc:String, userIconURL:String, sex:Int, beCommentedNickName:String, beCommentedUserID:String, commentData:String, commentMessage:String, publishID:String){
        self.commentID = commentID;
        self.userModel = CTAUserModel(userID: userID, nickName: nikeName, userDesc: userDesc, userIconURL: userIconURL, sex: sex)
        self.beCommentedUserID = beCommentedUserID;
        self.beCommentedNickName = beCommentedNickName;
        self.commentMessage = commentMessage
        self.publishID      = publishID
        if commentData == ""{
            self.commentData = NSDate()
        }else {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            if let date = formatter.dateFromString(commentData){
                self.commentData = date
            }else {
                self.commentData = NSDate()
            }
        }
    }
    
    static func generateFrom(json: JSON) -> CTACommentModel{
        
        let commentID:String           = json[key(.CommentID)].string ?? "";
        let userID:String              = json[key(.UserID)].string ?? "";
        let nickName:String            = json[key(.NickName)].string ?? "";
        let userDesc:String            = json[key(.UserDesc)].string ?? "";
        let userIconURL:String         = json[key(.UserIconURL)].string ?? "";
        let sex:Int                    = json[key(.Sex)].int ?? 0;
        let commentMessage:String      = json[key(.CommentMessage)].string ?? "";
        let beCommentedNikeName:String = json[key(.BeCommentedNikeName)].string ?? "";
        let beCommentedUserID:String   = json[key(.BeCommentedUserID)].string ?? "";
        let commentDate:String         = json[key(.CommentDate)].string ?? "";
        let publishID:String           = json[key(.PublishID)].string ?? "";
        
        return CTACommentModel(commentID: commentID, userID: userID, nikeName: nickName, userDesc: userDesc, userIconURL: userIconURL, sex: sex, beCommentedNickName: beCommentedNikeName, beCommentedUserID: beCommentedUserID, commentData: commentDate, commentMessage: commentMessage, publishID: publishID)
    }
    
    func save() throws {
        
    }
    
    func getData() -> [String: AnyObject]{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return [
            key(.CommentID):self.commentID,
            key(.UserID):self.userModel.userID,
            key(.NickName):self.userModel.nickName,
            key(.UserDesc):self.userModel.userDesc,
            key(.UserIconURL):self.userModel.userIconURL,
            key(.Sex):self.userModel.sex,
            key(.BeCommentedNikeName)  :self.beCommentedNickName,
            key(.BeCommentedUserID)  :self.beCommentedUserID,
            key(.CommentMessage)  :self.commentMessage,
            key(.CommentDate)  :formatter.stringFromDate(self.commentData),
            key(.PublishID)  :self.publishID
        ]
    }
}