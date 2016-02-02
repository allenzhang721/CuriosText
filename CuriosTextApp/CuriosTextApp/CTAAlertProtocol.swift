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
    func showSheetAlert(okAlertArray:Array<String>, cancelAlertLabel:String, compelecationBlock: (index:Int) -> Void)
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
    
    func showSheetAlert(okAlertArray:Array<String>, cancelAlertLabel:String, compelecationBlock: (index:Int) -> Void){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        for var i:Int=0; i < okAlertArray.count; i++ {
            let alertIndex = i
            alert.addAction(UIAlertAction(title: okAlertArray[i], style: .Default, handler: { (_) -> Void in
                compelecationBlock(index: alertIndex)
            }))
        }
        alert.addAction(UIAlertAction(title: cancelAlertLabel, style: UIAlertActionStyle.Cancel, handler: { (_) -> Void in
            compelecationBlock(index: -1)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}