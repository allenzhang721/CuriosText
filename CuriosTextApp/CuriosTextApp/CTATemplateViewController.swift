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
    
    fileprivate var previewView: AniPlayCanvasView!
    fileprivate var listVC: CTATempateListViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func setup() {
        
        // create previewView
        createPreView()
    }
    
    fileprivate func createPreView() {
        if let canvas = canvas, previewView == nil {
            let screenSize = UIScreen.main.bounds.size
            let previewView = AniPlayCanvasView(frame: CGRect(origin: CGPoint.zero, size: canvas.size))
            let scale = min(screenSize.width / canvas.size.width, screenSize.width / canvas.size.height)
            previewView.center = CGPoint(x: screenSize.width / 2.0, y: screenSize.width / 2.0 + 44)
            previewView.transform = CGAffineTransform(scaleX: scale, y: scale)
            previewView.backgroundColor = UIColor.white
            previewView.completedBlock = {[weak self] in
            }
            previewView.dataSource = canvas
            previewView.changeDataSource()
            previewView.aniDataSource = canvas
            view.addSubview(previewView)
            self.previewView = previewView
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let vc as CTATempateListViewController:
            listVC = vc
            listVC.selectedHandler = { data in
                
            }

        default:
            ()
        }
    }
    
    
}
