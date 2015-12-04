//
//  CTARequestAgent.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/4/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation

final class CTANetworkAgent {
  
  static let shareInstance = CTANetworkAgent()
  private let config = CTANetworkConfig.shareInstance
  private var requests = ContiguousArray<CTABaseRequest>()
  
  func addRequest(request: CTABaseRequest) {
    let method = request.requestMethod()
    let url = buildRequestUrl(request)
    let argument = request.requestArgument()
    
    
    // TODO: 'requestManager' set requestMethod -- Emiaostein; 2015-12-04-16:42
    
    
    // TODO: 'requestManager' set timeoutInterval -- Emiaostein; 2015-12-04-16:42
    
    
    // TODO: api need server userName and password -- Emiaostein; 2015-12-04-16:43
    
    
    // TODO: api need add custom value to httpHeadField -- Emiaostein; 2015-12-04-16:45
    
    
    // TODO: api build custom request -- Emiaostein; 2015-12-04-16:46
    
    
  }
  
  func cancelRequest(request: CTABaseRequest) {
    
  }
  
  func cancelAllRequests() {
    
  }

}

extension CTANetworkAgent {
  
  private func buildRequestUrl(request: CTABaseRequest) -> String {
    let requestUrl = request.requestUrl()
    
    guard !requestUrl.hasPrefix("http") else {
      return requestUrl
    }
    
    let baseUrl = request.baseUrl().isEmpty ? config.baseUrl : request.baseUrl()
    return "\(baseUrl)\(requestUrl)"
  }
  
}