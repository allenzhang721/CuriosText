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
    typealias Info = (title: String?, description: String?, thumbnail: UIImage?, media: CTASocialManager.Media?)
    
    enum CTASocialSharePlatformType {
        case WeChat, Weibo, SMS
    }
}

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

extension CTASocialRegisterable {
    
    static func register(platform: CTASocialManager.CTASocialSharePlatformType, appID: String, appKey: String) {
        
        switch platform {
        case .WeChat:
            MonkeyKing.registerAccount(.WeChat(appID: appID, appKey: appKey))
        case .Weibo:
            MonkeyKing.registerAccount(.Weibo(appID: appID, appKey: appKey, redirectURL: ""))
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

protocol CTASocialOAuthable: class {
    
    static func OAuth(platform: CTASocialManager.CTASocialSharePlatformType, completionHandler: CTASocialManager.OAuthCompletionHandler)
}

extension CTASocialOAuthable {
    
    static func OAuth(platform: CTASocialManager.CTASocialSharePlatformType, completionHandler: CTASocialManager.OAuthCompletionHandler) {
        
        switch platform {
        case .WeChat:
            MonkeyKing.OAuth(.WeChat, completionHandler: completionHandler)
            
        case .Weibo:
            MonkeyKing.OAuth(.Weibo, completionHandler: completionHandler)
        default:
            ()
        }
    }
}