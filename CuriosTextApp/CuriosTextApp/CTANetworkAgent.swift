//
//  CTARequestAgent.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/4/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation
import Alamofire

extension CTARequestMethod {
  
  private func toAlamofireMethod() -> Alamofire.Method {
    switch self {
    case .POST:
      return .POST
    }
  }
}

final class CTANetworkAgent {
  
  static let shareInstance = CTANetworkAgent()
  private let config = CTANetworkConfig.shareInstance
  private var requestRecords = [Int: CTABaseRequest]()
  
  func addRequest(request: CTABaseRequest) {
    let method = request.requestMethod()
    let url = buildRequestUrl(request)
    let parameters = request.requestParameters()
    let serialType = request.requestSerializerType()
    
    // TODO: 'requestManager' set requestMethod -- Emiaostein; 2015-12-04-16:42
    
    
    // TODO: 'requestManager' set timeoutInterval -- Emiaostein; 2015-12-04-16:42
    
    
    // TODO: api need server userName and password -- Emiaostein; 2015-12-04-16:43
    
    
    // TODO: api need add custom value to httpHeadField -- Emiaostein; 2015-12-04-16:45
    
    
    // TODO: api build custom request -- Emiaostein; 2015-12-04-16:46
    

    let urlRequest = Alamofire.request(method.toAlamofireMethod(), url, parameters: parameters)
    request.dependenceRequest = urlRequest
    switch serialType {
      
    case .JSON:
      urlRequest.validate().responseJSON {response -> Void in
        self.handleResponse(response)
      }
    }
    
    appendRequest(request)
  }
  
  func cancelRequest(request: CTABaseRequest) {
    request.dependenceRequest?.cancel()
    removeRequest(request)
    request.cleanCompletionBlock()
  }
  
  func cancelAllRequests() {
    let requestRecordCopy = requestRecords
    
    for (_, request) in requestRecordCopy {
      request.stop()
    }
  }
  
}

extension CTANetworkAgent {
  
  private func appendRequest(request: CTABaseRequest) {
    guard let dependenceRequest = request.dependenceRequest, let urlrequest = dependenceRequest.request else {
      return
    }
    let hashValue = urlrequest.hashValue
    requestRecords[hashValue] = request
  }
  
  private func removeRequest(request: CTABaseRequest) {
    guard let dependenceRequest = request.dependenceRequest, let urlrequest = dependenceRequest.request else {
      return
    }
    
    let hashValue = urlrequest.hashValue
    requestRecords[hashValue] = nil
    
  }
  
  private func buildRequestUrl(request: CTABaseRequest) -> String {
    let requestUrl = request.requestUrl()
    
    guard !requestUrl.hasPrefix("http") else {
      return requestUrl
    }
    
    let baseUrl = request.baseUrl().isEmpty ? config.baseUrl : request.baseUrl()
    return "\(baseUrl)\(requestUrl)"
  }
  
  private func handleResponse(response: Response<AnyObject, NSError>) {
    
    guard let urlRequest = response.request else {
      return
    }
    
    let hashValue = urlRequest.hashValue
    
    guard let request = requestRecords[hashValue] else {
      return
    }
    
    switch response.result {
    case .Success(let value):
      let aresult = CTARequestResult<AnyObject, NSError>.Success(value)
      let aresponse = CTARequestResponse(request: response.request, response: response.response, data: response.data, result: aresult)
      if let completionBlock = request.completionBlock {
        completionBlock(aresponse)
      }
    case .Failure(let error):
      let aresult = CTARequestResult<AnyObject, NSError>.Failure(error)
      let aresponse = CTARequestResponse(request: response.request, response: response.response, data: response.data, result: aresult)
      if let completionBlock = request.completionBlock {
        completionBlock(aresponse)
      }
    }
    request.cleanCompletionBlock()
  }
  
}