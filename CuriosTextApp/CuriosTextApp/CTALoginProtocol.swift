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
}

extension CTALoginProtocol where Self: UIViewController{
    
    func showLoginView(){
        
        
        let login = CTALoginViewController.getInstance()
        
        
        let navigationController = UINavigationController(rootViewController: login)
        navigationController.navigationBarHidden = true
        self.presentViewController(navigationController, animated: false, completion: {
            
        })
    }
}