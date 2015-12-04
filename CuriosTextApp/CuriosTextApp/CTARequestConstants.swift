//
//  CTARequestConstants.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/4/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation

func key(key: CTARequestParameterKey) -> String {
  return key.description
}

enum CTARequestHost: CustomStringConvertible {
  case Test, Debug, Production
  
  var description: String {
    switch self {
    case .Test:
      return "http://182.92.150.178/CuriosTextServices"
    case .Debug:
      return ""
    case .Production:
      return ""
    }
  }
}

enum CTARequestUrl: CustomStringConvertible {
  case PhoneRegister
  
  var description: String {
    switch self {
    case .PhoneRegister:
      return "/user/register"
    }
  }
}

enum CTARequestParameterKey: CustomStringConvertible {
  case Data
  case Phone, AreaCode, Password
  
  var description: String {
    switch self {
    case .Data:
      return "data"
    case .Phone:
      return "phone"
    case .AreaCode:
      return "areaCode"
    case .Password:
      return "password"
    }
  }
}