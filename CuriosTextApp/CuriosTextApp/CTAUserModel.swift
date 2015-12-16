//
//  CTAUserModel.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/14/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation
import Locksmith
import SwiftyJSON

final class CTAUserModel: CTABaseModel, CreateableSecureStorable, GenericPasswordSecureStorable {
    
    let userID:String;
    var nikeName: String = "";
    var userDesc:String = "";
    var userIconURL:String = "";
    var sex:Int = 0;
    var email:String = "";
    var phone:String = "";
    var areaCode:String = "";
    var countryID:Int = 0;
    var provinceID:Int = 0;
    var cityID:Int = 0;
    var weixinID:String = "";
    var weiboID:String = "";

    
    init(userID:String, nikeName:String, userDesc:String, userIconURL:String, sex:Int, email:String, phone:String, areaCode:String, countryID:Int, provinceID:Int, cityID:Int, weixinID:String, weiboID:String){
        self.userID      = userID;
        self.nikeName    = nikeName;
        self.userDesc    = userDesc;
        self.userIconURL = userIconURL;
        self.sex         = sex;
        self.email       = email;
        self.phone       = phone;
        self.areaCode    = areaCode;
        self.countryID   = countryID;
        self.provinceID  = provinceID;
        self.cityID      = cityID;
        self.weixinID    = weixinID;
        self.weiboID     = weiboID;
    }
    
    static func generateFrom(json: JSON) -> CTAUserModel {
        
        let userID:String      = json[key(.UserID)].string ?? "";
        let nikeName:String    = json[key(.NikeName)].string ?? "";
        let userDesc:String    = json[key(.UserDesc)].string ?? "";
        let userIconURL:String = json[key(.UserIconURL)].string ?? "";
        let sex:Int            = json[key(.Sex)].int ?? 0;
        let email:String       = json[key(.Email)].string ?? "";
        let phone:String       = json[key(.Phone)].string ?? "";
        let areaCode:String    = json[key(.AreaCode)].string ?? "";
        let countryID:Int      = json[key(.CountryID)].int ?? 0;
        let provinceID :Int    = json[key(.ProvinceID)].int ?? 0;
        let cityID:Int         = json[key(.CityID)].int ?? 0;
        let weixinID:String    = json[key(.WeixinID)].string ?? "";
        let weiboID:String     = json[key(.WeiboID)].string ?? "";


        return CTAUserModel.init(userID: userID, nikeName: nikeName, userDesc: userDesc, userIconURL: userIconURL, sex: sex, email: email, phone: phone, areaCode: areaCode, countryID: countryID, provinceID: provinceID, cityID: cityID, weixinID: weixinID, weiboID: weiboID)
    }
    
    func save() throws {
        
        do {
            try createInSecureStore()
            
        } catch let error as NSError {
            throw error
        } catch {}
    }
}

extension CTAUserModel {
    
    /// The service to which the type belongs
    var service: String {
        return "com.botai.curiosText"
    }
    
    var account: String {
        return userID
    }
    
    var data: [String: AnyObject] {
        return [
            key(.UserID)  :self.userID,
            key(.NikeName):self.nikeName,
            key(.UserDesc):self.userDesc,
            key(.UserIconURL):self.userIconURL,
            key(.Sex):self.sex,
            key(.Email):self.email,
            key(.Phone):self.phone,
            key(.AreaCode):self.areaCode,
            key(.CountryID):self.countryID,
            key(.ProvinceID):self.provinceID,
            key(.CityID):self.cityID,
            key(.WeixinID):self.weixinID,
            key(.WeiboID):self.weiboID
        ]
    }
}