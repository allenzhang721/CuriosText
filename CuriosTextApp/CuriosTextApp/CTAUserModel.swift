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
    
    static func generateFrom(_ json: JSON) -> CTAUserModel {
        
        let userID:String      = json[key(.userID)].string ?? "";
        let userType:Int       = json[key(.userType)].int ?? 1;
        let nickName:String    = json[key(.nickName)].string ?? "";
        let userDesc:String    = json[key(.userDesc)].string ?? "";
        let userIconURL:String = json[key(.userIconURL)].string ?? "";
        let sex:Int            = json[key(.sex)].int ?? 0;
        let email:String       = json[key(.email)].string ?? "";
        let phone:String       = json[key(.phone)].string ?? "";
        let areaCode:String    = json[key(.areaCode)].string ?? "";
        let country:String     = json[key(.country)].string ?? "";
        let province:String    = json[key(.province)].string ?? "";
        let city:String        = json[key(.city)].string ?? "";
        let weixinID:String    = json[key(.weixinID)].string ?? "";
        let weiboID:String     = json[key(.weiboID)].string ?? "";

        return CTAUserModel.init(userID: userID, userType: userType, nickName: nickName, userDesc: userDesc, userIconURL: userIconURL, sex: sex, email: email, phone: phone, areaCode: areaCode, country: country, province: province, city: city, weixinID: weixinID, weiboID: weiboID)
    }
    
    func save() throws {
        
        do {
            try createInSecureStore()
            
        } catch let error as NSError {
            throw error
        } catch {}
    }
    
    func getData() -> [String: Any]{
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
    
    var data: [String: Any] {
        return [
            key(.userID):self.userID as AnyObject,
            key(.userType):self.userType as AnyObject,
            key(.nickName):self.nickName,
            key(.userDesc):self.userDesc,
            key(.userIconURL):self.userIconURL,
            key(.sex):self.sex,
            key(.email):self.email,
            key(.phone):self.phone,
            key(.areaCode):self.areaCode,
            key(.country):self.country,
            key(.province):self.province,
            key(.city):self.city,
            key(.weixinID):self.weixinID,
            key(.weiboID):self.weiboID
        ]
    }
}
