//
//  ViewControllerModuleProtocol.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 5/23/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

protocol ViewControllerModuleProtocol {
    
    static func module_About() -> UIViewController?
}

extension UIViewController: ViewControllerModuleProtocol {
    
    static func module_About() -> UIViewController? {
        let a = UIStoryboard(name: "About", bundle: nil).instantiateInitialViewController() as? AboutViewController
        return a
    }
}