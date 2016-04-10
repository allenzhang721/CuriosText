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
        aniCanvasView.reloadData { [weak self] in
            guard let sf = self else { return }
            sf.ready(nil)
            sf.play()
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
}

// MARK: - Preview DataSource
//extension CTAPublishViewController: CTAPreviewCanvasViewDataSource {
//
//    func canvasViewWithPage(view: CTAPreviewCanvasView) -> PageVMProtocol? {
//        return page
//    }
//    
//}
