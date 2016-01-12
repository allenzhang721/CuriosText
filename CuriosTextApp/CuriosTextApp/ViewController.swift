//
//  ViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/4/15.
//  Copyright © 2015 botai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    
    private let pageControllers = CTAPageControllers()

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CTAUpTokenDomain.getInstance().uploadFilePath { (info) -> Void in
            let dic = info.modelDic
            let publishFilePath = dic![key(.PublishFilePath)]
            let userFilePath = dic![key(.UserFilePath)]
            CTAFilePath.publishFilePath = publishFilePath!
            CTAFilePath.userFilePath = userFilePath!
        }
    
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
    
        pageViewController.view.backgroundColor = UIColor.lightGrayColor()
        pageViewController.dataSource = pageControllers

        pageViewController.setViewControllers([pageControllers.controllers[0]], direction: .Forward, animated: false, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

