//
//  AniPreviewCanvasViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 4/8/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class AniPreviewCanvasViewController: UIViewController {
    
    @IBOutlet weak var fakePauseAllView: UIToolbar!
    @IBOutlet weak var fakePauseView: CTAGradientButtonView!
    var playAllInAnimaionView = (false, true)
    var canvas: AniCanvas!
    var targetCenter: CGPoint!
    var aniCanvasView: AniPlayCanvasView!
    var imageRetriver: ((String, (String, UIImage?) -> ()) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        fakePauseAllView.userInteractionEnabled = false
        fakePauseView.needGradient = false
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        aniCanvasView.alpha = 0.0
        aniCanvasView.reloadData { [weak self] in
            guard let sf = self else { return }
            dispatch_async(dispatch_get_main_queue(), { 
                self?.aniCanvasView.ready()
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            self?.aniCanvasView.alpha = 1.0
            self?.aniCanvasView.play()
        }
    }
    
    func setup() {
        aniCanvasView = AniPlayCanvasView(frame: CGRect(origin: CGPoint(x: 0, y: 44), size: canvas.size))
        aniCanvasView.backgroundColor = UIColor.whiteColor()
        
        for c in canvas.containers {
            if let content = c.contents.first where content.type == .Image {
                c.imageRetriver = imageRetriver
            }
        }
        
        aniCanvasView.dataSource = canvas
        aniCanvasView.aniDataSource = canvas
//        view.layer.addSublayer(aniCanvasView.layer
        
        view.addSubview(aniCanvasView) // debug
        
        aniCanvasView.completedBlock = {[weak self] in
            self?.dismiss(nil)
//            self?.aniCanvasView.stop()
        }
        
        fakePauseView.userInteractionEnabled = false
        fakePauseView.image = CTAStyleKit.imageOfAnimationpause
        
        switch playAllInAnimaionView {
        case (true, true):
            fakePauseAllView.hidden = false
            fakePauseView.hidden = true
            
        case (true, false):
            fakePauseAllView.hidden = false
            fakePauseView.hidden = true
            
        case (false, true):
            fakePauseAllView.hidden = true
            fakePauseView.hidden = false
            
        case (false, false):
            fakePauseAllView.hidden = true
            fakePauseView.hidden = true
            
        }

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let scale = min(view.bounds.size.width / canvas.size.width, view.bounds.size.height / canvas.size.height)
        
        aniCanvasView.center = targetCenter
//        aniCanvasView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY - 46)
        aniCanvasView.transform = CGAffineTransformMakeScale(scale, scale)
    }
}

extension AniPreviewCanvasViewController {
    @IBAction func tap(sender: AnyObject) {
        dismissViewControllerAnimated(false, completion: nil)
//        aniCanvasView.pause()
//        aniCanvasView.stop()
//        
//        aniCanvasView.ready()
//        aniCanvasView.play()
    }
    
    @IBAction func ready(sender: AnyObject?) {
        aniCanvasView.ready()
    }
    
    @IBAction func play(sender: AnyObject) {
        aniCanvasView.ready()
        aniCanvasView.play()
    }
    
    @IBAction func pause(sender: AnyObject) {
        aniCanvasView.pause()
    }
    
    @IBAction func dismiss(sender: AnyObject?) {
        dismissViewControllerAnimated(false, completion: nil)
    }
}
