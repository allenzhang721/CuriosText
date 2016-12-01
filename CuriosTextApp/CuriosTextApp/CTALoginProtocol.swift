//
//  CTALoginProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/30.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation

protocol CTALoginProtocol{
    func showLoginView(_ isPopupSelf:Bool)
    func loginComplete(_ userModel:CTAUserModel?)
}

extension CTALoginProtocol where Self: UIViewController{
    
    func showLoginView(_ isPopupSelf:Bool){
        if isPopupSelf{
            NotificationCenter.default.post(name: Notification.Name(rawValue: "showLoginView"), object: self)
        }else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "showLoginView"), object: nil)
        }
    }
    
    func loginComplete(_ userModel:CTAUserModel?){
        if let user = userModel{
            CTAUserManager.save(user)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "loginComplete"), object: nil)
        }
        self.navigationController?.dismiss(animated: true, completion: { () -> Void in
        })
    }
}
