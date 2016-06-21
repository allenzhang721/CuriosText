//
//  CTAMainViewController.swift
//  CuriosTextApp
//
//  Created by allen on 16/2/19.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation
class CTAMainViewController: UIViewController, CTALoginProtocol{
    
    static var _instance:CTAMainViewController?;
    
    static func getInstance() -> CTAMainViewController{
        if _instance == nil{
            _instance = CTAMainViewController()
        }
        return _instance!
    }
    
    private let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    
    private let pageControllers = CTAPageControllers()
    
    
    override func prefersStatusBarHidden() -> Bool {
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
        
        
        pageViewController.setViewControllers([pageControllers.controllers[0]], direction: .Forward, animated: false, completion: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CTAMainViewController.changePageView(_:)), name: "changePageView", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if CTAUserManager.isLogin {
            for subView in pageViewController.view.subviews {
                if let scrolliew = subView as? UIScrollView {
                    scrolliew.scrollEnabled = true
                    break
                }
            }
        } else {
            for subView in pageViewController.view.subviews {
                if let scrolliew = subView as? UIScrollView {
                    scrolliew.scrollEnabled = false
                    break
                }
            }
        }
    }
    
    func changePageView(noti: NSNotification) {
        if noti.object != nil {
            let index = noti.object as! Int
            if index > -1 && index < self.pageControllers.controllers.count {
                var dir:UIPageViewControllerNavigationDirection = .Forward
                let currentControl = self.pageViewController.viewControllers
                if currentControl != nil {
                    let current = self.pageControllers.indexOfController(currentControl![0])
                    if current > index{
                        dir = .Reverse
                    }else {
                        dir = .Forward
                    }
                }
                self.pageViewController.setViewControllers([self.pageControllers.controllers[index]], direction: dir, animated: true, completion: nil)
            }
        }
    }
    
    func goToFirstView(){
        self.pageViewController.setViewControllers([self.pageControllers.controllers[0]], direction: .Reverse, animated: false, completion: nil)
    }
    
    func addBarViewClick(sender: UIPanGestureRecognizer){
        if CTAUserManager.isLogin {
            //self.showEditView()
        }else {
            self.showLoginView()
        }
    }
}