//
//  CTASocialShareManager.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/28/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
import MonkeyKing

typealias CTASocialProtocol = CTASocialRegisterable & CTASocialOAuthable

class CTASocialManager: CTASocialProtocol {

    typealias SMSCompletionHandler = (_ result: Bool) -> Void
    typealias SharedCompletionHandler = (_ result: Bool) -> Void
    typealias OAuthCompletionHandler = (NSDictionary?, URLResponse?, NSError?) -> Void
    typealias LoginCompletionHandler = (NSDictionary?, URLResponse?, NSError?) -> Void
    typealias Info = (title: String?, description: String?, thumbnail: UIImage?, media: CTASocialManager.Media?)
    
    enum CTASocialSharePlatformType {
        case weChat, weibo, sms
    }
}

// SMS
extension CTASocialManager {
    
    static func getVerificationCode(_ phoneNumber: String, zone: String!, completionHandler: @escaping SMSCompletionHandler) {
        
        SMSSDK.getVerificationCode(by: SMSGetCodeMethod(0), phoneNumber: phoneNumber, zone: zone, customIdentifier: nil) { (error) -> Void in
            
            completionHandler(error == nil ? true : false)
        }
    }
    
    static func commitVerificationCode(_ code: String, phoneNumber: String, zone: String!, completionHandler: @escaping SMSCompletionHandler) {
        
        SMSSDK.commitVerificationCode(code, phoneNumber: phoneNumber, zone: zone) { (error) -> Void in
            
            completionHandler(error == nil ? true : false)
        }
    }
}

protocol CTASocialRegisterable {
    
    static func register(_ platform: CTASocialManager.CTASocialSharePlatformType, appID: String, appKey: String)
    static func handleOpenURL(_ url: URL) -> Bool
}


// Register
extension CTASocialRegisterable {
    
    static func register(_ platform: CTASocialManager.CTASocialSharePlatformType, appID: String, appKey: String) {
        
        switch platform {
        case .weChat:
            MonkeyKing.registerAccount(.weChat(appID: appID, appKey: appKey))
        case .weibo:
            MonkeyKing.registerAccount(.weibo(appID: appID, appKey: appKey, redirectURL: "http://api.weibo.com/oauth2/default.html"))
        case .sms:
            SMSSDK.registerApp(appKey, withSecret: appID)
        }
    }
    
    static func handleOpenURL(_ url: URL) -> Bool {
        return MonkeyKing.handleOpenURL(url)
    }
}

protocol CTASocialShareable {
  
}

extension CTASocialManager: CTASocialShareable {

    enum Media {
        case url(Foundation.URL)
        case image(UIImage)
        case audio(audioURL: Foundation.URL, linkURL: Foundation.URL?)
        case video(Foundation.URL)
        
        func toMonkeyKingMedia() -> MonkeyKing.Media {
            
            switch self {
            case .url(let url):
                return MonkeyKing.Media.url(url)
            case .image(let image):
                return MonkeyKing.Media.image(image)
            case .audio(audioURL: let audioURL, linkURL: let linkURL):
                return MonkeyKing.Media.audio(audioURL: audioURL, linkURL: linkURL)
            case .video(let url):
                return MonkeyKing.Media.video(url)
            }
        }
    }
    
     enum Message {
         enum WeChatSubtype {
            case session(info: CTASocialManager.Info)
            case timeline(info: CTASocialManager.Info)
            case favorite(info: CTASocialManager.Info)
            
            func toMonkeyKingSubtype() -> MonkeyKing.Message.WeChatSubtype {
                
                switch self {
                case .session(info: (title: let title, description: let description, thumbnail: let thumbnail, media: let media)):
                    return MonkeyKing.Message.WeChatSubtype.session(info: (title: title, description: description, thumbnail: thumbnail, media: media?.toMonkeyKingMedia()))
                    
                case .timeline(info: (title: let title, description: let description, thumbnail: let thumbnail, media: let media)):
                    return MonkeyKing.Message.WeChatSubtype.timeline(info: (title: title, description: description, thumbnail: thumbnail, media: media?.toMonkeyKingMedia()))
                    
                case .favorite(info: (title: let title, description: let description, thumbnail: let thumbnail, media: let media)):
                    return MonkeyKing.Message.WeChatSubtype.favorite(info: (title: title, description: description, thumbnail: thumbnail, media: media?.toMonkeyKingMedia()))
                }
                
            }
        }
        case weChat(CTASocialManager.Message.WeChatSubtype)

        enum WeiboSubtype {
            case `default`(info: CTASocialManager.Info, accessToken: String?)
            
            func toMonkeyKingSubtype() -> MonkeyKing.Message.WeiboSubtype {
                
                switch self {
                case .default(info: (title: let title, description: let description, thumbnail: let thumbnail, media: let media), accessToken: let accessToken):
                    return MonkeyKing.Message.WeiboSubtype.default(info: (title: title, description: description, thumbnail: thumbnail, media: media?.toMonkeyKingMedia()), accessToken: accessToken)
                }
            }
        }
        case weibo(CTASocialManager.Message.WeiboSubtype)

        
         func toMonkeyKingMessage() -> MonkeyKing.Message {
            
            switch self {
            case .weChat(let weChatSubtype):
                return MonkeyKing.Message.weChat(weChatSubtype.toMonkeyKingSubtype())
                
            case .weibo(let weiboSubtype):
                return MonkeyKing.Message.weibo(weiboSubtype.toMonkeyKingSubtype())
            }
        }
    }
    class func shareMessage(_ message: CTASocialManager.Message, completionHandler: @escaping CTASocialManager.SharedCompletionHandler) {
        
        MonkeyKing.deliver(message.toMonkeyKingMessage(), completionHandler: completionHandler)
    }
}

extension CTASocialManager{
    
    static func isAppInstaller(_ platform: CTASocialManager.CTASocialSharePlatformType) -> Bool {
        switch platform {
        case .weChat:
            return MonkeyKing.Account.weChat(appID: "", appKey: "").isAppInstalled
        case .weibo:
            let weiboAcount = MonkeyKing.Account.weibo(appID: "", appKey: "", redirectURL: "")
            return weiboAcount.isAppInstalled || weiboAcount.canWebOAuth
        default:
            return true
        }
    }
}

protocol CTASocialOAuthable: class {
    
    static func oauth(_ platform: CTASocialManager.CTASocialSharePlatformType, completionHandler: @escaping (CTASocialManager.OAuthCompletionHandler))
}

extension CTASocialManager {
    
    static func oauth(_ platform: CTASocialManager.CTASocialSharePlatformType, completionHandler: @escaping CTASocialManager.OAuthCompletionHandler) {
        switch platform {
        case .weChat:
            
            MonkeyKing.oauth(for: .weChat, completionHandler: {(dictionary, response, error) -> Void in
                if error == nil {
                    CTASocialManager.fetchUserInfo(dictionary as NSDictionary?, completeBlock: { (userInfoDictionary, response, error) in
                        
                        completionHandler(userInfoDictionary, response, error)
                    })
                }else {
                    completionHandler(nil, nil, error as NSError?)
                }
            })
            
        case .weibo:
            MonkeyKing.oauth(for: .weibo, completionHandler: { (OAuthInfo, response, error) in
                if error == nil {
                    debug_print(OAuthInfo)
                    
                    // App or Web: token & userID
                    guard let token = (OAuthInfo?["access_token"] ?? OAuthInfo?["accessToken"]) as? String, let userID = (OAuthInfo?["uid"] ?? OAuthInfo?["userID"]) as? String, let expireDate = OAuthInfo?["expirationDate"] else {
                        return
                    }
    
                    UserDefaults.standard.setValue(userID, forKey: userID + "userID")
                    UserDefaults.standard.setValue(token, forKey: userID + "token")
                    UserDefaults.standard.setValue(expireDate, forKey: userID + "expireDate")
                    
                    completionHandler(OAuthInfo as NSDictionary?, response, error as NSError?)
                    
//                    let userInfoAPI = "https://api.weibo.com/2/users/show.json"
//                    let parameters = ["uid": userID, "access_token": token]
//                    
//                    // fetch UserInfo by userInfoAPI
//                    SimpleNetworking.sharedInstance.request(userInfoAPI, method: .GET, parameters: parameters, completionHandler: { (userInfoDictionary, _, _) -> Void in
//                        print("userInfoDictionary \(userInfoDictionary)")
//                    })
                    
                    
                } else {
                    completionHandler(nil, nil, error as NSError?)
                }
            })
        default:
            ()
        }
    }
    
    static func needOAuthOrGetTokenByUserID(_ userID: String) -> String? {

        if let expireDate = UserDefaults.standard.value(forKey: userID + "expireDate"), Date().compare(expireDate as! Date) == .orderedAscending, let token = UserDefaults.standard.value(forKey: userID + "token") as? String {
            
            return token
            
        } else {
            
            return nil
        }
        
        
        
    }
    
    static func reOAuthWeiboGetAccessToken (_ userID: String, completed: ((_ token: String?, _ weiboID: String?) -> ())?) {
        
        oauth(.weibo) { (OAuthInfo, _, _) in
            guard let token = (OAuthInfo?["access_token"] ?? OAuthInfo?["accessToken"]) as? String, let _ = (OAuthInfo?["uid"] ?? OAuthInfo?["userID"] ?? "") as? String, let _ = OAuthInfo?["expirationDate"] else {
                completed?(nil, nil)
                return
            }
            
            saveToken(userID, OAuthInfo: OAuthInfo)
            completed?(token, userID)
        }
    }
    
    static func saveToken(_ userID:String, OAuthInfo: NSDictionary?){
        guard let token = (OAuthInfo?["access_token"] ?? OAuthInfo?["accessToken"]) as? String, let _ = (OAuthInfo?["uid"] ?? OAuthInfo?["userID"] ?? "") as? String, let expireDate = OAuthInfo?["expirationDate"] else {
            return
        }
        UserDefaults.standard.setValue(userID, forKey: userID + "userID")
        UserDefaults.standard.setValue(token, forKey: userID + "token")
        UserDefaults.standard.setValue(expireDate, forKey: userID + "expireDate")
    }
}

extension CTASocialOAuthable {
    
    fileprivate static func fetchUserInfo(_ OAuthInfo: NSDictionary?, completeBlock: @escaping (NSDictionary?, URLResponse?, NSError?) -> Void) {
        
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
        SimpleNetworking.sharedInstance.request(userInfoAPI, method: .GET, parameters: parameters as [String : AnyObject]?, completionHandler: { (userInfoDictionary, r, e) -> Void in
            
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
    
    fileprivate static func fetchWeiboUserInfo(_ OAuthInfo: NSDictionary?, completionHandler: @escaping CTASocialManager.LoginCompletionHandler) {
        
        // App or Web: token & userID
        guard let token = (OAuthInfo?["access_token"] ?? OAuthInfo?["accessToken"] ?? "") as? String, let userID = (OAuthInfo?["uid"] ?? OAuthInfo?["userID"]) as? String else {
            let error = NSError(domain: "social", code: -3, userInfo: nil)
            completionHandler(nil, nil, error)
            return
        }
        
        let userInfoAPI = "https://api.weibo.com/2/users/show.json"
        let parameters = ["uid": userID, "access_token": token]
        
        // fetch UserInfo by userInfoAPI
        SimpleNetworking.sharedInstance.request(userInfoAPI, method: .GET, parameters: parameters as [String : AnyObject]?, completionHandler: { (userInfoDictionary, r, e) -> Void in
//            print("userInfoDictionary \(userInfoDictionary)")
            completionHandler(userInfoDictionary, r, e)
        })
    }
}

protocol CTASocialLoginable {
    
    func login(_ platform: CTASocialManager.CTASocialSharePlatformType, OAuthInfo: NSDictionary?, completionHandler: @escaping CTASocialManager.LoginCompletionHandler)
}

extension CTASocialLoginable {
    
    func login(_ platform: CTASocialManager.CTASocialSharePlatformType, OAuthInfo: NSDictionary?,completionHandler: @escaping CTASocialManager.LoginCompletionHandler) {
        
        switch platform {
        case .weChat:
            CTASocialManager.fetchUserInfo(OAuthInfo, completeBlock: completionHandler)
            
        case .weibo:
            CTASocialManager.fetchWeiboUserInfo(OAuthInfo, completionHandler: completionHandler)
            
        default:
            let error = NSError(domain: "social", code: -3, userInfo: nil)
            completionHandler(nil, nil, error)
        }
    }
}







