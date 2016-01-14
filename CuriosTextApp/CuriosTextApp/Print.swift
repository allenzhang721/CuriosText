//
//  Print.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/14/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

// other swift flags : -D DEBUG
public func debug_print<T>(value: T,file: String = __FILE__, line: Int = __LINE__ ,function: String = __FUNCTION__) {
    
//    #if DEBUG
    
        print("<\(((file as NSString).lastPathComponent as NSString).stringByDeletingPathExtension) : \(line)>: \(function)")
        print(value)
        print("-------\n")
        
//    #else
//
//        print(value)
//        
//    #endif
    
}