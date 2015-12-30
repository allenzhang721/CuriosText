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
    let filePath:String;
    var uploadID:String = "";
    var isUploading:Bool = false;
    var uploadProgress:Float = 0.0;
    var uploadComplete:Bool = false;
    
    init(key:String, token:String, filePath:String){
        self.key          = key;
        self.token        = token;
        self.filePath     = filePath;
    }
    
}