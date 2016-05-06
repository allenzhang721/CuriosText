//
//  ViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/4/15.
//  Copyright © 2015 botai. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    var navigate:UINavigationController!
    
    let mainView = CTAMainViewController.getInstance()

    override func prefersStatusBarHidden() -> Bool {
        return true
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
        
        self.navigate = UINavigationController(rootViewController: mainView)
        self.navigate.navigationBarHidden = true

        addChildViewController(self.navigate)
        view.addSubview(self.navigate.view)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.showNavigationView(_:)), name: "showNavigationView", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.showLoginView(_:)), name: "showLoginView", object: nil)
    }
    
    func showNavigationView(noti: NSNotification){
        let popView = noti.object as! UIViewController
        self.navigate.pushViewController(popView, animated: true)
    }
    
    func showLoginView(noti: NSNotification){
        let login = CTALoginViewController.getInstance()
        login.isChangeContry = true
        let navigationController = UINavigationController(rootViewController: login)
        navigationController.navigationBarHidden = true
        self.presentViewController(navigationController, animated: true, completion: {
            self.navigate.popToRootViewControllerAnimated(false)
            self.mainView.goToFirstView()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//extension ViewController: UIScrollViewDelegate {

//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        
//        if let i = pageControllers.controllers.indexOf(pageViewController.viewControllers!.first!) where currentPageIndex != i {
//            currentPageIndex = i
//        }
//       
//        debugPrint(scrollView.contentOffset)
//        let nextOffset = scrollView.contentOffset.x
//        
//        switch currentPageIndex {
//            
//        case 0:
//            if nextOffset <= scrollView.bounds.width {
//                //            scrollView.bounces = false
//                scrollView.contentOffset = CGPoint(x: view.bounds.width, y: 0)
//            }
//            
//        case 1:
//            if nextOffset >= view.bounds.width {
//                //            scrollView.bounces = false
//                scrollView.contentOffset = CGPoint(x: view.bounds.width, y: 0)
//            }
//            
//        default:
//            ()
//            
//        }
//    }
//
////    
//    
//    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        
//        let nextOffset = scrollView.contentOffset.x
//        
//        switch currentPageIndex {
//            
//        case 0:
//            if nextOffset <= scrollView.bounds.width {
//                //            scrollView.bounces = false
//                targetContentOffset.memory = CGPointMake(scrollView.bounds.size.width * 2, 0);
//            }
//            
//        case 1:
//            if nextOffset >= view.bounds.width {
//                //            scrollView.bounces = false
//                targetContentOffset.memory = CGPointMake(scrollView.bounds.size.width * 2, 0);
//            }
//            
//        default:
//            ()
//            
//        }
//    }
//}

