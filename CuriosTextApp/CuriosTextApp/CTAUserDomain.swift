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
    
    static func login(phone: String, areaCode: String, passwd: String, compelecationBlock: (CTAUserModel?, ErrorType?) -> Void)  {
        
        CTALoginRequest.init(phone: phone, areaCode: areaCode, password: passwd).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                
                do {
                    let json = JSON(json)
                    let model = try CTAUserModel.generateFrom(json)
                    compelecationBlock(model, nil)
                } catch let error as CTAUserLoginError {
                    compelecationBlock(nil, error)
                } catch {}
                
            case .Failure(let error):
                compelecationBlock(nil, error)
            }
        }
    }
    
    static func phoneRegister(phone: String, areaCode: String, passwd: String, compelecationBlock: (CTAUserModel?, ErrorType?) -> Void) {
        
        CTAPhoneRegisterRequest(phone: phone, areaCode: areaCode, password: passwd).startWithCompletionBlockWithSuccess { (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                print("json = \(json)")
                do {
                    let json = JSON(json)
                    let model = try CTAUserModel.generateFrom(json)
                    compelecationBlock(model, nil)
                } catch let error as CTAUserLoginError {
                    compelecationBlock(nil, error)
                } catch {}
                
            case .Failure(let error):
                compelecationBlock(nil, error)
            }
        }
        
    }
}