//
//  CTAViewUserModel.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/15.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation
import SwiftyJSON

func GetViewUserModel(_ user:CTAUserModel) -> CTAViewUserModel{
    return CTAViewUserModel(userID: user.userID, nickName: user.nickName, userDesc: user.userDesc, userIconURL: user.userIconURL, sex: user.sex, relationType: 0)
}

final class CTAViewUserModel: CTABaseModel {
    
    let userID:String;
    let nickName:String;
    let userDesc:String;
    let userIconURL:String;
    let sex:Int;
    var country:String = "";
    var province:String = "";
    var city:String = "";
    var followCount:Int = 0;
    var beFollowCount:Int = 0;
    var publishCount:Int = 0;
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
    
    init(userID:String, nickName:String, userDesc:String, userIconURL:String, sex:Int, relationType:Int){
        self.userID      = userID;
        self.nickName    = nickName;
        self.userDesc    = userDesc;
        self.userIconURL = userIconURL;
        self.sex         = sex;
        self.relationType = relationType;
    }
    
    static func generateFrom(_ json: JSON) -> CTAViewUserModel {
        
        let userID:String      = json[key(.userID)].string ?? "";
        let nickName:String    = json[key(.nickName)].string ?? "";
        let userDesc:String    = json[key(.userDesc)].string ?? "";
        let userIconURL:String = json[key(.userIconURL)].string ?? "";
        let sex:Int            = json[key(.sex)].int ?? 0;
        let country:String     = json[key(.country)].string ?? "";
        let province:String    = json[key(.province)].string ?? "";
        let city:String        = json[key(.city)].string ?? "";
        let followCount:Int    = json[key(.followCount)].int ?? 0;
        let beFollowCount:Int  = json[key(.beFollowCount)].int ?? 0;
        let publishCount:Int   = json[key(.publishCount)].int ?? 0;
        let relationType:Int   = json[key(.relationType)].int ?? 0;
        
        return CTAViewUserModel.init(userID: userID, nickName: nickName, userDesc: userDesc, userIconURL: userIconURL, sex: sex, country: country, province: province, city: city, followCount: followCount, beFollowCount: beFollowCount, publishCount: publishCount, relationType: relationType)
    }
    
    func save() throws {
        
    }
    
    func getData() -> [String: Any]{
        return [
            key(.userID)  :self.userID as AnyObject,
            key(.nickName):self.nickName as AnyObject,
            key(.userDesc):self.userDesc as AnyObject,
            key(.userIconURL):self.userIconURL as AnyObject,
            key(.sex):self.sex as AnyObject,
            key(.country):self.country as AnyObject,
            key(.province):self.province as AnyObject,
            key(.city):self.city as AnyObject,
            key(.followCount):self.followCount as AnyObject,
            key(.beFollowCount):self.beFollowCount as AnyObject,
            key(.publishCount):self.publishCount as AnyObject,
            key(.relationType):self.relationType as AnyObject
        ]
    }
}
