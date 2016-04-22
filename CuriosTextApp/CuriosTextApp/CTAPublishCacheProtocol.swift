//
//  CTAPublishCacheProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/3/3.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol CTAPublishCacheProtocol{
    func savePublishArray(baseRequest:CTABaseRequest, modelArray:Array<CTAPublishModel>)
    func getPublishArray(baseRequest:CTABaseRequest)->Array<CTAPublishModel>?
}

extension CTAPublishCacheProtocol {
    
    func savePublishArray(baseRequest:CTABaseRequest, modelArray:Array<CTAPublishModel>){
        
        let requestUrl = buildRequestUrl(baseRequest)
        let parament = baseRequest.parameter()
        var newParment:String = ""
        for character in parament.characters {
            if character != "\"" {
                newParment = newParment+String(stringInterpolationSegment: character)
            }
        }
        let dataURL = requestUrl+"?data="+newParment
        var dataArray:Array<[String: AnyObject]> = []
        for i in 0..<modelArray.count{
            let model = modelArray[i]
            let modelDic = model.getData()
            dataArray.append(modelDic)
        }
        let dir:[String: AnyObject] = ["dataArray":dataArray]
        let data = try? NSJSONSerialization.dataWithJSONObject(dir, options: NSJSONWritingOptions(rawValue: 0))
        if data != nil{
            BlackCatManager.init().storeData(data!, byURL: dataURL) { (result) -> () in
            }
        }
    }
    
    func getPublishArray(baseRequest:CTABaseRequest) -> Array<CTAPublishModel>?{
        let requestUrl = buildRequestUrl(baseRequest) 
        let parament = baseRequest.parameter()
        var newParment:String = ""
        for character in parament.characters {
            if character != "\"" {
                newParment = newParment+String(stringInterpolationSegment: character)
            }
        }
        let dataURL = requestUrl+"?data="+newParment
        var modelArray:Array<CTAPublishModel>? = nil
        BlackCatManager.init().retriveDataForURL(dataURL) { (data) -> () in
            if data != nil {
                let dic = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! [String: AnyObject]
                let json:JSON = JSON(dic!)
                let dataJson = json["dataArray"].array
                if dataJson != nil {
                    modelArray = []
                    for i in 0..<dataJson!.count{
                        let modelJson = dataJson![i]
                        modelArray!.append(CTAPublishModel.generateFrom(modelJson))
                    }
                }
            }
        }
        return modelArray
    }
    
    func getDicString(dic: AnyObject, errorMessage:String) ->String{
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions(rawValue: 0))
            
            return NSString(data: data, encoding: NSUTF8StringEncoding) as! String
        } catch let error {
            
            print("\(errorMessage) is error, error message \(error)")
            
            return ""
        }
    }
    
    func buildRequestUrl(request: CTABaseRequest) -> String {
        let requestUrl = request.requestUrl()
        
        guard !requestUrl.hasPrefix("http") else {
            return requestUrl
        }
    
        let baseUrl = request.baseUrl().isEmpty ? CTANetworkConfig.shareInstance.baseUrl : request.baseUrl()
        return "\(baseUrl)\(requestUrl)"
    }
}