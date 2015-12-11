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
    
    let list:Array<AnyObject>;
    
    init(list:Array<AnyObject>) {
        self.list = list;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.UserUpToken.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.List): list
        ];
        return self.getParameterString(dic, errorMessage: "CTAUserUpTokenRequest");
    }
}

class CTAPublishUpTokenRequest: CTABaseRequest {
    
    let list:Array<AnyObject>;
    
    init(list:Array<AnyObject>) {
        self.list = list;
    }
    
    override func requestUrl() -> String {
        return CTARequestUrl.PublishUpToken.description;
    }
    
    override func parameter() -> String {
        let dic:Dictionary<String, AnyObject> = [
            key(.List): list
        ];
        return self.getParameterString(dic, errorMessage: "CTAPublishUpTokenRequest");
    }
}