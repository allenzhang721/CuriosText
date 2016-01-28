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

class CTASocialShareManager: CTASocialProtocol {
    
    typealias SharedCompletionHandler = (result: Bool) -> Void
    typealias OAuthCompletionHandler = (NSDictionary?, NSURLResponse?, NSError?) -> Void
    typealias Info = (title: String?, description: String?, thumbnail: UIImage?, media: CTASocialShareManager.Media?)
    
    enum CTASocialSharePlatformType {
        case WeChat, Weibo
    }
}

protocol CTASocialRegisterable {
    
    static func register(platform: CTASocialShareManager.CTASocialSharePlatformType, appID: String, appKey: String)
    static func handleOpenURL(url: NSURL) -> Bool
}

extension CTASocialRegisterable {
    
    static func register(platform: CTASocialShareManager.CTASocialSharePlatformType, appID: String, appKey: String) {
        
        switch platform {
        case .WeChat:
            MonkeyKing.registerAccount(.WeChat(appID: appID, appKey: appKey))
        case .Weibo:
            MonkeyKing.registerAccount(.Weibo(appID: appID, appKey: appKey, redirectURL: ""))
        }
    }
    
    static func handleOpenURL(url: NSURL) -> Bool {
        return MonkeyKing.handleOpenURL(url)
    }
}

protocol CTASocialShareable {
  
}

extension CTASocialShareManager: CTASocialShareable {
    
    
    
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
    
    
//    
//    func toMonkeyKingInfo(info: CTASocialShareManager.Info) -> MonkeyKing.Info {
//        
//        return (title: info.title, description: info.description, thumbnail: info.thumbnail, media: info.media?.toMonkeyKingMedia())
//    }
    
     enum Message {
         enum WeChatSubtype {
            case Session(info: CTASocialShareManager.Info)
            case Timeline(info: CTASocialShareManager.Info)
            case Favorite(info: CTASocialShareManager.Info)
            
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
        case WeChat(CTASocialShareManager.Message.WeChatSubtype)

        enum WeiboSubtype {
            case Default(info: CTASocialShareManager.Info, accessToken: String?)
            
            func toMonkeyKingSubtype() -> MonkeyKing.Message.WeiboSubtype {
                
                switch self {
                case .Default(info: (title: let title, description: let description, thumbnail: let thumbnail, media: let media), accessToken: let accessToken):
                    return MonkeyKing.Message.WeiboSubtype.Default(info: (title: title, description: description, thumbnail: thumbnail, media: media?.toMonkeyKingMedia()), accessToken: accessToken)
                }
            }
        }
        case Weibo(CTASocialShareManager.Message.WeiboSubtype)

        
         func toMonkeyKingMessage() -> MonkeyKing.Message {
            
            switch self {
            case .WeChat(let weChatSubtype):
                return MonkeyKing.Message.WeChat(weChatSubtype.toMonkeyKingSubtype())
                
            case .Weibo(let weiboSubtype):
                return MonkeyKing.Message.Weibo(weiboSubtype.toMonkeyKingSubtype())
            }
        }
    }
    class func shareMessage(message: CTASocialShareManager.Message, completionHandler: CTASocialShareManager.SharedCompletionHandler) {
        
        MonkeyKing.shareMessage(message.toMonkeyKingMessage(), completionHandler: completionHandler)
    }
}

protocol CTASocialOAuthable: class {
    
    static func OAuth(platform: CTASocialShareManager.CTASocialSharePlatformType, completionHandler: CTASocialShareManager.OAuthCompletionHandler)
}

extension CTASocialOAuthable {
    
    static func OAuth(platform: CTASocialShareManager.CTASocialSharePlatformType, completionHandler: CTASocialShareManager.OAuthCompletionHandler) {
        
        switch platform {
        case .WeChat:
            MonkeyKing.OAuth(.WeChat, completionHandler: completionHandler)
            
        case .Weibo:
            MonkeyKing.OAuth(.Weibo, completionHandler: completionHandler)
        }
    }
}