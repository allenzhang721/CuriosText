//
//  GIFCreateViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 5/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import SVProgressHUD

enum CTAGIFCreateType: String {
    case Small, Normal, Big
}

class GIFCreateViewController: UIViewController {
    
    var gifType:CTAGIFCreateType = .Small
    var fakeView: UIView?
    var publishID: String!
    var canvas: AniCanvas!
    var imageRetriver: ((String, (String, UIImage?) -> ()) -> ())?
    var aniCanvasView: AniPlayCanvasView!
    var progressBlock: ((_ progress: CGFloat, _ next: () -> ()) -> ())?
    var indexs = [CountableRange<Int>]()
    var currentIndex = 0
    var counts = 0
    var completed: ((_ gifURL: URL, _ thumbURL: URL) -> ())?
    
    var slider: UISlider!
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupStyles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//            self.aniCanvasView.reloadData { [weak self] in
//                guard let sf = self else { return }
//                    aniCanvasView.ready()
        
//            }
    }
    
    func began() {
        
        self.aniCanvasView.reloadData { [weak self] in
            guard let sf = self else { return }
            sf.aniCanvasView.ready()
            
            SVProgressHUD.showProgress(0, status: "\(Int(0 * 100.0))%")
            let time: TimeInterval = 0.3
            let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delay) {
                sf.makeGIFBegan()
            }
        }
    }
    
    fileprivate func next() {
        let index = indexs[currentIndex]
        makeGIF(index)
    }
    
    func makeGIFBegan() {
        
        var publishFile = publishID
        switch self.gifType{
        case .Small:
            publishFile = publishFile!+"(320*320)"
        case .Normal:
            publishFile = publishFile!+"(480*480)"
        case .Big:
            publishFile = publishFile!+"(640*640)"
        }
        let cacheStatus = GIFCreator.beganWith(publishFile!, images: [], delays: [], useCache: true)
        
        switch cacheStatus {
        case .cached(GIFURL: _, thumbURL: _): commit()
        default:
            let result = aniCanvasView.progressBegan()
            
            switch result {
            case .next(let duration):
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
    
    fileprivate func makeGIF(_ indexs: CountableRange<Int>) {
        let count = counts

      let up = indexs.upperBound
      let down = indexs.lowerBound
      
//        var thumbImage: UIImage!
        for i in down..<up {
            autoreleasepool {
            let progress = CGFloat(i) / CGFloat(count)
            aniCanvasView.progress =  progress < 1.0 ? progress : 1.0
                var gifSize:CGSize = CGSize(width: 320, height: 320)
                switch self.gifType{
                case .Small:
                    gifSize = CGSize(width: 320, height: 320)
                case .Normal:
                    gifSize = CGSize(width: 480, height: 480)
                case .Big:
                    gifSize = CGSize(width: 640, height: 640)
                }
                UIGraphicsBeginImageContext(gifSize)
                aniCanvasView.drawHierarchy(in: CGRect(origin: CGPoint.zero, size: gifSize), afterScreenUpdates: true)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                let img = image//UIImage(data: UIImageJPEGRepresentation(image, 1)!)!
//                if i == count - 1 { thumbImage = img }
                let delay = (i == up && currentIndex == self.indexs.count - 1) ? 1.0 + 1.0 / CGFloat(24) : 1.0 / CGFloat(24)
              if let img = img {
                GIFCreator.addImage(img, delay: delay)
              }
            }
        }
        
        currentIndex += 1
        if currentIndex < self.indexs.count {
//            if let progressBlock = progressBlock {
//                progressBlock(progress: aniCanvasView.progress, next: next)
//            } else {
                let aprogress = aniCanvasView.progress
                UIView.animate(withDuration: 1.0, animations: {
                    
                    }, completion: { (finished) in
                        if finished {
                            
                        }
                })
            SVProgressHUD.showProgress(Float(aprogress), status: "\(Int(aprogress * 100.0))%")
            let time: TimeInterval = 0.5
            let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delay) {
                self.next()
            }
//            }
        } else {
            commit()
        }
    }
    
    fileprivate func commit() {
        GIFCreator.commitWith({[weak self] (url, thumburl) in
            SVProgressHUD.showProgress(1, status: "\(Int(1.0 * 100.0))%")
            
            debug_print("gif url = \(url)")
            let time: TimeInterval = 0.3
            let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delay) {
                
                SVProgressHUD.showSuccess(withStatus: LocalStrings.done.description)
            }
            
            let time3: TimeInterval = 0.5
            let delay3 = DispatchTime.now() + Double(Int64(time3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delay3) {
                
                SVProgressHUD.dismiss()
            }
            
            let time2: TimeInterval = 0.7
            let delay2 = DispatchTime.now() + Double(Int64(time2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delay2) {
                self?.completed?(url, thumburl)
            }
            })
    }
}

// MARK: - Styles
extension GIFCreateViewController {
    
    func setupViews() {
        aniCanvasView = AniPlayCanvasView(frame: CGRect(origin: CGPoint(x: 0, y: 44), size: canvas.size))
        aniCanvasView.dataSource = canvas
        aniCanvasView.changeDataSource()
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
    
    func tap(_ sender: UITapGestureRecognizer) {
        makeGIFBegan()
    }
    
    func sliderChanged(_ sender: UISlider) {
        aniCanvasView.progress = CGFloat(sender.value)
        
        if sender.value >= 1.0 {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func setupStyles() {
        aniCanvasView.backgroundColor = UIColor(hexString: canvas.canvas.backgroundColor)
        view.backgroundColor = CTAStyleKit.ediorBackgroundColor
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let scale = min(view.bounds.size.width / canvas.size.width, view.bounds.size.height / canvas.size.height)
        aniCanvasView.transform = CGAffineTransform(scaleX: scale, y: scale)
        aniCanvasView.center = view.center
    }
}
