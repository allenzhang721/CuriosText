//
//  CATAlertProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/31.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit

protocol CTAAlertProtocol{
    
    func showSelectedAlert(alertTile:String, alertMessage:String, okAlertLabel:String, cancelAlertLabel:String, compelecationBlock: (Bool) -> Void)
    func showSingleAlert(alertTile:String, alertMessage:String, compelecationBlock: () -> Void)
    func showSheetAlert(okAlertLabel:String, cancelAlertLabel:String, compelecationBlock: (Bool) -> Void)
}

extension CTAAlertProtocol where Self: UIViewController{
    
    func showSelectedAlert(alertTile:String, alertMessage:String, okAlertLabel:String, cancelAlertLabel:String, compelecationBlock: (Bool) -> Void){
        let alert = UIAlertController(title: alertTile, message: alertMessage, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: okAlertLabel, style: .Default, handler: { (_) -> Void in
            compelecationBlock(true)
        }))
        alert.addAction(UIAlertAction(title: cancelAlertLabel, style: UIAlertActionStyle.Cancel, handler: { (_) -> Void in
            compelecationBlock(false)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showSingleAlert(alertTile:String, alertMessage:String, compelecationBlock: () -> Void){
        let alert = UIAlertController(title: alertTile, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("AlertOkLabel", comment: ""), style: .Default, handler: { (_) -> Void in
            compelecationBlock()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showSheetAlert(okAlertLabel:String, cancelAlertLabel:String, compelecationBlock: (Bool) -> Void){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: okAlertLabel, style: .Default, handler: { (_) -> Void in
            compelecationBlock(true)
        }))
        alert.addAction(UIAlertAction(title: cancelAlertLabel, style: UIAlertActionStyle.Cancel, handler: { (_) -> Void in
            compelecationBlock(false)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}