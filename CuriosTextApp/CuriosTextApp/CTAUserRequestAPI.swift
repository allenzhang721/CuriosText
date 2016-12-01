//
//  CTAUserRequestAPI.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/7.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation

class CTALoginRequest: CTABaseRequest {
    let phone:String;
    let areaCode:String;
    let password:String;
    
    init(phone: String, areaCode: String, password: String) {
        
        self.phone    = phone;
        self.areaCode = areaCode;
        self.password = password;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.login.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.phone)   : phone as AnyObject,
            key(.areaCode): areaCode as AnyObject,
            key(.password): password as AnyObject
        ];
        
        return self.getParameterString(dic as AnyObject, errorMessage: "CTALoginAP");
    }
}

class CTAPhoneRegisterRequest: CTABaseRequest {
    let phone: String;
    let areaCode: String;
    let password: String;
    
    init(phone: String, areaCode: String, password: String) {
        
        self.phone    = phone;
        self.areaCode = areaCode;
        self.password = password;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.phoneRegister.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.phone)   : phone as AnyObject,
            key(.areaCode): areaCode as AnyObject,
            key(.password): password as AnyObject
        ];
        
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAPhoneRegister");
    }
    
}

class CTAWeixinRegisterRequest: CTABaseRequest {
    let weixinID:String;
    let nickName:String;
    let sex:Int;
    let country:String;
    let province:String;
    let city:String;
    
    init(weixinID:String, nickName:String, sex:Int, country:String, province:String, city:String){
        self.weixinID    = weixinID;
        self.nickName    = nickName;
        self.sex         = sex;
        self.country     = country;
        self.province    = province;
        self.city        = city;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.weixinRegister.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.weixinID)   : weixinID as AnyObject,
            key(.nickName)   : nickName as AnyObject,
            key(.sex): sex as AnyObject,
            key(.country): country as AnyObject as AnyObject,
            key(.province): province as AnyObject,
            key(.city): city as AnyObject
        ];
        
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAWeixinRegister");
    }
}

class CTAWeiboRegisterRequest: CTABaseRequest {
    let weiboID:String;
    let nickName:String;
    let userDesc:String;
    let sex:Int;
    
    init(weiboID:String, nickName:String, userDesc:String, sex:Int){
        self.weiboID     = weiboID;
        self.nickName    = nickName;
        self.userDesc    = userDesc;
        self.sex         = sex;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.weiboRegister.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.weiboID)    : weiboID as AnyObject,
            key(.nickName)   : nickName as AnyObject,
            key(.userDesc)   : userDesc as AnyObject as AnyObject,
            key(.sex)        : sex as AnyObject
        ];
        
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAWeiboRegister");
    }
}

class CTAUpdateUserInfoRequest: CTABaseRequest{
    let userID:String;
    let nickName:String;
    let userDesc:String;
    let userIconURL:String;
    let sex:Int;
    let country:String;
    let province:String;
    let city:String;
    
    init(userModel:CTAUserModel){
        self.userID      = userModel.userID;
        self.nickName    = userModel.nickName;
        self.userDesc    = userModel.userDesc;
        self.userIconURL = userModel.userIconURL;
        self.sex         = userModel.sex;
        self.country     = userModel.country;
        self.province    = userModel.province;
        self.city        = userModel.city;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.updateUserInfo.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.userID): userID as AnyObject,
            key(.nickName): nickName as AnyObject,
            key(.userDesc): userDesc as AnyObject,
            key(.userIconURL): userIconURL as AnyObject,
            key(.sex): sex as AnyObject,
            key(.country): country as AnyObject,
            key(.province): province as AnyObject,
            key(.city): city as AnyObject
        ];
        
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAUpdateUserInfoRequest");
    }
}

class CTAUpdateUserNicknameRequest: CTABaseRequest{
    let userID:String;
    let nickName:String;
    
    init(userID:String, nickName:String){
        self.userID   = userID;
        self.nickName = nickName;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.updateUserNickname.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)  : userID as AnyObject,
            key(.nickName): nickName as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAUpdateUserNicknameRequest");
    }
}

class CTAUpdateUserDescRequest: CTABaseRequest{
    let userID:String;
    let userDesc:String;
    
    init(userID:String, userDesc:String){
        self.userID   = userID;
        self.userDesc = userDesc;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.updateUserDesc.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)  : userID as AnyObject,
            key(.userDesc): userDesc as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAUpdateUserDescRequest");
    }
}

class CTAUpdateUserIconURLRequest: CTABaseRequest{
    let userID:String;
    let userIconURL:String;
    
    init(userID:String, userIconURL:String){
        self.userID      = userID;
        self.userIconURL = userIconURL;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.updateUserIconURL.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)     : userID as AnyObject,
            key(.userIconURL): userIconURL as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAUpdateUserIconURLRequest");
    }
}

class CTAUpdateUserAddressRequest: CTABaseRequest{
    let userID:String;
    let country:String;
    let province:String;
    let city:String;
    
    init(userID:String, country:String = "", province:String = "", city:String = ""){
        self.userID     = userID;
        self.country    = country;
        self.province   = province;
        self.city       = city;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.updateUserAddress.description;
    }
    
    override func parameter() -> String {
        
        var dic:Dictionary<String, AnyObject> = [
            key(.userID): userID as AnyObject
        ];
        
        if self.country != ""{
            dic[key(.country)] = self.country as AnyObject?;
        }
        if self.province != ""{
            dic[key(.province)] = self.province as AnyObject?;
        }
        if self.city != ""{
            dic[key(.city)] = self.city as AnyObject?;
        }
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAUpdateUserAddressRequest");
    }
}

class CTAUpdateUserSexRequest: CTABaseRequest{
    let userID:String;
    let sex:Int;
    
    init(userID:String, sex:Int = -1){
        self.userID = userID;
        self.sex    = sex;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.updateUserSex.description;
    }
    
    override func parameter() -> String {
        
        var dic:Dictionary<String, AnyObject> = [
            key(.userID): userID as AnyObject
        ];
        
        if self.sex != -1{
            dic[key(.sex)] = self.sex as AnyObject?;
        }
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAUpdateUserSexRequest");
    }
}

class CTACheckUserExistRequest: CTABaseRequest{
    let phone: String;
    let areaCode: String;
    
    init(phone:String, areaCode:String){
        self.phone    = phone;
        self.areaCode = areaCode;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.checkUserExist.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.phone)   : phone as AnyObject,
            key(.areaCode): areaCode as AnyObject
        ];
        
        return self.getParameterString(dic as AnyObject, errorMessage: "CTACheckUserExistRequest");
    }
}

class CTABindingPhoneRequest: CTABaseRequest{
    let userID:String;
    let phone: String;
    let areaCode: String;
    
    init(userID:String, phone:String, areaCode:String){
        self.userID   = userID;
        self.phone    = phone;
        self.areaCode = areaCode;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.bindingPhone.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)  : userID as AnyObject,
            key(.phone)   : phone as AnyObject,
            key(.areaCode): areaCode as AnyObject
        ];
        
        return self.getParameterString(dic as AnyObject, errorMessage: "CTABindingPhoneRequest");
    }
}

class CTABindingWeixinIDRequest: CTABaseRequest{
    let userID:String;
    let weixinID: String;
    
    init(userID:String, weixinID:String){
        self.userID   = userID;
        self.weixinID = weixinID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.bindingWeixinID.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)  : userID as AnyObject,
            key(.weixinID): weixinID as AnyObject
        ];
        
        return self.getParameterString(dic as AnyObject, errorMessage: "CTABindingWeixinIDRequest");
    }
}

class CTAUnBindingWeixinIDRequest: CTABaseRequest{
    let userID:String;
    
    init(userID:String){
        self.userID = userID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.unbindingWeixinID.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.userID): userID as AnyObject
        ];
        
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAUnBindingWeixinIDRequest");
    }
}

class CTABindingWeiboIDRequest: CTABaseRequest{
    let userID:String;
    let weiboID: String;
    
    init(userID:String, weiboID:String){
        self.userID  = userID;
        self.weiboID = weiboID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.bingingWeiboID.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.userID) : userID as AnyObject,
            key(.weiboID): weiboID as AnyObject
        ];
        
        return self.getParameterString(dic as AnyObject, errorMessage: "CTABindingWeiboIDRequest");
    }
}

class CTAUnBindingWeiboIDRequest: CTABaseRequest{
    let userID:String;
    
    init(userID:String){
        self.userID = userID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.unbindingWeiboID.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.userID): userID as AnyObject
        ];
        
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAUnBindingWeiboIDRequest");
    }
}

class CTACheckPasswordRequest: CTABaseRequest{
    let userID:String;
    let password:String;
    
    init(userID:String, password:String){
        self.userID   = userID;
        self.password = password;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.checkPassword.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)  : userID as AnyObject,
            key(.password): password as AnyObject
        ];
        
        return self.getParameterString(dic as AnyObject, errorMessage: "CTACheckPasswordRequest");
    }
}

class CTAUpdatePasswordRequest: CTABaseRequest{
    let userID:String;
    let newPassword:String;
    
    init(userID:String, newPassword:String){
        self.userID      = userID;
        self.newPassword = newPassword
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.updatePassword.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)     : userID as AnyObject,
            key(.newPassword): newPassword as AnyObject
        ];
        
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAUpdatePasswordRequest");
    }
}

class CTAResetPasswordRequest: CTABaseRequest{
    let phone:String;
    let areaCode:String;
    let newPassword:String;
    
    init(phone:String, areaCode:String, newPassword:String){
        self.phone       = phone;
        self.areaCode    = areaCode;
        self.newPassword = newPassword;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.resetPassword.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.phone)      : phone as AnyObject,
            key(.areaCode)   : areaCode as AnyObject,
            key(.newPassword): newPassword as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAResetPasswordRequest");
    }
}

class CTAUserDetailRequest: CTABaseRequest{
    let userID:String;
    let beUserID:String;
    
    init(userID:String, beUserID:String){
        self.userID   = userID;
        self.beUserID = beUserID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.userDetail.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.userID)  : userID as AnyObject,
            key(.beUserID): beUserID as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAUserDetailRequest");
    }
}
