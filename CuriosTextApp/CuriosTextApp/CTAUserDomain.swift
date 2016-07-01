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
            _instance = CTAUserDomain();
        }
        return _instance!
    }
    
    func login(phone: String, areaCode: String, passwd: String, compelecationBlock: (CTADomainInfo!) -> Void)  {
        
        CTALoginRequest(phone: phone, areaCode: areaCode, password: passwd).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                    let json:JSON = JSON(json)
                    let resultIndex = json[CTARequestResultKey.resultIndex].int!
                    let result = self.checkJsonResult(json)
                    if result {
                        let model = CTAUserModel.generateFrom(json)
                        compelecationBlock(CTADomainInfo(result: true, baseModel: model, successType: resultIndex))
                    } else{
                        compelecationBlock(CTADomainInfo(result: false, errorType: CTAUserLoginError(rawValue: resultIndex)!))
                    }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func phoneRegister(phone: String, areaCode: String, passwd: String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAPhoneRegisterRequest(phone: phone, areaCode: areaCode, password: passwd).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let model = CTAUserModel.generateFrom(json)
                    compelecationBlock(CTADomainInfo(result: true, baseModel: model, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAPhoneRegisterError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func weixinRegister(weixinID:String, nickName:String, sex:Int, country:String, province:String, city:String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAWeixinRegisterRequest(weixinID: weixinID, nickName: nickName, sex: sex, country: country, province: province, city: city).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let model = CTAUserModel.generateFrom(json)
                    compelecationBlock(CTADomainInfo(result: true, baseModel: model, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAWeixinRegisterError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func weiboRegister(weiboID: String, nickName: String, userDesc:String, sex:Int,compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAWeiboRegisterRequest(weiboID: weiboID, nickName: nickName, userDesc: userDesc, sex: sex).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let model = CTAUserModel.generateFrom(json)
                    compelecationBlock(CTADomainInfo(result: true, baseModel: model, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAWeiboRegisterError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func updateUserInfo(userModel:CTAUserModel, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAUpdateUserInfoRequest(userModel: userModel).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let model = CTAUserModel.generateFrom(json)
                    compelecationBlock(CTADomainInfo(result: true, baseModel: model, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func updateNickname(userID:String, nickName:String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAUpdateUserNicknameRequest(userID: userID, nickName: nickName).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let model = CTAUserModel.generateFrom(json)
                    compelecationBlock(CTADomainInfo(result: true, baseModel: model, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func updateUserDesc(userID:String, userDesc:String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAUpdateUserDescRequest(userID: userID, userDesc: userDesc).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func updateUserIconURL(userID:String, userIconURL:String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAUpdateUserIconURLRequest(userID: userID, userIconURL: userIconURL).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func updateUserAddress(userID:String, country: String, province: String, city: String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAUpdateUserAddressRequest(userID: userID, country: country,  province: province, city: city).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func updateUserSex(userID:String, sex: Int, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAUpdateUserSexRequest(userID: userID, sex: sex).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func checkUserExist(phone:String, areaCode:String, compelecationBlock: (CTADomainInfo!) -> Void){
        CTACheckUserExistRequest(phone: phone, areaCode: areaCode).startWithCompletionBlockWithSuccess{ (response) -> Void in
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func bindingUserPhone(userID:String, phone: String, areaCode: String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTABindingPhoneRequest(userID: userID, phone: phone, areaCode: areaCode).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTABindingUserPhoneError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }

    func bindingUserWeixin(userID:String, weixinID: String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTABindingWeixinIDRequest(userID: userID, weixinID: weixinID).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTABindingUserWeixinError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func unBindingWeixinID(userID:String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAUnBindingWeixinIDRequest(userID: userID).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func bindingUserWeibo(userID:String, weibo:String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTABindingWeiboIDRequest(userID: userID, weiboID: weibo).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTABindingUserWeiboError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func unBindingWeiboID(userID:String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAUnBindingWeiboIDRequest(userID: userID).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func checkPassword(userID:String, passwd:String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTACheckPasswordRequest(userID: userID, password: passwd).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTACheckPasswordError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func updatePassword(userID:String, newPasswd:String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAUpdatePasswordRequest(userID: userID, newPassword: newPasswd).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func resetPassword(phone: String, areaCode: String, newPassword: String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAResetPasswordRequest(phone: phone, areaCode: areaCode, newPassword: newPassword).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let model = CTAUserModel.generateFrom(json)
                    compelecationBlock(CTADomainInfo(result: true, baseModel: model, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAResetPasswordError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
    
    func userDetail(userID: String, beUserID: String, compelecationBlock: (CTADomainInfo!) -> Void) {
        
        CTAUserDetailRequest(userID: userID, beUserID: beUserID).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let model = CTAViewUserModel.generateFrom(json)
                    compelecationBlock(CTADomainInfo(result: true, baseModel: model, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAUserDetailError(rawValue: resultIndex)!))
                }
            case .Failure( _):
                compelecationBlock(CTADomainInfo(result: false, errorType: CTAInternetError(rawValue: 10)!))
            }
        }
    }
}