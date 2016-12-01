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
            case 1: break
                //controller = CTAUserPublishesViewController()
            default:
                ()
            }
            
            if let controller = controller {
                vcs.append(controller)
            }
        }
        
        return vcs
    }()
    
    func indexOfController(_ viewController: UIViewController) -> Int? {
        return controllers.index(of: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = indexOfController(viewController), index > 0 else {
            return nil
        }
        
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = indexOfController(viewController), index < controllers.count - 1 else {
            return nil
        }
        
        return controllers[index + 1]
    }
    
    
}
