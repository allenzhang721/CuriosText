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
let fdContext = PrintContext(shouldPrint: false, context: "First Dispaly Font Name")
let colorContext = PrintContext(shouldPrint: false, context: "First Dispaly Color")
let aniContext = PrintContext(shouldPrint: false, context: "animation")
let previewConttext = PrintContext(shouldPrint: false, context: "Preview")
let animationChangedContext = PrintContext(shouldPrint: true, context: "animation Changed")

// other swift flags : -D DEBUG
public func debug_print<T>(value: T,file: String = __FILE__, line: Int = __LINE__ ,function: String = __FUNCTION__, context: PrintContext = defaultContext) {
    
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

