//
//  CTALoginProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/30.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation

protocol CTALoginProtocol{
    func showLoginView(isPopupSelf:Bool)
    func loginComplete(userModel:CTAUserModel?)
}

extension CTALoginProtocol where Self: UIViewController{
    
    func showLoginView(isPopupSelf:Bool){
        if isPopupSelf{
            NSNotificationCenter.defaultCenter().postNotificationName("showLoginView", object: self)
        }else {
            NSNotificationCenter.defaultCenter().postNotificationName("showLoginView", object: nil)
        }
    }
    
    func loginComplete(userModel:CTAUserModel?){
        if let user = userModel{
            CTAUserManager.save(user)
            NSNotificationCenter.defaultCenter().postNotificationName("loginComplete", object: nil)
        }
        self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
}