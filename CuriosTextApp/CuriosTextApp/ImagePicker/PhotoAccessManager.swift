//
//  PhotoAccessManager.swift
//  ImagePickerApp
//
//  Created by Emiaostein on 2/29/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import Foundation
import Photos

func photoLibraryAuthorizedStatus() {
    
    let status = PHPhotoLibrary.authorizationStatus()
    switch status {
        
    case .Authorized:
        ()
    case .Denied:
        ()
    case .NotDetermined:
        ()
    case .Restricted:
        ()
    }
    
    PHPhotoLibrary.requestAuthorization { (status) in
        switch status {
            
        case .Authorized:
            ()
        case .Denied:
            ()
        case .NotDetermined:
            ()
        case .Restricted:
            ()
        }
    }
    
}