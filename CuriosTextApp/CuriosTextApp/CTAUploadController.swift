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
        do {
            let file:QNFileRecorder = try QNFileRecorder(folder: NSTemporaryDirectory().stringByAppendingString("Curios"))
            self.uploadManager = QNUploadManager.init(recorder: file)
        } catch {
            self.uploadManager = QNUploadManager()
        }
    }
    
    static var _instance:CTAUploadController?;
    
    var delegate:CTAUploadProtocol?;

    var uploadArray:Array<CTAUploadModel>;
    
    let uploadManager:QNUploadManager;
    
    static func getInstance() -> CTAUploadController{
        if _instance == nil {
            _instance = CTAUploadController.init();
        }
        return _instance!;
    }
    
    func uploadFile(uploadModel:CTAUploadModel) {
        if !checkUploadModel(uploadModel) {
            self.uploadArray.append(uploadModel)
        }
        self.uploadAction(uploadModel.uploadID);
    }
    
    func uploadFileArray(uploadModelArray:Array<CTAUploadModel>){
        if uploadModelArray.count > 0{
            for i in 0..<uploadModelArray.count {
                let uploadModel = uploadModelArray[i]
                if !checkUploadModel(uploadModel) {
                    self.uploadArray.append(uploadModel)
                }
            }
            let uploadModel:CTAUploadModel = uploadModelArray[0]
            self.uploadAction(uploadModel.uploadID);
        }
    }
    
    func getUnUploadModel(uploadID:String = "") -> CTAUploadModel?{
        var uploadModel:CTAUploadModel?
        for i in 0..<self.uploadArray.count {
            let oldModel:CTAUploadModel = self.uploadArray[i]
            if !oldModel.isUploading{
                if uploadID != "" {
                    if(oldModel.uploadID == uploadID){
                        uploadModel = oldModel
                        break;
                    }
                }else {
                    uploadModel = oldModel
                    break;
                }
            }
        }
        return uploadModel
    }
    
    func uploadAction(uploadID:String){
        if self.getUploadingCount() < 4{
            var uploadModel:CTAUploadModel? = self.getUnUploadModel(uploadID);
            if uploadModel == nil{
                uploadModel = self.getUnUploadModel();
            }
            if let uploadModel = uploadModel {
                self.uploadStart(uploadModel.key)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    let option = QNUploadOption(mime: nil, progressHandler: { (fileKey, progress) -> Void in
                            CTAUploadController.getInstance().uploadProgress(fileKey, progress: progress)
                        }, params: nil, checkCrc: true, cancellationSignal: nil)
                    var ainfo: QNResponseInfo!
                    var afileKey: String!
                    var aresponse:  [NSObject : AnyObject]?
                    if uploadModel.isUploadData {
                        self.uploadManager.putData(uploadModel.fileData, key: uploadModel.key, token: uploadModel.token, complete: { (info, fileKey, response) -> Void in
                                ainfo = info
                                afileKey = fileKey
                                aresponse = response
                            
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.uploadCompleted(ainfo, filekey: afileKey, response: aresponse)
                                })
                            }, option: option)
                    }else {
                        self.uploadManager.putFile(uploadModel.filePath, key: uploadModel.key, token: uploadModel.token, complete: { (info, fileKey, response) -> Void in
                                ainfo = info
                                afileKey = fileKey
                                aresponse = response
                            
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.uploadCompleted(ainfo, filekey: afileKey, response: aresponse)
                                })
                            }, option: option)
                    }
                })
            }
        }
    }
    
    func uploadStart(fileKey:String){
        let uploadModel = self.getUploadModelByKey(fileKey)
        if uploadModel != nil {
            uploadModel!.isUploading = true
            if let delegate = self.delegate {
                delegate.uploadStart(uploadModel!)
            }
        }
    }
    
    func uploadProgress(fileKey:String, progress:Float){
        let uploadModel = self.getUploadModelByKey(fileKey)
        if uploadModel != nil {
            if let delegate = self.delegate {
                delegate.uploadProgress(uploadModel!, progress: progress)
            }
        }
    }
    
    func uploadCompleted(info: QNResponseInfo!, filekey: String!, response: [NSObject : AnyObject]?) {
        let uploadModel = self.getUploadModelByKey(filekey)
        if uploadModel != nil {
            uploadModel!.isUploading = false
            let isUploadOk = info.ok && response != nil
            if isUploadOk {
                uploadModel!.uploadComplete = true
                if let delegate = self.delegate {
                    delegate.uploadComplete(uploadModel!)
                }
                self.uploadModelComplete(uploadModel!)
            } else {
                uploadModel!.uploadComplete = false
                if let delegate = self.delegate {
                    delegate.uploadError(uploadModel!, error: CTAUploadError(rawValue: 10)!)
                }
            }
        }
    }
    
    func uploadModelComplete(uploadModel:CTAUploadModel) {
        var index:Int = -1
        for i in 0..<self.uploadArray.count {
            let oldModel:CTAUploadModel = self.uploadArray[i];
            if oldModel.key == uploadModel.key {
                index = i;
            }
        }
        if index != -1{
            self.uploadArray.removeAtIndex(index)
        }
        if self.uploadArray.count == 0{
            self.delegate = nil;
        }else {
            self.uploadAction(uploadModel.uploadID);
        }
    }
    
    func checkUploadModel(uploadModel:CTAUploadModel) -> Bool{
        for i in 0..<self.uploadArray.count {
            let oldModel:CTAUploadModel = self.uploadArray[i];
            if oldModel.key == uploadModel.key {
                return true
            }
        }
        return false
    }
    
    func getUploadModelByKey(fileKey:String) -> CTAUploadModel? {
        var uploadModel:CTAUploadModel?;
        for i in 0..<self.uploadArray.count {
            let oldModel:CTAUploadModel = self.uploadArray[i]
            if oldModel.key == fileKey {
                uploadModel = oldModel
                break
            }
        }
        return uploadModel
    }
    
    func getUploadingCount() -> Int {
        var count:Int = 0
        for i in 0..<self.uploadArray.count {
            let oldModel:CTAUploadModel = self.uploadArray[i]
            if oldModel.isUploading {
                count+=1
            }
        }
        return count;
    }
    

}