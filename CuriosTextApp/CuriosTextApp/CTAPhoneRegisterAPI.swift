//
//  CTAPhoneRegisterAPI.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/4/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation

class CTAPhoneRegister: CTABaseRequest {
  
  let phone: String
  let areaCode: String
  let password: String
  
  init(phone: String, areaCode: String, password: String) {
    
    self.phone = phone
    self.areaCode = areaCode
    self.password = password
  }
  
  override func requestUrl() -> String {
    return CTARequestUrl.PhoneRegister.description
  }
  
  override func requestParameters() -> [String : AnyObject]? {
    
    let para = parameter()
    
    return [key(.Data): para]
  }
  
  private func parameter() -> String {
    
    let dic = [
      key(.Phone): phone,
      key(.AreaCode): areaCode,
      key(.Password): password
    ]
    
    do {
      let data = try NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions(rawValue: 0))
      
      return NSString(data: data, encoding: NSUTF8StringEncoding) as! String
      
    } catch let error {
      
      print(error)
      
      return ""
    }
  }
  
}