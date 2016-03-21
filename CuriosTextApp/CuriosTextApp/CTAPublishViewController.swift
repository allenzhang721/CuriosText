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
    
    @IBOutlet weak var publishButton: CTAPublishButton!
    @IBOutlet weak var previewView: CTAPreviewCanvasView!
    var publishWillBegan: (() -> ())?
    var publishDismiss:(() -> ())?
    var page: PageVMProtocol?
    var publishID: String!
    var baseURL: NSURL!
    var imageAccess: ((baseURL: NSURL, imageName: String) -> Promise<Result<CTAImageCache>>)!
    
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
        previewView.reloadData { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.previewView.play()
        }
    }
}

// MARK: - Styles
extension CTAPublishViewController {
    
    func setupViews() {
        previewView.imageAccessBaseURL = baseURL
        previewView.imageAccess = imageAccess
        previewView.datasource = self
    }
    
    func setupStyles() {
        previewView.backgroundColor = CTAStyleKit.commonBackgroundColor
        view.backgroundColor = CTAStyleKit.ediorBackgroundColor
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
}

// MARK: - Preview DataSource
extension CTAPublishViewController: CTAPreviewCanvasViewDataSource {

    func canvasViewWithPage(view: CTAPreviewCanvasView) -> PageVMProtocol? {
        return page
    }
    
}
