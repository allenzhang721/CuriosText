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
        return CTARequestUrl.UploadFilePath.description;
    }
}

class CTAUserUpTokenRequest: CTABaseRequest {
    
    let list:Array<CTAUpTokenModel>;
    
    init(list:Array<CTAUpTokenModel>) {
        self.list = list;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.UserUpToken.description;
    }
    
    override func parameter() -> String {
        var keyArray:Array<AnyObject> = [];
        for var i=0; i < list.count; i++ {
            let upTokeModel:CTAUpTokenModel = list[i]
            keyArray.append(upTokeModel.data)
        }
        let dic:Dictionary<String, AnyObject> = [
            key(.List): keyArray
        ];
        return self.getParameterString(dic, errorMessage: "CTAUserUpTokenRequest");
    }
}

class CTAPublishUpTokenRequest: CTABaseRequest {
    
    let list:Array<CTAUpTokenModel>;
    
    init(list:Array<CTAUpTokenModel>) {
        self.list = list;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.PublishUpToken.description;
    }
    
    override func parameter() -> String {
        var keyArray:Array<AnyObject> = [];
        for var i=0; i < list.count; i++ {
            let upTokeModel:CTAUpTokenModel = list[i]
            keyArray.append(upTokeModel.data)
        }
        let dic:Dictionary<String, AnyObject> = [
            key(.List): keyArray
        ];
        return self.getParameterString(dic, errorMessage: "CTAPublishUpTokenRequest");
    }
}