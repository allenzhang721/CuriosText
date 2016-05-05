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
    var imageRetriver: ((String, (String, UIImage?) -> ()) -> ())?
    var aniCanvasView: AniPlayCanvasView!
    var completed: ((NSURL, UIImage) -> ())?
    
    var v: UIView!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupStyles()
        
        v = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        v.backgroundColor = UIColor.lightGrayColor()
        view.addSubview(v)
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        dispatch_async(dispatch_get_main_queue(), {
            self.aniCanvasView.reloadData { [weak self] in
                guard let sf = self else { return }
                dispatch_async(dispatch_get_main_queue(), {
                    sf.aniCanvasView.ready()
                    dispatch_async(dispatch_get_main_queue()) { [weak self] in
                        guard let sf = self else { return }
                        
                        UIView.animateWithDuration(5, animations: {
                            sf.v.frame = CGRect(x: 0, y: 568, width: 50, height: 50)
                        })
                        
                        sf.makeGIF()
                    }
                })
            }
        })
        
        
    }
    
    private func makeGIF() {
        
        let result = aniCanvasView.progressBegan()
        
        switch result {
        case .Next(let duration):
            let FPS = 24
            let count = Int(CGFloat(FPS) * duration) + 1
            
            GIFCreator.beganWith(publishID, images: [], delays: [], ignoreCache: true)
            
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                guard let sf = self else {return}
                var thumbImage: UIImage!
                for i in 0..<count {
                    let progress = CGFloat(i) / CGFloat(count)
                    sf.aniCanvasView.progress =  progress < 1.0 ? progress : 1.0
                    let snapshot = sf.aniCanvasView.snapshotViewAfterScreenUpdates(true)
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                    autoreleasepool {
                        UIGraphicsBeginImageContext(CGSize(width: 320, height: 320))
                        sf.aniCanvasView.drawViewHierarchyInRect(CGRect(origin: CGPoint.zero, size: CGSize(width: 320, height: 320)), afterScreenUpdates: true)
                        let image = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                        
                        let img = UIImage(data: UIImageJPEGRepresentation(image, 0.1)!)!
                        if i == count - 1 { thumbImage = img }
                        GIFCreator.addImage(img, delay: 1.0 / CGFloat(FPS))
                    }
                    }
//                }
                GIFCreator.commitWith({[weak self] (url) in
                    debug_print("gif url = \(url)")
                    self?.completed?(url, thumbImage)
                    })
            }
            
            
            
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
        
        //        for c in canvas.containers {
        //            if let content = c.contents.first where content.type == .Image {
        //                c.imageRetriver = imageRetriver
        //            }
        //        }
        
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
