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
   
    var list:Array<AnyObject> = Array<AnyObject>();
    let a = [
    "key":"qhjsklajkl"
    ];
    let b = [
    "key":"111222333"
    ]
    list.append(a);
    list.append(b);
    let request = CTAPublishUpTokenRequest.init(list: list);
    
    request.startWithCompletionBlockWithSuccess { (response) -> Void in
      
      switch response.result {
      case .Success(let JSON):
        print(JSON)
      case .Failure(let networkError):
        print(networkError)
      }
    }
  }
    
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

