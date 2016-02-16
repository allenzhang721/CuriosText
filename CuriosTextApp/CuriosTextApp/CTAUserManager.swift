//
//  CTAUserManager.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/28/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
import Locksmith
import SwiftyJSON

class CTAUserManager {
    
    static let account = "com.botai.curiosText.LatestAccount"
    static let service = "com.botai.curiosText"
    
    static private(set) var user: CTAUserModel?
    
    class func save(user: CTAUserModel) -> Bool {
        
        do {
            try Locksmith.saveData(user.data, forUserAccount: account, inService: service)
            CTAUserManager.user = user
            
            return true
            
        } catch let error {
            
            debug_print("Error = \(error)")
            return false
        }
    }
    
    class func load() -> Bool {
        
        guard let dic = Locksmith.loadDataForUserAccount(account, inService: service) else {
            return false
        }
        
        let json = JSON(dic)
        let user = CTAUserModel.generateFrom(json)
        CTAUserManager.user = user
        return true
    }
    
    class func logout() -> Bool {
        
        do {
            try Locksmith.deleteDataForUserAccount(account, inService: service)
            user = nil
            return true
        } catch {
            return false
        }
    }
}