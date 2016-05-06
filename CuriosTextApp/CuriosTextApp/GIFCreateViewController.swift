//
//  GIFCreateViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 5/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import SVProgressHUD

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
    var completed: ((gifURL: NSURL, thumbURL: NSURL) -> ())?
    
    var slider: UISlider!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupStyles()
    }
    
    override func viewDidAppear(animated: Bool) {
//            self.aniCanvasView.reloadData { [weak self] in
//                guard let sf = self else { return }
//                    aniCanvasView.ready()
        
//            }
    }
    
    func began() {
        
        debug_print("Will Reload")
        
        self.aniCanvasView.reloadData { [weak self] in
            debug_print("Did Reload")
            guard let sf = self else { return }
            sf.aniCanvasView.ready()
            
            SVProgressHUD.showProgress(0, status: "\(Int(0 * 100.0))%")
            let time: NSTimeInterval = 0.3
            let delay = dispatch_time(DISPATCH_TIME_NOW,
                Int64(time * Double(NSEC_PER_SEC)))
            dispatch_after(delay, dispatch_get_main_queue()) {
                sf.makeGIFBegan()
            }
        }
    }
    
    private func next() {
        print("next \(currentIndex) all \(indexs.count)")
        let index = indexs[currentIndex]
        makeGIF(index)
    }
    
    func makeGIFBegan() {
        
        let cacheStatus = GIFCreator.beganWith(publishID, images: [], delays: [], useCache: true)
        
        switch cacheStatus {
        case .Cached(GIFURL: _, thumbURL: _): commit()
        default:
            debug_print("Did MakeGIF")
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
                    i += c
                }
                indexs.append(i..<i + 2)
                counts += 2
                debug_print(indexs)
                next()
                
            default:
                ()
            }
        } 
    }
    
    private func makeGIF(indexs: Range<Int>) {
        let count = counts
        
//        var thumbImage: UIImage!
        for i in indexs {
            autoreleasepool {
            let progress = CGFloat(i) / CGFloat(count)
            aniCanvasView.progress =  progress < 1.0 ? progress : 1.0
            
                UIGraphicsBeginImageContext(CGSize(width: 320, height: 320))
                aniCanvasView.drawViewHierarchyInRect(CGRect(origin: CGPoint.zero, size: CGSize(width: 320, height: 320)), afterScreenUpdates: true)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                let img = image//UIImage(data: UIImageJPEGRepresentation(image, 1)!)!
//                if i == count - 1 { thumbImage = img }
                GIFCreator.addImage(img, delay: 1.0 / CGFloat(24))
            }
        }
        
        currentIndex += 1
        if currentIndex < self.indexs.count {
//            if let progressBlock = progressBlock {
//                progressBlock(progress: aniCanvasView.progress, next: next)
//            } else {
                let aprogress = aniCanvasView.progress
                UIView.animateWithDuration(1.0, animations: {
                    
                    }, completion: { (finished) in
                        if finished {
                            
                        }
                })
            SVProgressHUD.showProgress(Float(aprogress), status: "\(Int(aprogress * 100.0))%")
            let time: NSTimeInterval = 0.5
            let delay = dispatch_time(DISPATCH_TIME_NOW,
                                      Int64(time * Double(NSEC_PER_SEC)))
            dispatch_after(delay, dispatch_get_main_queue()) {
                self.next()
            }
//            }
        } else {
            commit()
        }
    }
    
    private func commit() {
        GIFCreator.commitWith({[weak self] (url, thumburl) in
            SVProgressHUD.showProgress(1, status: "\(Int(1.0 * 100.0))%")
            
            debug_print("gif url = \(url)")
            let time: NSTimeInterval = 0.3
            let delay = dispatch_time(DISPATCH_TIME_NOW,
                Int64(time * Double(NSEC_PER_SEC)))
            dispatch_after(delay, dispatch_get_main_queue()) {
                
                SVProgressHUD.showSuccessWithStatus(LocalStrings.Done.description)
            }
            
            let time2: NSTimeInterval = 0.6
            let delay2 = dispatch_time(DISPATCH_TIME_NOW,
                Int64(time2 * Double(NSEC_PER_SEC)))
            dispatch_after(delay2, dispatch_get_main_queue()) {
                self?.completed?(gifURL: url, thumbURL: thumburl)
            }
            })
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
        
//        slider = UISlider(frame: CGRect(x: 20, y: 568 - 60, width: 280, height: 30))
//        slider.addTarget(self, action: #selector(GIFCreateViewController.sliderChanged(_:)), forControlEvents: .ValueChanged)
//        
//        view.addSubview(slider)
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(GIFCreateViewController.tap(_:)))
//        view.addGestureRecognizer(tap)
        
    }
    
    func tap(sender: UITapGestureRecognizer) {
        makeGIFBegan()
    }
    
    func sliderChanged(sender: UISlider) {
        aniCanvasView.progress = CGFloat(sender.value)
        
        if sender.value >= 1.0 {
            dismissViewControllerAnimated(true, completion: nil)
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
