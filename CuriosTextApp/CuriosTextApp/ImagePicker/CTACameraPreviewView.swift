//
//  CTACameraPreviewView.swift
//  ImagePickerApp
//
//  Created by Emiaostein on 2/28/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import UIKit
import AVFoundation

@IBDesignable
class CTACameraPreviewView: UIView {
    
    enum CTACameraPreviewViewVideoGravity {
        case resize, resizeAspect, resizeAspectFill
    }
    
    var session: AVCaptureSession {
        get {
           return previewLayer.session
        }
        set {
            previewLayer.session = newValue
        }
    }
    
    var videoGravity: CTACameraPreviewViewVideoGravity {
        
        get {
          guard let s = previewLayer.videoGravity else {
            return .resizeAspect
          }
            switch s {
            case AVLayerVideoGravityResize:
                return .resize
                
            case AVLayerVideoGravityResizeAspect:
                return .resizeAspect
                
            case AVLayerVideoGravityResizeAspectFill:
                return .resizeAspectFill
                
            default:
                return .resizeAspect
            }
        }
        
        set {
            switch newValue {
            case .resize:
                previewLayer.videoGravity = AVLayerVideoGravityResize
                
            case .resizeAspect:
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspect
                
            case .resizeAspectFill:
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            }
        }
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    override class var layerClass : AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
