//
//  ViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/4/15.
//  Copyright © 2015 botai. All rights reserved.
//

import UIKit

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
                let publishFilePath = dic![key(.PublishFilePath)]
                let userFilePath = dic![key(.UserFilePath)]
                let resourceFilePath = dic![key(.ResourceFilePath)]
                CTAFilePath.publishFilePath  = publishFilePath!
                CTAFilePath.userFilePath     = userFilePath!
                CTAFilePath.resourceFilePath = resourceFilePath!
            }
        }
        CTAUserManager.load()

        
        PlusButton.registerSubclass()
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.showLoginView(_:)), name: "showLoginView", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.loginComplete(_:)), name: "loginComplete", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.addPublishFile(_:)), name: "addPublishFile", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.addViewInRoot(_:)), name: "addViewInRoot", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.popupViewControllerInRoot(_:)), name: "popupViewControllerInRoot", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.setNoticeReaded(_:)), name: "setNoticeReaded", object: nil)
        
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
    
    func addViewInRoot(noti: NSNotification){
        let popView = noti.object as! UIView
        self.view.addSubview(popView)
    }
    
    func popupViewControllerInRoot(noti: NSNotification){
        let popView = noti.object as! UIViewController
        self.view.userInteractionEnabled = false
        self.presentViewController(popView, animated: true) {
            self.view.userInteractionEnabled = true
        }
    }
    
    func showLoginView(noti: NSNotification){
        let loginView = noti.object as? UIViewController
        self.showLoginHandler(loginView)
    }
    
    func loginComplete(noti: NSNotification){
        self.getUserNotice()
    }
    
    func showLoginHandler(rootView:UIViewController?){
        let login = CTALoginViewController.getInstance()
        login.isChangeContry = true
        let navigationController = UINavigationController(rootViewController: login)
        navigationController.navigationBarHidden = true
        if rootView != nil {
            rootView?.self.presentViewController(navigationController, animated: true, completion: {
                self.mainTabBarController.selectedIndex = self.mainDefaultSelected
            })
        }else {
            self.presentViewController(navigationController, animated: true, completion: {
                self.mainTabBarController.selectedIndex = self.mainDefaultSelected
            })
        }
        if self.loadNoticeTask != nil {
            cancel(self.loadNoticeTask)
            self.loadNoticeTask = nil
        }
        self.mainTabBarController.tabBar.items![2].badgeValue = nil
    }
    
    func addPublishFile(noti: NSNotification){
        if CTAUserManager.isLogin{
            self.showEditView()
        }else {
            self.showLoginHandler(nil)
        }
    }
    
    func showEditView(){
        self.view.userInteractionEnabled = false
        let page = EditorFactory.generateRandomPage()
        let documentURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileUrl = CTADocumentManager.generateDocumentURL(documentURL)
        CTADocumentManager.createNewDocumentAt(fileUrl, page: page) { (success) -> Void in
            
            if success {
                CTADocumentManager.openDocument(fileUrl, completedBlock: { (success) -> Void in
                    
                    if let openDocument = CTADocumentManager.openedDocument {
                        
                        let editNaviVC = UIStoryboard(name: "Editor", bundle: nil).instantiateViewControllerWithIdentifier("EditorNavigationController") as! UINavigationController
                        
                        let editVC = editNaviVC.topViewController as! EditViewController
                        
                        editVC.document = openDocument
                        editVC.delegate = self
                        self.presentViewController(editNaviVC, animated: true, completion: { () -> Void in
                            self.view.userInteractionEnabled = true
                        })
                    }
                })
            }
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
    
    func setNoticeReaded(noti: NSNotification){
        self.mainTabBarController.tabBar.items![2].badgeValue = nil
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
                        NSNotificationCenter.defaultCenter().postNotificationName("haveNewNotice", object: nil)
                    }else {
                        self.mainTabBarController.tabBar.items![2].badgeValue = nil
                    }
                    self.getUserNoticeComplete()
                }else {
                    self.getUserNoticeComplete()
                }
            })
        }
    }
    
    func getUserNoticeComplete(){
        if self.loadNoticeTask == nil {
            self.loadNoticeTask = delay(30.0){
                cancel(self.loadNoticeTask)
                self.loadNoticeTask = nil
                self.getUserNotice()
            }
        }
    }
}

extension ViewController: CTAEditViewControllerDelegate{
    func EditControllerDidPublished(viewController: EditViewController){
        NSNotificationCenter.defaultCenter().postNotificationName("publishEditFile", object: nil)
    }
}

extension ViewController: UITabBarControllerDelegate{
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool{
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
            NSNotificationCenter.defaultCenter().postNotificationName("refreshSelf", object: nil)
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

