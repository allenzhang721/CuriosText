//
//  CTASocialShareManager.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/28/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
import MonkeyKing

typealias CTASocialProtocol = protocol<CTASocialRegisterable, CTASocialOAuthable>

class CTASocialManager: CTASocialProtocol {
    
    typealias SMSCompletionHandler = (result: Bool) -> Void
    typealias SharedCompletionHandler = (result: Bool) -> Void
    typealias OAuthCompletionHandler = (NSDictionary?, NSURLResponse?, NSError?) -> Void
    typealias LoginCompletionHandler = (NSDictionary?, NSURLResponse?, NSError?) -> Void
    typealias Info = (title: String?, description: String?, thumbnail: UIImage?, media: CTASocialManager.Media?)
    
    enum CTASocialSharePlatformType {
        case WeChat, Weibo, SMS
    }
}

// SMS
extension CTASocialManager {
    
    static func getVerificationCode(phoneNumber: String, zone: String!, completionHandler: SMSCompletionHandler) {
        
        SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethod(0), phoneNumber: phoneNumber, zone: zone, customIdentifier: nil) { (error) -> Void in
            
            completionHandler(result: error == nil ? true : false)
        }
    }
    
    static func commitVerificationCode(code: String, phoneNumber: String, zone: String!, completionHandler: SMSCompletionHandler) {
        
        SMSSDK.commitVerificationCode(code, phoneNumber: phoneNumber, zone: zone) { (error) -> Void in
            
            completionHandler(result: error == nil ? true : false)
        }
    }
}

protocol CTASocialRegisterable {
    
    static func register(platform: CTASocialManager.CTASocialSharePlatformType, appID: String, appKey: String)
    static func handleOpenURL(url: NSURL) -> Bool
}


// Register
extension CTASocialRegisterable {
    
    static func register(platform: CTASocialManager.CTASocialSharePlatformType, appID: String, appKey: String) {
        
        switch platform {
        case .WeChat:
            MonkeyKing.registerAccount(.WeChat(appID: appID, appKey: appKey))
        case .Weibo:
            MonkeyKing.registerAccount(.Weibo(appID: appID, appKey: appKey, redirectURL: "http://api.weibo.com/oauth2/default.html"))
        case .SMS:
            SMSSDK.registerApp(appKey, withSecret: appID)
        }
    }
    
    static func handleOpenURL(url: NSURL) -> Bool {
        return MonkeyKing.handleOpenURL(url)
    }
}

protocol CTASocialShareable {
  
}

extension CTASocialManager: CTASocialShareable {

    enum Media {
        case URL(NSURL)
        case Image(UIImage)
        case Audio(audioURL: NSURL, linkURL: NSURL?)
        case Video(NSURL)
        
        func toMonkeyKingMedia() -> MonkeyKing.Media {
            
            switch self {
            case .URL(let url):
                return MonkeyKing.Media.URL(url)
            case .Image(let image):
                return MonkeyKing.Media.Image(image)
            case .Audio(audioURL: let audioURL, linkURL: let linkURL):
                return MonkeyKing.Media.Audio(audioURL: audioURL, linkURL: linkURL)
            case .Video(let url):
                return MonkeyKing.Media.Video(url)
            }
        }
    }
    
     enum Message {
         enum WeChatSubtype {
            case Session(info: CTASocialManager.Info)
            case Timeline(info: CTASocialManager.Info)
            case Favorite(info: CTASocialManager.Info)
            
            func toMonkeyKingSubtype() -> MonkeyKing.Message.WeChatSubtype {
                
                switch self {
                case .Session(info: (title: let title, description: let description, thumbnail: let thumbnail, media: let media)):
                    return MonkeyKing.Message.WeChatSubtype.Session(info: (title: title, description: description, thumbnail: thumbnail, media: media?.toMonkeyKingMedia()))
                    
                case .Timeline(info: (title: let title, description: let description, thumbnail: let thumbnail, media: let media)):
                    return MonkeyKing.Message.WeChatSubtype.Timeline(info: (title: title, description: description, thumbnail: thumbnail, media: media?.toMonkeyKingMedia()))
                    
                case .Favorite(info: (title: let title, description: let description, thumbnail: let thumbnail, media: let media)):
                    return MonkeyKing.Message.WeChatSubtype.Favorite(info: (title: title, description: description, thumbnail: thumbnail, media: media?.toMonkeyKingMedia()))
                }
                
            }
        }
        case WeChat(CTASocialManager.Message.WeChatSubtype)

        enum WeiboSubtype {
            case Default(info: CTASocialManager.Info, accessToken: String?)
            
            func toMonkeyKingSubtype() -> MonkeyKing.Message.WeiboSubtype {
                
                switch self {
                case .Default(info: (title: let title, description: let description, thumbnail: let thumbnail, media: let media), accessToken: let accessToken):
                    return MonkeyKing.Message.WeiboSubtype.Default(info: (title: title, description: description, thumbnail: thumbnail, media: media?.toMonkeyKingMedia()), accessToken: accessToken)
                }
            }
        }
        case Weibo(CTASocialManager.Message.WeiboSubtype)

        
         func toMonkeyKingMessage() -> MonkeyKing.Message {
            
            switch self {
            case .WeChat(let weChatSubtype):
                return MonkeyKing.Message.WeChat(weChatSubtype.toMonkeyKingSubtype())
                
            case .Weibo(let weiboSubtype):
                return MonkeyKing.Message.Weibo(weiboSubtype.toMonkeyKingSubtype())
            }
        }
    }
    class func shareMessage(message: CTASocialManager.Message, completionHandler: CTASocialManager.SharedCompletionHandler) {
        
        MonkeyKing.shareMessage(message.toMonkeyKingMessage(), completionHandler: completionHandler)
    }
}

extension CTASocialManager{
    
    static func isAppInstaller(platform: CTASocialManager.CTASocialSharePlatformType) -> Bool {
        switch platform {
        case .WeChat:
            return MonkeyKing.Account.WeChat(appID: "", appKey: "").isAppInstalled
        case .Weibo:
            let weiboAcount = MonkeyKing.Account.Weibo(appID: "", appKey: "", redirectURL: "")
            return weiboAcount.isAppInstalled || weiboAcount.canWebOAuth
        default:
            return true
        }
    }
}

protocol CTASocialOAuthable: class {
    
    static func OAuth(platform: CTASocialManager.CTASocialSharePlatformType, completionHandler: CTASocialManager.OAuthCompletionHandler)
}

extension CTASocialOAuthable {
    
    static func OAuth(platform: CTASocialManager.CTASocialSharePlatformType, completionHandler: CTASocialManager.OAuthCompletionHandler) {
        switch platform {
        case .WeChat:
            
            MonkeyKing.OAuth(.WeChat, completionHandler: {(dictionary, response, error) -> Void in
                if error == nil {
                    CTASocialManager.fetchUserInfo(dictionary, completeBlock: { (userInfoDictionary, response, error) in
                        
                        completionHandler(userInfoDictionary, response, error)
                    })
                }else {
                    completionHandler(nil, nil, error)
                }
            })
            
        case .Weibo:
            MonkeyKing.OAuth(.Weibo, completionHandler: { (OAuthInfo, response, error) in
                if error == nil {
                    debug_print(OAuthInfo)
                    
                    // App or Web: token & userID
                    guard let token = (OAuthInfo?["access_token"] ?? OAuthInfo?["accessToken"]) as? String, userID = (OAuthInfo?["uid"] ?? OAuthInfo?["userID"]) as? String, let expireDate = OAuthInfo?["expirationDate"] else {
                        return
                    }
    
                    NSUserDefaults.standardUserDefaults().setValue(userID, forKey: userID + "userID")
                    NSUserDefaults.standardUserDefaults().setValue(token, forKey: userID + "token")
                    NSUserDefaults.standardUserDefaults().setValue(expireDate, forKey: userID + "expireDate")
                    
                    completionHandler(OAuthInfo, response, error)
                    
//                    let userInfoAPI = "https://api.weibo.com/2/users/show.json"
//                    let parameters = ["uid": userID, "access_token": token]
//                    
//                    // fetch UserInfo by userInfoAPI
//                    SimpleNetworking.sharedInstance.request(userInfoAPI, method: .GET, parameters: parameters, completionHandler: { (userInfoDictionary, _, _) -> Void in
//                        print("userInfoDictionary \(userInfoDictionary)")
//                    })
                    
                    
                } else {
                    completionHandler(nil, nil, error)
                }
            })
        default:
            ()
        }
    }
    
    static func needOAuthOrGetTokenByUserID(userID: String) -> String? {

        if let expireDate = NSUserDefaults.standardUserDefaults().valueForKey(userID + "expireDate") where NSDate().compare(expireDate as! NSDate) == .OrderedAscending, let token = NSUserDefaults.standardUserDefaults().valueForKey(userID + "token") as? String {
            
            return token
            
        } else {
            
            return nil
        }
        
        
        
    }
    
    static func reOAuthWeiboGetAccessToken (completed: ((token: String?, weiboID: String?) -> ())?) {
        
        OAuth(.Weibo) { (OAuthInfo, _, _) in
            guard let token = (OAuthInfo?["access_token"] ?? OAuthInfo?["accessToken"]) as? String, userID = (OAuthInfo?["uid"] ?? OAuthInfo?["userID"]) as? String, let expireDate = OAuthInfo?["expirationDate"] else {
                completed?(token: nil, weiboID: nil)
                return
            }
            
            NSUserDefaults.standardUserDefaults().setValue(userID, forKey: userID + "userID")
            NSUserDefaults.standardUserDefaults().setValue(token, forKey: userID + "token")
            NSUserDefaults.standardUserDefaults().setValue(expireDate, forKey: userID + "expireDate")
            completed?(token: token, weiboID: userID)
        }
    }
}

extension CTASocialOAuthable {
    
    private static func fetchUserInfo(OAuthInfo: NSDictionary?, completeBlock: (NSDictionary?, NSURLResponse?, NSError?) -> Void) {
        
        guard let token = OAuthInfo?["access_token"] as? String,
            let openID = OAuthInfo?["openid"] as? String,
            let refreshToken = OAuthInfo?["refresh_token"] as? String,
            let expiresIn = OAuthInfo?["expires_in"] as? Int else {
                
                let error = NSError(domain: "social", code: -3, userInfo: nil)
                completeBlock(nil, nil, error)
                return
        }
        
        let userInfoAPI = "https://api.weixin.qq.com/sns/userinfo"
        
        let parameters = [
            "openid": openID,
            "access_token": token
        ]
        
        // fetch UserInfo by userInfoAPI
        SimpleNetworking.sharedInstance.request(userInfoAPI, method: .GET, parameters: parameters, completionHandler: { (userInfoDictionary, r, e) -> Void in
            
            guard let mutableDictionary = userInfoDictionary?.mutableCopy() as? NSMutableDictionary else {
                let error = NSError(domain: "social", code: -3, userInfo: nil)
                completeBlock(nil, nil, error)
                return
            }
            
            mutableDictionary["access_token"] = token
            mutableDictionary["openid"] = openID
            mutableDictionary["refresh_token"] = refreshToken
            mutableDictionary["expires_in"] = expiresIn
            
            completeBlock(mutableDictionary, r, e)
        })
        
        // More API
        // http://mp.weixin.qq.com/wiki/home/index.html
    }
    
    private static func fetchWeiboUserInfo(OAuthInfo: [String: AnyObject]?, completionHandler: CTASocialManager.LoginCompletionHandler) {
        
        // App or Web: token & userID
        guard let token = (OAuthInfo?["access_token"] ?? OAuthInfo?["accessToken"]) as? String, userID = (OAuthInfo?["uid"] ?? OAuthInfo?["userID"]) as? String else {
            let error = NSError(domain: "social", code: -3, userInfo: nil)
            completionHandler(nil, nil, error)
            return
        }
        
        let userInfoAPI = "https://api.weibo.com/2/users/show.json"
        let parameters = ["uid": userID, "access_token": token]
        
        // fetch UserInfo by userInfoAPI
        SimpleNetworking.sharedInstance.request(userInfoAPI, method: .GET, parameters: parameters, completionHandler: { (userInfoDictionary, r, e) -> Void in
//            print("userInfoDictionary \(userInfoDictionary)")
            completionHandler(userInfoDictionary, r, e)
        })
    }
}

protocol CTASocialLoginable {
    
    func login(platform: CTASocialManager.CTASocialSharePlatformType, completionHandler: CTASocialManager.LoginCompletionHandler)
}

extension CTASocialLoginable {
    
    func login(platform: CTASocialManager.CTASocialSharePlatformType, OAuthInfo: [String: AnyObject],completionHandler: CTASocialManager.LoginCompletionHandler) {
        
        switch platform {
        case .WeChat:
            CTASocialManager.fetchUserInfo(OAuthInfo, completeBlock: completionHandler)
            
        case .Weibo:
            CTASocialManager.fetchWeiboUserInfo(OAuthInfo, completionHandler: completionHandler)
            
        default:
            let error = NSError(domain: "social", code: -3, userInfo: nil)
            completionHandler(nil, nil, error)
        }
    }
}







