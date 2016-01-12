//
//  CTABaseDomain.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/14/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol CTABaseDomain{
    func checkJsonResult(json: JSON) -> Bool;
    func changeUUID(uuid:String) ->String;
}

extension CTABaseDomain {
    
   func checkJsonResult(json: JSON) -> Bool{
        let reslut = json[CTARequestResultKey.result].string
        if reslut == CTARequestResultKey.success {
            return true;
        }else{
            return false;
        }
    }
    
    func changeUUID(uuid:String) ->String{
        var newID:String = uuid;
        while  newID.rangeOfString("-") != nil{
            let range = newID.rangeOfString("-")
            newID.replaceRange(range!, with: "")
        }
        return newID;
    }
}