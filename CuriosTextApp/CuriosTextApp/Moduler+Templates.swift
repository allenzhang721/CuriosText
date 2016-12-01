//
//  Moduler+Templates.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 5/26/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

private let moduleName = "Templates"
private struct Actions {
    let templateListVC = "templateListVC:"
    let templateVC = "templateVC:"
}

extension Moduler {
    
    class func module_templateVC(_ changed: (() -> ())?, dismiss: (() -> ())?, cancel: (() -> ())?, done: (() -> ())?) -> UIViewController? {
        var paras: [String: AnyObject] = [:]

        if let h = changed {
            paras["didChangedHandler"] = FunctionWrapper(f: h)
        }
        if let h = dismiss {
            paras["dismissHandler"] = FunctionWrapper(f: h)
        }
        if let h = cancel {
            paras["cancelHandler"] = FunctionWrapper(f: h)
        }
        if let h = done {
            paras["doneHandler"] = FunctionWrapper(f: h)
        }
        
        let vc = Moduler.target(moduleName, performAction: Actions().templateVC, paras: paras as AnyObject?)?.takeUnretainedValue() as? UIViewController
        
        return vc
    }
    
    
    class func module_templateListVC(_ selectedHandler: ((_ pageData: Data?, _ origin: Bool) -> ())?) -> UIViewController? {
        var paras: [String: AnyObject] = [:]
        
        if let s = selectedHandler {
            paras["selectedHandler"] = FunctionWrapper(f: s)
        }
        
        let vc = Moduler.target(moduleName, performAction: Actions().templateListVC, paras: paras as AnyObject?)?.takeUnretainedValue() as? UIViewController
        
        return vc
    }
}
