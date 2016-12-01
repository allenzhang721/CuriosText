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
    let userModel:CTAViewUserModel;
    var beCommentUserModel:CTAViewUserModel?;
    let commentData:Date;
    let commentMessage:String;
    let publishID:String
    
    init(commentID:String, userID:String, nickName:String, userDesc:String, userIconURL:String, sex:Int, relationType:Int, beCommentedNickName:String, beCommentedUserID:String, beCommentUserIconURL:String, beCommentUserDesc:String, beCommentSex:Int, commentData:String, commentMessage:String, publishID:String){
        self.commentID = commentID;
        self.userModel = CTAViewUserModel(userID: userID, nickName: nickName, userDesc: userDesc, userIconURL: userIconURL, sex: sex, relationType: relationType)
        if beCommentedUserID != "" {
            self.beCommentUserModel = CTAViewUserModel(userID: beCommentedUserID, nickName: beCommentedNickName, userDesc: beCommentUserDesc, userIconURL: beCommentUserIconURL, sex: beCommentSex, relationType: 0)
        }else {
            self.beCommentUserModel = nil
        }
        self.commentMessage = commentMessage
        self.publishID      = publishID
        if commentData == ""{
            self.commentData = Date()
        }else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            if let date = formatter.date(from: commentData){
                self.commentData = date
            }else {
                self.commentData = Date()
            }
        }
    }
    
    static func generateFrom(_ json: JSON) -> CTACommentModel{
        
        let commentID:String           = json[key(.commentID)].string ?? "";
        let userID:String              = json[key(.userID)].string ?? "";
        let nickName:String            = json[key(.nickName)].string ?? "";
        let userDesc:String            = json[key(.userDesc)].string ?? "";
        let userIconURL:String         = json[key(.userIconURL)].string ?? "";
        let sex:Int                    = json[key(.sex)].int ?? 0;
        let relationType:Int           = json[key(.relationType)].int ?? 0;
        let commentMessage:String      = json[key(.commentMessage)].string ?? "";
        let beCommentedNickName:String = json[key(.beCommentedNickName)].string ?? "";
        let beCommentedUserID:String   = json[key(.beCommentedUserID)].string ?? "";
        let beCommentedUserDesc:String = json[key(.beCommentUserDesc)].string ?? "";
        let beCommentedUserIconURL:String = json[key(.beCommentUserIconURL)].string ?? "";
        let beCommentedSex:Int      = json[key(.beCommentSex)].int ?? 0;
        let commentDate:String         = json[key(.commentDate)].string ?? "";
        let publishID:String           = json[key(.publishID)].string ?? "";
        
        return CTACommentModel(commentID: commentID, userID: userID, nickName: nickName, userDesc: userDesc, userIconURL: userIconURL, sex: sex, relationType: relationType, beCommentedNickName: beCommentedNickName, beCommentedUserID: beCommentedUserID, beCommentUserIconURL: beCommentedUserIconURL, beCommentUserDesc: beCommentedUserDesc, beCommentSex: beCommentedSex, commentData: commentDate, commentMessage: commentMessage, publishID: publishID)
    }
    
    func save() throws {
        
    }
    
    func getData() -> [String: Any]{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return [
            key(.commentID):self.commentID as AnyObject,
            key(.userID):self.userModel.userID as AnyObject,
            key(.nickName):self.userModel.nickName as AnyObject,
            key(.userDesc):self.userModel.userDesc as AnyObject,
            key(.userIconURL):self.userModel.userIconURL as AnyObject,
            key(.sex):self.userModel.sex as AnyObject,
            key(.beCommentedNickName)  : self.beCommentUserModel != nil ? self.beCommentUserModel!.nickName : "",
            key(.beCommentedUserID)  :self.beCommentUserModel != nil ? self.beCommentUserModel!.userID : "",
            key(.beCommentUserDesc)  :self.beCommentUserModel != nil ? self.beCommentUserModel!.userDesc : "",
            key(.beCommentUserIconURL)  :self.beCommentUserModel != nil ? self.beCommentUserModel!.userIconURL : "",
            key(.beCommentSex)  :self.beCommentUserModel != nil ? self.beCommentUserModel!.sex : "",
            key(.commentMessage)  :self.commentMessage,
            key(.commentDate)  :formatter.string(from: self.commentData),
            key(.publishID)  :self.publishID
        ]
    }
}
