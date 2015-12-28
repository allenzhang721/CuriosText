//
//  CTADomainListModel.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/28.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation
class CTADomainListInfo {
    
    let result:Bool
    var modelArray:Array<AnyObject>?
    var modelDic:Dictionary<String, AnyObject>?
    var errorType:ErrorType?
    var successType:Int?
    
    init(result:Bool, modelArray:Array<AnyObject>, successType:Int){
        self.result      = result
        self.modelArray  = modelArray
        self.successType = successType
    }
    
    init(result:Bool, modelDic:Dictionary<String, AnyObject>, successType:Int){
        self.result      = result
        self.modelDic    = modelDic
        self.successType = successType
    }
    
    init(result:Bool, successType:Int){
        self.result      = result
        self.successType = successType
    }
    
    init(result:Bool, errorType:ErrorType){
        self.result    = result
        self.errorType = errorType
    }
}