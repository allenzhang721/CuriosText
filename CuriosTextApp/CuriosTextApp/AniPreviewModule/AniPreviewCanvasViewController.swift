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
        
        fakePauseAllView.isUserInteractionEnabled = false
        fakePauseView.needGradient = false
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        aniCanvasView.alpha = 0.0
        aniCanvasView.reloadData { [weak self] in
            guard let sf = self else { return }
            DispatchQueue.main.async(execute: { 
                self?.aniCanvasView.ready()
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let sf = self else {return}
            self?.aniCanvasView.alpha = 1.0
            self?.aniCanvasView.play()
            self?.aniCanvasView.backgroundColor = UIColor(hexString: sf.canvas.canvas.backgroundColor)
        }
    }
    
    func setup() {
        aniCanvasView = AniPlayCanvasView(frame: CGRect(origin: CGPoint(x: 0, y: 44), size: canvas.size))
        aniCanvasView.backgroundColor = UIColor.white
        
        for c in canvas.containers {
            if let content = c.contents.first, content.type == .Image {
                c.imageRetriver = imageRetriver
            }
        }
        
        aniCanvasView.dataSource = canvas
        aniCanvasView.changeDataSource()
        aniCanvasView.aniDataSource = canvas
//        view.layer.addSublayer(aniCanvasView.layer
        
        view.addSubview(aniCanvasView) // debug
        
        aniCanvasView.completedBlock = {[weak self] in
            self?.dismiss(nil)
//            self?.aniCanvasView.stop()
        }
        
        fakePauseView.isUserInteractionEnabled = false
        fakePauseView.image = CTAStyleKit.imageOfAnimationpause
        
        switch playAllInAnimaionView {
        case (true, true):
            fakePauseAllView.isHidden = false
            fakePauseView.isHidden = true
            
        case (true, false):
            fakePauseAllView.isHidden = false
            fakePauseView.isHidden = true
            
        case (false, true):
            fakePauseAllView.isHidden = true
            fakePauseView.isHidden = false
            
        case (false, false):
            fakePauseAllView.isHidden = true
            fakePauseView.isHidden = true
            
        }

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let scale = min(view.bounds.size.width / canvas.size.width, view.bounds.size.height / canvas.size.height)
        
        aniCanvasView.center = targetCenter
//        aniCanvasView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY - 46)
        aniCanvasView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
}

extension AniPreviewCanvasViewController {
    @IBAction func tap(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
        aniCanvasView.pause()
        aniCanvasView.stop()
//
//        aniCanvasView.ready()
//        aniCanvasView.play()
    }
    
    @IBAction func ready(_ sender: AnyObject?) {
        aniCanvasView.ready()
    }
    
    @IBAction func play(_ sender: AnyObject) {
        aniCanvasView.ready()
        aniCanvasView.play()
    }
    
    @IBAction func pause(_ sender: AnyObject) {
        aniCanvasView.pause()
    }
    
    @IBAction func dismiss(_ sender: AnyObject?) {
        self.dismiss(animated: false, completion: nil)
    }
}
