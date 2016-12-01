//
//  CTAUploadProtrocol.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/23.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation

protocol CTAUploadProtocol{
    func uploadStart(_ uploadModel:CTAUploadModel)
    func uploadProgress(_ uploadModel:CTAUploadModel, progress:Float)
    func uploadComplete(_ uploadModel:CTAUploadModel)
    func uploadError(_ uploadModel:CTAUploadModel, error:Error)
}
