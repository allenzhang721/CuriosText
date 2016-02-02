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
        let login = CTALoginViewController.getInstance()
        login.isChangeContry = true
        let navigationController = UINavigationController(rootViewController: login)
        navigationController.navigationBarHidden = true
        self.presentViewController(navigationController, animated: false, completion: {
            
        })
    }
    
    func loginComplete(userModel:CTAUserModel){
        CTAUserManager.save(userModel)
        self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
}