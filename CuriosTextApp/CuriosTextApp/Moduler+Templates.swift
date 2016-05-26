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
    let aboutVC = "templateListVC:"
}

extension Moduler {
    class func module_templateVC(selectedHandler: ((NSData?) -> ())?) -> UIViewController? {
        var paras: [String: AnyObject] = [:]
        
        if let s = selectedHandler {
            paras["selectedHandler"] = FunctionWrapper(f: s)
        }
        
        let vc = Moduler.target(moduleName, performAction: Actions().aboutVC, paras: paras)?.takeUnretainedValue() as? UIViewController
        
        return vc
    }
}