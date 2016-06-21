//
//  ViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/4/15.
//  Copyright © 2015 botai. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    var mainTab:UITabBarController!
    
    let mainDefaultSelected = 0
    
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
        self.mainTab = RootAction.rootTabViewController()
        self.mainTab.delegate = self
        
        addChildViewController(self.mainTab)
        view.addSubview(self.mainTab.view)
        self.mainTab.selectedIndex = self.mainDefaultSelected
        
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.showNavigationView(_:)), name: "showNavigationView", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.showLoginView(_:)), name: "showLoginView", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.addPublishFile(_:)), name: "addPublishFile", object: nil)
    }
    
    
//    func showNavigationView(noti: NSNotification){
//        let popView = noti.object as! UIViewController
//        self.navigate.pushViewController(popView, animated: true)
//    }
    
    func showLoginView(noti: NSNotification){
        self.showLoginHandler()
    }
    
    func showLoginHandler(){
        let login = CTALoginViewController.getInstance()
        login.isChangeContry = true
        let navigationController = UINavigationController(rootViewController: login)
        navigationController.navigationBarHidden = true
        self.presentViewController(navigationController, animated: true, completion: {
            //            self.navigate.popToRootViewControllerAnimated(false)
            self.mainTab.selectedIndex = self.mainDefaultSelected
        })
    }
    
    func addPublishFile(noti: NSNotification){
        if CTAUserManager.isLogin{
            self.showEditView()
        }else {
            self.showLoginHandler()
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
}

extension ViewController: CTAEditViewControllerDelegate{
    func EditControllerDidPublished(viewController: EditViewController){
        NSNotificationCenter.defaultCenter().postNotificationName("publishEditFile", object: nil)
    }
}

extension ViewController: UITabBarControllerDelegate{
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool{
        if !(viewController is HomeViewController){
            if CTAUserManager.isLogin{
                return true
            }else {
                self.showLoginHandler()
                return false
            }
        }
        return true
    }
}

