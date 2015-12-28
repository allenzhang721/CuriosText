//
//  CTAUploadModel.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/23.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation

class CTAUploadModel {
    
    let key:String;
    let token:String;
    let upProtocolID:String;
    var filePath:String?;
    var fileData:NSData?;
    var isUploading:Bool = false;
 
    
    init(key:String, token:String, upProtocolID:String, filePath:String){
        self.key          = key;
        self.token        = token;
        self.upProtocolID = upProtocolID;
        self.filePath     = filePath;
    }
    
    init(key:String, token:String, upProtocolID:String, fileData:NSData){
        self.key          = key;
        self.token        = token;
        self.upProtocolID = upProtocolID;
        self.fileData     = fileData;
    }
    
}