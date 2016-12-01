//
//  AboutUs.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 5/26/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

class AboutUs: NSObject {
    
    class func aboutVC(_ paras: [String: AnyObject]?) -> UIViewController? {
        
        let a = UIStoryboard(name: "About", bundle: nil).instantiateInitialViewController() as? AboutViewController
        
        return a
    }
    
}
