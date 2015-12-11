//
//  CTABaseRequest.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/4/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation
import Alamofire

enum CTARequestMethod {
  case POST
}

enum CTARequestSerializerType {
  case JSON // or HTTP
}

protocol CTARequestDelegate: NSObjectProtocol {
  
  func requestDidFinished(request: CTABaseRequest)
  func requestFailed(request: CTABaseRequest)
}


class CTABaseRequest {
  
  weak var delegate: CTARequestDelegate?
  var completionBlock: ((CTARequestResponse<AnyObject, NSError>) -> Void)?
  var dependenceRequest: (Alamofire.Request)?
  
  func start() {
    CTANetworkAgent.shareInstance.addRequest(self)
  }
  
  func stop() {
    delegate = nil
    CTANetworkAgent.shareInstance.cancelRequest(self)
  }
  
  func startWithCompletionBlockWithSuccess(completionBlock: ((CTARequestResponse<AnyObject, NSError>) -> Void)?) {
    self.completionBlock = completionBlock
    start()
  }
  
  func setCompletionBlockWithSuccess(completionBlock: ((CTARequestResponse<AnyObject, NSError>) -> Void)?) {
      self.completionBlock = completionBlock
  }
  
  func cleanCompletionBlock() {
    completionBlock = nil
  }
  
  
  // MARK: - override by subClass
  
  func baseUrl() -> String {
    return ""
  }
  
  func requestUrl() -> String {
    return ""
  }
  
  func requestMethod() -> CTARequestMethod {
    return .POST
  }
  
  func requestSerializerType() -> CTARequestSerializerType {
    return .JSON
  }
  
  func requestParameters() -> [String: AnyObject]? {
    let para = parameter()
    
    return [key(.Data): para]
  }
    
  func parameter() ->String{
   return "";
  }
    
  func getParameterString(dic: AnyObject, errorMessage:String) ->String{
    do {
        let data = try NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions(rawValue: 0))
            
        return NSString(data: data, encoding: NSUTF8StringEncoding) as! String
            
    } catch let error {
            
        print("\(errorMessage) is error, error message \(error)")
            
        return ""
    }
  }
  
  func requestTimeoutInterval() -> CFTimeInterval {
    return 30.0
  }
}


extension CTABaseRequest {
  

}