//
//  CTAPreviewViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/20/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAPreviewViewController: UIViewController {

    fileprivate let page = EditorFactory.generateRandomPage()
    @IBOutlet weak var previewView: CTAPreviewCanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        previewView.datasource = self
    }
    
    @IBAction func play(_ sender: AnyObject) {
        
        previewView.play()
    }
    
    @IBAction func pause(_ sender: AnyObject) {
        
        previewView.pause()
    }
    
    
    @IBAction func reload(_ sender: AnyObject) {
        previewView.stop()
    }
}

extension CTAPreviewViewController: CTAPreviewCanvasViewDataSource {
    
    func canvasViewWithPage(_ view: CTAPreviewCanvasView) -> PageVMProtocol? {
        return page
    }
}
