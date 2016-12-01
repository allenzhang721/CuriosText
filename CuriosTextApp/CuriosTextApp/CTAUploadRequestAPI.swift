//
//  CTAUploadRequestAPI.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/9.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation
class CTAUploadFileRequest: CTABaseRequest {
    
    override func requestUrl() -> String {
        return CTARequestUrl.uploadFilePath.description;
    }
}

class CTAUserUpTokenRequest: CTABaseRequest {
    
    let list:Array<CTAUpTokenModel>;
    
    init(list:Array<CTAUpTokenModel>) {
        self.list = list;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.userUpToken.description;
    }
    
    override func parameter() -> String {
        var keyArray:Array<AnyObject> = [];
        for i in 0..<list.count {
            let upTokeModel:CTAUpTokenModel = list[i]
            keyArray.append(upTokeModel.data as AnyObject)
        }
        let dic:Dictionary<String, AnyObject> = [
            key(.list): keyArray as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAUserUpTokenRequest");
    }
}

class CTAPublishUpTokenRequest: CTABaseRequest {
    
    let list:Array<CTAUpTokenModel>;
    
    init(list:Array<CTAUpTokenModel>) {
        self.list = list;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.publishUpToken.description;
    }
    
    override func parameter() -> String {
        var keyArray:Array<AnyObject> = [];
        for i in 0..<list.count {
            let upTokeModel:CTAUpTokenModel = list[i]
            keyArray.append(upTokeModel.data as AnyObject)
        }
        let dic:Dictionary<String, AnyObject> = [
            key(.list): keyArray as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAPublishUpTokenRequest");
    }
}

class CTAResourceUpTokenRequest: CTABaseRequest{
    
    let list:Array<CTAUpTokenModel>;
    
    init(list:Array<CTAUpTokenModel>) {
        self.list = list;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.resourceUpToken.description;
    }
    
    override func parameter() -> String {
        var keyArray:Array<AnyObject> = [];
        for i in 0..<list.count {
            let upTokeModel:CTAUpTokenModel = list[i]
            keyArray.append(upTokeModel.data as AnyObject)
        }
        let dic:Dictionary<String, AnyObject> = [
            key(.list): keyArray as AnyObject
        ];
        return self.getParameterString(dic as AnyObject, errorMessage: "CTAResourceUpTokenRequest");
    }
}
