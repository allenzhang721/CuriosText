//
//  ModuleManager.swift
//  ModuleManager
//
//  Created by Emiaostein on 5/23/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import Foundation

class FunctionWrapper<T> {
    let method: T
    init(f: T) { self.method = f }
}

private let mainBoundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "CuriosTextApp"

class Moduler {

    class func target(_ targetName: String, performAction actionName: String, paras: Any, inBundle name: String = mainBoundleName) -> Unmanaged<AnyObject>? {
        
        let bundle = name
        let target = targetName
        let action = NSSelectorFromString(actionName)
        
        guard let aClass = NSClassFromString(bundle + "." + target) as? NSObject.Type else {return nil}
        
//        let object = aClass.self.init()
        
        if aClass.responds(to: action) {
            return aClass.perform(action, with: paras)
        } else {
            print("Module '\(aClass)' not respond to selector '\(action)'")
        }
        
        return nil
    }
}
