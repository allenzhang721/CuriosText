//
//  ViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/4/15.
//  Copyright © 2015 botai. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CTAAddBarProtocol{
    
    private let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    
    private let pageControllers = CTAPageControllers()

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
                CTAFilePath.publishFilePath = publishFilePath!
                CTAFilePath.userFilePath = userFilePath!
            }
        }
    
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
    
        pageViewController.view.backgroundColor = UIColor.whiteColor()
        pageViewController.dataSource = pageControllers
        
        
        pageViewController.setViewControllers([pageControllers.controllers[0]], direction: .Forward, animated: false, completion: nil)
        
        self.initAddBarView()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if CTAUserManager.isLogin {
            
            for subView in pageViewController.view.subviews {
                if let scrolliew = subView as? UIScrollView {
                    scrolliew.bounces = true
                    break
                }
            }
        } else {
            for subView in pageViewController.view.subviews {
                if let scrolliew = subView as? UIScrollView {
                    scrolliew.bounces = false
                    break
                }
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addBarViewClick(sender: UIPanGestureRecognizer){
//        self.addPublishHandler()
        let page = EditorFactory.generateRandomPage()
//        let doc = CTADocument(fileURL: <#T##NSURL#>, page: page)
        let documentURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileUrl = CTADocumentManager.generateDocumentURL(documentURL)
        CTADocumentManager.createNewDocumentAt(fileUrl, page: page) { (success) -> Void in
            
            if success {
                CTADocumentManager.openDocument(fileUrl, completedBlock: { (success) -> Void in
                    
                    if let openDocument = CTADocumentManager.openedDocument {
                        
                        let editVC = UIStoryboard(name: "Editor", bundle: nil).instantiateViewControllerWithIdentifier("EditViewController") as! EditViewController
                        editVC.document = openDocument
                        
                        self.presentViewController(editVC, animated: false, completion: { () -> Void in
                            
                            
                        })
                    }
                })
            }
        }
        
    }
    
    var currentPageIndex: Int = 0
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

