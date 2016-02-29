//
//  CTALoginProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/30.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation

protocol CTALoginProtocol{
    func showLoginView()
    func loginComplete(userModel:CTAUserModel)
}

extension CTALoginProtocol where Self: UIViewController{
    
    func showLoginView(){
        NSNotificationCenter.defaultCenter().postNotificationName("showLoginView", object: nil)
    }
    
    func loginComplete(userModel:CTAUserModel){
        CTAUserManager.save(userModel)
        NSNotificationCenter.defaultCenter().postNotificationName("loginComplete", object: nil)
        self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
}