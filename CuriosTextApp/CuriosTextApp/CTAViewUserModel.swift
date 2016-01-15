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
    let nikeName:String;
    let userDesc:String;
    let userIconURL:String;
    let sex:Int;
    let countryID:Int;
    let provinceID:Int;
    let cityID:Int;
    let followCount:Int;
    var beFollowCount:Int = 0;
    let publishCount:Int;
    var relationType:Int = 0;
    
    init(userID:String, nikeName:String, userDesc:String, userIconURL:String, sex:Int, countryID:Int, provinceID:Int, cityID:Int, followCount:Int, beFollowCount:Int, publishCount:Int, relationType:Int){
        self.userID      = userID;
        self.nikeName    = nikeName;
        self.userDesc    = userDesc;
        self.userIconURL = userIconURL;
        self.sex         = sex;
        self.countryID   = countryID;
        self.provinceID  = provinceID;
        self.cityID      = cityID;
        self.followCount = followCount;
        self.beFollowCount = beFollowCount;
        self.publishCount  = publishCount;
        self.relationType  = relationType;
    }
    
    static func generateFrom(json: JSON) -> CTAViewUserModel {
        
        let userID:String      = json[key(.UserID)].string ?? "";
        let nikeName:String    = json[key(.NikeName)].string ?? "";
        let userDesc:String    = json[key(.UserDesc)].string ?? "";
        let userIconURL:String = json[key(.UserIconURL)].string ?? "";
        let sex:Int            = json[key(.Sex)].int ?? 0;
        let countryID:Int      = json[key(.CountryID)].int ?? 0;
        let provinceID:Int     = json[key(.ProvinceID)].int ?? 0;
        let cityID:Int         = json[key(.CityID)].int ?? 0;
        let followCount:Int    = json[key(.FollowCount)].int ?? 0;
        let beFollowCount:Int  = json[key(.BeFollowCount)].int ?? 0;
        let publishCount:Int   = json[key(.PublishCount)].int ?? 0;
        let relationType:Int   = json[key(.RelationType)].int ?? 0;
        
        return CTAViewUserModel.init(userID: userID, nikeName: nikeName, userDesc: userDesc, userIconURL: userIconURL, sex: sex, countryID: countryID, provinceID: provinceID, cityID: cityID, followCount: followCount, beFollowCount: beFollowCount, publishCount: publishCount, relationType: relationType)
    }
    
    func save() throws {
        
    }
}