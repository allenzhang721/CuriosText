//
//  EMBlackCatResultExtension.swift
//  EMDownloadCacheManager
//
//  Created by Emiaostein on 7/31/15.
//  Copyright (c) 2015 botai. All rights reserved.
//

import Foundation

protocol ResultConvertable {
  associatedtype Result
  static func converFromData(_ data: Data!) -> (Result?, NSError?)
}

extension Data: ResultConvertable {
  
  typealias Result = Data
  static func converFromData(_ data: Data!) -> (Result?, NSError?) {

    var error: NSError? = nil
    if data == nil {
      error = NSError(domain: BlackCatErrorDomain, code: BlackCatError.invalidURL.rawValue, userInfo: nil)
    }
    return (data, error)
  }
}

extension Dictionary: ResultConvertable {
  typealias Result = Dictionary<NSObject, AnyObject>
  static func converFromData(_ data: Data!) -> (Result?, NSError?) {

    if let dic = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [AnyHashable: Any] {
      return (dic as Dictionary.Result?, nil)
    } else {
      let error = NSError(domain: BlackCatErrorDomain, code: BlackCatError.invalidURL.rawValue, userInfo: nil)
      return (nil, error)
    }
  }
}

extension Array: ResultConvertable {
  typealias Result = Array<Dictionary<NSObject, AnyObject>>
  static func converFromData(_ data: Data!) -> (Result?, NSError?) {
    
    if let arr = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [[AnyHashable: Any]] {
      return (arr as Array.Result?, nil)
    } else {
      let error = NSError(domain: BlackCatErrorDomain, code: BlackCatError.invalidURL.rawValue, userInfo: nil)
      return (nil, error)
    }
  }
}
