//
//  AniPreviewCanvasViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 4/8/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class AniPreviewCanvasViewController: UIViewController {
    
    var canvas: AniCanvas!
    var aniCanvasView: AniPlayCanvasView!
    var imageRetriver: ((String, (String, UIImage?) -> ()) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        
        aniCanvasView.reloadData { [weak self] in
            guard let sf = self else { return }
            sf.ready(nil)
        }
    }
    
    func setup() {
        aniCanvasView = AniPlayCanvasView(frame: CGRect(origin: CGPoint(x: 0, y: 44), size: canvas.size))
        aniCanvasView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        for c in canvas.containers {
            if let content = c.contents.first where content.type == .Image {
                c.imageRetriver = imageRetriver
            }
        }
        
        aniCanvasView.dataSource = canvas
        aniCanvasView.aniDataSource = canvas
//        view.layer.addSublayer(aniCanvasView.layer
        
        view.addSubview(aniCanvasView) // debug
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let scale = min(view.bounds.size.width / canvas.size.width, view.bounds.size.height / canvas.size.height)
        aniCanvasView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        aniCanvasView.transform = CGAffineTransformMakeScale(scale, scale)
    }
}

extension AniPreviewCanvasViewController {
    
    @IBAction func ready(sender: AnyObject?) {
        aniCanvasView.ready()
    }
    
    @IBAction func play(sender: AnyObject) {
        aniCanvasView.play()
    }
    
    @IBAction func pause(sender: AnyObject) {
        aniCanvasView.pause()
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
