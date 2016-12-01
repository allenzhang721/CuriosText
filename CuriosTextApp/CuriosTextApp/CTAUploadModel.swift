//
//  CTAUploadModel.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/23.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation

class CTAUploadModel {
    
    let key:String; // Service relative path: /publishID/fileName.png --  Emiaostein, 1/02/16, 18:15
    let token:String;
    var filePath:String; // file's local absolute path --  Emiaostein, 1/02/16, 18:18
    var uploadID:String = "";
    var isUploading:Bool = false;
    var uploadProgress:Float = 0.0;
    var uploadComplete:Bool = false;
    var fileData:Data?
    let isUploadData:Bool
    
    init(key:String, token:String, filePath:String){
        self.key          = key;
        self.token        = token;
        self.filePath     = filePath;
        self.fileData     = nil;
        self.isUploadData = false;
    }
    
    init(key:String, token:String, fileData:Data){
        self.key          = key;
        self.token        = token;
        self.fileData     = fileData;
        self.filePath     = ""
        self.isUploadData = true;
    }
    
}
