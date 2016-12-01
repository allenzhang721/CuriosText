//
//  CTATimeProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/6/21.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation

typealias Task = (_ cancel : Bool) -> Void

func delay(_ time:TimeInterval, task:@escaping ()->()) ->  Task? {
    
    func dispatch_later(_ block:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: block)
    }
    
    var closure: (()->())? = task
    var result: Task?
    
    let delayedClosure: Task = {
        cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                DispatchQueue.main.async(execute: internalClosure);
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    
    return result;
}

func cancel(_ task:Task?) {
    task?(true)
}
