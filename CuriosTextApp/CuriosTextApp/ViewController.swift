//
//  ViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/4/15.
//  Copyright © 2015 botai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
   
    var id = self.publishFile();
    print("index = \(1) id = \(id)")
    
    let time: NSTimeInterval = 1.0
    let delay = dispatch_time(DISPATCH_TIME_NOW,
        Int64(time * Double(NSEC_PER_SEC)))
    dispatch_after(delay, dispatch_get_main_queue()) {
        id = self.publishFile();
        print("index = \(2) id = \(id)")
    }
    
  }
    
    func publishFile() -> String {
        let publishID = self.changeUUID(NSUUID().UUIDString)
        
        let publishIconURL = generateTempFileBy(1024*1024)
        let publishIconKey = publishID+"/icon.jpg"
        
        let previewIconURL = generateTempFileBy(2048*1024)
        let previewIconKey = publishID+"/preview.jpg"
        
        let publishJsonURL = generateTempFileBy(10*1024)
        let publishJsonKey = publishID+"/publish.json"
        
        let publishImageURL = generateTempFileBy(800*1024)
        let publishImageKey = publishID+"/publish.jpg"
        
        var upTokenArray:Array<CTAUpTokenModel> = []
        
        upTokenArray.append(CTAUpTokenModel.init(upTokenKey: publishIconKey))
        upTokenArray.append(CTAUpTokenModel.init(upTokenKey: publishJsonKey))
        upTokenArray.append(CTAUpTokenModel.init(upTokenKey: publishImageKey))
        upTokenArray.append(CTAUpTokenModel.init(upTokenKey: previewIconKey))
        
        var uploadArray:Array<CTAUploadModel> = []
        CTAUpTokenDomain.getInstance().publishUpToken(upTokenArray) { (listInfo) -> Void in
            if listInfo.result {
                let modelArray = listInfo.modelArray;
                if modelArray != nil {
                    
                    var uploadModel:CTAUploadModel?;
                    for var i=0 ; i < modelArray!.count; i++ {
                        let uptokenModel:CTAUpTokenModel = modelArray![i] as! CTAUpTokenModel
                        switch uptokenModel.upTokenKey {
                        case publishIconKey:
                            uploadModel = CTAUploadModel.init(key: uptokenModel.upTokenKey, token: uptokenModel.upToken, filePath: publishIconURL.path!)
                        case previewIconKey:
                            uploadModel = CTAUploadModel.init(key: uptokenModel.upTokenKey, token: uptokenModel.upToken, filePath: previewIconURL.path!)
                        case publishJsonKey:
                            uploadModel = CTAUploadModel.init(key: uptokenModel.upTokenKey, token: uptokenModel.upToken, filePath: publishJsonURL.path!)
                        case publishImageKey:
                            uploadModel = CTAUploadModel.init(key: uptokenModel.upTokenKey, token: uptokenModel.upToken, filePath: publishImageURL.path!)
                        default:
                            uploadModel = nil;
                        }
                        if uploadModel != nil {
                            uploadArray.append(uploadModel!)
                        }
                    }
                    let a:NSDate = NSDate();
                    print("upload Begin \(a)");
            
                    CTAUploadAction.getInstance().uploadFileArray(publishID, uploadArray: uploadArray, progress: { (progressInfo) -> Void in
                          print("upload File = \(progressInfo.uploadID) progress = \(progressInfo.progress)")
                            }, complete: { (info) -> Void in
                            if info.result{
                                print("upload File = \(info.uploadID) complete")
                                let b:NSDate = NSDate();
                                print("upload Complete \(b)");
                            }
                        })
                }
            }
        }
        return publishID
    }
    
    func changeUUID(uuid:String) ->String{
        var newID:String = uuid;
        while  newID.rangeOfString("-") != nil{
            let range = newID.rangeOfString("-")
            newID.replaceRange(range!, with: "")
        }
        return newID;
    }
    
    func generateTempFileBy(fileSize: Int) -> NSURL {
        let fileName = NSProcessInfo.processInfo().globallyUniqueString + "_file.extension"
        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory() + "/" + fileName)
        let tempData = NSMutableData(length: fileSize)
        tempData?.writeToURL(fileURL, atomically: false)
        return fileURL
    }
    
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

