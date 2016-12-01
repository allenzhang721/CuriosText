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
    func savePublishArray(_ baseRequest:CTABaseRequest, modelArray:Array<CTAPublishModel>)
    func getPublishArray(_ baseRequest:CTABaseRequest)->Array<CTAPublishModel>?
    
    func saveUserDetail(_ baseRequest:CTABaseRequest, userDetail:CTAViewUserModel)
    func getUserDetail(_ baseRequest:CTABaseRequest) -> CTAViewUserModel?
}

extension CTAPublishCacheProtocol {
    
    func savePublishArray(_ baseRequest:CTABaseRequest, modelArray:Array<CTAPublishModel>){
        let dataURL = self.getRequestURL(baseRequest)
        var dataArray:Array<[String: AnyObject]> = []
        for i in 0..<modelArray.count{
            let model = modelArray[i]
            let modelDic = model.getData()
            dataArray.append(modelDic as [String : AnyObject])
        }
        let dir:[String: AnyObject] = ["dataArray":dataArray as AnyObject]
        let data = try? JSONSerialization.data(withJSONObject: dir, options: JSONSerialization.WritingOptions(rawValue: 0))
        if data != nil{
            BlackCatManager.init().storeData(data!, byURL: dataURL) { (result) -> () in
            }
        }
    }
    
    func getPublishArray(_ baseRequest:CTABaseRequest) -> Array<CTAPublishModel>?{
        let dataURL = self.getRequestURL(baseRequest)
        var modelArray:Array<CTAPublishModel>? = nil
        BlackCatManager.init().retriveDataForURL(dataURL) { (data) -> () in
            if data != nil {
                let dic = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String: AnyObject]
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
    
    func saveUserDetail(_ baseRequest:CTABaseRequest, userDetail:CTAViewUserModel){
        let dataURL = self.getRequestURL(baseRequest)
        let dir:[String: AnyObject] = userDetail.getData() as [String : AnyObject]
        let data = try? JSONSerialization.data(withJSONObject: dir, options: JSONSerialization.WritingOptions(rawValue: 0))
        if data != nil{
            BlackCatManager.init().storeData(data!, byURL: dataURL) { (result) -> () in
            }
        }
    }
    
    func getUserDetail(_ baseRequest:CTABaseRequest) -> CTAViewUserModel?{
        let dataURL = self.getRequestURL(baseRequest)
        var model:CTAViewUserModel? = nil
        BlackCatManager.init().retriveDataForURL(dataURL) { (data) -> () in
            if data != nil {
                let dic = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String: AnyObject]
                let json:JSON = JSON(dic!)
                if json != nil {
                    model = CTAViewUserModel.generateFrom(json)
                }
            }
        }
        return model
    }
    
    func getRequestURL(_ baseRequest:CTABaseRequest) -> String{
        let requestUrl = buildRequestUrl(baseRequest)
        let parament = baseRequest.parameter()
        var newParment:String = ""
        for character in parament.characters {
            if character != "\"" {
                newParment = newParment+String(stringInterpolationSegment: character)
            }
        }
        let dataURL = requestUrl+"?data="+newParment
        return dataURL
    }
    
    func getDicString(_ dic: AnyObject, errorMessage:String) ->String{
        do {
            let data = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions(rawValue: 0))
            
            return NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String
        } catch let error {
            
            print("\(errorMessage) is error, error message \(error)")
            
            return ""
        }
    }
    
    func buildRequestUrl(_ request: CTABaseRequest) -> String {
        let requestUrl = request.requestUrl()
        
        guard !requestUrl.hasPrefix("http") else {
            return requestUrl
        }
    
        let baseUrl = request.baseUrl().isEmpty ? CTANetworkConfig.shareInstance.baseUrl : request.baseUrl()
        return "\(baseUrl)\(requestUrl)"
    }
}
