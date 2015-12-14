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

struct CTAUserModel: CTABaseModel, CreateableSecureStorable, GenericPasswordSecureStorable {
    
    
    struct SerialazitionKey {
        static let userName = "userName"
        static let phone = "phone"
        static let weChat = "weChat"
    }
    
    let userName: String
    let phone:String
    let weChat:String
    
    
    static func generateFrom(json: JSON) throws -> CTAUserModel {
        
        guard let reslut = json[CTARequestResultKey.result].string where reslut == CTARequestResultKey.success else {
            let failReslut = json[CTARequestResultKey.resultIndex].int!
            throw CTAUserLoginError(rawValue: failReslut)!
        }
        
        let userName = json[SerialazitionKey.userName].string!
        let phone = json[SerialazitionKey.phone].string!
        let weChat = json[SerialazitionKey.weChat].string!
        
        return CTAUserModel(userName: userName, phone: phone, weChat: weChat)
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
        return userName
    }
    
    var data: [String: AnyObject] {
        return [
            SerialazitionKey.userName: userName,
            SerialazitionKey.phone: phone,
            SerialazitionKey.weChat: weChat
        ]
    }
}