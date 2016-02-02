//
//  CTAUpTokeModel.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/21.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation
import SwiftyJSON

final class CTAUpTokenModel: CTABaseModel {
    
    let upTokenKey:String; // service path: publishID/fileName.fileExtension
    let upToken:String;
    
    init(upTokenKey:String, upToken:String = ""){
        self.upTokenKey = upTokenKey;
        self.upToken    = upToken;
    }
    
    static func generateFrom(json: JSON) -> CTAUpTokenModel {
        let upTokenKey:String = json[key(.UpTokenKey)].string ?? "";
        let upToken:String    = json[key(.UpToken)].string ?? "";
        
        return CTAUpTokenModel.init(upTokenKey: upTokenKey, upToken:upToken)
    }
    
    func save() throws {
        
    }
}

extension CTAUpTokenModel {
    
    /// The service to which the type belongs
    
    var data: [String: AnyObject] {
        return [
            key(.UpTokenKey)  :self.upTokenKey,
        ]
    }
}