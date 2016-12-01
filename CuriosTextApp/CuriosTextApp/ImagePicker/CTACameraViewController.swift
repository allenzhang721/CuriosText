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
    
    fileprivate struct Inner {
        fileprivate let session = AVCaptureSession()
        fileprivate let sessionQueue = DispatchQueue(label: "Session.Queue", attributes: [])
        fileprivate var cameraResult: CTACameraResult = .authorized
        fileprivate var stillImageOutput: AVCaptureStillImageOutput?
        fileprivate var ratio: CTAImageCropAspectRatio = .square
        fileprivate var currentDevice: AVCaptureDevice?
        fileprivate var flashType: FlashType = .off
    }
    
    enum CTACameraResult {
        case authorized
        case notAuthorized, sessionConfigFailed
    }
    
    enum FlashType {
        case off
        case on
        case auto
        
        func next() -> FlashType {
            
            switch self {
            case .off:
                return .on
            case .on:
                return .auto
            case .auto:
                return .off
            }
        }
    }
    
    weak var pickerDelegate: CTAPhotoPickerProtocol?
    
    var templateImage: UIImage?
    var backgroundColor: UIColor = UIColor.white
    var backgroundColorHex: String = "FFFFFF"
    var frontCamera = false
    var selectedImageIdentifier: String? = nil
    
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var accessView: UIView!
    @IBOutlet weak var templateImageView: UIImageView!
    @IBOutlet weak var cameraView: CTACameraPreviewView!
    @IBOutlet weak var cropView: CTACropOverlayView!
    @IBOutlet weak var ratioCollectionView: UICollectionView!
    
    fileprivate var inner = Inner()
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let selectedImage = ImagePickerResource.imageOfCameraSelected.withRenderingMode(.alwaysOriginal)
        let normalImage = ImagePickerResource.imageOfCamera.withRenderingMode(.alwaysOriginal)
        
        self.tabBarItem = UITabBarItem(title: LocalStrings.camera.description, image: normalImage, selectedImage: selectedImage)
    }
    
    deinit {
        debug_print("\(#file) deinit", context: deinitContext)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accessView.isHidden = true
        setup()
    }
    
    fileprivate func setupTemplate() {
        templateImageView.image = templateImage
    }
    
    fileprivate func setup() {
        
        ratioCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        let layout = ratioCollectionView.collectionViewLayout as! CTACollectionViewActiveFlowLayout
        
        layout.didChangedHandler = { [weak self] (collectionView, indexPath, oldIndexPath) in
            
            if let strongSelf = self {
                let ratio = CTAImageCropAspectRatio.defaultRatio[indexPath.item]
                strongSelf.inner.ratio = ratio
                strongSelf.cropView.positionByAspectRatio(ratio, animated: true)
            }
        }
        
        cameraView.videoGravity = .resizeAspectFill
        cameraView.clipsToBounds = true
        
        // 1. connect session to previewLayer
        cameraView.session = inner.session
        
        changeCamera(frontCamera)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // sessioin begin running
        inner.sessionQueue.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async(execute: {
                strongSelf.templateImageView.image = strongSelf.templateImage
            })
            
            switch strongSelf.inner.cameraResult {
                
            case .authorized:
                DispatchQueue.main.async(execute: {
                    strongSelf.inner.session.startRunning()
                })
                
            default:
                DispatchQueue.main.async(execute: { 
                    strongSelf.cameraView.backgroundColor = UIColor.groupTableViewBackground
                })
            }
        }
    }
    
    fileprivate func flash(_ type: FlashType) {
        
        guard let device = inner.currentDevice, device.hasFlash && device.hasTorch else {
            return
        }
        
        inner.session.beginConfiguration()
        do {
           try device.lockForConfiguration()
            
            switch type {
            case .off:
//                device.torchMode = .Off
                device.flashMode = .off
                DispatchQueue.main.async(execute: { 
                    self.flashButton.setImage(UIImage(named: "icon_flashOff"), for: UIControlState())
                })
                
            case .on:
//                device.torchMode = .On
                device.flashMode = .on
                DispatchQueue.main.async(execute: { 
                    self.flashButton.setImage(UIImage(named: "icon_flashOn"), for: UIControlState())
                })
                
            case .auto:
//                device.torchMode = .Auto
                device.flashMode = .auto
                DispatchQueue.main.async(execute: { 
                    self.flashButton.setImage(UIImage(named: "icon_flashAuto"), for: UIControlState())  
                })
            }
            
            device.unlockForConfiguration()
            inner.session.commitConfiguration()
        } catch {
            
        }
    }
    
    fileprivate func changeCamera(_ front: Bool = false) {
     
        // 1.1. check camera authorized result
        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) {
        case .authorized:
            inner.cameraResult = .authorized
            accessView.isHidden = true
            
        case .notDetermined:
            inner.sessionQueue.suspend()
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { [weak self] (authorized) in
                
                if authorized {
                    self?.inner.cameraResult = .authorized
                    self?.accessView.isHidden = true
                } else {
                    self?.inner.cameraResult = .notAuthorized
                    self?.accessView.isHidden = false
                }
                if let strongSelf = self {
                    strongSelf.inner.sessionQueue.resume()
                }
                }
            )
            
        default:
            inner.cameraResult = .notAuthorized
            accessView.isHidden = false
        }
        
        // config session
        inner.sessionQueue.async { [weak self] in
            guard let strongSelf = self, strongSelf.inner.cameraResult == .authorized else {
                return
            }
            
            if let oldInputs = strongSelf.inner.session.inputs, oldInputs.count > 0 {
                for i in oldInputs {
                    strongSelf.inner.session.removeInput(i as! AVCaptureInput)
                }
            }
            
            if let outputs = strongSelf.inner.session.outputs, outputs.count > 0 {
                for i in outputs {
                    strongSelf.inner.session.removeOutput(i as! AVCaptureOutput)
                }
            }
            
            if front {
                strongSelf.inner.flashType = .off
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
                strongSelf.inner.cameraResult = .sessionConfigFailed
            }
            
            // 3.2. create output and add it to session
            let stillImageOutput = AVCaptureStillImageOutput()
            if strongSelf.inner.session.canAddOutput(stillImageOutput) {
                stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
                strongSelf.inner.session.addOutput(stillImageOutput)
                strongSelf.inner.stillImageOutput = stillImageOutput
            } else {
                strongSelf.inner.cameraResult = .sessionConfigFailed
            }
            
            // 3.3. end config session
            strongSelf.inner.session.commitConfiguration()
        }
    }
}

// MARK: - Actions
extension CTACameraViewController {
    
    @IBAction func changeFlash(_ sender: AnyObject) {
        
        let t = inner.flashType
        inner.flashType = t.next()
        flash(inner.flashType)
    }
    
    
    @IBAction func changedCamera(_ sender: AnyObject) {
        frontCamera = !frontCamera
        changeCamera(frontCamera)
        
//        flash()
    }
    
    @IBAction func accessClick(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    @IBAction func captureClick(_ sender: AnyObject) {
        
        guard inner.cameraResult == .authorized else { return }
        
        captureStillImage {[weak self] (data) in
            if let data = data {
                DispatchQueue.main.async(execute: {
                    self?.pickerDelegate?.pickerDidSelectedImage(UIImage(data: data)!, backgroundColor: self!.backgroundColor, identifier: nil)
                })
            }
        }
    }
    
    @IBAction func dismiss(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Logics
extension CTACameraViewController {
    
    // MARK: - Capture Still Image
    typealias CaptureStillImageCompletedHander = (Data?) -> ()
    
    fileprivate func captureStillImage(_ handler: CaptureStillImageCompletedHander?) {
        inner.sessionQueue.async { [weak self] in
            guard let strongSelf = self, let output = self?.inner.stillImageOutput else {
                handler?(nil)
                return
            }
            
            let connection = output.connection(withMediaType: AVMediaTypeVideo)
            
            strongSelf.inner.stillImageOutput?.captureStillImageAsynchronously(from: connection, completionHandler: {[weak self] (buffer, error) in
                guard let strongSelf = self else {
                    return
                }
                if let buffer = buffer {
                    let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                    let image = UIImage(data: data!)!.cropImageWith(strongSelf.inner.ratio)
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
    
    fileprivate func cropImageWith(_ ratio: CTAImageCropAspectRatio) -> UIImage {
        
        let originSize = size
        let targetSize = CGSize(width: originSize.width, height: originSize.height)
        let ratioMinSize = ratio.minumSize()
        let minScale = min(targetSize.width / ratioMinSize.width, targetSize.height / ratioMinSize.height)
        let cropSize = CGSize(width: ratioMinSize.width * minScale, height: ratioMinSize.height * minScale)
        let cropOrigin = CGPoint(x: (targetSize.width - cropSize.width) / 2.0, y: (targetSize.height - cropSize.height) / 2.0)
        let cropFrame = CGRect(origin: cropOrigin, size: cropSize)
        let drawOrigin = CGPoint(x: -cropOrigin.x, y: -cropOrigin.y)
        
        UIGraphicsBeginImageContext(cropSize)
        self.draw(in: CGRect(origin: drawOrigin, size: originSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

// MARK: - Deleagete and DataSource
extension CTACameraViewController: UICollectionViewDataSource {
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return CTAImageCropAspectRatio.defaultRatio.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AspectRatioCell", for: indexPath) as! CTACameraAspectRatioCollectionViewCell
        
        cell.text = CTAImageCropAspectRatio.defaultRatio[indexPath.item].description
        
        return cell
        
    }
    
}

extension CTACameraViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let acenter = collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath)?.center {
            collectionView.setContentOffset(CGPoint(x: acenter.x - collectionView.bounds.width / 2.0, y: 0), animated: true)
        }
    }
}
