//
//  CTANoticeModel.swift
//  CuriosTextApp
//
//  Created by allen on 16/6/30.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation
import SwiftyJSON

final class CTANoticeModel: CTABaseModel {
    
    let noticeID:String;
    let userModel:CTAUserModel;
    let publishID:String;
    let publishIconURL:String;
    let previewIconURL:String;
    let noticeMessage:String;
    let noticeDate:NSDate;
    let noticeReaded:Int;
    let noticeType:Int;
    let noticeTypeID:Int
    
    init(noticeID:String, userID:String, nikeName:String, userDesc:String, userIconURL:String, sex:Int, noticeDate:String, noticeMessage:String, noticeReaded:Int, noticeType:Int, noticeTypeID:Int, publishID:String, publishIconURL:String, previewIconURL:String){
        self.noticeID       = noticeID;
        self.userModel      = CTAUserModel(userID: userID, nickName: nikeName, userDesc: userDesc, userIconURL: userIconURL, sex: sex)
        self.noticeMessage  = noticeMessage
        self.noticeReaded   = noticeReaded;
        self.noticeType     = noticeType;
        self.noticeTypeID   = noticeTypeID;
        self.publishID      = publishID;
        self.publishIconURL = publishIconURL;
        self.previewIconURL = previewIconURL;
        if noticeDate == ""{
            self.noticeDate = NSDate()
        }else {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            if let date = formatter.dateFromString(noticeDate){
                self.noticeDate = date
            }else {
                self.noticeDate = NSDate()
            }
        }
    }
    
    static func generateFrom(json: JSON) -> CTANoticeModel{
        
        let noticeID:String            = json[key(.NoticeID)].string ?? "";
        let userID:String              = json[key(.UserID)].string ?? "";
        let nickName:String            = json[key(.NickName)].string ?? "";
        let userDesc:String            = json[key(.UserDesc)].string ?? "";
        let userIconURL:String         = json[key(.UserIconURL)].string ?? "";
        let sex:Int                    = json[key(.Sex)].int ?? 0;
        let noticeMessage:String       = json[key(.NoticeMessage)].string ?? "";
        let noticeDate:String          = json[key(.NoticeDate)].string ?? "";
        let noticeReaded:Int           = json[key(.NoticeReaded)].int ?? 0;
        let noticeType:Int             = json[key(.NoticeType)].int ?? 0;
        let noticeTypeID:Int           = json[key(.NoticeTypeID)].int ?? 0;
        let publishID:String           = json[key(.PublishID)].string ?? "";
        let publishIconURL:String      = json[key(.PublishIconURL)].string ?? "";
        let previewIconURL:String      = json[key(.PreviewIconURL)].string ?? "";
        return CTANoticeModel(noticeID: noticeID, userID: userID, nikeName: nickName, userDesc: userDesc, userIconURL: userIconURL, sex: sex, noticeDate: noticeDate, noticeMessage: noticeMessage, noticeReaded: noticeReaded, noticeType: noticeType, noticeTypeID: noticeTypeID, publishID: publishID, publishIconURL: publishIconURL, previewIconURL: previewIconURL)
    }
    
    func save() throws {
        
    }
    
    func getData() -> [String: AnyObject]{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return [
            key(.NoticeID):self.noticeID,
            key(.UserID):self.userModel.userID,
            key(.NickName):self.userModel.nickName,
            key(.UserDesc):self.userModel.userDesc,
            key(.UserIconURL):self.userModel.userIconURL,
            key(.Sex):self.userModel.sex,
            key(.NoticeMessage)  :self.noticeMessage,
            key(.NoticeReaded)  :self.noticeReaded,
            key(.NoticeType)  :self.noticeType,
            key(.NoticeTypeID)  :self.noticeTypeID,
            key(.NoticeDate)  :formatter.stringFromDate(self.noticeDate),
            key(.PublishID)  :self.publishID,
            key(.PublishIconURL)  :self.publishIconURL,
            key(.PreviewIconURL)  :self.previewIconURL
        ]
    }

}