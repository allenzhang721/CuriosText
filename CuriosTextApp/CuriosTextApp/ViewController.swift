//
//  ViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/4/15.
//  Copyright © 2015 botai. All rights reserved.
//

import UIKit
import CYLTabBarController

class ViewController: UIViewController{

    var mainTabBarController:UITabBarController!
    
    let mainDefaultSelected = 1
    
    var loadNoticeTask:Task?
    
    static var _instance:UIViewController?;
    
    static func getInstance() -> UIViewController{
        if _instance == nil{
            _instance = ViewController()
        }
        return _instance!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CTAUpTokenDomain.getInstance().uploadFilePath { (info) -> Void in
            if info.result {
                let dic = info.modelDic
                let publishFilePath = dic![key(.publishFilePath)]
                let userFilePath = dic![key(.userFilePath)]
                let resourceFilePath = dic![key(.resourceFilePath)]
                CTAFilePath.publishFilePath  = publishFilePath!
                CTAFilePath.userFilePath     = userFilePath!
                CTAFilePath.resourceFilePath = resourceFilePath!
            }
        }
        CTAUserManager.load()

        
//        PlusButton.registerSubclass()
      PlusButton.register()
//        CYLPlusButton.register()
        self.mainTabBarController = RootAction.rootTabViewController()
        self.mainTabBarController.delegate = self
        
        addChildViewController(self.mainTabBarController)
        view.addSubview(self.mainTabBarController.view)
        if CTAUserManager.isLogin{
            self.mainTabBarController.selectedIndex = 0
        }else {
            self.mainTabBarController.selectedIndex = self.mainDefaultSelected
        }
        
        self.getUserNotice()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.showLoginView(_:)), name: NSNotification.Name(rawValue: "showLoginView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.loginComplete(_:)), name: NSNotification.Name(rawValue: "loginComplete"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.addPublishFile(_:)), name: NSNotification.Name(rawValue: "addPublishFile"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.addViewInRoot(_:)), name: NSNotification.Name(rawValue: "addViewInRoot"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.popupViewControllerInRoot(_:)), name: NSNotification.Name(rawValue: "popupViewControllerInRoot"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.setNoticeReaded(_:)), name: NSNotification.Name(rawValue: "setNoticeReaded"), object: nil)
        
        let _ = CTASettingViewController()
        let _ = UIStoryboard(name: "Comment", bundle: nil).instantiateInitialViewController() as! CommentViewController
    }
    
    func repositionBadge(){
        for tabBarButton in self.mainTabBarController.tabBar.subviews{
            for badgeView in tabBarButton.subviews {
                let className = NSStringFromClass(badgeView.classForCoder)
                if className == "_UIBadgeView" {
                    badgeView.layer.transform = CATransform3DIdentity
                    badgeView.layer.transform = CATransform3DMakeTranslation(-12.0, 2.0, 1.0)
                }
            }
        }
    }
    
    func addViewInRoot(_ noti: Notification){
        let popView = noti.object as! UIView
        self.view.addSubview(popView)
    }
    
    func popupViewControllerInRoot(_ noti: Notification){
        
//        slf.presentViewController(editNaviVC, animated: true, completion: { () -> Void in
//        })
        let viewArray = noti.object as! Array<UIViewController>
        let popView = viewArray[0]
        var rootVIew:UIViewController
        if viewArray.count > 1{
            rootVIew = viewArray[1]
        }else {
            rootVIew = self
        }
        self.popupEditView(popView, rootView: rootVIew)
    }
    
    func showLoginView(_ noti: Notification){
        let loginView = noti.object as? UIViewController
        self.showLoginHandler(loginView)
    }
    
    func loginComplete(_ noti: Notification){
        self.getUserNotice()
    }
    
    func showLoginHandler(_ rootView:UIViewController?){
        let login = CTALoginViewController.getInstance()
        login.isChangeContry = true
        let navigationController = UINavigationController(rootViewController: login)
        navigationController.isNavigationBarHidden = true
        if rootView != nil {
            rootView?.self.present(navigationController, animated: true, completion: {
                self.mainTabBarController.selectedIndex = self.mainDefaultSelected
            })
        }else {
            self.present(navigationController, animated: true, completion: {
                self.mainTabBarController.selectedIndex = self.mainDefaultSelected
            })
        }
        if self.loadNoticeTask != nil {
            cancel(self.loadNoticeTask)
            self.loadNoticeTask = nil
        }
        self.mainTabBarController.tabBar.items![2].badgeValue = nil
        CTARemoteNotificationManager.cleanIconBadge()
    }
    
    func addPublishFile(_ noti: Notification){
        if CTAUserManager.isLogin{
            self.showEditView()
        }else {
            self.showLoginHandler(nil)
        }
    }
    
    func showEditView(){
        self.view.isUserInteractionEnabled = false
        let page = EditorFactory.generateRandomPage()
        let documentURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileUrl = CTADocumentManager.generateDocumentURL(documentURL)
        CTADocumentManager.createNewDocumentAt(fileUrl, page: page) { (success) -> Void in
            
            if success {
                CTADocumentManager.openDocument(fileUrl, completedBlock: { (success) -> Void in
                    
                    if let openDocument = CTADocumentManager.openedDocument {
                        
                        let editNaviVC = UIStoryboard(name: "Editor", bundle: nil).instantiateViewController(withIdentifier: "EditorNavigationController") as! UINavigationController
                        
                        let editVC = editNaviVC.topViewController as! EditViewController
                        
                        editVC.document = openDocument
                        editVC.delegate = self
                        self.popupEditView(editNaviVC, rootView: self)
                    }
                })
            }
        }
    }
    
    func popupEditView(_ editeView:UIViewController, rootView:UIViewController){
        rootView.view.isUserInteractionEnabled = false
        let ani = CTAEditorTransition.getInstance()
        let bgView = UIScreen.main.snapshotView(afterScreenUpdates: false)
        ani.rootView = bgView
        editeView.transitioningDelegate = ani
        editeView.modalPresentationStyle = .custom
      editeView.modalPresentationCapturesStatusBarAppearance = true
        rootView.present(editeView, animated: true) {
            rootView.view.isUserInteractionEnabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserNotice(){
        if CTAUserManager.isLogin{
            self.getUserNoticeHandler()
        }
    }
    
    func setNoticeReaded(_ noti: Notification){
        self.mainTabBarController.tabBar.items![2].badgeValue = nil
        CTARemoteNotificationManager.cleanIconBadge()
    }
    
    func getUserNoticeHandler(){
        if CTAUserManager.isLogin{
            let userID = CTAUserManager.user!.userID
            CTANoticeDomain.getInstance().unReadNoticeCount(userID, compelecationBlock: { (info) in
                if info.result{
                    let count = info.successType
                    if count > 0{
                        var noticeText:String = ""
                        if count > 99{
                            noticeText = "..."
                        }else {
                            noticeText = String(count)
                        }
                        self.mainTabBarController.tabBar.items![2].badgeValue = noticeText
                        self.repositionBadge()
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "haveNewNotice"), object: nil)
                        CTARemoteNotificationManager.setIconBadge(count);
                    }else {
                        self.mainTabBarController.tabBar.items![2].badgeValue = nil
                        CTARemoteNotificationManager.cleanIconBadge()
                    }
                    self.getUserNoticeComplete()
                }else {
                    self.getUserNoticeComplete()
                }
            })
        }
    }
    
    func getUserNoticeComplete(){
//        if self.loadNoticeTask == nil {
//            self.loadNoticeTask = delay(30.0){
//                cancel(self.loadNoticeTask)
//                self.loadNoticeTask = nil
//                self.getUserNotice()
//            }
//        }
    }
}

extension ViewController: CTAEditViewControllerDelegate{
    func EditControllerDidPublished(_ viewController: EditViewController){
        NotificationCenter.default.post(name: Notification.Name(rawValue: "publishEditFile"), object: nil)
    }
}

extension ViewController: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool{
        var isSelf:Bool = false
        if let selectedView = self.mainTabBarController.selectedViewController{
            if selectedView.isEqual(viewController){
                isSelf = true
            }else {
                isSelf = false
            }
        }else {
            isSelf = false
        }
        if isSelf{
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshSelf"), object: nil)
            return false
        }else {
            let index = self.mainTabBarController.selectedIndex
            if index == self.mainDefaultSelected{
                if CTAUserManager.isLogin{
                    return true
                }else {
                    self.showLoginHandler(nil)
                    return false
                }
            }
        }
        return true
    }
}

