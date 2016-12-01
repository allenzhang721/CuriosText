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
        case video
        var description: String {
            switch self {
            case .video:
                return AVMediaTypeVideo
            }
        }
    }
    
    static var defaultDevice: AVCaptureDevice? {
        return deviceWithType(.video, preferringPosition: .back)
    }
    
    static var frontDevice: AVCaptureDevice? {
        return deviceWithType(.video, preferringPosition: .front)
    }
    
    class func deviceWithType(_ type: CTADeviceType, preferringPosition position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        
        let devices = AVCaptureDevice.devices(withMediaType: type.description) as! [AVCaptureDevice]
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
