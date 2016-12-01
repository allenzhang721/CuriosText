//
//  CTAPublishModel.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/18.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation
import SwiftyJSON

final class CTAPublishModel: CTABaseModel{
    
    let publishID:String;
    let title:String;
    let publishDesc:String;
    let publishIconURL:String;
    let previewIconURL:String;
    let publishURL:String;
    let publishDate:Date;
    let userModel:CTAViewUserModel;
    var shareCount:Int;
    var rebuildCount:Int;
    var likeCount:Int;
    var commentCount:Int;
    var likeStatus:Int = 0;
    
    init(publishID:String, title:String, publishDesc:String, publishIconURL:String, previewIconURL:String, publishURL:String, publishDate:String, userID:String, nickName:String, userDesc:String, userIconURL:String, sex:Int, relationType:Int, shareCount:Int, rebuildCount:Int, likeCount:Int, likeStatus:Int, commentCount:Int) {
        self.publishID      = publishID;
        self.title          = title;
        self.publishDesc    = publishDesc;
        self.publishIconURL = publishIconURL;
        self.previewIconURL = previewIconURL;
        self.publishURL     = publishURL;
        if publishDate == ""{
            self.publishDate = Date()
        }else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            if let date = formatter.date(from: publishDate){
                self.publishDate = date
            }else {
                self.publishDate = Date()
            }
        }
        
        self.userModel      = CTAViewUserModel(userID: userID, nickName: nickName, userDesc: userDesc, userIconURL: userIconURL, sex: sex, relationType: relationType)
        self.shareCount     = shareCount;
        self.rebuildCount   = rebuildCount;
        self.likeCount      = likeCount;
        self.likeStatus     = likeStatus;
        self.commentCount   = commentCount;
    }
    
    static func generateFrom(_ json: JSON) -> CTAPublishModel {
        
        let publishID:String      = json[key(.publishID)].string ?? "";
        let title:String          = json[key(.title)].string ?? "";
        let publishDesc:String    = json[key(.publishDesc)].string ?? "";
        let publishIconURL:String = json[key(.publishIconURL)].string ?? "";
        let previewIconURL:String = json[key(.previewIconURL)].string ?? "";
        let publishURL:String     = json[key(.publishURL)].string ?? "";
        let publishDate:String    = json[key(.publishDate)].string ?? "";
        let userID:String         = json[key(.userID)].string ?? "";
        let nickName:String       = json[key(.nickName)].string ?? "";
        let userDesc:String       = json[key(.userDesc)].string ?? "";
        let userIconURL:String    = json[key(.userIconURL)].string ?? "";
        let sex:Int               = json[key(.sex)].int ?? 0;
        let relationType:Int      = json[key(.relationType)].int ?? 0;
        let shareCount:Int        = json[key(.shareCount)].int ?? 0;
        let rebuildCount:Int      = json[key(.rebuildCount)].int ?? 0;
        let likeCount:Int         = json[key(.likeCount)].int ?? 0;
        let likeStatus:Int        = json[key(.likeStatus)].int ?? 0;
        let commentCount:Int      = json[key(.commentCount)].int ?? 0;
        
        return CTAPublishModel.init(publishID: publishID, title: title, publishDesc: publishDesc, publishIconURL: publishIconURL, previewIconURL: previewIconURL, publishURL: publishURL, publishDate: publishDate, userID: userID, nickName: nickName, userDesc: userDesc, userIconURL: userIconURL, sex: sex, relationType: relationType, shareCount: shareCount, rebuildCount: rebuildCount, likeCount: likeCount, likeStatus: likeStatus, commentCount: commentCount)
    }
    
    func save() throws {
        
    }
    
    func getData() -> [String: Any]{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return [
            key(.publishID)  :self.publishID as AnyObject,
            key(.title):self.title as AnyObject,
            key(.publishDesc):self.publishDesc as AnyObject,
            key(.publishIconURL):self.publishIconURL as AnyObject,
            key(.previewIconURL):self.previewIconURL as AnyObject,
            key(.publishURL):self.publishURL as AnyObject,
            key(.userID):self.userModel.userID as AnyObject,
            key(.nickName):self.userModel.nickName as AnyObject,
            key(.userDesc):self.userModel.userDesc as AnyObject,
            key(.userIconURL):self.userModel.userIconURL as AnyObject,
            key(.sex):self.userModel.sex as AnyObject,
            key(.relationType):self.userModel.relationType as AnyObject,
            key(.shareCount):self.shareCount as AnyObject,
            key(.rebuildCount):self.rebuildCount as AnyObject,
            key(.likeCount):self.likeCount as AnyObject,
            key(.commentCount):self.commentCount as AnyObject,
            key(.likeStatus):self.likeStatus as AnyObject,
            key(.publishDate):formatter.string(from: self.publishDate)
        ]
    }
}
