//
//  CTAUploadProtrocol.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/23.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation

protocol CTAUploadProtocol{

    func getProtocolID() -> String;
    func uploadStart(fileKey:String)
    func uploadProgress(fileKey:String, progress:Float)
    func uploadComplete(fileKey:String)
    func uploadError(fileKey:String, error:ErrorType)
}
