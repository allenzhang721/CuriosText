//
//  CTARemoteNotificationDomain.swift
//  JpushDemo
//
//  Created by Emiaostein on 23/12/2016.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

class CTARemoteNotificationManager {
    
    // 注册特定用户的通知。在用户登录时使用。例如：点赞等；
    class func registerAtLoginWithUserID(_ alias: String, completed: @escaping (_ iResCode: Int32, _ iTags: Set<AnyHashable>?, _ iAlias: String?) -> ()) {
        JPUSHService.setTags(nil, alias: alias, fetchCompletionHandle: completed)
    }
    
    // 取消特定用户的通知。在退出登录时使用。
    class func registerAtLogOut(_ completed: @escaping (_ iResCode: Int32, _ iTags: Set<AnyHashable>?, _ iAlias: String?) -> ()) {
        JPUSHService.setTags(nil, alias: "", fetchCompletionHandle: completed)
    }
    
//    class func registerWith(tags: Set<String>, alias: String, completed: @escaping (_ iResCode: Int32, _ iTags: Set<AnyHashable>?, _ iAlias: String?) -> ()) {
//        JPUSHService.setTags(tags, alias: alias, fetchCompletionHandle: completed)
//    }
}
