//
//  CTACameraViewController.swift
//  ImagePickerApp
//
//  Created by Emiaostein on 2/28/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import UIKit
import AVFoundation

class CTACameraViewController: UIViewController, CTAPhotoPickerDelegate {
    
    enum CTACameraResult {
        case Authorized
        case NotAuthorized, SessionConfigFailed
    }
    
    weak var pickerDelegate: CTAPhotoPickerProtocol?
    
    @IBOutlet weak var cameraView: CTACameraPreviewView!
    
    @IBOutlet weak var cropView: CTACropOverlayView!
    @IBOutlet weak var ratioCollectionView: UICollectionView!
    private let session = AVCaptureSession()
    private let sessionQueue = dispatch_queue_create("Session.Queue", DISPATCH_QUEUE_SERIAL)
    private var cameraResult: CTACameraResult = .Authorized
    private var stillImageOutput: AVCaptureStillImageOutput?
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .Featured, tag: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        
        ratioCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        let layout = ratioCollectionView.collectionViewLayout as! CTACollectionViewActiveFlowLayout
        
        layout.didChangedHandler = { [weak self] (collectionView, indexPath, oldIndexPath) in
            
            if let strongSelf = self {
                let ratio = CTAImageCropAspectRatio.defaultRatio[indexPath.item]
                
                strongSelf.cropView.positionByAspectRatio(ratio, animated: true)
            }
            
        }
        
        cameraView.videoGravity = .ResizeAspectFill
        cameraView.clipsToBounds = true
        
        // 1. connect session to previewLayer
        cameraView.session = session
        
        // 1.1. check camera authorized result
        switch AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) {
        case .Authorized:
            cameraResult = .Authorized
            
        case .NotDetermined:
            dispatch_suspend(sessionQueue)
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { [weak self] (authorized) in
                
                if authorized {
                    self?.cameraResult = .Authorized
                } else {
                    self?.cameraResult = .NotAuthorized
                }
                if let strongSelf = self {
                    dispatch_resume(strongSelf.sessionQueue)
                }
                }
            )
            
        default:
            cameraResult = .NotAuthorized
        }
        
        // config session
        dispatch_async(sessionQueue) { [weak self] in
            
            guard let strongSelf = self where strongSelf.cameraResult == .Authorized else {
                return
            }
            
            // 2. create capture devices
            let videoCapture = CTADevicesHelper.defaultDevice
            let deviceInput = try? AVCaptureDeviceInput.init(device: videoCapture)
            
            
            // 3. begin config session
            strongSelf.session.beginConfiguration()
            
            // 3.1. craete input and add it to session
            if strongSelf.session.canAddInput(deviceInput) {
                strongSelf.session.addInput(deviceInput)
            } else {
                strongSelf.cameraResult = .SessionConfigFailed
            }
            
            // 3.2. create output and add it to session
            let stillImageOutput = AVCaptureStillImageOutput()
            if strongSelf.session.canAddOutput(stillImageOutput) {
                stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
                strongSelf.session.addOutput(stillImageOutput)
                strongSelf.stillImageOutput = stillImageOutput
            } else {
                strongSelf.cameraResult = .SessionConfigFailed
            }
            
                    // 3.3. end config session
            strongSelf.session.commitConfiguration()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        // sessioin begin running
        dispatch_async(sessionQueue) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            switch strongSelf.cameraResult {
                
            case .Authorized:
                dispatch_async(dispatch_get_main_queue(), {
                    strongSelf.session.startRunning()
                })
                
            default:
                dispatch_async(dispatch_get_main_queue(), { 
                    strongSelf.cameraView.backgroundColor = .redColor()
                })
            }
        }
    }
}

// MARK: - Actions
extension CTACameraViewController {
    
    @IBAction func captureClick(sender: AnyObject) {
        
        captureStillImage {[weak self] (data) in
            if let data = data {
                dispatch_async(dispatch_get_main_queue(), {
                    self?.pickerDelegate?.pickerDidSelectedImage(UIImage(data: data)!)
                })
            }
        }
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - Capture Still Image
extension CTACameraViewController {
    
    typealias CaptureStillImageCompletedHander = (NSData?) -> ()
    
    func captureStillImage(handler: CaptureStillImageCompletedHander?) {
        dispatch_async(sessionQueue) { [weak self] in
            guard let strongSelf = self, let output = self?.stillImageOutput else {
                handler?(nil)
                return
            }
            
            let connection = output.connectionWithMediaType(AVMediaTypeVideo)
            
            strongSelf.stillImageOutput?.captureStillImageAsynchronouslyFromConnection(connection, completionHandler: { (buffer, error) in
                
                if let buffer = buffer {
                    let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                    handler?(data)
                } else {
                    handler?(nil)
                }
            })
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CTACameraViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return CTAImageCropAspectRatio.defaultRatio.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AspectRatioCell", forIndexPath: indexPath) as! CTACameraAspectRatioCollectionViewCell
        
        cell.text = CTAImageCropAspectRatio.defaultRatio[indexPath.item].description
        
        return cell
        
    }
    
}

extension CTACameraViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let acenter = collectionView.collectionViewLayout.layoutAttributesForItemAtIndexPath(indexPath)?.center {
            collectionView.setContentOffset(CGPoint(x: acenter.x - collectionView.bounds.width / 2.0, y: 0), animated: true)
        }
    }
}
