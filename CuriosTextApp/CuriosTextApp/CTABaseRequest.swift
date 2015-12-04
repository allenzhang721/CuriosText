//
//  CTABaseRequest.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/4/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation

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
  
  func start() {
    CTANetworkAgent.shareInstance.addRequest(self)
  }
  
  func stop() {
    delegate = nil
    CTANetworkAgent.shareInstance.cancelRequest(self)
  }
}

// override by subClass
extension CTABaseRequest {
  
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
  
  func requestArgument() -> [String: AnyObject] {
    return [String: AnyObject]()
  }
  
  func requestTimeoutInterval() -> CFTimeInterval {
    return 30.0
  }
  
}