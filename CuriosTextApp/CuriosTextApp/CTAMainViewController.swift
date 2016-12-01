//
//  CTAMainViewController.swift
//  CuriosTextApp
//
//  Created by allen on 16/2/19.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

class CTAMainViewController: UIViewController, CTALoginProtocol{
    
    static var _instance:CTAMainViewController?;
    
    static func getInstance() -> CTAMainViewController{
        if _instance == nil{
            _instance = CTAMainViewController()
        }
        return _instance!
    }
    
    fileprivate let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    fileprivate let pageControllers = CTAPageControllers()
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.initView()
        self.view.backgroundColor = CTAStyleKit.commonBackgroundColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView(){
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        
        pageViewController.view.backgroundColor = CTAStyleKit.lightGrayBackgroundColor
        pageViewController.dataSource = pageControllers
        
        
        pageViewController.setViewControllers([pageControllers.controllers[0]], direction: .forward, animated: false, completion: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CTAMainViewController.changePageView(_:)), name: NSNotification.Name(rawValue: "changePageView"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CTAUserManager.isLogin {
            for subView in pageViewController.view.subviews {
                if let scrolliew = subView as? UIScrollView {
                    scrolliew.isScrollEnabled = true
                    break
                }
            }
        } else {
            for subView in pageViewController.view.subviews {
                if let scrolliew = subView as? UIScrollView {
                    scrolliew.isScrollEnabled = false
                    break
                }
            }
        }
    }
    
    func changePageView(_ noti: Notification) {
        if noti.object != nil {
            let index = noti.object as! Int
            if index > -1 && index < self.pageControllers.controllers.count {
                var dir:UIPageViewControllerNavigationDirection = .forward
                let currentControl = self.pageViewController.viewControllers
                if currentControl != nil {
                    let current = self.pageControllers.indexOfController(currentControl![0])
                    if current > index{
                        dir = .reverse
                    }else {
                        dir = .forward
                    }
                }
                self.pageViewController.setViewControllers([self.pageControllers.controllers[index]], direction: dir, animated: true, completion: nil)
            }
        }
    }
    
    func goToFirstView(){
        self.pageViewController.setViewControllers([self.pageControllers.controllers[0]], direction: .reverse, animated: false, completion: nil)
    }
    
    func addBarViewClick(_ sender: UIPanGestureRecognizer){
        if CTAUserManager.isLogin {
            //self.showEditView()
        }else {
            self.showLoginView(false)
        }
    }
}
