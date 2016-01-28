//
//  CTASocialTestViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/28/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTASocialTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func weChatOAuth(sender: AnyObject) {
        
        CTASocialManager.OAuth(.WeChat) { (resultDic, urlResponse, error) -> Void in
            
            debug_print(resultDic)
        }
    }
    
    @IBAction func weiboOAuth(sender: AnyObject) {
        
        CTASocialManager.OAuth(.Weibo) { (resultDic, urlResponse, error) -> Void in
            
            debug_print(resultDic)
        }
    }

    @IBAction func shareMessage(sender: AnyObject) {
        
        let url = NSURL(string: "")
        
        let message = CTASocialManager.Message
            .WeChat(
                .Session(
                    info: (
                        title: "title",
                        description: "description",
                        thumbnail: nil,
                        media: .URL(url!)
                    )
                )
        )
        
        CTASocialManager.shareMessage(message) { (result) -> Void in
            
            debug_print("shareMessage result = \(result)")
        }
    }

    @IBAction func sms(sender: AnyObject) {
        
        let number = "15501005475"
        let zone = "86"
        
        CTASocialManager.getVerificationCode(number, zone: zone) { (result) -> Void in
            debug_print(result)
        }
    }
    
    
    @IBAction func verifySMS(sender: AnyObject) {
        
        let number = "15501005475"
        let zone = "86"
        
        let alertController = UIAlertController(title: "短信验证", message: "输入短信验证码", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler(nil)
        let confirmAction = UIAlertAction(title: "确定", style: .Default) { (action) -> Void in
            let textfield = alertController.textFields!.first!
            let code = textfield.text!
            CTASocialManager.commitVerificationCode(code, phoneNumber: number, zone: zone, completionHandler: { (result) -> Void in
                
                debug_print(result)
            })
        }
        
        alertController.addAction(confirmAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}
