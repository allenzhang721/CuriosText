//
//  CATAlertProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/31.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit

protocol CTAAlertProtocol{
    
    func showSelectedAlert(_ alertTile:String, alertMessage:String, okAlertLabel:String, cancelAlertLabel:String, compelecationBlock: @escaping (Bool) -> Void)
    func showTextAlert(_ alertTile:String, alertMessage:String, okAlertLabel:String, cancelAlertLabel:String, compelecationBlock: @escaping (Bool, String) -> Void)
    func showSingleAlert(_ alertTile:String, alertMessage:String, compelecationBlock: (() -> Void)?)
    func showSheetAlert(_ alertTile:String?, okAlertArray:Array<[String: AnyObject]>, cancelAlertLabel:String, compelecationBlock: @escaping (_ index:Int) -> Void)
}

extension CTAAlertProtocol where Self: UIViewController{
    
  func showSelectedAlert(_ alertTile:String, alertMessage:String, okAlertLabel:String, cancelAlertLabel:String, compelecationBlock: @escaping (Bool) -> Void){
        let alert = UIAlertController(title: alertTile, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okAlertLabel, style: .destructive, handler: { (_) -> Void in
            compelecationBlock(true)
        }))
        alert.addAction(UIAlertAction(title: cancelAlertLabel, style: UIAlertActionStyle.cancel, handler: { (_) -> Void in
            compelecationBlock(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showTextAlert(_ alertTile:String, alertMessage:String, okAlertLabel:String, cancelAlertLabel:String, compelecationBlock: @escaping (Bool, String) -> Void){
        let alert = UIAlertController(title: alertTile, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okAlertLabel, style: .default, handler: { (_) -> Void in
            let firstTextField = alert.textFields![0] as UITextField
            compelecationBlock(true, firstTextField.text!)
        }))
        alert.addAction(UIAlertAction(title: cancelAlertLabel, style: UIAlertActionStyle.cancel, handler: { (_) -> Void in
            compelecationBlock(false, "")
        }))
        alert.addTextField { (textField) in
            textField.isSecureTextEntry = true
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSingleAlert(_ alertTile:String, alertMessage:String, compelecationBlock: (() -> Void)?){
        let alert = UIAlertController(title: alertTile, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: LocalStrings.ok.description, style: .default, handler: { (_) -> Void in
            if compelecationBlock != nil {
                compelecationBlock!()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSheetAlert(_ alertTile:String?, okAlertArray:Array<[String: AnyObject]>, cancelAlertLabel:String, compelecationBlock: @escaping (_ index:Int) -> Void){
        let alert = UIAlertController(title: alertTile, message: nil, preferredStyle: .actionSheet)
        for i in 0..<okAlertArray.count {
            let alertIndex = i
            let alertDic = okAlertArray[i]
            var alertStyle:UIAlertActionStyle = .default
            let title = alertDic["title"] as? String
            if let style = alertDic["style"] as? String {
                switch style {
                case "Default":
                    alertStyle = .default
                case "Cancel":
                    alertStyle = .cancel
                case "Destructive":
                    alertStyle = .destructive
                default:
                    alertStyle = .default
                }
            }
            alert.addAction(UIAlertAction(title: title, style: alertStyle, handler: { (_) -> Void in
                compelecationBlock(alertIndex)
            }))
        }
        alert.addAction(UIAlertAction(title: cancelAlertLabel, style: UIAlertActionStyle.cancel, handler: { (_) -> Void in
            compelecationBlock(-1)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
