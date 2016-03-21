//
//  PhotoHelper.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 3/21/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

func photo_saveImageToLibrary(image: UIImage, finishedHandler:((Bool) -> ())?) {
    
    func save(image: UIImage, finishedHandler:((Bool) -> ())?) {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromImage(image)
        }) {finishedHandler?($0.0)}
    }
    
    func openSetting() {
        // alert to open setting
        let cancelTitle = "Cancel"
        let cancelAction = UIAlertAction(title: cancelTitle, style: .Cancel, handler: nil)
        
        let doneTitle = "OK"
        let doneAction = UIAlertAction(title: doneTitle, style: .Default) { (action) in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }
        
        let alertTitle = "Please Allow Access to Your Photos"
        let message = "This allow Curios to share photos from your library and save photos to your camera roll."
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .Alert)
        alert.addAction(cancelAction)
        alert.addAction(doneAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func authorize() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .Authorized:
                save(image, finishedHandler: finishedHandler)
                
            default:
                finishedHandler?(false)
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