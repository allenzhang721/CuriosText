//
//  Moduler+AboutUs.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 5/26/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

private let moduleName = "AboutUs"
private struct Actions {
    let aboutVC = "aboutVC:"
}

extension Moduler {
    class func module_aboutUS() -> UIViewController? {
        let paras: [String: AnyObject] = [:]
        
       let vc = Moduler
            .target(moduleName,
                    performAction: Actions().aboutVC,
                    paras: paras)?.takeUnretainedValue() as? UIViewController
        return vc
    }
}
