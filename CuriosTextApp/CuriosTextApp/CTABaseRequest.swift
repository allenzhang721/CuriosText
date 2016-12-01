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
  case post
}

enum CTARequestSerializerType {
  case json // or HTTP
}

protocol CTARequestDelegate: NSObjectProtocol {
  
  func requestDidFinished(_ request: CTABaseRequest)
  func requestFailed(_ request: CTABaseRequest)
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
  
  func startWithCompletionBlockWithSuccess(_ completionBlock: ((CTARequestResponse<AnyObject, NSError>) -> Void)?) {
    self.completionBlock = completionBlock
    start()
  }
  
  func setCompletionBlockWithSuccess(_ completionBlock: ((CTARequestResponse<AnyObject, NSError>) -> Void)?) {
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
    return .post
  }
  
  func requestSerializerType() -> CTARequestSerializerType {
    return .json
  }
  
  func requestParameters() -> [String: AnyObject]? {
    let para = parameter()
    
    return [key(.data): para as AnyObject]
  }
    
  func parameter() ->String{
   return "";
  }
    
  func getParameterString(_ dic: AnyObject, errorMessage:String) ->String{
    do {
        let data = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions(rawValue: 0))
            
        return NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String
            
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
