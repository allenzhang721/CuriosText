//
//  GIFCreateViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 5/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class GIFCreateViewController: UIViewController {
    
    var fakeView: UIView?
    var publishID: String!
    var canvas: AniCanvas!
    var aniCanvasView: AniPlayCanvasView!
    var completed: ((NSURL, UIImage) -> ())?
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupStyles()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //        previewView.publishID = publishID
        aniCanvasView.reloadData { [weak self] in
            guard let sf = self else { return }
            sf.aniCanvasView.ready()
            dispatch_async(dispatch_get_main_queue(), {
                sf.makeGIF()
            })
            //            sf.play()
        }
    }
    
    private func makeGIF() {
        
        let result = aniCanvasView.progressBegan()
        
        switch result {
        case .Next(let duration):
            let FPS = 24
            let count = Int(CGFloat(FPS) * duration) + 1
            
            GIFCreator.beganWith(publishID, images: [], delays: [], ignoreCache: true)
            
            var thumbImage: UIImage!
            for i in 0..<count {
                let progress = CGFloat(i) / CGFloat(count)
                aniCanvasView.progress =  progress < 1.0 ? progress : 1.0
                autoreleasepool {
                    UIGraphicsBeginImageContext(CGSize(width: 320, height: 320))
                    aniCanvasView.drawViewHierarchyInRect(CGRect(origin: CGPoint.zero, size: CGSize(width: 320, height: 320)), afterScreenUpdates: true)
                    let image = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    let img = UIImage(data: UIImageJPEGRepresentation(image, 0.1)!)!
                    if i == count - 1 { thumbImage = img }
                    GIFCreator.addImage(img, delay: 1.0 / CGFloat(FPS))
                }
            }
            
            GIFCreator.commitWith({[weak self] (url) in
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
                self?.completed?(url, thumbImage)
            })
            
        default:
            ()
        }
    }
}

// MARK: - Styles
extension GIFCreateViewController {
    
    func setupViews() {
        aniCanvasView = AniPlayCanvasView(frame: CGRect(origin: CGPoint(x: 0, y: 44), size: canvas.size))
        aniCanvasView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        aniCanvasView.dataSource = canvas
        aniCanvasView.aniDataSource = canvas
        //        view.layer.addSublayer(aniCanvasView.layer)
        
        view.addSubview(aniCanvasView) // debug
        if let fakeView = fakeView {
            view.addSubview(fakeView)
        }
        
    }
    
    func setupStyles() {
        aniCanvasView.backgroundColor = CTAStyleKit.commonBackgroundColor
        view.backgroundColor = CTAStyleKit.ediorBackgroundColor
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let scale = min(view.bounds.size.width / canvas.size.width, view.bounds.size.height / canvas.size.height)
        aniCanvasView.transform = CGAffineTransformMakeScale(scale, scale)
    }
}
