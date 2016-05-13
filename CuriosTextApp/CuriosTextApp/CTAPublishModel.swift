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
    let publishDate:NSDate;
    let userModel:CTAUserModel;
    let relationType:Int;
    let shareCount:Int;
    let rebuildCount:Int;
    let likeCount:Int;
    var likeStatus:Int = 0;
    
    init(publishID:String, title:String, publishDesc:String, publishIconURL:String, previewIconURL:String, publishURL:String, publishDate:String, userID:String, nickName:String, userDesc:String, userIconURL:String, sex:Int, relationType:Int, shareCount:Int, rebuildCount:Int, likeCount:Int, likeStatus:Int) {
        self.publishID      = publishID;
        self.title          = title;
        self.publishDesc    = publishDesc;
        self.publishIconURL = publishIconURL;
        self.previewIconURL = previewIconURL;
        self.publishURL     = publishURL;
        if publishDate == ""{
            self.publishDate = NSDate()
        }else {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            if let date = formatter.dateFromString(publishDate){
                self.publishDate = date
            }else {
                self.publishDate = NSDate()
            }
        }
        
        self.userModel      = CTAUserModel.init(userID: userID, nickName: nickName, userDesc: userDesc, userIconURL: userIconURL, sex: sex)
        self.relationType   = relationType;
        self.shareCount     = shareCount;
        self.rebuildCount   = rebuildCount;
        self.likeCount      = likeCount;
        self.likeStatus     = likeStatus;
    }
    
    static func generateFrom(json: JSON) -> CTAPublishModel {
        
        let publishID:String      = json[key(.PublishID)].string ?? "";
        let title:String          = json[key(.Title)].string ?? "";
        let publishDesc:String    = json[key(.PublishDesc)].string ?? "";
        let publishIconURL:String = json[key(.PublishIconURL)].string ?? "";
        let previewIconURL:String = json[key(.PreviewIconURL)].string ?? "";
        let publishURL:String     = json[key(.PublishURL)].string ?? "";
        let publishDate:String    = json[key(.PublishDate)].string ?? "";
        let userID:String         = json[key(.UserID)].string ?? "";
        let nickName:String       = json[key(.NickName)].string ?? "";
        let userDesc:String       = json[key(.UserDesc)].string ?? "";
        let userIconURL:String    = json[key(.UserIconURL)].string ?? "";
        let sex:Int               = json[key(.Sex)].int ?? 0;
        let relationType:Int      = json[key(.RelationType)].int ?? 0;
        let shareCount:Int        = json[key(.ShareCount)].int ?? 0;
        let rebuildCount:Int      = json[key(.RebuildCount)].int ?? 0;
        let likeCount:Int         = json[key(.LikeCount)].int ?? 0;
        let likeStatus:Int        = json[key(.LikeStatus)].int ?? 0;
        
        return CTAPublishModel.init(publishID: publishID, title: title, publishDesc: publishDesc, publishIconURL: publishIconURL, previewIconURL: previewIconURL, publishURL: publishURL, publishDate: publishDate, userID: userID, nickName: nickName, userDesc: userDesc, userIconURL: userIconURL, sex: sex, relationType: relationType, shareCount: shareCount, rebuildCount: rebuildCount, likeCount: likeCount, likeStatus: likeStatus)
    }
    
    func save() throws {
        
    }
    
    func getData() -> [String: AnyObject]{
        return [
            key(.PublishID)  :self.publishID,
            key(.Title):self.title,
            key(.PublishDesc):self.publishDesc,
            key(.PublishIconURL):self.publishIconURL,
            key(.PreviewIconURL):self.previewIconURL,
            key(.PublishURL):self.publishURL,
            key(.UserID):self.userModel.userID,
            key(.NickName):self.userModel.nickName,
            key(.UserDesc):self.userModel.userDesc,
            key(.UserIconURL):self.userModel.userIconURL,
            key(.Sex):self.userModel.sex,
            key(.RelationType):self.relationType,
            key(.ShareCount):self.shareCount,
            key(.RebuildCount):self.rebuildCount,
            key(.LikeCount):self.likeCount,
            key(.LikeStatus):self.likeStatus
        ]
    }
}
