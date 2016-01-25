//
//  CTAPreviewViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/20/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAPreviewViewController: UIViewController {

    private let page = EditorFactory.generateRandomPage()
    @IBOutlet weak var previewView: CTAPreviewCanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        previewView.datasource = self
    }
    @IBAction func tap(sender: UITapGestureRecognizer) {
        
//        previewView.refresh()
        previewView.play()
    }
    @IBAction func stop(sender: AnyObject) {
        
        previewView.refresh()
    }
}

extension CTAPreviewViewController: CTAPreviewCanvasViewDataSource {
    
    func canvasViewWithPage(view: CTAPreviewCanvasView) -> PageVMProtocol {
        return page
    }
}
