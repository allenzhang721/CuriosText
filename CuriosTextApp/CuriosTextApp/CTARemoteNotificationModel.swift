//
//  CTARemoteNotificationModel.swift
//  CuriosTextApp
//
//  Created by ting on 2016/12/26.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation
import SwiftyJSON
import Locksmith

final class CTARemoteNotificationModel: CTABaseModel{
    
    let alias:String;
    
    init(alias:String) {
        self.alias      = alias;
    }
    
    static func generateFrom(_ json: JSON) -> CTARemoteNotificationModel {
        
        let alias:String      = json[key(.alias)].string ?? "";
        
        return CTARemoteNotificationModel.init(alias: alias)
    }
    
    func save() throws {
        
        do {
            try createInSecureStore()
            
        } catch let error as NSError {
            throw error
        } catch {}
    }
    
    func getData() -> [String: Any]{
        
        return self.data
    }
}

extension CTARemoteNotificationModel: CreateableSecureStorable, GenericPasswordSecureStorable {
    
    /// The service to which the type belongs
    var service: String {
        return "com.botai.curiosText"
    }
    
    var account: String {
        return "com.botai.curiosText.noticePush"
    }
    
    var data: [String: Any] {
        return [
            key(.alias)  :self.alias as AnyObject
        ]
    }
}
