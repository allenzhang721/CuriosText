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
    
    static func userID(compelecationBlock: (String?) -> Void)  {
        
        CTAUserIDRequest.init().startWithCompletionBlockWithSuccess { (response) -> Void in
            
            var uuid:String!;
            switch response.result{
            case .Success(let json):
                let json:JSON = JSON(json)
                let result = checkJsonResult(json)
                if result{
                    let data = json[key(.Data)].string
                    compelecationBlock(data)
                } else{
                    uuid = NSUUID().UUIDString
                    uuid = changeUUID(uuid)
                    compelecationBlock(uuid)
                }
            case .Failure( _):
                uuid = NSUUID().UUIDString
                uuid = changeUUID(uuid)
                compelecationBlock(uuid)
            }
        }
    }
    
    static func login(phone: String, areaCode: String, passwd: String, compelecationBlock: (CTAUserModel?, ErrorType?) -> Void)  {
        
        CTALoginRequest.init(phone: phone, areaCode: areaCode, password: passwd).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                    let json:JSON = JSON(json)
                    let resultindex = json[CTARequestResultKey.resultIndex].int!
                    let result = checkJsonResult(json)
                    if result {
                        let model = CTAUserModel.generateFrom(json)
                        compelecationBlock(model, CTARequestSuccess(rawValue: resultindex)!)
                    } else{
                        compelecationBlock(nil, CTAUserLoginError(rawValue: resultindex)!)
                    }
            case .Failure( _):
                compelecationBlock(nil, CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func phoneRegister(phone: String, areaCode: String, passwd: String, compelecationBlock: (CTAUserModel?, ErrorType?) -> Void) {
        
        CTAPhoneRegisterRequest.init(phone: phone, areaCode: areaCode, password: passwd).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    let model = CTAUserModel.generateFrom(json)
                    compelecationBlock(model, CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(nil, CTAPhoneRegisterError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(nil, CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func weixinRegister(weixinID: String, nikeName: String, userIconURL:String, compelecationBlock: (CTAUserModel?, ErrorType?) -> Void) {
        
        CTAWeixinRegisterRequest.init(weixinID: weixinID, nikeName: nikeName, userIconURL: userIconURL).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    let model = CTAUserModel.generateFrom(json)
                    compelecationBlock(model, CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(nil, CTAWeixinRegisterError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(nil, CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func weiboRegister(weiboID: String, nikeName: String, userIconURL:String, compelecationBlock: (CTAUserModel?, ErrorType?) -> Void) {
        
        CTAWeiboRegisterRequest.init(weiboID: weiboID, nikeName: nikeName, userIconURL: userIconURL).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    let model = CTAUserModel.generateFrom(json)
                    compelecationBlock(model, CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(nil, CTAWeiboRegisterError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(nil, CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func updateUserInfo(userModel:CTAUserModel, compelecationBlock: (CTAUserModel?, ErrorType?) -> Void) {
        
        CTAUpdateUserInfoRequest.init(userModel: userModel).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    let model = CTAUserModel.generateFrom(json)
                    compelecationBlock(model, CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(nil, CTARequestUserError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(nil, CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func updateNikename(userID:String, nikeName:String, compelecationBlock: (CTAUserModel?, ErrorType?) -> Void) {
        
        CTAUpdateUserNikenameRequest.init(userID: userID, nikeName: nikeName).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    let model = CTAUserModel.generateFrom(json)
                    compelecationBlock(model, CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(nil, CTARequestUserError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(nil, CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func updateUserDesc(userID:String, userDesc:String, compelecationBlock: (ErrorType?) -> Void) {
        
        CTAUpdateUserDescRequest.init(userID: userID, userDesc: userDesc).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    compelecationBlock(CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(CTARequestUserError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func updateUserIconURL(userID:String, userIconURL:String, compelecationBlock: (ErrorType?) -> Void) {
        
        CTAUpdateUserIconURLRequest.init(userID: userID, userIconURL: userIconURL).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    compelecationBlock(CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(CTARequestUserError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func updateUserAddress(userID:String, countryID: Int, provinceID: Int, cityID: Int, compelecationBlock: (ErrorType?) -> Void) {
        
        CTAUpdateUserAddressRequest.init(userID: userID, countryID: countryID, provinceID: provinceID, cityID: cityID).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    compelecationBlock(CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(CTARequestUserError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func updateUserSex(userID:String, sex: Int, compelecationBlock: (ErrorType?) -> Void) {
        
        CTAUpdateUserSexRequest.init(userID: userID, sex: sex).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    compelecationBlock(CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(CTARequestUserError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func bindingUserPhone(userID:String, phone: String, areaCode: String, compelecationBlock: (ErrorType?) -> Void) {
        
        CTABindingPhoneRequest.init(userID: userID, phone: phone, areaCode: areaCode).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    compelecationBlock(CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(CTABindingUserPhoneError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(CTAInternetError(rawValue: 10)!)
            }
        }
    }

    static func bindingUserWeixin(userID:String, weixinID: String, compelecationBlock: (ErrorType?) -> Void) {
        
        CTABindingWeixinIDRequest.init(userID: userID, weixinID: weixinID).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    compelecationBlock(CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(CTABindingUserWeixinError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func unBindingWeixinID(userID:String, compelecationBlock: (ErrorType?) -> Void) {
        
        CTAUnBindingWeixinIDRequest.init(userID: userID).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    compelecationBlock(CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(CTARequestUserError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func bindingUserWeibo(userID:String, weibo:String, compelecationBlock: (ErrorType?) -> Void) {
        
        CTABindingWeiboIDRequest.init(userID: userID, weiboID: weibo).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    compelecationBlock(CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(CTABindingUserWeiboError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func unBindingWeiboID(userID:String, compelecationBlock: (ErrorType?) -> Void) {
        
        CTAUnBindingWeiboIDRequest.init(userID: userID).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    compelecationBlock(CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(CTARequestUserError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func checkPassword(userID:String, passwd:String, compelecationBlock: (ErrorType?) -> Void) {
        
        CTACheckPasswordRequest.init(userID: userID, password: passwd).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    compelecationBlock(CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(CTACheckPasswordError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func updatePassword(userID:String, passwd:String, newPasswd:String,compelecationBlock: (ErrorType?) -> Void) {
        
        CTAUpdatePasswordRequest.init(userID: userID, password: passwd, newPassword: newPasswd).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    compelecationBlock(CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(CTARequestUserError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func resetPassword(phone: String, areaCode: String, newPassword: String, compelecationBlock: (CTAUserModel?, ErrorType?) -> Void) {
        
        CTAResetPasswordRequest.init(phone: phone, areaCode: areaCode, newPassword: newPassword).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    let model = CTAUserModel.generateFrom(json)
                    compelecationBlock(model, CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(nil, CTAResetPasswordError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(nil, CTAInternetError(rawValue: 10)!)
            }
        }
    }
    
    static func userDetail(userID: String, beUserID: String, compelecationBlock: (CTAViewUserModel?, ErrorType?) -> Void) {
        
        CTAUserDetailRequest.init(userID: userID, beUserID: beUserID).startWithCompletionBlockWithSuccess{ (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                let json:JSON = JSON(json)
                let resultindex = json[CTARequestResultKey.resultIndex].int!
                let result = checkJsonResult(json)
                if result {
                    let model = CTAViewUserModel.generateFrom(json)
                    compelecationBlock(model, CTARequestSuccess(rawValue: resultindex)!)
                } else{
                    compelecationBlock(nil, CTAUserDetailError(rawValue: resultindex)!)
                }
            case .Failure( _):
                compelecationBlock(nil, CTAInternetError(rawValue: 10)!)
            }
        }
    }
}