//
//  Print.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/14/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation



public struct PrintContext {
    
    let shouldPrint: Bool
    let context: String
}

let disablePrint: [PrintContext] = [defaultContext]

let defaultContext = PrintContext(shouldPrint: true, context: "default Print")
let fdContext = PrintContext(shouldPrint: true, context: "First Dispaly Font Name")


// other swift flags : -D DEBUG
public func debug_print<T>(value: T,file: String = __FILE__, line: Int = __LINE__ ,function: String = __FUNCTION__, context: PrintContext) {
    
//    #if DEBUG
    if context.shouldPrint {
        print("<\(((file as NSString).lastPathComponent as NSString).stringByDeletingPathExtension) : \(line)>: \(function)")
        print(value)
        print("-------\n")
    }
    
//    #else
//
//        print(value)
//        
//    #endif
    
}

