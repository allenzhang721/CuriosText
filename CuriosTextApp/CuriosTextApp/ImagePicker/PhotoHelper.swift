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
    case success
    case authorized(alert: UIAlertController)
    case failture
}

func photo_saveImageToLibrary(_ image: UIImage ,finishedHandler:((PhotoSaveStatus) -> ())?) {
    
    func save(_ image: UIImage, finishedHandler:((PhotoSaveStatus) -> ())?) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) {finishedHandler?($0.0 ? .success : .failture)}
    }
    
    func openSetting() {
        // alert to open setting
        let cancelTitle = LocalStrings.cancel.description
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        
        let doneTitle = LocalStrings.ok.description
        let doneAction = UIAlertAction(title: doneTitle, style: .default) { (action) in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        }
        
        let alertTitle = LocalStrings.allowPhotoTitle.description
        let message = LocalStrings.allowPhotoMessage.description
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(cancelAction)
        alert.addAction(doneAction)
        
        finishedHandler?(.authorized(alert: alert))
        
//        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    func authorize() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                save(image, finishedHandler: finishedHandler)
                
            default:
                finishedHandler?(.failture)
            }
        }
    }
    
    let status = PHPhotoLibrary.authorizationStatus()
    
    switch status {
    case .authorized:
        save(image, finishedHandler: finishedHandler)
        
    case .notDetermined:
        authorize()
        
    default:
        openSetting()
    }
}
