////
////  CTAEditorViewController.swift
////  CuriosTextApp
////
////  Created by Emiaostein on 12/17/15.
////  Copyright © 2015 botai. All rights reserved.
////
//
//import UIKit
//
//class CTAEditorViewController: UIViewController {
//    
//    var page: CTAPage!
//    var canvasView: CTACanvasView!
//    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        
//        setupCanvas()
//    }
//    
//    func setupCanvas() {
//        page = EditorFactory.generateRandomPage()
//        let layers = EditorFactory.containerBy(page)
//        canvasView = CTACanvasView(frame: CGRect(x: 0, y: 64, width: 320, height: 320))
//        canvasView.backgroundColor = UIColor.lightGrayColor()
//        canvasView.setupLayers(layers)
//        let shaper = CAShapeLayer()
//        shaper.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 320, height: 320)).CGPath
//        canvasView.layer.mask = shaper
//        
//        self.view.addSubview(canvasView)
//    }
//    
//    var selectedLayer: CTAContainerLayer?
//    var selectedConVM: containerVMProtocol?
//    
//    @IBAction func tap(sender: UITapGestureRecognizer) {
//        
//        let location = sender.locationInView(canvasView)
//        
//        guard let selectedLayer = canvasView.topContainerLayerAt(location),
//            let conVM = page.containerByID(selectedLayer.iD) else {
//            return
//        }
//        
//        self.selectedLayer = selectedLayer
//        self.selectedConVM = conVM
//    }
//    
//    
//    @IBAction func pan(sender: UIPanGestureRecognizer) {
//        
//        guard let selectedLayer = selectedLayer, let conVM = selectedConVM else {
//            return
//        }
//        
//        let translation = sender.translationInView(canvasView)
////        var beginPoint: CGPoint
//
//        switch sender.state {
//        case .Began:
//            let location = sender.locationInView(canvasView)
//            if !canvasView.layer.containsPoint(location) {
//                return
//            }
//            
//        case .Changed:
//            let beginPoint = CGPoint(x: conVM.origion.x, y: conVM.origion.y)
//           let nextOrigin = CGPoint(x: beginPoint.x + translation.x, y: beginPoint.y + translation.y)
//            selectedLayer.frame.origin = nextOrigin
//            
//        case .Ended:
//            conVM.origion = (Double(CGRectGetMinX(selectedLayer.frame)), Double(CGRectGetMinY(selectedLayer.frame)))
//            
//        default:
//            ()
//        }
//    }
//
//    
//    @IBAction func scaleChanged(sender: UISlider) {
//        guard let selectedLayer = selectedLayer, let conVM = selectedConVM else {
//            return
//        }
//
//        selectedLayer.frame.size = CGSize(width: CGFloat(conVM.size.width) * CGFloat( sender.value), height: CGFloat(conVM.size.height) * CGFloat( sender.value))
//        
//        
//        if let textLayer = selectedLayer.sublayers!.first as? CTATextLayer {
//            textLayer.frame.origin = CGPoint(x: -50, y: 0)
//            textLayer.frame.size = CGSize(width: CGRectGetWidth(selectedLayer.frame) + 100.0 * CGFloat(sender.value), height: CGRectGetWidth(selectedLayer.frame))
//             textLayer.fontSize = 12.0 * CGFloat(sender.value)
//            print(textLayer.font)
//        }
//    }
//    
//    
//
//}
