//
//  CTACameraView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 2/17/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import AVFoundation

class CTACameraView: UIView {
    
    var session: AVCaptureSession {
        
        get {
            return (layer as! AVCaptureVideoPreviewLayer).session
        }
        
        set {
            (layer as! AVCaptureVideoPreviewLayer).session = newValue
        }
    }

    override class func layerClass() -> AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    

}
