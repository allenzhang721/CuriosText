//
//  PageControllers.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
import UIKit

class CTAPageControllers: NSObject, UIPageViewControllerDataSource {
    
    
    let controllers: [UIViewController] = {
       
        var vcs = [UIViewController]()
        for i in 0..<2 {
            
            var controller: UIViewController?
            switch i {
            case 0:
                controller = CTAHomeViewController()
            case 1:
                controller = CTAUserPublishesViewController()
            default:
                ()
            }
            
            if let controller = controller {
                vcs.append(controller)
            }
        }
        
        return vcs
    }()
    
    func indexOfController(viewController: UIViewController) -> Int? {
        return controllers.indexOf(viewController)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        guard let index = indexOfController(viewController) where index > 0 else {
            return nil
        }
        
        return controllers[index - 1]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        guard let index = indexOfController(viewController) where index < controllers.count - 1 else {
            return nil
        }
        
        return controllers[index + 1]
    }
    
    
}