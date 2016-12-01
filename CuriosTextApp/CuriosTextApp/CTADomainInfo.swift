//
//  CTADomainModel.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/28.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation

struct CTADomainInfo {
    
    let result:Bool
    var baseModel:CTABaseModel?
    var errorType:Error?
    var successType:Int = -1
    
    init(result:Bool, baseModel:CTABaseModel, successType:Int){
        self.result      = result
        self.baseModel   = baseModel
        self.successType = successType
    }
    
    init(result:Bool, successType:Int){
        self.result      = result
        self.successType = successType
    }
    
    init(result:Bool, errorType:Error){
        self.result    = result
        self.errorType = errorType
    }
}
