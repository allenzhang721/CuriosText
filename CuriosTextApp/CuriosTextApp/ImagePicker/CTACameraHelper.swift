//
//  CTACameraHelper.swift
//  ImagePickerApp
//
//  Created by Emiaostein on 2/28/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import Foundation
import AVFoundation

final class CTADevicesHelper {
    
    enum CTADeviceType: CustomStringConvertible {
        case Video
        var description: String {
            switch self {
            case .Video:
                return AVMediaTypeVideo
            }
        }
    }
    
    static var defaultDevice: AVCaptureDevice? {
        return deviceWithType(.Video, preferringPosition: .Back)
    }
    
    class func deviceWithType(type: CTADeviceType, preferringPosition position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        
        let devices = AVCaptureDevice.devicesWithMediaType(type.description) as! [AVCaptureDevice]
        var captureDevice = devices.first
        
        for d in devices {
            if d.position == position {
                captureDevice = d
                break
            }
        }
        
        return captureDevice
    }
    
}