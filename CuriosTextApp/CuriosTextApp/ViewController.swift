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
    
   let request = CTAPhoneRegister.init(phone: "10045647891", areaCode: "102208", password: "123123")
    
    request.startWithCompletionBlockWithSuccess { (response) -> Void in
      
      switch response.result {
      case .Success(let JSON):
        print(JSON)
      case .Failure(let networkError):
        ()
      }
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

