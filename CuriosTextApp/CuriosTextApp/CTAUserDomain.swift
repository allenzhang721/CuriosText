//
//  CTAUser.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/14/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation
import SwiftyJSON



class CTAUserDomain: CTABaseDomain {
    
    static var _instance:CTAUserDomain?;
    
    static func getInstance() -> CTAUserDomain{
        if _instance == nil{
            _instance = CTAUserDomain.init();
        }
        return _instance!
    }
    
    
    func userID(compelecationBlock: (String!) -> Void)  {
        
        CTAUserIDRequest.init().startWithCompletionBlockWithSuccess { (response) -> Void in
            
            var uuid:String!;
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let result = self.checkJsonResult(json)
                if result{
                    let data = json[key(.Data)].string
                    compelecationBlock(data)
                } else{
                    uuid = NSUUID().UUIDString
                    uuid = self.changeUUID(uuid)
                    compelecationBlock(uuid)
                }
            case .Failure( _):
                uuid = NSUUID().UUIDString
                uuid = self.changeUUID(uuid)
                compelecationBlock(uuid)
            }
        }
    }
    
    func login(phone: String, areaCode: String, passwd: String, compelecationBlock: (CTADomainInfo!) -> Void)  {
        
        CTALoginRequest.init(phone: phone, areaCode: areaCode, password: passwd).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                    let json:JSON = JSON(json)
                    let resultIndex = json[CTARequestResultKey.resultIndex].int!
                    let result = self.checkJsonResult(json)
                    if result {
                        let model = CTAUserModel.generateFrom(json)
                        compelecationBlock(CTADomainInfo.init(result: true, baseModel: model, successType: resultIndex))
                    } else{
                        compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAUserLoginError(rawValue: resultIndex)!))
                    }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func phoneRegister(phone: String, areaCode: String, passwd: String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAPhoneRegisterRequest.init(phone: phone, areaCode: areaCode, password: passwd).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let model = CTAUserModel.generateFrom(json)
                    compelecationBlock(CTADomainInfo.init(result: true, baseModel: model, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAPhoneRegisterError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func weixinRegister(weixinID: String, nikeName: String, userIconURL:String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAWeixinRegisterRequest.init(weixinID: weixinID, nikeName: nikeName, userIconURL: userIconURL).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let model = CTAUserModel.generateFrom(json)
                    compelecationBlock(CTADomainInfo.init(result: true, baseModel: model, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAWeixinRegisterError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func weiboRegister(weiboID: String, nikeName: String, userIconURL:String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAWeiboRegisterRequest.init(weiboID: weiboID, nikeName: nikeName, userIconURL: userIconURL).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let model = CTAUserModel.generateFrom(json)
                    compelecationBlock(CTADomainInfo.init(result: true, baseModel: model, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAWeiboRegisterError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func updateUserInfo(userModel:CTAUserModel, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAUpdateUserInfoRequest.init(userModel: userModel).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let model = CTAUserModel.generateFrom(json)
                    compelecationBlock(CTADomainInfo.init(result: true, baseModel: model, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func updateNikename(userID:String, nikeName:String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAUpdateUserNikenameRequest.init(userID: userID, nikeName: nikeName).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let model = CTAUserModel.generateFrom(json)
                    compelecationBlock(CTADomainInfo.init(result: true, baseModel: model, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func updateUserDesc(userID:String, userDesc:String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAUpdateUserDescRequest.init(userID: userID, userDesc: userDesc).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo.init(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func updateUserIconURL(userID:String, userIconURL:String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAUpdateUserIconURLRequest.init(userID: userID, userIconURL: userIconURL).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo.init(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func updateUserAddress(userID:String, countryID: Int, provinceID: Int, cityID: Int, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAUpdateUserAddressRequest.init(userID: userID, countryID: countryID, provinceID: provinceID, cityID: cityID).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo.init(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func updateUserSex(userID:String, sex: Int, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAUpdateUserSexRequest.init(userID: userID, sex: sex).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo.init(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func checkUserExist(phone:String, areaCode:String, compelecationBlock: (CTADomainInfo!) -> Void){
        CTACheckUserExistRequest.init(phone: phone, areaCode: areaCode).startWithCompletionBlockWithSuccess{ (response) -> Void in
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo.init(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func bindingUserPhone(userID:String, phone: String, areaCode: String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTABindingPhoneRequest.init(userID: userID, phone: phone, areaCode: areaCode).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo.init(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTABindingUserPhoneError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }

    func bindingUserWeixin(userID:String, weixinID: String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTABindingWeixinIDRequest.init(userID: userID, weixinID: weixinID).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo.init(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTABindingUserWeixinError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func unBindingWeixinID(userID:String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAUnBindingWeixinIDRequest.init(userID: userID).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo.init(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func bindingUserWeibo(userID:String, weibo:String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTABindingWeiboIDRequest.init(userID: userID, weiboID: weibo).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo.init(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTABindingUserWeiboError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func unBindingWeiboID(userID:String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAUnBindingWeiboIDRequest.init(userID: userID).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo.init(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func checkPassword(userID:String, passwd:String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTACheckPasswordRequest.init(userID: userID, password: passwd).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo.init(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTACheckPasswordError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func updatePassword(userID:String, newPasswd:String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAUpdatePasswordRequest.init(userID: userID, newPassword: newPasswd).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo.init(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func resetPassword(phone: String, areaCode: String, newPassword: String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAResetPasswordRequest.init(phone: phone, areaCode: areaCode, newPassword: newPassword).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let model = CTAUserModel.generateFrom(json)
                    compelecationBlock(CTADomainInfo.init(result: true, baseModel: model, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAResetPasswordError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func userDetail(userID: String, beUserID: String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAUserDetailRequest.init(userID: userID, beUserID: beUserID).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let model = CTAViewUserModel.generateFrom(json)
                    compelecationBlock(CTADomainInfo.init(result: true, baseModel: model, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAUserDetailError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo.init(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
}