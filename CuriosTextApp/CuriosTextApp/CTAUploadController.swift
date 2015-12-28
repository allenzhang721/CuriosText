//
//  CTAUploadController.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/23.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation
import Qiniu

class CTAUploadController {
    
    init(){
        self.uploadArray = [];
        self.uploadDelegateArray = [];
    }
    
    static var _instance:CTAUploadController?;
    
    var uploadArray:Array<CTAUploadModel>?;
    
    var uploadDelegateArray:Array<CTAUploadProtocol>?;
    
    let uploadManager = QNUploadManager();
    
    static func getInstance() -> CTAUploadController{
        if _instance == nil {
            _instance = CTAUploadController.init();
        }
        return _instance!;
    }
    
    func uploadFile(uploadModel:CTAUploadModel) {
        if !checkUploadModel(uploadModel) {
            self.uploadArray!.append(uploadModel)
        }
        self.uploadAction();
    }
    
    func uploadFileArray(uploadModelArray:Array<CTAUploadModel>){
        for var i=0; i < uploadModelArray.count; i++ {
            let uploadModel = uploadModelArray[i]
            if !checkUploadModel(uploadModel) {
                self.uploadArray!.append(uploadModel)
            }
        }
        self.uploadAction();
    }
    
    func addDelegate(delegate:CTAUploadProtocol) {
        if !checkProtocol(delegate) {
            self.uploadDelegateArray!.append(delegate);
        }
    }
    
    func uploadAction(){
        if self.getUploadingCount() < 5{
            var uploadModel:CTAUploadModel!;
            for var i = 0; i < self.uploadArray!.count; i++ {
                let oldModel:CTAUploadModel = self.uploadArray![i]
                if !oldModel.isUploading{
                    uploadModel = oldModel
                    break;
                }
            }
            
            if uploadModel != nil {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    CTAUploadController.init().uploadStart(uploadModel.key)
                    let option = QNUploadOption(mime: nil, progressHandler: { (fileKey, progress) -> Void in
                        CTAUploadController.init().uploadProgress(fileKey, progress: progress)
                        }, params: nil, checkCrc: true, cancellationSignal: nil)
                    var ainfo: QNResponseInfo!
                    var afileKey: String!
                    var aresponse:  [NSObject : AnyObject]?
                    self.uploadManager.putFile(uploadModel.filePath!, key: uploadModel.key, token: uploadModel.token, complete: { (info, fileKey, response) -> Void in
                        ainfo = info
                        afileKey = fileKey
                        aresponse = response
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.uploadCompleted(ainfo, filekey: afileKey, response: aresponse)
                        })
                        }, option: option)
                })
            }
        }
    }
    
    func uploadStart(fileKey:String){
        let uploadModel = self.getUploadModelByKey(fileKey)
        if uploadModel != nil {
            uploadModel!.isUploading = true
            let delegate = self.getProtocolByID(uploadModel!.upProtocolID)
            if delegate != nil {
                delegate!.uploadStart(fileKey)
            }
        }
    }
    
    func uploadProgress(fileKey:String, progress:Float){
        let uploadModel = self.getUploadModelByKey(fileKey)
        if uploadModel != nil {
            let delegate = self.getProtocolByID(uploadModel!.upProtocolID)
            if delegate != nil {
                delegate!.uploadProgress(fileKey, progress: progress)
            }
        }
    }
    
    func uploadCompleted(info: QNResponseInfo!, filekey: String!, response: [NSObject : AnyObject]?) {
        let uploadModel = self.getUploadModelByKey(filekey)
        var delegate:CTAUploadProtocol?
        if uploadModel != nil {
            uploadModel!.isUploading = false
            delegate = self.getProtocolByID(uploadModel!.upProtocolID)
        }
        if delegate != nil {
            let isUploadOk = info.ok && response != nil
            if isUploadOk {
                delegate!.uploadComplete(filekey)
                self.uploadModelComplete(uploadModel!)
            } else {
                delegate!.uploadError(filekey, error: CTAUploadError(rawValue: 10)!)
            }
        }
    }
    
    func uploadModelComplete(uploadModel:CTAUploadModel) {
        var index:Int = -1
        var upProtocolCount = 0
        for var i=0; i < self.uploadArray!.count; i++ {
            let oldModel:CTAUploadModel = self.uploadArray![i];
            if oldModel.key == uploadModel.key {
                index = i;
            }
            if oldModel.upProtocolID == uploadModel.upProtocolID {
                upProtocolCount++
            }
        }
        if index != -1{
            self.uploadArray!.removeAtIndex(index)
        }
        if upProtocolCount <= 1{
            for var j=0; j < self.uploadDelegateArray!.count; j++ {
                let oldDelegate:CTAUploadProtocol = self.uploadDelegateArray![j];
                if oldDelegate.getProtocolID() == uploadModel.upProtocolID {
                    self.uploadDelegateArray!.removeAtIndex(j)
                    break
                }
            }
        }
        self.uploadAction();
    }
    
    func checkProtocol(delegate:CTAUploadProtocol) -> Bool{
        for var i=0; i < self.uploadDelegateArray!.count; i++ {
            let oldDelegate:CTAUploadProtocol = self.uploadDelegateArray![i];
            if oldDelegate.getProtocolID() == delegate.getProtocolID() {
                return true
            }
        }
        return false
    }
    
    func getProtocolByID(protocolID:String) -> CTAUploadProtocol? {
        var delegate:CTAUploadProtocol?
        for var i=0; i < self.uploadDelegateArray!.count; i++ {
            let oldDelegate:CTAUploadProtocol = self.uploadDelegateArray![i];
            if oldDelegate.getProtocolID() == protocolID {
                delegate = oldDelegate
                break
            }
        }
        return delegate
    }
    
    func checkUploadModel(uploadModel:CTAUploadModel) -> Bool{
        for var i=0; i < self.uploadArray!.count; i++ {
            let oldModel:CTAUploadModel = self.uploadArray![i];
            if oldModel.key == uploadModel.key {
                return true
            }
        }
        return false
    }
    
    func getUploadModelByKey(fileKey:String) -> CTAUploadModel? {
        var uploadModel:CTAUploadModel?;
        for var i=0; i < self.uploadArray!.count; i++ {
            let oldModel:CTAUploadModel = self.uploadArray![i]
            if oldModel.key == fileKey {
                uploadModel = oldModel
                break
            }
        }
        return uploadModel
    }
    
    func getUploadingCount() -> Int {
        var count:Int = 0
        for var i=0; i < self.uploadArray!.count; i++ {
            let oldModel:CTAUploadModel = self.uploadArray![i]
            if oldModel.isUploading {
                count++
            }
        }
        return count;
    }
    

}