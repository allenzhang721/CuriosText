//
//  CTACameraViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 2/14/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import AVFoundation

protocol CTACameraViewControllerDelegate: class {
    
    func cameraViewController(viewController: CTACameraViewController, didCaptureImage image: UIImage?)
    func cameraViewControllerDidCanceled(viewController: CTACameraViewController)
}

class CTACameraViewController: UIViewController {
    
    enum CTACameraSetupResult {
        case Success, NotAuthorized, ConfigurationFailed
    }
    
    weak var delegate: CTACameraViewControllerDelegate?
    var completionBlock: ((image: UIImage?) -> ())?
    @IBOutlet weak var cameraView: CTACameraView!
    
    let session = AVCaptureSession()
    let sessionQueue = dispatch_queue_create("com.botai.CuriosText.Editor.CameraSessionQueue", DISPATCH_QUEUE_SERIAL)
    var videoDeviceInput: AVCaptureDeviceInput?
    var imageOutput: AVCaptureStillImageOutput?
    var setupResult: CTACameraSetupResult = .Success
    var sessionRunning: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = self.session
        
        cameraView.session = session
        (cameraView.layer as! AVCaptureVideoPreviewLayer).videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraView.layer.masksToBounds = true
//        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
//        previewLayer.frame = view.boundsz
//        view.layer.addSublayer(previewLayer)
        
            
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let input = try? AVCaptureDeviceInput(device: device)
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        
        
        
        let output = AVCaptureStillImageOutput()
        output.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
        session.addOutput(output)
        self.imageOutput = output
        session.startRunning()
        
        
//        setup()
    }
    
    func setup() {
//        session.sessionPreset = AVCaptureSessionPresetPhoto
        cameraView.session = session
        
        

        // 1. Check Video authorization status.
        switch AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) {
            
        case .Authorized:
            ()
        case .NotDetermined:
            dispatch_suspend(sessionQueue)
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { [weak self] (success) in
                
                if let strongSelf = self {
                    if !success {
                        strongSelf.setupResult = .NotAuthorized
                    }
                    dispatch_resume(strongSelf.sessionQueue)
                }
            })
            
        default:
            setupResult = .NotAuthorized
        }
        
        
        // 2. Config the capture session.
        dispatch_async(sessionQueue) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            // s1. video input
            let device = strongSelf.deviceWithType(AVMediaTypeVideo, position: .Front)
            let videoInput = try! AVCaptureDeviceInput.init(device: device)
            
            // s2. session configuration began
            strongSelf.session.beginConfiguration()
            
            if strongSelf.session.canAddInput(videoInput) {
                strongSelf.session.canAddInput(videoInput)
                strongSelf.videoDeviceInput = videoInput
                
                dispatch_async(dispatch_get_main_queue(), {
                    if let layer = strongSelf.cameraView.layer as? AVCaptureVideoPreviewLayer {
                        layer.connection?.videoOrientation = .Portrait
                    }
                })
            } else {
                strongSelf.setupResult = .ConfigurationFailed
            }
            
            // s2.1. image output
            let imageOutput = AVCaptureStillImageOutput()
            if strongSelf.session.canAddOutput(imageOutput) {
                imageOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG];
                strongSelf.session.addOutput(imageOutput)
                strongSelf.imageOutput = imageOutput
            } else {
                strongSelf.setupResult = .ConfigurationFailed
            }
            
            // session configuration end
            strongSelf.session.commitConfiguration()
            
            dispatch_async(dispatch_get_main_queue(), { 
                
                let p = AVCaptureVideoPreviewLayer(session: strongSelf.session)
                p.frame = strongSelf.view.bounds
                strongSelf.view.layer.addSublayer(p)
            })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        dispatch_async(sessionQueue) { 
            
            switch self.setupResult {
            case .Success:
                self.session.startRunning()
                self.sessionRunning = self.session.running
                
            default:
                ()
            }
            // s3. only observe and start the session running if result is Success
            
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        dispatch_async(sessionQueue) { 
            
            // s4. if success, session stop running and remove observer
        }
    }
    
    private func deviceWithType(type: String, position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        
        return AVCaptureDevice.defaultDeviceWithMediaType(type)
//        guard let devices = AVCaptureDevice.defaultDeviceWithMediaType(<#T##mediaType: String!##String!#>)(AVMediaTypeVideo) as?[AVCaptureDevice] else {
//            return nil
//        }
//        return devices.filter{$0.position == position}.first
    }
}

// MARK: - KVO and Notifications
extension CTACameraViewController {
    
}

// MARK: - Actions
extension CTACameraViewController {
    
    @IBAction func dismissAction(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func takePhotoClick(sender: AnyObject) {
        
        snapImage {[weak self] (imageData) in
            
            if let _ = self {
                if let imageData = imageData, let image = UIImage(data: imageData) {
                   
                    self?.completionBlock?(image: image)
//                    self?.delegate?.cameraViewController(strongSelf, didCaptureImage: image)
                }
            }
            
           self?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    private func snapImage(completionBlock:(imageData: NSData?) -> ()) {
        
        guard let imageOutput = imageOutput else {
            completionBlock(imageData: nil)
            return
        }
        
        let connection = imageOutput.connectionWithMediaType(AVMediaTypeVideo)
        imageOutput.captureStillImageAsynchronouslyFromConnection(connection) { (buffer, error) in
            
            if let buffer = buffer {
                completionBlock(imageData: AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer))
            } else {
                completionBlock(imageData: nil)
            }
        }
    }
}

// MARK: - File input and Record delegate
extension CTACameraViewController {
    
    
}
