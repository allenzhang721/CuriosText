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

final class CTAUserModel: CTABaseModel {
    
    let userID:String;
    let userType:Int;
    var nickName: String = "";
    var userDesc:String = "";
    var userIconURL:String = "";
    var sex:Int = 0;
    var email:String = "";
    var phone:String = "";
    var areaCode:String = "";
    var country:String = "";
    var province:String = "";
    var city:String = "";
    var weixinID:String = "";
    var weiboID:String = "";

    
    init(userID:String, userType:Int, nickName:String, userDesc:String, userIconURL:String, sex:Int, email:String, phone:String, areaCode:String, country:String, province:String, city:String, weixinID:String, weiboID:String){
        self.userID      = userID;
        self.userType    = userType;
        self.nickName    = nickName;
        self.userDesc    = userDesc;
        self.userIconURL = userIconURL;
        self.sex         = sex;
        self.email       = email;
        self.phone       = phone;
        self.areaCode    = areaCode;
        self.country     = country;
        self.province    = province;
        self.city        = city;
        self.weixinID    = weixinID;
        self.weiboID     = weiboID;
    }
    
    static func generateFrom(json: JSON) -> CTAUserModel {
        
        let userID:String      = json[key(.UserID)].string ?? "";
        let userType:Int       = json[key(.UserType)].int ?? 1;
        let nickName:String    = json[key(.NickName)].string ?? "";
        let userDesc:String    = json[key(.UserDesc)].string ?? "";
        let userIconURL:String = json[key(.UserIconURL)].string ?? "";
        let sex:Int            = json[key(.Sex)].int ?? 0;
        let email:String       = json[key(.Email)].string ?? "";
        let phone:String       = json[key(.Phone)].string ?? "";
        let areaCode:String    = json[key(.AreaCode)].string ?? "";
        let country:String     = json[key(.Country)].string ?? "";
        let province:String    = json[key(.Province)].string ?? "";
        let city:String        = json[key(.City)].string ?? "";
        let weixinID:String    = json[key(.WeixinID)].string ?? "";
        let weiboID:String     = json[key(.WeiboID)].string ?? "";

        return CTAUserModel.init(userID: userID, userType: userType, nickName: nickName, userDesc: userDesc, userIconURL: userIconURL, sex: sex, email: email, phone: phone, areaCode: areaCode, country: country, province: province, city: city, weixinID: weixinID, weiboID: weiboID)
    }
    
    func save() throws {
        
        do {
            try createInSecureStore()
            
        } catch let error as NSError {
            throw error
        } catch {}
    }
    
    func getData() -> [String: AnyObject]{
        return self.data
    }
}

extension CTAUserModel: CreateableSecureStorable, GenericPasswordSecureStorable {
    
    /// The service to which the type belongs
    var service: String {
        return "com.botai.curiosText"
    }
    
    var account: String {
        return userID
    }
    
    var data: [String: AnyObject] {
        return [
            key(.UserID):self.userID,
            key(.UserType):self.userType,
            key(.NickName):self.nickName,
            key(.UserDesc):self.userDesc,
            key(.UserIconURL):self.userIconURL,
            key(.Sex):self.sex,
            key(.Email):self.email,
            key(.Phone):self.phone,
            key(.AreaCode):self.areaCode,
            key(.Country):self.country,
            key(.Province):self.province,
            key(.City):self.city,
            key(.WeixinID):self.weixinID,
            key(.WeiboID):self.weiboID
        ]
    }
}