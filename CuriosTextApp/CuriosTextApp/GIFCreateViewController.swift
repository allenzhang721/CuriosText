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
    var progressBlock: ((progress: CGFloat, next: () -> ()) -> ())?
    var indexs = [Range<Int>]()
    var currentIndex = 0
    var counts = 0
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
        dispatch_async(dispatch_get_main_queue(), {
            self.aniCanvasView.reloadData { [weak self] in
                guard let sf = self else { return }
                dispatch_async(dispatch_get_main_queue(), {
                    sf.aniCanvasView.ready()
                    
                    dispatch_async(dispatch_get_main_queue()) { [weak self] in
                        guard let sf = self else { return }
                        sf.makeGIFBegan()
                        //                        sf.makeGIF()
                    }
                })
            }
        })
    }
    
    private func next() {
        print("next")
        let index = indexs[currentIndex]
        makeGIF(index)
    }
    
    private func makeGIFBegan() {
        let result = aniCanvasView.progressBegan()
        
        switch result {
        case .Next(let duration):
            let FPS = 24
            counts = Int(CGFloat(FPS) * duration)
            var c = counts
            var i = 0
            while c > 24  {
                let ind = i..<(i + 24)
                i += 24
                c -= 24
                indexs.append(ind)
            }
            
            if c > 0 {
                indexs.append(i..<i + c)
            }
            
            debug_print(indexs)
            
            GIFCreator.beganWith(publishID, images: [], delays: [], ignoreCache: true)
            
            next()
            
        default:
            ()
        }
    }
    
    private func makeGIF(indexs: Range<Int>) {
        let count = counts
        
        
        var thumbImage: UIImage!
        for i in indexs {
            let progress = CGFloat(i) / CGFloat(count)
            aniCanvasView.progress =  progress < 1.0 ? progress : 1.0
            autoreleasepool {
                UIGraphicsBeginImageContext(CGSize(width: 320, height: 320))
                aniCanvasView.drawViewHierarchyInRect(CGRect(origin: CGPoint.zero, size: CGSize(width: 320, height: 320)), afterScreenUpdates: true)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                let img = UIImage(data: UIImageJPEGRepresentation(image, 0.1)!)!
                if i == count - 1 { thumbImage = img }
                GIFCreator.addImage(img, delay: 1.0 / CGFloat(24))
            }
        }
        
        currentIndex += 1
        if currentIndex < self.indexs.count {
            if let progressBlock = progressBlock {
                progressBlock(progress: aniCanvasView.progress, next: next)
            } else {
                next()
            }
        } else {
            GIFCreator.commitWith({[weak self] (url) in
                debug_print("gif url = \(url)")
                self?.completed?(url, thumbImage)
            })
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
        aniCanvasView.center = view.center
    }
}
