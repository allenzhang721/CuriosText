//
//  CTACameraViewController.swift
//  ImagePickerApp
//
//  Created by Emiaostein on 2/28/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import UIKit
import AVFoundation

class CTACameraViewController: UIViewController, CTAPhotoPickerDelegate, CTAPhotoPickerTemplateable {
    
    private struct Inner {
        private let session = AVCaptureSession()
        private let sessionQueue = dispatch_queue_create("Session.Queue", DISPATCH_QUEUE_SERIAL)
        private var cameraResult: CTACameraResult = .Authorized
        private var stillImageOutput: AVCaptureStillImageOutput?
        private var ratio: CTAImageCropAspectRatio = .Square
        private var currentDevice: AVCaptureDevice?
        private var flashType: FlashType = .Off
    }
    
    enum CTACameraResult {
        case Authorized
        case NotAuthorized, SessionConfigFailed
    }
    
    enum FlashType {
        case Off
        case On
        case Auto
        
        func next() -> FlashType {
            
            switch self {
            case .Off:
                return On
            case .On:
                return Auto
            case .Auto:
                return Off
            }
        }
    }
    
    weak var pickerDelegate: CTAPhotoPickerProtocol?
    
    var templateImage: UIImage?
    var backgroundColor: UIColor = UIColor.whiteColor()
    var backgroundColorHex: String = "FFFFFF"
    var frontCamera = false
    
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var accessView: UIView!
    @IBOutlet weak var templateImageView: UIImageView!
    @IBOutlet weak var cameraView: CTACameraPreviewView!
    @IBOutlet weak var cropView: CTACropOverlayView!
    @IBOutlet weak var ratioCollectionView: UICollectionView!
    
    private var inner = Inner()
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let selectedImage = ImagePickerResource.imageOfCameraSelected.imageWithRenderingMode(.AlwaysOriginal)
        
        self.tabBarItem = UITabBarItem(title: LocalStrings.Camera.description, image: ImagePickerResource.imageOfCamera, selectedImage: selectedImage)
    }
    
    deinit {
        print("\(#file) deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accessView.hidden = true
        setup()
    }
    
    private func setupTemplate() {
        templateImageView.image = templateImage
    }
    
    private func setup() {
        
        ratioCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        let layout = ratioCollectionView.collectionViewLayout as! CTACollectionViewActiveFlowLayout
        
        layout.didChangedHandler = { [weak self] (collectionView, indexPath, oldIndexPath) in
            
            if let strongSelf = self {
                let ratio = CTAImageCropAspectRatio.defaultRatio[indexPath.item]
                strongSelf.inner.ratio = ratio
                strongSelf.cropView.positionByAspectRatio(ratio, animated: true)
            }
        }
        
        cameraView.videoGravity = .ResizeAspectFill
        cameraView.clipsToBounds = true
        
        // 1. connect session to previewLayer
        cameraView.session = inner.session
        
        changeCamera(frontCamera)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // sessioin begin running
        dispatch_async(inner.sessionQueue) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                strongSelf.templateImageView.image = strongSelf.templateImage
            })
            
            switch strongSelf.inner.cameraResult {
                
            case .Authorized:
                dispatch_async(dispatch_get_main_queue(), {
                    strongSelf.inner.session.startRunning()
                })
                
            default:
                dispatch_async(dispatch_get_main_queue(), { 
                    strongSelf.cameraView.backgroundColor = UIColor.groupTableViewBackgroundColor()
                })
            }
        }
    }
    
    private func flash(type: FlashType) {
        
        guard let device = inner.currentDevice where device.hasFlash && device.hasTorch else {
            return
        }
        
        inner.session.beginConfiguration()
        do {
           try device.lockForConfiguration()
            
            switch type {
            case .Off:
//                device.torchMode = .Off
                device.flashMode = .Off
                dispatch_async(dispatch_get_main_queue(), { 
                    self.flashButton.setImage(UIImage(named: "icon_flashOff"), forState: .Normal)
                })
                
            case .On:
//                device.torchMode = .On
                device.flashMode = .On
                dispatch_async(dispatch_get_main_queue(), { 
                    self.flashButton.setImage(UIImage(named: "icon_flashOn"), forState: .Normal)
                })
                
            case .Auto:
//                device.torchMode = .Auto
                device.flashMode = .Auto
                dispatch_async(dispatch_get_main_queue(), { 
                    self.flashButton.setImage(UIImage(named: "icon_flashAuto"), forState: .Normal)  
                })
            }
            
            device.unlockForConfiguration()
            inner.session.commitConfiguration()
        } catch {
            
        }
    }
    
    private func changeCamera(front: Bool = false) {
     
        // 1.1. check camera authorized result
        switch AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) {
        case .Authorized:
            inner.cameraResult = .Authorized
            accessView.hidden = true
            
        case .NotDetermined:
            dispatch_suspend(inner.sessionQueue)
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { [weak self] (authorized) in
                
                if authorized {
                    self?.inner.cameraResult = .Authorized
                    self?.accessView.hidden = true
                } else {
                    self?.inner.cameraResult = .NotAuthorized
                    self?.accessView.hidden = false
                }
                if let strongSelf = self {
                    dispatch_resume(strongSelf.inner.sessionQueue)
                }
                }
            )
            
        default:
            inner.cameraResult = .NotAuthorized
            accessView.hidden = false
        }
        
        // config session
        dispatch_async(inner.sessionQueue) { [weak self] in
            guard let strongSelf = self where strongSelf.inner.cameraResult == .Authorized else {
                return
            }
            
            if let oldInputs = strongSelf.inner.session.inputs where oldInputs.count > 0 {
                for i in oldInputs {
                    strongSelf.inner.session.removeInput(i as! AVCaptureInput)
                }
            }
            
            if let outputs = strongSelf.inner.session.outputs where outputs.count > 0 {
                for i in outputs {
                    strongSelf.inner.session.removeOutput(i as! AVCaptureOutput)
                }
            }
            
            if front {
                strongSelf.inner.flashType = .Off
                strongSelf.flash(strongSelf.inner.flashType)
            }
            
            // 2. create capture devices
            let videoCapture = front ? CTADevicesHelper.frontDevice : CTADevicesHelper.defaultDevice
            let deviceInput = try? AVCaptureDeviceInput.init(device: videoCapture)
            
            
            // 3. begin config session
            strongSelf.inner.session.beginConfiguration()
            
            // 3.1. craete input and add it to session
            if strongSelf.inner.session.canAddInput(deviceInput) {
                strongSelf.inner.session.addInput(deviceInput)
                strongSelf.inner.currentDevice = videoCapture
            } else {
                strongSelf.inner.cameraResult = .SessionConfigFailed
            }
            
            // 3.2. create output and add it to session
            let stillImageOutput = AVCaptureStillImageOutput()
            if strongSelf.inner.session.canAddOutput(stillImageOutput) {
                stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
                strongSelf.inner.session.addOutput(stillImageOutput)
                strongSelf.inner.stillImageOutput = stillImageOutput
            } else {
                strongSelf.inner.cameraResult = .SessionConfigFailed
            }
            
            // 3.3. end config session
            strongSelf.inner.session.commitConfiguration()
        }
    }
}

// MARK: - Actions
extension CTACameraViewController {
    
    @IBAction func changeFlash(sender: AnyObject) {
        
        let t = inner.flashType
        inner.flashType = t.next()
        flash(inner.flashType)
    }
    
    
    @IBAction func changedCamera(sender: AnyObject) {
        frontCamera = !frontCamera
        changeCamera(frontCamera)
        
//        flash()
    }
    
    @IBAction func accessClick(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    @IBAction func captureClick(sender: AnyObject) {
        
        guard inner.cameraResult == .Authorized else { return }
        
        captureStillImage {[weak self] (data) in
            if let data = data {
                dispatch_async(dispatch_get_main_queue(), {
                    self?.pickerDelegate?.pickerDidSelectedImage(UIImage(data: data)!, backgroundColor: self!.backgroundColor)
                })
            }
        }
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - Logics
extension CTACameraViewController {
    
    // MARK: - Capture Still Image
    typealias CaptureStillImageCompletedHander = (NSData?) -> ()
    
    private func captureStillImage(handler: CaptureStillImageCompletedHander?) {
        dispatch_async(inner.sessionQueue) { [weak self] in
            guard let strongSelf = self, let output = self?.inner.stillImageOutput else {
                handler?(nil)
                return
            }
            
            let connection = output.connectionWithMediaType(AVMediaTypeVideo)
            
            strongSelf.inner.stillImageOutput?.captureStillImageAsynchronouslyFromConnection(connection, completionHandler: {[weak self] (buffer, error) in
                guard let strongSelf = self else {
                    return
                }
                if let buffer = buffer {
                    let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                    let image = UIImage(data: data)!.cropImageWith(strongSelf.inner.ratio)
                    handler?(UIImagePNGRepresentation(image))
                } else {
                    handler?(nil)
                }
            })
        }
    }
    
    // MARK: - Photo Snapshot
    
}

extension UIImage {
    
    private func cropImageWith(ratio: CTAImageCropAspectRatio) -> UIImage {
        
        let originSize = size
        let targetSize = CGSize(width: originSize.width, height: originSize.height)
        let ratioMinSize = ratio.minumSize()
        let minScale = min(targetSize.width / ratioMinSize.width, targetSize.height / ratioMinSize.height)
        let cropSize = CGSize(width: ratioMinSize.width * minScale, height: ratioMinSize.height * minScale)
        let cropOrigin = CGPoint(x: (targetSize.width - cropSize.width) / 2.0, y: (targetSize.height - cropSize.height) / 2.0)
        let cropFrame = CGRect(origin: cropOrigin, size: cropSize)
        let drawOrigin = CGPoint(x: -cropOrigin.x, y: -cropOrigin.y)
        
        UIGraphicsBeginImageContext(cropSize)
        drawInRect(CGRect(origin: drawOrigin, size: originSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - Deleagete and DataSource
extension CTACameraViewController: UICollectionViewDataSource {
    // MARK: - UICollectionViewDataSource
    
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
