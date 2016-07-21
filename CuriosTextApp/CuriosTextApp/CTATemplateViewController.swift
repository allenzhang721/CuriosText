//
//  CTATemplateViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTATemplateViewController: UIViewController {
    
    var canvas: AniCanvas?
    var didChangedHandler: (() -> ())?
    var dismissHandler: (() -> ())?
    var doneHandler: (() -> ())?
    var cancelHandler: (() -> ())?
    
    private var previewView: AniPlayCanvasView!
    private var listVC: CTATempateListViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setup() {
        
        // create previewView
        createPreView()
    }
    
    private func createPreView() {
        if let canvas = canvas where previewView == nil {
            let screenSize = UIScreen.mainScreen().bounds.size
            let previewView = AniPlayCanvasView(frame: CGRect(origin: CGPoint.zero, size: canvas.size))
            let scale = min(screenSize.width / canvas.size.width, screenSize.width / canvas.size.height)
            previewView.center = CGPoint(x: screenSize.width / 2.0, y: screenSize.width / 2.0 + 44)
            previewView.transform = CGAffineTransformMakeScale(scale, scale)
            previewView.backgroundColor = UIColor.whiteColor()
            previewView.completedBlock = {[weak self] in
            }
            previewView.dataSource = canvas
            previewView.changeDataSource()
            previewView.aniDataSource = canvas
            view.addSubview(previewView)
            self.previewView = previewView
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.destinationViewController {
        case let vc as CTATempateListViewController:
            listVC = vc
            listVC.selectedHandler = { data in
                
            }

        default:
            ()
        }
    }
    
    
}
