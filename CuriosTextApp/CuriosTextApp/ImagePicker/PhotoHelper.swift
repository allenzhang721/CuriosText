//
//  PhotoHelper.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 3/21/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
import Photos
import UIKit

enum PhotoSaveStatus {
    case Success
    case Authorized(alert: UIAlertController)
    case Failture
}

func photo_saveImageToLibrary(image: UIImage ,finishedHandler:((PhotoSaveStatus) -> ())?) {
    
    func save(image: UIImage, finishedHandler:((PhotoSaveStatus) -> ())?) {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            }) {finishedHandler?($0.0 ? .Success : .Failture)}
    }
    
    func openSetting() {
        // alert to open setting
        let cancelTitle = LocalStrings.Cancel.description
        let cancelAction = UIAlertAction(title: cancelTitle, style: .Cancel, handler: nil)
        
        let doneTitle = LocalStrings.OK.description
        let doneAction = UIAlertAction(title: doneTitle, style: .Default) { (action) in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }
        
        let alertTitle = LocalStrings.AllowPhotoTitle.description
        let message = LocalStrings.AllowPhotoMessage.description
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .Alert)
        alert.addAction(cancelAction)
        alert.addAction(doneAction)
        
        finishedHandler?(.Authorized(alert: alert))
        
//        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    func authorize() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .Authorized:
                save(image, finishedHandler: finishedHandler)
                
            default:
                finishedHandler?(.Failture)
            }
        }
    }
    
    let status = PHPhotoLibrary.authorizationStatus()
    
    switch status {
    case .Authorized:
        save(image, finishedHandler: finishedHandler)
        
    case .NotDetermined:
        authorize()
        
    default:
        openSetting()
    }
}