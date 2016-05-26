//
//  Templates.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 5/26/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class Templates: NSObject {
    
    class func templateListVC(paras: [String: AnyObject]) -> UIViewController? {
        
        let listVC = UIStoryboard(name: "Templates", bundle: nil).instantiateViewControllerWithIdentifier("TemplateList") as? CTATempateListViewController
        
        if let selectedHandler = paras["selectedHandler"] as? FunctionWrapper<((NSData?) -> ())?> {
            listVC?.selectedHandler = selectedHandler.method
        }
        
        return listVC
    }
}
