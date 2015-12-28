//
//  ViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/4/15.
//  Copyright © 2015 botai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
   
    var list:Array<CTAUpTokenModel> = Array<CTAUpTokenModel>();
    let a = CTAUpTokenModel.init(upTokenKey: "aaaaa/aa.png")
    let b = CTAUpTokenModel.init(upTokenKey: "bbbbb/bb.png")
    list.append(a);
    list.append(b);
    CTAUpTokenDomain.getInstance().userUpToken(list) { (domainInfo) -> Void in
        
        if domainInfo.result {
            let upTokenList:Array = domainInfo.modelArray!
            for var i=0; i < upTokenList.count; i++ {
                print(upTokenList[i])
            }
        }
    }
    
    
//    CTAUploadDomain.uploadFilePath(){(dic, error) -> Void in
//        if ((error as? CTARequestSuccess) != nil) {
//            let publishFilePath = dic![key(.PublishFilePath)]
//            let userFilePath    = dic![key(.UserFilePath)]
//            CTAFilePath.userFilePath = String(userFilePath)
//            CTAFilePath.publishFilePath = String(publishFilePath)
//        }else {
//            print("error: \(error)")
//        }
//    }
//
//    CTAUserDomain.login("15501005475", areaCode: "102208", passwd: "222222") { (userModel, error) -> Void in
//        
//        if ((error as? CTARequestSuccess) != nil) {
//            print("userModel = \(userModel)")
//            
//        }else if let error = error as? CTAUserLoginError {
//            print("error: \(error)")
//        }
//    }
    
//    CTAPublishDomain .newPublishList("", start: 0) { (publishList, ErrorType) -> Void in
//        
//        print(publishList);
//        
//    }
  }
    
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

