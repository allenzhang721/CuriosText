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
        
        CTASocialShareManager.OAuth(.WeChat) { (resultDic, urlResponse, error) -> Void in
            
            debug_print(resultDic)
        }
    }
    
    @IBAction func weiboOAuth(sender: AnyObject) {
        
        CTASocialShareManager.OAuth(.Weibo) { (resultDic, urlResponse, error) -> Void in
            
            debug_print(resultDic)
        }
    }

    @IBAction func shareMessage(sender: AnyObject) {
        
        let url = NSURL(string: "")
        
        let message = CTASocialShareManager.Message
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
        
        CTASocialShareManager.shareMessage(message) { (result) -> Void in
            
            debug_print("shareMessage result = \(result)")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
