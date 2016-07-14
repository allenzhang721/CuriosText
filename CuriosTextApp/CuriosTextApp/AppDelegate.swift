//
//  AppDelegate.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/4/15.
//  Copyright © 2015 botai. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {
    
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        setup()
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        SVProgressHUD.setDefaultMaskType(.Clear)
        SVProgressHUD.setDefaultStyle(.Custom)
        SVProgressHUD.setForegroundColor(CTAStyleKit.selectedColor)
        SVProgressHUD.setBackgroundColor(UIColor.whiteColor())
        
        return true
    }
    
    func setup() {
        
        cleanFontCache()
        registerLocalFonts()
        registerSystemFonts()
        familiesDisplayNames()
        familiesFixRatio()
        ImageCache.defaultCache.maxMemoryCost = 80 * 1024 * 1024 // Allen: 80 MB
        // Override point for customization after application launch.
        #if DEBUG
            CTANetworkConfig.shareInstance.baseUrl = CTARequestHost.Test.description
        #else
            CTANetworkConfig.shareInstance.baseUrl = CTARequestHost.Production.description
        #endif
        
        WXApi.registerApp(CTAConfigs.weChat.appID)
        WeiboSDK.registerApp(CTAConfigs.weibo.appID)
        CTASocialManager.register(.WeChat, appID: CTAConfigs.weChat.appID, appKey: CTAConfigs.weChat.appKey)
        CTASocialManager.register(.Weibo, appID: CTAConfigs.weibo.appID, appKey: CTAConfigs.weibo.appKey)
        CTASocialManager.register(.SMS, appID: CTAConfigs.SMS.appID, appKey: CTAConfigs.SMS.appKey) // http://dashboard.mob.com/#/sms/index
    }
    
    func cleanFontCache() {
        CTAFontsManager.cleanCacheFamilyList()
        CTAFontsManager.cleanCacheFamily()
    }
    
    func registerLocalFonts() {
        
        let fontsName = "Fonts"
        let path = NSBundle.mainBundle().bundleURL
        let fontsDirUrl = path.URLByAppendingPathComponent(fontsName)
        let jsonName = "fonts.json"
        let jsonFileURL = fontsDirUrl.URLByAppendingPathComponent(jsonName)
        let data = NSData(contentsOfURL: jsonFileURL)!
        let fileNames = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as! [String]
        
        for name in fileNames {
            let fontFileUrl = fontsDirUrl.URLByAppendingPathComponent(name)
            CTAFontsManager.registerFontAt(fontFileUrl)
        }
        
        CTAFontsManager.reloadData()
    }
    
    func registerSystemFonts() {
        
        /*
         Times New Roman
         
         American Typewriter
         
         Snell Roundhand
         
         Chalkduster
         */
        
        let familiesName = ["Times New Roman", "American Typewriter", "Snell Roundhand", "Chalkduster"]
        for fa in familiesName {
            let fonts = UIFont.fontNamesForFamilyName(fa)
            for f in fonts {
                if let font = UIFont(name: f, size: 17) {
                    let desc = font.fontDescriptor()
                    let fullName = f
                    let postName = desc.postscriptName
                    let style = CTFontCopyName(font, kCTFontStyleNameKey)?.toString() ?? ""
                    let copyRight = CTFontCopyName(font, kCTFontCopyrightNameKey)?.toString() ?? ""
                    let version = CTFontCopyName(font, kCTFontVersionNameKey)?.toString() ?? ""
                    
                    CTAFontsManager.registerFontWith(fa, fullName: fullName, postscriptName: postName, copyRight: copyRight, style: style, size: "", version: version)
                    
                }
                
            }
        }
        
        CTAFontsManager.reloadData()
    }
    
    func familiesDisplayNames() {
        
        let fontsName = "Fonts"
        let path = NSBundle.mainBundle().bundleURL
        let fontsDirUrl = path.URLByAppendingPathComponent(fontsName)
        let jsonName = "familyDisplayNames.json"
        let jsonFileURL = fontsDirUrl.URLByAppendingPathComponent(jsonName)
        let data = NSData(contentsOfURL: jsonFileURL)!
        let fileNames = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as! [String: String]
        
        CTAFontsManager.familiyDisplayNameDic = fileNames
    }
    
    func familiesFixRatio() {
        
        let fontsName = "Fonts"
        let path = NSBundle.mainBundle().bundleURL
        let fontsDirUrl = path.URLByAppendingPathComponent(fontsName)
        let jsonName = "familyFixRatios.json"
        let jsonFileURL = fontsDirUrl.URLByAppendingPathComponent(jsonName)
        let data = NSData(contentsOfURL: jsonFileURL)!
        let fixRatio = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as! [String: [String: CGFloat]]
        
        CTAFontsManager.familiyFixRectRatio = fixRatio
        
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
//       return WXApi.handleOpenURL(url, delegate: self)
        debug_print(url)
        if CTASocialManager.handleOpenURL(url) {
            return true
        }
        
        return false
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return WXApi.handleOpenURL(url, delegate: self)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

private extension CFString {
    
    func toString() -> String {
        return self as String
    }
}

