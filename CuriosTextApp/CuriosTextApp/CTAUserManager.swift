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
    
    static private(set) var user: CTAUserModel?
    
    class func save(user: CTAUserModel) -> Bool {
        
        do {
            try Locksmith.saveData(user.data, forUserAccount: "LatestAccount", inService: "com.botai.curiosText")
            CTAUserManager.user = user
            
            return true
            
        } catch {
            
            return false
        }
    }
    
    class func load() -> Bool {
        
        guard let dic = Locksmith.loadDataForUserAccount("LatestAccount", inService: "com.botai.curiosText") else {
            return false
        }
        
        let json = JSON(dic)
        let user = CTAUserModel.generateFrom(json)
        CTAUserManager.user = user
        return true
    }
}