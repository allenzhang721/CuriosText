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
    
    func drawPublishButtonBorder(size size: CGSize = CGSizeMake(100, 50)) {
        
        //// Variable Declarations
        let expression: CGFloat = size.height / 2.0
        
        //// Frames
        let frame = CGRectMake(0, 0, size.width, size.height)
        
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRectMake(frame.minX + 2, frame.minY + 2, frame.width - 4, frame.height - 4), cornerRadius: expression)
        UIColor.blackColor().setStroke()
        rectanglePath.lineWidth = 0.5
        rectanglePath.stroke()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
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
    
    
    private var first = true
    var publishID: String!
    var canvas: AniCanvas!
    var aniCanvasView: AniPlayCanvasView!
    var imageRetriver: ((String, (String, UIImage?) -> ()) -> ())?
    
    var loadingImageView:UIImageView? = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupStyles()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {

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
        aniCanvasView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        for c in canvas.containers {
            if let content = c.contents.first where content.type == .Image {
                c.imageRetriver = imageRetriver
            }
        }
        
        aniCanvasView.dataSource = canvas
        aniCanvasView.aniDataSource = canvas
//        view.layer.addSublayer(aniCanvasView.layer)
        
        view.addSubview(aniCanvasView) // debug
    }
    
    func setupStyles() {
        aniCanvasView.backgroundColor = CTAStyleKit.commonBackgroundColor
        view.backgroundColor = CTAStyleKit.ediorBackgroundColor
        publishButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let scale = min(view.bounds.size.width / canvas.size.width, view.bounds.size.height / canvas.size.height)
        aniCanvasView.center = canvasPositionView.center
        aniCanvasView.transform = CGAffineTransformMakeScale(scale, scale)
    }
}

// MARK: - Actions
extension CTAPublishViewController: CTALoadingProtocol {
    
    @IBAction func publishClick(sender: AnyObject) {
        showLoadingViewByView(publishButton)
        publish()
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        dismiss()
    }
    
    @IBAction func makeGIFClick(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
           self?.makeGIF()
        }
    }
}

// MARK: - Logics
extension CTAPublishViewController {
    
    private func publish() {
        publishWillBegan?()
    }
    
    private func dismiss() {
        publishDismiss?()
    }
    
    private func ready(sender: AnyObject?) {
        aniCanvasView.ready()
    }
    
    private func play() {
        aniCanvasView.play()
    }
    
    private func makeGIF() {
        
        let gifCreatorVC = GIFCreateViewController()
        gifCreatorVC.canvas = canvas
        gifCreatorVC.publishID = publishID
        gifCreatorVC.fakeView = view.snapshotViewAfterScreenUpdates(true)
        gifCreatorVC.completed = {[weak self] (url, image) in
            dispatch_async(dispatch_get_main_queue(), { 
                let message =  WXMediaMessage()
                message.setThumbImage(image)
                
                let ext =  WXEmoticonObject()
                let filePath = url.path
                ext.emoticonData = NSData(contentsOfFile:filePath!)
                message.mediaObject = ext
                
                let req =  SendMessageToWXReq()
                req.bText = false
                req.message = message
                req.scene = 0
                WXApi.sendReq(req)
                dispatch_async(dispatch_get_main_queue(), { 
                    self?.dismissViewControllerAnimated(false, completion: {
                    })
                })
            })
            
        }
        
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            self?.presentViewController(gifCreatorVC, animated: false, completion: nil)
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
