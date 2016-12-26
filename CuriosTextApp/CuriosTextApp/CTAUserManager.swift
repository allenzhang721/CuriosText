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
    
    static let noticeKey = "com.botai.curiosText.NoticePush"
    static let account = "com.botai.curiosText.LatestAccount"
    static let service = "com.botai.curiosText"
    
    static fileprivate(set) var user: CTAUserModel?
    static var isLogin: Bool {
        return CTAUserManager.user != nil
    }
    
    static var notice: CTARemoteNotificationModel?
    
    class func save(_ user: CTAUserModel) -> Bool {
        
        do {
            try Locksmith.saveData(data: user.data, forUserAccount: account, inService: service)
            CTAUserManager.user = user
            saveNotice()
            
            return true
            
        } catch let error {
            
            debug_print("Error = \(error)")
            return false
        }
    }
    
    class func load() -> Bool {
        
        guard let dic = Locksmith.loadDataForUserAccount(userAccount: account, inService: service) else {
            return false
        }
        
        let json = JSON(dic)
        let user = CTAUserModel.generateFrom(json)
        CTAUserManager.user = user
        loadNotice()
        return true
    }
    
    class func logout() -> Bool {
        
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: account, inService: service)
            user = nil
            logoutNotice()
            return true
        } catch {
            return false
        }
    }
    
    class func saveNotice() -> Bool {
        if(user == nil){
            return false
        }
        var isSave: Bool = false;
        let alias = user!.userID;
        if(notice == nil){
            isSave = true;
        }else if(notice?.alias != alias){
            isSave = true;
        }
        if(isSave){
            do{
                let remote = CTARemoteNotificationModel.init(alias: alias);
                
                try Locksmith.saveData(data: remote.data, forUserAccount: noticeKey, inService: service)
                CTAUserManager.notice = remote
                
                CTARemoteNotificationManager.registerAtLoginWithUserID(alias, completed: { (code, tags, alias) in
                    debug_print("code = \(code) alias = \(alias)")
                })
                return true
            }catch let error {
                
                debug_print("Error = \(error)")
                return false
            }
        }else {
            return true
        }
    }
    
    class func loadNotice() -> Bool {
        guard let dic = Locksmith.loadDataForUserAccount(userAccount: noticeKey, inService: service) else {
            return saveNotice();
        }
        
        let json = JSON(dic)
        let remote = CTARemoteNotificationModel.generateFrom(json)
        CTAUserManager.notice = remote
        return true
    }
    
    class func logoutNotice() -> Bool {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: noticeKey, inService: service)
            notice = nil
            CTARemoteNotificationManager.registerAtLogOut({ (code, tags, alias) in
                
            })
            return true
        } catch {
            return false
        }
    }

}
