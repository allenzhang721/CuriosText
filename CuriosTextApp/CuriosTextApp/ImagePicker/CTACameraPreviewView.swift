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
        case Resize, ResizeAspect, ResizeAspectFill
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
            switch previewLayer.videoGravity {
            case AVLayerVideoGravityResize:
                return .Resize
                
            case AVLayerVideoGravityResizeAspect:
                return .ResizeAspect
                
            case AVLayerVideoGravityResizeAspectFill:
                return .ResizeAspectFill
                
            default:
                return .ResizeAspect
            }
        }
        
        set {
            switch newValue {
            case .Resize:
                previewLayer.videoGravity = AVLayerVideoGravityResize
                
            case .ResizeAspect:
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspect
                
            case .ResizeAspectFill:
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            }
        }
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    override class func layerClass() -> AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
