//
//  CTAUploadProtrocol.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/23.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation

protocol CTAUploadProtocol{
    func uploadStart(uploadModel:CTAUploadModel)
    func uploadProgress(uploadModel:CTAUploadModel, progress:Float)
    func uploadComplete(uploadModel:CTAUploadModel)
    func uploadError(uploadModel:CTAUploadModel, error:ErrorType)
}
