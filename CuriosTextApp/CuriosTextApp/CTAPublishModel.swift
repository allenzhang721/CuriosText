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
    let userModel:CTAUserModel;
    let relationType:Int;
    
    init(publishID:String, title:String, publishDesc:String, publishIconURL:String, previewIconURL:String, publishURL:String, userID:String, nikeName:String, userDesc:String, userIconURL:String, sex:Int, relationType:Int) {
        self.publishID      = publishID;
        self.title          = title;
        self.publishDesc    = publishDesc;
        self.publishIconURL = publishIconURL;
        self.previewIconURL = previewIconURL;
        self.publishURL     = publishURL;
        self.userModel      = CTAUserModel.init(userID: userID, nikeName: nikeName, userDesc: userDesc, userIconURL: userIconURL, sex: sex)
        self.relationType   = relationType;
    }
    
    static func generateFrom(json: JSON) -> CTAPublishModel {
        
        let publishID:String      = json[key(.PublishID)].string ?? "";
        let title:String          = json[key(.Title)].string ?? "";
        let publishDesc:String    = json[key(.PublishDesc)].string ?? "";
        let publishIconURL:String = json[key(.PublishIconURL)].string ?? "";
        let previewIconURL:String = json[key(.PreviewIconURL)].string ?? "";
        let publishURL:String     = json[key(.PublishURL)].string ?? "";
        let userID:String         = json[key(.UserID)].string ?? "";
        let nikeName:String       = json[key(.NikeName)].string ?? "";
        let userDesc:String       = json[key(.UserDesc)].string ?? "";
        let userIconURL:String    = json[key(.UserIconURL)].string ?? "";
        let sex:Int               = json[key(.Sex)].int ?? 0;
        let relationType:Int      = json[key(.RelationType)].int ?? 0;
        
        return CTAPublishModel.init(publishID: publishID, title: title, publishDesc: publishDesc, publishIconURL: publishIconURL, previewIconURL: previewIconURL, publishURL: publishURL, userID: userID, nikeName: nikeName, userDesc: userDesc, userIconURL: userIconURL, sex: sex, relationType: relationType)
    }
    
    func save() throws {
        
    }
}
