//
//  Templates.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 5/26/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class Templates: NSObject {
    
    class func templateVC(_ paras: [String: AnyObject]) -> UIViewController? {
        
        let templateVC = UIStoryboard(name: "Templates", bundle: nil).instantiateViewController(withIdentifier: "TemplateVC") as? CTATemplateViewController
        
        if let handler = paras["didChangedHandler"] as? FunctionWrapper<() -> ()> {
            templateVC?.didChangedHandler = handler.method
        }
        
        if let handler = paras["dismissHandler"] as? FunctionWrapper<() -> ()> {
            templateVC?.dismissHandler = handler.method
        }
        
        if let handler = paras["cancelHandler"] as? FunctionWrapper<() -> ()> {
            templateVC?.cancelHandler = handler.method
        }
        
        if let handler = paras["doneHandler"] as? FunctionWrapper<() -> ()> {
            templateVC?.doneHandler = handler.method
        }
        
        return templateVC
    }
    
    class func templateListVC(_ paras: [String: AnyObject]) -> UIViewController? {
        
        let listVC = UIStoryboard(name: "Templates", bundle: nil).instantiateViewController(withIdentifier: "TemplateList") as? CTATempateListViewController
        
        if let selectedHandler = paras["selectedHandler"] as? FunctionWrapper<(_ pageData: Data?, _ origin: Bool) -> ()> {
            listVC?.selectedHandler = selectedHandler.method
        }
        
        return listVC
    }
}
