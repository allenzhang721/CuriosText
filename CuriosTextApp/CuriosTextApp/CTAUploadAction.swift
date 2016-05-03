//
//  CTAPublishUpload.swift
//  CuriosTextApp
//
//  Created by allen on 15/12/29.
//  Copyright © 2015年 botai. All rights reserved.
//

import Foundation
class CTAUploadAction: CTAUploadProtocol {
    
    var uploadQueue:Array<CTAUploadActionModel>
    
    init(){
        uploadQueue = []
    }
    
    static var _instance:CTAUploadAction?;
    
    static func getInstance() -> CTAUploadAction{
        if _instance == nil {
            _instance = CTAUploadAction.init();
        }
        return _instance!;
    }
    
    func uploadStart(uploadModel:CTAUploadModel){
        
    }
    
    func uploadProgress(uploadModel:CTAUploadModel, progress:Float){
        uploadModel.uploadProgress = progress;
        self.uploadActionProgress(uploadModel)
    }
    
    func uploadComplete(uploadModel:CTAUploadModel){
        uploadModel.uploadProgress = 1;
        uploadModel.uploadComplete = true
        self.uploadActionComplete(uploadModel)
    }
    
    func uploadError(uploadModel:CTAUploadModel, error:ErrorType){
        uploadModel.uploadComplete = false
        self.uploadActionError(uploadModel, error: error)
    }
    
    func uploadActionProgress(uploadModel: CTAUploadModel) {
        let uploadActionModel:CTAUploadActionModel? = self.getUploadActionModel(uploadModel)
        if uploadActionModel != nil {
            self.progressAction(uploadActionModel!)
        }
    }
    
    func uploadActionComplete(uploadModel: CTAUploadModel){
        let uploadActionModel:CTAUploadActionModel? = self.getUploadActionModel(uploadModel)
        if uploadActionModel != nil {
            if self.checkPublishUploadComplete(uploadActionModel!) {
                self.completeAction(uploadActionModel!, uploadInfo: CTAUploadInfo.init(result: true, uploadID: uploadActionModel!.uploadID))
            } else {
                self.progressAction(uploadActionModel!)
            }
        }
    }
    
    func uploadActionError(uploadModel: CTAUploadModel, error: ErrorType){
        let uploadActionModel:CTAUploadActionModel? = self.getUploadActionModel(uploadModel)
        if uploadActionModel != nil {
            self.completeAction(uploadActionModel!, uploadInfo: CTAUploadInfo.init(result: false, uploadID:uploadActionModel!.uploadID , errorType: error))
        }
    }
    
    func completeAction(uploadActionModel:CTAUploadActionModel, uploadInfo:CTAUploadInfo) {
        uploadActionModel.complete(uploadInfo)
        var index:Int = -1
        for i in 0..<self.uploadQueue.count {
            let oldModel:CTAUploadActionModel = self.uploadQueue[i];
            if oldModel.uploadID == uploadActionModel.uploadID {
                index = i;
                break;
            }
        }
        if index != -1{
            self.uploadQueue.removeAtIndex(index)
        }
    }
    
    func progressAction(publishUploadModel:CTAUploadActionModel) {
        let uploadArray = publishUploadModel.uploadArray
        let count:Int = uploadArray.count
        let rate:Float = 1/Float(count);
        var progress:Float = 0.0;
        for i in 0..<count {
            let model:CTAUploadModel = uploadArray[i]
            progress = progress + model.uploadProgress * rate
        }
        publishUploadModel.progress(CTAUploadProgressInfo.init(uploadID: publishUploadModel.uploadID, progress: progress))
    }
    
    func getUploadActionModel(uploadModel: CTAUploadModel) -> CTAUploadActionModel?{
        for i in 0..<self.uploadQueue.count {
            let uploadActionModel:CTAUploadActionModel = self.uploadQueue[i]
            let uploadArray = uploadActionModel.uploadArray
            for j in 0..<uploadArray.count {
                let model:CTAUploadModel = uploadArray[j]
                if(model.key == uploadModel.key){
                    return uploadActionModel
                }
            }
        }
        return nil
    }
    
    func checkPublishUploadComplete(uploadActionModel:CTAUploadActionModel) -> Bool {
        let uploadArray = uploadActionModel.uploadArray
        for i in 0..<uploadArray.count {
            let model:CTAUploadModel = uploadArray[i]
            if(!model.uploadComplete){
                return false
            }
        }
        return true
    }
    
    /**
     User to upload
     
     - parameter uploadID:       publishID
     - parameter uploadArray:    uploadArray description
     - parameter progressHandle:
     - parameter completeHandle:
     */
    func uploadFileArray(uploadID:String, uploadArray:Array<CTAUploadModel>, progress progressHandle:(CTAUploadProgressInfo!) -> Void, complete completeHandle:(CTAUploadInfo!) -> Void){
        for i in 0..<uploadArray.count {
            let uploadMode:CTAUploadModel = uploadArray[i]
            uploadMode.uploadID = uploadID
        }
        self.uploadQueue.append(CTAUploadActionModel.init(uploadID: uploadID, uploadArray: uploadArray, progress: progressHandle, complete: completeHandle))
        CTAUploadController.getInstance().delegate = self
        CTAUploadController.getInstance().uploadFileArray(uploadArray)
    }
    
    func uploadFile(uploadID:String, uploadModel:CTAUploadModel, progress progressHandle:(CTAUploadProgressInfo!) -> Void, complete completeHandle:(CTAUploadInfo!) -> Void){
        
        uploadModel.uploadID = uploadID
        var uploadArray:Array<CTAUploadModel> = []
        uploadArray.append(uploadModel)
        self.uploadQueue.append(CTAUploadActionModel.init(uploadID: uploadID, uploadArray: uploadArray, progress: progressHandle, complete: completeHandle))
        CTAUploadController.getInstance().delegate = self
        CTAUploadController.getInstance().uploadFile(uploadModel)
    }
}

class CTAUploadInfo {
    
    let result:Bool
    let uploadID:String
    var errorType:ErrorType?
    var data:AnyObject?
    
    init(result:Bool, uploadID:String, errorType:ErrorType? = nil, data:AnyObject? = nil){
        self.result    = result
        self.uploadID  = uploadID
        self.errorType = errorType
        self.data      = data
    }
}

class CTAUploadProgressInfo {
    let uploadID:String
    let progress:Float
    
    init(uploadID:String, progress:Float){
        self.uploadID = uploadID
        self.progress = progress
    }
}

class CTAUploadActionModel {
    let uploadID:String
    let uploadArray:Array<CTAUploadModel>
    let progress: (CTAUploadProgressInfo!) -> Void
    let complete: (CTAUploadInfo!) -> Void

    init(uploadID:String, uploadArray:Array<CTAUploadModel>, progress:(CTAUploadProgressInfo!) -> Void, complete:(CTAUploadInfo!) -> Void){
        self.uploadID    = uploadID;
        self.uploadArray = uploadArray;
        self.progress    = progress;
        self.complete    = complete;
    }
}