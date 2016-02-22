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
    
    @IBAction func play(sender: AnyObject) {
        
        previewView.play()
    }
    
    @IBAction func pause(sender: AnyObject) {
        
        previewView.pause()
    }
    
    
    @IBAction func reload(sender: AnyObject) {
        previewView.stop()
    }
}

extension CTAPreviewViewController: CTAPreviewCanvasViewDataSource {
    
    func canvasViewWithPage(view: CTAPreviewCanvasView) -> PageVMProtocol? {
        return page
    }
}
