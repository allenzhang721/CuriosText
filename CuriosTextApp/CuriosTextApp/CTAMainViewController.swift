//
//  CTAMainViewController.swift
//  CuriosTextApp
//
//  Created by allen on 16/2/19.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation
class CTAMainViewController: UIViewController, CTAAddBarProtocol, CTALoginProtocol{
    
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
        self.view.backgroundColor = CTAStyleKit.lightGrayBackgroundColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView(){
        
        let pageNavigate = UINavigationController(rootViewController: pageViewController)
        pageNavigate.navigationBarHidden = true
        self.addChildViewController(pageNavigate)
        self.view.addSubview(pageNavigate.view)
        
        pageViewController.view.backgroundColor = CTAStyleKit.lightGrayBackgroundColor
        pageViewController.dataSource = pageControllers
        
        
        pageViewController.setViewControllers([pageControllers.controllers[0]], direction: .Forward, animated: false, completion: nil)
        
        self.initAddBarView(self.view)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CTAMainViewController.changePageView(_:)), name: "changePageView", object: nil)
        
        
        let bounds = UIScreen.mainScreen().bounds
        let colorPick = CTAColorPickerView(frame: CGRect(x: 0, y: bounds.height - 88, width: bounds.width, height: 88))
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
            self.showEditView()
        }else {
            self.showLoginView()
        }
    }
}