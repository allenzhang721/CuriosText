//
//  CTAUserRequestAPI.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/7.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation

class CTAUserIDRequest:CTABaseRequest {
    
    override func requestUrl() -> String {
        return CTARequestUrl.GetUserID.description;
    }
}

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
        return CTARequestUrl.Login.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.Phone)   : phone,
            key(.AreaCode): areaCode,
            key(.Password): password
        ];
        
        return self.getParameterString(dic, errorMessage: "CTALoginAP");
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
        return CTARequestUrl.PhoneRegister.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.Phone)   : phone,
            key(.AreaCode): areaCode,
            key(.Password): password
        ];
        
        return self.getParameterString(dic, errorMessage: "CTAPhoneRegister");
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
        return CTARequestUrl.WeixinRegister.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.WeixinID)   : weixinID,
            key(.NickName)   : nickName,
            key(.Sex): sex,
            key(.Country): country,
            key(.Province): province,
            key(.City): city
        ];
        
        return self.getParameterString(dic, errorMessage: "CTAWeixinRegister");
    }
}

class CTAWeiboRegisterRequest: CTABaseRequest {
    let weiboID:String;
    let nickName:String;
    let userIconURL:String;
    
    init(weiboID:String, nickName:String, userIconURL:String){
        self.weiboID     = weiboID;
        self.nickName    = nickName;
        self.userIconURL = userIconURL;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.WeixinRegister.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.WeiboID)    : weiboID,
            key(.NickName)   : nickName,
            key(.UserIconURL): userIconURL
        ];
        
        return self.getParameterString(dic, errorMessage: "CTAWeiboRegister");
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
        return CTARequestUrl.UpdateUserInfo.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID): userID,
            key(.NickName): nickName,
            key(.UserDesc): userDesc,
            key(.UserIconURL): userIconURL,
            key(.Sex): sex,
            key(.Country): country,
            key(.Province): province,
            key(.City): city
        ];
        
        return self.getParameterString(dic, errorMessage: "CTAUpdateUserInfoRequest");
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
        return CTARequestUrl.UpdateUserNickname.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)  : userID,
            key(.NickName): nickName
        ];
        return self.getParameterString(dic, errorMessage: "CTAUpdateUserNicknameRequest");
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
        return CTARequestUrl.UpdateUserDesc.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)  : userID,
            key(.UserDesc): userDesc
        ];
        return self.getParameterString(dic, errorMessage: "CTAUpdateUserDescRequest");
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
        return CTARequestUrl.UpdateUserIconURL.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)     : userID,
            key(.UserIconURL): userIconURL
        ];
        return self.getParameterString(dic, errorMessage: "CTAUpdateUserIconURLRequest");
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
        return CTARequestUrl.UpdateUserAddress.description;
    }
    
    override func parameter() -> String {
        
        var dic:Dictionary<String, AnyObject> = [
            key(.UserID): userID
        ];
        
        if self.country != ""{
            dic[key(.Country)] = self.country;
        }
        if self.province != ""{
            dic[key(.Province)] = self.province;
        }
        if self.city != ""{
            dic[key(.City)] = self.city;
        }
        return self.getParameterString(dic, errorMessage: "CTAUpdateUserAddressRequest");
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
        return CTARequestUrl.UpdateUserSex.description;
    }
    
    override func parameter() -> String {
        
        var dic:Dictionary<String, AnyObject> = [
            key(.UserID): userID
        ];
        
        if self.sex != -1{
            dic[key(.Sex)] = self.sex;
        }
        return self.getParameterString(dic, errorMessage: "CTAUpdateUserSexRequest");
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
        return CTARequestUrl.CheckUserExist.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.Phone)   : phone,
            key(.AreaCode): areaCode
        ];
        
        return self.getParameterString(dic, errorMessage: "CTACheckUserExistRequest");
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
        return CTARequestUrl.BindingPhone.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)  : userID,
            key(.Phone)   : phone,
            key(.AreaCode): areaCode
        ];
        
        return self.getParameterString(dic, errorMessage: "CTABindingPhoneRequest");
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
        return CTARequestUrl.BindingWeixinID.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)  : userID,
            key(.WeixinID): weixinID
        ];
        
        return self.getParameterString(dic, errorMessage: "CTABindingWeixinIDRequest");
    }
}

class CTAUnBindingWeixinIDRequest: CTABaseRequest{
    let userID:String;
    
    init(userID:String){
        self.userID = userID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.UnbindingWeixinID.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID): userID
        ];
        
        return self.getParameterString(dic, errorMessage: "CTAUnBindingWeixinIDRequest");
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
        return CTARequestUrl.BingingWeiboID.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID) : userID,
            key(.WeiboID): weiboID
        ];
        
        return self.getParameterString(dic, errorMessage: "CTABindingWeiboIDRequest");
    }
}

class CTAUnBindingWeiboIDRequest: CTABaseRequest{
    let userID:String;
    
    init(userID:String){
        self.userID = userID;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.UnbindingWeiboID.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID): userID
        ];
        
        return self.getParameterString(dic, errorMessage: "CTAUnBindingWeiboIDRequest");
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
        return CTARequestUrl.CheckPassword.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)  : userID,
            key(.Password): password
        ];
        
        return self.getParameterString(dic, errorMessage: "CTACheckPasswordRequest");
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
        return CTARequestUrl.UpdatePassword.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)     : userID,
            key(.NewPassword): newPassword
        ];
        
        return self.getParameterString(dic, errorMessage: "CTAUpdatePasswordRequest");
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
        return CTARequestUrl.ResetPassword.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.Phone)      : phone,
            key(.AreaCode)   : areaCode,
            key(.NewPassword): newPassword
        ];
        return self.getParameterString(dic, errorMessage: "CTAResetPasswordRequest");
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
        return CTARequestUrl.UserDetail.description;
    }
    
    override func parameter() -> String {
        
        let dic:Dictionary<String, AnyObject> = [
            key(.UserID)  : userID,
            key(.BeUserID): beUserID
        ];
        return self.getParameterString(dic, errorMessage: "CTAUserDetailRequest");
    }
}
