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
    let userModel:CTAViewUserModel;
    let publishID:String;
    let publishIconURL:String;
    let previewIconURL:String;
    let noticeMessage:String;
    let noticeDate:Date;
    let noticeReaded:Int;
    let noticeType:Int;  // 0 follow   1  like    2 comment
    let noticeTypeID:Int
    
    init(noticeID:String, userID:String, nikeName:String, userDesc:String, userIconURL:String, sex:Int, relationType:Int, noticeDate:String, noticeMessage:String, noticeReaded:Int, noticeType:Int, noticeTypeID:Int, publishID:String, publishIconURL:String, previewIconURL:String){
        self.noticeID       = noticeID;
        self.userModel      = CTAViewUserModel(userID: userID, nickName: nikeName, userDesc: userDesc, userIconURL: userIconURL, sex: sex, relationType: relationType)
        self.noticeMessage  = noticeMessage
        self.noticeReaded   = noticeReaded;
        self.noticeType     = noticeType;
        self.noticeTypeID   = noticeTypeID;
        self.publishID      = publishID;
        self.publishIconURL = publishIconURL;
        self.previewIconURL = previewIconURL;
        if noticeDate == ""{
            self.noticeDate = Date()
        }else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            if let date = formatter.date(from: noticeDate){
                self.noticeDate = date
            }else {
                self.noticeDate = Date()
            }
        }
    }
    
    static func generateFrom(_ json: JSON) -> CTANoticeModel{
        
        let noticeID:String            = json[key(.noticeID)].string ?? "";
        let userID:String              = json[key(.userID)].string ?? "";
        let nickName:String            = json[key(.nickName)].string ?? "";
        let userDesc:String            = json[key(.userDesc)].string ?? "";
        let userIconURL:String         = json[key(.userIconURL)].string ?? "";
        let sex:Int                    = json[key(.sex)].int ?? 0;
        let relationType:Int           = json[key(.relationType)].int ?? 0;
        let noticeMessage:String       = json[key(.noticeMessage)].string ?? "";
        let noticeDate:String          = json[key(.noticeDate)].string ?? "";
        let noticeReaded:Int           = json[key(.noticeReaded)].int ?? 0;
        let noticeType:Int             = json[key(.noticeType)].int ?? 0;
        let noticeTypeID:Int           = json[key(.noticeTypeID)].int ?? 0;
        let publishID:String           = json[key(.publishID)].string ?? "";
        let publishIconURL:String      = json[key(.publishIconURL)].string ?? "";
        let previewIconURL:String      = json[key(.previewIconURL)].string ?? "";
        return CTANoticeModel(noticeID: noticeID, userID: userID, nikeName: nickName, userDesc: userDesc, userIconURL: userIconURL, sex: sex, relationType: relationType, noticeDate: noticeDate, noticeMessage: noticeMessage, noticeReaded: noticeReaded, noticeType: noticeType, noticeTypeID: noticeTypeID, publishID: publishID, publishIconURL: publishIconURL, previewIconURL: previewIconURL)
    }
    
    func save() throws {
        
    }
    
    func getData() -> [String: Any]{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return [
            key(.noticeID):self.noticeID as AnyObject,
            key(.userID):self.userModel.userID as AnyObject,
            key(.nickName):self.userModel.nickName as AnyObject,
            key(.userDesc):self.userModel.userDesc as AnyObject,
            key(.userIconURL):self.userModel.userIconURL as AnyObject,
            key(.sex):self.userModel.sex as AnyObject,
            key(.noticeMessage)  :self.noticeMessage as AnyObject,
            key(.noticeReaded)  :self.noticeReaded as AnyObject,
            key(.noticeType)  :self.noticeType as AnyObject,
            key(.noticeTypeID)  :self.noticeTypeID as AnyObject,
            key(.noticeDate)  :formatter.string(from: self.noticeDate) as AnyObject,
            key(.publishID)  :self.publishID as AnyObject,
            key(.publishIconURL)  :self.publishIconURL as AnyObject,
            key(.previewIconURL)  :self.previewIconURL
        ]
    }

}
