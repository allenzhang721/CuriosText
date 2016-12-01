//
//  CTAPublishViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 3/7/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import PromiseKit

class CTAPublishButton: UIButton {
    
    override func prepareForInterfaceBuilder() {
        setNeedsDisplay()
    }
    
    func drawPublishButtonBorder(size: CGSize = CGSize(width: 100, height: 50)) {
        
        //// Variable Declarations
        let expression: CGFloat = size.height / 2.0
        
        //// Frames
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: frame.minX + 2, y: frame.minY + 2, width: frame.width - 4, height: frame.height - 4), cornerRadius: expression)
        UIColor.black.setStroke()
        rectanglePath.lineWidth = 0.5
        rectanglePath.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawPublishButtonBorder(size: rect.size)
    }
}

class CTAPublishViewController: UIViewController {
    
    @IBOutlet weak var canvasPositionView: UIView!
    @IBOutlet weak var publishButton: CTAPublishButton!
//    @IBOutlet weak var previewView: CTAPreviewCanvasView!
    var publishWillBegan: (() -> ())?
    var publishDismiss:(() -> ())?
//    var page: PageVMProtocol?
//    var publishID: String!
//    var baseURL: NSURL!
//    var imageAccess: ((baseURL: NSURL, imageName: String) -> Promise<Result<CTAImageCache>>)!
    
    
    fileprivate var first = true
    var publishID: String!
    var canvas: AniCanvas!
    var aniCanvasView: AniPlayCanvasView!
    var imageRetriver: ((String, (String, UIImage?) -> ()) -> ())?
    
    var loadingImageView:UIImageView? = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
    
    deinit {
        debug_print("\(#file) deinit", context: deinitContext)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupStyles()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {

//        previewView.publishID = publishID
        if first {
        first = false
        aniCanvasView.reloadData { [weak self] in
            guard let sf = self else { return }
            sf.ready(nil)
            sf.play()
        }
        }
    }
}

// MARK: - Styles
extension CTAPublishViewController {
    
    func setupViews() {
        aniCanvasView = AniPlayCanvasView(frame: CGRect(origin: CGPoint(x: 0, y: 44), size: canvas.size))
//        aniCanvasView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        for c in canvas.containers {
            if let content = c.contents.first, content.type == .Image {
                c.imageRetriver = imageRetriver
            }
        }
        
        aniCanvasView.dataSource = canvas
        aniCanvasView.changeDataSource()
        aniCanvasView.aniDataSource = canvas
//        view.layer.addSublayer(aniCanvasView.layer)
        
        view.addSubview(aniCanvasView) // debug
    }
    
    func setupStyles() {
        aniCanvasView.backgroundColor = UIColor(hexString: canvas.canvas.backgroundColor)
        view.backgroundColor = CTAStyleKit.ediorBackgroundColor
        publishButton.setTitleColor(UIColor.black, for: UIControlState())
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let scale = min(view.bounds.size.width / canvas.size.width, view.bounds.size.height / canvas.size.height)
        aniCanvasView.center = canvasPositionView.center
        aniCanvasView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
}

// MARK: - Actions
extension CTAPublishViewController: CTALoadingProtocol {
    
    @IBAction func publishClick(_ sender: AnyObject) {
//        showLoadingViewByView(publishButton)
        publish()
    }
    
    @IBAction func dismiss(_ sender: AnyObject) {
        dismiss()
    }
    
    @IBAction func makeGIFClick(_ sender: AnyObject) {
        DispatchQueue.main.async { [weak self] in
           self?.makeGIF()
        }
    }
}

// MARK: - Logics
extension CTAPublishViewController {
    
    fileprivate func publish() {
        publishWillBegan?()
    }
    
    fileprivate func dismiss() {
        publishDismiss?()
    }
    
    fileprivate func ready(_ sender: AnyObject?) {
        aniCanvasView.ready()
    }
    
    fileprivate func play() {
        aniCanvasView.play()
    }
    
    fileprivate func makeGIF() {
        
        let gifCreatorVC = GIFCreateViewController()
        gifCreatorVC.canvas = canvas
        gifCreatorVC.publishID = publishID
        gifCreatorVC.fakeView = view.snapshotView(afterScreenUpdates: true)
        gifCreatorVC.completed = {[weak self] (url, thumburl) in
            DispatchQueue.main.async(execute: { 
                let message =  WXMediaMessage()
                message.setThumbImage(UIImage(contentsOfFile: thumburl.path))
                
                let ext =  WXEmoticonObject()
                let filePath = url.path
                ext.emoticonData = try? Data(contentsOf: URL(fileURLWithPath: filePath))
                message.mediaObject = ext
                
                let req =  SendMessageToWXReq()
                req.bText = false
                req.message = message
                req.scene = 0
                WXApi.send(req)
                DispatchQueue.main.async(execute: { 
                    self?.dismiss(animated: false, completion: {
                    })
                })
            })
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.present(gifCreatorVC, animated: false, completion: nil)
        }
        
//        aniCanvasView.ready()
        
//        let result = aniCanvasView.progressBegan()
//        
//        switch result {
//        case .Next(let duration):
//            let FPS = 24
//            let count = Int(CGFloat(FPS) * duration) + 1
//            
//            GIFCreator.beganWith(publishID)
//            
//            var thumbImage: UIImage!
//            for i in 0..<count {
//                let progress = CGFloat(i) / CGFloat(count)
//                aniCanvasView.progress =  progress < 1.0 ? progress : 1.0
//                autoreleasepool {
//                    UIGraphicsBeginImageContext(CGSize(width: 320, height: 320))
//                    aniCanvasView.drawViewHierarchyInRect(CGRect(origin: CGPoint.zero, size: CGSize(width: 320, height: 320)), afterScreenUpdates: true)
//                    let image = UIGraphicsGetImageFromCurrentImageContext()
//                    UIGraphicsEndImageContext()
//                    
//                    let img = UIImage(data: UIImageJPEGRepresentation(image, 0.1)!)!
//                    if i == count - 1 { thumbImage = img }
//                    GIFCreator.addImage(img, delay: 1.0 / CGFloat(FPS))
//                }
//            }
//            
//            GIFCreator.commitWith({ (url) in
//                let message =  WXMediaMessage()
//                message.setThumbImage(thumbImage)
//                
//                let ext =  WXEmoticonObject()
//                let filePath = url.path
//                ext.emoticonData = NSData(contentsOfFile:filePath!)
//                message.mediaObject = ext
//                
//                let req =  SendMessageToWXReq()
//                req.bText = false
//                req.message = message
//                req.scene = 0
//                WXApi.sendReq(req)
//            })
//
//        default:
//            ()
//        }
    }
}

// MARK: - Preview DataSource
//extension CTAPublishViewController: CTAPreviewCanvasViewDataSource {
//
//    func canvasViewWithPage(view: CTAPreviewCanvasView) -> PageVMProtocol? {
//        return page
//    }
//    
//}
