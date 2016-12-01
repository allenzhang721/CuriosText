//
//  CTARequestAgent.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/4/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation
//import Alamofire
//import Alamofire
import Alamofire

extension CTARequestMethod {
  
  fileprivate func toAlamofireMethod() -> Alamofire.HTTPMethod {
    switch self {
    case .post:
      return .post
    }
  }
}

final class CTANetworkAgent {
  
  static let shareInstance = CTANetworkAgent()
  fileprivate let config = CTANetworkConfig.shareInstance
  fileprivate var requestRecords = [Int: CTABaseRequest]()
  
  func addRequest(_ request: CTABaseRequest) {
    let method = request.requestMethod()
    let urlstr = buildRequestUrl(request)
    let parameters = request.requestParameters()
    let serialType = request.requestSerializerType()
    
    // TODO: 'requestManager' set requestMethod -- Emiaostein; 2015-12-04-16:42
    
    
    // TODO: 'requestManager' set timeoutInterval -- Emiaostein; 2015-12-04-16:42
    
    
    // TODO: api need server userName and password -- Emiaostein; 2015-12-04-16:43
    
    
    // TODO: api need add custom value to httpHeadField -- Emiaostein; 2015-12-04-16:45
    
    
    // TODO: api build custom request -- Emiaostein; 2015-12-04-16:46
    
//   let urlRequest = Alamofire.request(url, method: .post, parameters: parameters, encoding: ParameterEncoding, headers: nil)
    
    let urlRequest = Alamofire.request(urlstr, method: .post, parameters: parameters, encoding: URLEncoding.default)
    
//    let urlRequest = Alamofire.request(method.toAlamofireMethod(), url, parameters: parameters)
    request.dependenceRequest = urlRequest
    switch serialType {
      
    case .json:
//      urlRequest.validate().responseJSON {response -> Void in
//        self.handleResponse(response)
//      }
      urlRequest.validate().responseJSON(completionHandler: {[weak self] (response: DataResponse<Any>) in
        guard let sf = self else { return }
        switch response.result {
        case .success(let v):
          let res = CTARequestResponse(request: response.request, response: response.response, data: response.data, result: CTARequestResult<AnyObject, NSError>.success(v as AnyObject))
          sf.handleResponse(res)
          
        case .failure(let error):
          let res = CTARequestResponse(request: response.request, response: response.response, data: response.data, result: CTARequestResult<AnyObject, NSError>.failure(error as NSError))
          sf.handleResponse(res)
        }
        
        
//        let res = CTARequestResponse(request: response.request, response: response.response, data: response.data, result: CTARequestResult<Value, AError>)
//        sf.handleResponse(CTARequestResponse<AnyObject, NSError>)
      })
    }
    
    appendRequest(request)
  }
  
  func cancelRequest(_ request: CTABaseRequest) {
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
  
  fileprivate func appendRequest(_ request: CTABaseRequest) {
    guard let dependenceRequest = request.dependenceRequest, let urlrequest = dependenceRequest.request else {
      return
    }
    let hashValue = urlrequest.hashValue
    requestRecords[hashValue] = request
  }
  
  fileprivate func removeRequest(_ request: CTABaseRequest) {
    guard let dependenceRequest = request.dependenceRequest, let urlrequest = dependenceRequest.request else {
      return
    }
    
    let hashValue = urlrequest.hashValue
    requestRecords[hashValue] = nil
    
  }
  
  fileprivate func buildRequestUrl(_ request: CTABaseRequest) -> String {
    let requestUrl = request.requestUrl()
    
    guard !requestUrl.hasPrefix("http") else {
      return requestUrl
    }
    
    let baseUrl = request.baseUrl().isEmpty ? config.baseUrl : request.baseUrl()
    return "\(baseUrl)\(requestUrl)"
  }
  
  fileprivate func handleResponse(_ response: CTARequestResponse<AnyObject, NSError>) {
    
    guard let urlRequest = response.request else {
      return
    }
    
    let hashValue = urlRequest.hashValue
    
    guard let request = requestRecords[hashValue] else {
      return
    }
    
    switch response.result {
    case .success(let value):
      let aresult = CTARequestResult<AnyObject, NSError>.success(value)
      let aresponse = CTARequestResponse(request: response.request, response: response.response, data: response.data, result: aresult)
      if let completionBlock = request.completionBlock {
        completionBlock(aresponse)
      }
    case .failure(let error):
      let aresult = CTARequestResult<AnyObject, NSError>.failure(error)
      let aresponse = CTARequestResponse(request: response.request, response: response.response, data: response.data, result: aresult)
      if let completionBlock = request.completionBlock {
        completionBlock(aresponse)
      }
    }
    request.cleanCompletionBlock()
  }
  
}
