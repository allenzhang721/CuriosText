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
    
    func login(_ phone: String, areaCode: String, passwd: String, compelecationBlock: @escaping (CTADomainInfo!) -> Void)  {
        
        CTALoginRequest(phone: phone, areaCode: areaCode, password: passwd).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result {
            case .success(let json):
                    let json:JSON = JSON(json)
                    let resultIndex = json[CTARequestResultKey.resultIndex].int!
                    let result = self.checkJsonResult(json)
                    if result {
                        let model = CTAUserModel.generateFrom(json)
                        compelecationBlock(CTADomainInfo(result: true, baseModel: model, successType: resultIndex))
                    } else{
                        compelecationBlock(CTADomainInfo(result: false, errorType: CTAUserLoginError(rawValue: resultIndex)!))
                    }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, successType: CTAInternetError(rawValue: 10)!.rawValue))
            }
        }
    }
    
    func phoneRegister(_ phone: String, areaCode: String, passwd: String, compelecationBlock: @escaping (CTADomainInfo!) -> Void) {
        
        CTAPhoneRegisterRequest(phone: phone, areaCode: areaCode, password: passwd).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result {
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let model = CTAUserModel.generateFrom(json)
                    compelecationBlock(CTADomainInfo(result: true, baseModel: model, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAPhoneRegisterError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, successType: CTAInternetError(rawValue: 10)!.rawValue))
            }
        }
    }
    
    func weixinRegister(_ weixinID:String, nickName:String, sex:Int, country:String, province:String, city:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void) {
        
        CTAWeixinRegisterRequest(weixinID: weixinID, nickName: nickName, sex: sex, country: country, province: province, city: city).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let model = CTAUserModel.generateFrom(json)
                    compelecationBlock(CTADomainInfo(result: true, baseModel: model, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAWeixinRegisterError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, successType: CTAInternetError(rawValue: 10)!.rawValue))
            }
        }
    }
    
    func weiboRegister(_ weiboID: String, nickName: String, userDesc:String, sex:Int,compelecationBlock: @escaping (CTADomainInfo!) -> Void) {
        
        CTAWeiboRegisterRequest(weiboID: weiboID, nickName: nickName, userDesc: userDesc, sex: sex).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let model = CTAUserModel.generateFrom(json)
                    compelecationBlock(CTADomainInfo(result: true, baseModel: model, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAWeiboRegisterError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, successType: CTAInternetError(rawValue: 10)!.rawValue))
            }
        }
    }
    
    func updateUserInfo(_ userModel:CTAUserModel, compelecationBlock: @escaping (CTADomainInfo!) -> Void) {
        
        CTAUpdateUserInfoRequest(userModel: userModel).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let model = CTAUserModel.generateFrom(json)
                    compelecationBlock(CTADomainInfo(result: true, baseModel: model, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, successType: CTAInternetError(rawValue: 10)!.rawValue))
            }
        }
    }
    
    func updateNickname(_ userID:String, nickName:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void) {
        
        CTAUpdateUserNicknameRequest(userID: userID, nickName: nickName).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let model = CTAUserModel.generateFrom(json)
                    compelecationBlock(CTADomainInfo(result: true, baseModel: model, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, successType: CTAInternetError(rawValue: 10)!.rawValue))
            }
        }
    }
    
    func updateUserDesc(_ userID:String, userDesc:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void) {
        
        CTAUpdateUserDescRequest(userID: userID, userDesc: userDesc).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, successType: CTAInternetError(rawValue: 10)!.rawValue))
            }
        }
    }
    
    func updateUserIconURL(_ userID:String, userIconURL:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void) {
        
        CTAUpdateUserIconURLRequest(userID: userID, userIconURL: userIconURL).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, successType: CTAInternetError(rawValue: 10)!.rawValue))
            }
        }
    }
    
    func updateUserAddress(_ userID:String, country: String, province: String, city: String, compelecationBlock: @escaping (CTADomainInfo!) -> Void) {
        
        CTAUpdateUserAddressRequest(userID: userID, country: country,  province: province, city: city).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, successType: CTAInternetError(rawValue: 10)!.rawValue))
            }
        }
    }
    
    func updateUserSex(_ userID:String, sex: Int, compelecationBlock: @escaping (CTADomainInfo!) -> Void) {
        
        CTAUpdateUserSexRequest(userID: userID, sex: sex).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, successType: CTAInternetError(rawValue: 10)!.rawValue))
            }
        }
    }
    
    func checkUserExist(_ phone:String, areaCode:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void){
        CTACheckUserExistRequest(phone: phone, areaCode: areaCode).startWithCompletionBlockWithSuccess{ (response) -> Void in
            switch response.result {
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, successType: CTAInternetError(rawValue: 10)!.rawValue))
            }
        }
    }
    
    func bindingUserPhone(_ userID:String, phone: String, areaCode: String, compelecationBlock: @escaping (CTADomainInfo!) -> Void) {
        
        CTABindingPhoneRequest(userID: userID, phone: phone, areaCode: areaCode).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTABindingUserPhoneError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, successType: CTAInternetError(rawValue: 10)!.rawValue))
            }
        }
    }

    func bindingUserWeixin(_ userID:String, weixinID: String, compelecationBlock: @escaping (CTADomainInfo!) -> Void) {
        
        CTABindingWeixinIDRequest(userID: userID, weixinID: weixinID).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTABindingUserWeixinError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, successType: CTAInternetError(rawValue: 10)!.rawValue))
            }
        }
    }
    
    func unBindingWeixinID(_ userID:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void) {
        
        CTAUnBindingWeixinIDRequest(userID: userID).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, successType: CTAInternetError(rawValue: 10)!.rawValue))
            }
        }
    }
    
    func bindingUserWeibo(_ userID:String, weibo:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void) {
        
        CTABindingWeiboIDRequest(userID: userID, weiboID: weibo).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTABindingUserWeiboError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, successType: CTAInternetError(rawValue: 10)!.rawValue))
            }
        }
    }
    
    func unBindingWeiboID(_ userID:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void) {
        
        CTAUnBindingWeiboIDRequest(userID: userID).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, successType: CTAInternetError(rawValue: 10)!.rawValue))
            }
        }
    }
    
    func checkPassword(_ userID:String, passwd:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void) {
        
        CTACheckPasswordRequest(userID: userID, password: passwd).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTACheckPasswordError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, successType: CTAInternetError(rawValue: 10)!.rawValue))
            }
        }
    }
    
    func updatePassword(_ userID:String, newPasswd:String, compelecationBlock: @escaping (CTADomainInfo!) -> Void) {
        
        CTAUpdatePasswordRequest(userID: userID, newPassword: newPasswd).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    compelecationBlock(CTADomainInfo(result: true, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTARequestUserError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, successType: CTAInternetError(rawValue: 10)!.rawValue))
            }
        }
    }
    
    func resetPassword(_ phone: String, areaCode: String, newPassword: String, compelecationBlock: @escaping (CTADomainInfo!) -> Void) {
        
        CTAResetPasswordRequest(phone: phone, areaCode: areaCode, newPassword: newPassword).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let model = CTAUserModel.generateFrom(json)
                    compelecationBlock(CTADomainInfo(result: true, baseModel: model, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAResetPasswordError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, successType: CTAInternetError(rawValue: 10)!.rawValue))
            }
        }
    }
    
    func userDetail(_ userID: String, beUserID: String, compelecationBlock: @escaping (CTADomainInfo!) -> Void) {
        
        CTAUserDetailRequest(userID: userID, beUserID: beUserID).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .success(let json):
                let json:JSON = JSON(json)
                let resultIndex = json[CTARequestResultKey.resultIndex].int!
                let result = self.checkJsonResult(json)
                if result {
                    let model = CTAViewUserModel.generateFrom(json)
                    compelecationBlock(CTADomainInfo(result: true, baseModel: model, successType: resultIndex))
                } else{
                    compelecationBlock(CTADomainInfo(result: false, errorType: CTAUserDetailError(rawValue: resultIndex)!))
                }
            case .failure( _):
                compelecationBlock(CTADomainInfo(result: false, successType: CTAInternetError(rawValue: 10)!.rawValue))
            }
        }
    }
}
