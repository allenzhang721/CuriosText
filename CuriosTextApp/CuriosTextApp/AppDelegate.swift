//
//  AppDelegate.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/4/15.
//  Copyright © 2015 botai. All rights reserved.
//

import UIKit
import Kingfisher
import UserNotifications
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        registerJPush()
        setupJPush(launchOptions)
        
        self.loadFilters()
        self.setup()
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setForegroundColor(CTAStyleKit.selectedColor)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        
        return true
    }
    
    func registerJPush() {
        let entity = JPUSHRegisterEntity()
        entity.types = Int(JPAuthorizationOptions.alert.union(JPAuthorizationOptions.badge).union(JPAuthorizationOptions.sound).rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.networkDidReceiveMessage(noti:)), name: NSNotification.Name.jpfNetworkDidReceiveMessage, object: nil)
//        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//        [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    }
    
    func networkDidReceiveMessage(noti: Notification) {
        //        NSDictionary * userInfo = [notification userInfo];
        //        NSString *content = [userInfo valueForKey:@"content"];
        //        NSDictionary *extras = [userInfo valueForKey:@"extras"];
        //        NSString *customizeField1 = [extras valueForKey:@"customizeField1"];
        
        // 参考：https://docs.jiguang.cn/jpush/client/iOS/ios_api/#_24
        if let userInfo = noti.userInfo {
            print(userInfo)
        }
        
    }
    
    func setupJPush(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        let appKey = "2f694891521f24a9f4cf00b1"
        JPUSHService.setup(withOption: launchOptions, appKey: appKey, channel: "App Store", apsForProduction: false)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //    [JPUSHService registerDeviceToken:deviceToken];
        print("Did Register")
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func loadFilters() {
        let bundle = Bundle.main.bundleURL
        let manager = FilterManager()
        manager.loadDefaultFilters()
        manager.filters.forEach{$0.createData(fromColorDirAt: bundle, complation: nil)}
    }
    
    func setup() {
        self.cleanFontCache()
        self.registerLocalFonts()
        self.registerSystemFonts()
        self.familiesDisplayNames()
        self.familiesFixRatio()
        ImageCache.default.maxMemoryCost = UInt(100 * 1024 * 1024) // Allen: 80 MB
        // Override point for customization after application launch.
        #if DEBUG
            CTANetworkConfig.shareInstance.baseUrl = CTARequestHost.production.description
        #else
            CTANetworkConfig.shareInstance.baseUrl = CTARequestHost.production.description
        #endif
        
        WXApi.registerApp(CTAConfigs.weChat.appID)
        WeiboSDK.registerApp(CTAConfigs.weibo.appID)
        CTASocialManager.register(.weChat, appID: CTAConfigs.weChat.appID, appKey: CTAConfigs.weChat.appKey)
        CTASocialManager.register(.weibo, appID: CTAConfigs.weibo.appID, appKey: CTAConfigs.weibo.appKey)
        CTASocialManager.register(.sms, appID: CTAConfigs.SMS.appID, appKey: CTAConfigs.SMS.appKey) // http://dashboard.mob.com/#/sms/index
    }
    
    func cleanFontCache() {
        CTAFontsManager.cleanCacheFamilyList()
        CTAFontsManager.cleanCacheFamily()
    }
    
    func registerLocalFonts() {
        let fontsName = "Fonts"
        let path = Bundle.main.bundleURL
        let fontsDirUrl = path.appendingPathComponent(fontsName)
        let jsonName = "fonts.json"
        let jsonFileURL = fontsDirUrl.appendingPathComponent(jsonName)
        let data = try! Data(contentsOf: jsonFileURL)
        let fileNames = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String]
        for name in fileNames {
            let fontFileUrl = fontsDirUrl.appendingPathComponent(name)
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
            let fonts = UIFont.fontNames(forFamilyName: fa)
            for f in fonts {
                if let font = UIFont(name: f, size: 17) {
                    let desc = font.fontDescriptor
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
        let path = Bundle.main.bundleURL
        let fontsDirUrl = path.appendingPathComponent(fontsName)
        let jsonName = "familyDisplayNames.json"
        let jsonFileURL = fontsDirUrl.appendingPathComponent(jsonName)
        let data = try! Data(contentsOf: jsonFileURL)
        let fileNames = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String: String]
        
        CTAFontsManager.familiyDisplayNameDic = fileNames
    }
    
    func familiesFixRatio() {
        
        let fontsName = "Fonts"
        let path = Bundle.main.bundleURL
        let fontsDirUrl = path.appendingPathComponent(fontsName)
        let jsonName = "familyFixRatios.json"
        let jsonFileURL = fontsDirUrl.appendingPathComponent(jsonName)
        let data = try! Data(contentsOf: jsonFileURL)
        let fixRatio = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String: [String: CGFloat]]
        
        CTAFontsManager.familiyFixRectRatio = fixRatio
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if CTASocialManager.handleOpenURL(url) {
            return true
        }
        return false
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

private extension CFString {
    func toString() -> String {
        return self as String
    }
}

extension AppDelegate: JPUSHRegisterDelegate {
    
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        // Required
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue)) // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        
        // Required
        
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        
        completionHandler?() // 系统要求执行这个方法
    }
}

