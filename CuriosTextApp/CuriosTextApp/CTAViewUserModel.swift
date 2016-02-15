//
//  CTAViewUserModel.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/15.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation
import SwiftyJSON

final class CTAViewUserModel: CTABaseModel {
    
    let userID:String;
    let nickName:String;
    let userDesc:String;
    let userIconURL:String;
    let sex:Int;
    let country:String;
    let province:String;
    let city:String;
    let followCount:Int;
    var beFollowCount:Int = 0;
    let publishCount:Int;
    var relationType:Int = 0;
    
    init(userID:String, nickName:String, userDesc:String, userIconURL:String, sex:Int, country:String, province:String, city:String, followCount:Int, beFollowCount:Int, publishCount:Int, relationType:Int){
        self.userID      = userID;
        self.nickName    = nickName;
        self.userDesc    = userDesc;
        self.userIconURL = userIconURL;
        self.sex         = sex;
        self.country     = country;
        self.province    = province;
        self.city        = city;
        self.followCount = followCount;
        self.beFollowCount = beFollowCount;
        self.publishCount  = publishCount;
        self.relationType  = relationType;
    }
    
    static func generateFrom(json: JSON) -> CTAViewUserModel {
        
        let userID:String      = json[key(.UserID)].string ?? "";
        let nickName:String    = json[key(.NickName)].string ?? "";
        let userDesc:String    = json[key(.UserDesc)].string ?? "";
        let userIconURL:String = json[key(.UserIconURL)].string ?? "";
        let sex:Int            = json[key(.Sex)].int ?? 0;
        let country:String     = json[key(.Country)].string ?? "";
        let province:String    = json[key(.Province)].string ?? "";
        let city:String        = json[key(.City)].string ?? "";
        let followCount:Int    = json[key(.FollowCount)].int ?? 0;
        let beFollowCount:Int  = json[key(.BeFollowCount)].int ?? 0;
        let publishCount:Int   = json[key(.PublishCount)].int ?? 0;
        let relationType:Int   = json[key(.RelationType)].int ?? 0;
        
        return CTAViewUserModel.init(userID: userID, nickName: nickName, userDesc: userDesc, userIconURL: userIconURL, sex: sex, country: country, province: province, city: city, followCount: followCount, beFollowCount: beFollowCount, publishCount: publishCount, relationType: relationType)
    }
    
    func save() throws {
        
    }
}