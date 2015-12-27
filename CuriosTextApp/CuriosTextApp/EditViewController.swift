//
//  EditViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/23/15.
//  Copyright © 2015 botai. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, CanvasViewDataSource, CanvasViewDelegate {
    
    let page = EditorFactory.generateRandomPage()
    
    var canvasView: CanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        canvasView = EditorFactory.canvasBy(page)
        canvasView.frame.origin = CGPoint(x: 0, y: 64)
        
        canvasView.backgroundColor = UIColor.lightGrayColor()
        
        canvasView.dataSource = self
        canvasView.delegate = self
        
        let tap = UITapGestureRecognizer(target: canvasView, action: "tap:")
        self.view.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: "pan:")
        self.view.addGestureRecognizer(pan)
        
        let rotation = UIRotationGestureRecognizer(target: self, action: "rotation:")
        self.view.addGestureRecognizer(rotation)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: "pinch:")
        self.view.addGestureRecognizer(pinch)
        
        self.view.layer.addSublayer(canvasView.layer)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        canvasView.reloadData()
    }
    
    var selContainerView: ContainerView?
    var selCotainerVM: ContainerVMProtocol?
    var beginPosition: CGPoint!
    func pan(sender: UIPanGestureRecognizer) {
        
        guard let selContainerView = selContainerView, let selContainer = selCotainerVM else {
            return
        }
        
        let translation = sender.translationInView(self.view)
        
        switch sender.state {
        case .Began:
            beginPosition = CGPoint(x: selContainer.position.x, y: selContainer.position.y)
            
        case .Changed:
            let nextPosition = CGPoint(x: beginPosition.x + translation.x, y: beginPosition.y + translation.y)
            selContainerView.layer.position = nextPosition
            
        case .Ended:
            let nextPosition = CGPoint(x: beginPosition.x + translation.x, y: beginPosition.y + translation.y)
            selContainer.position = (Double(nextPosition.x), Double(nextPosition.y))
        default:
            ()   
        }
    }
    
    var beganRadian: CGFloat = 0.0
    func rotation(sender: UIRotationGestureRecognizer) {
        
        guard let selContainerView = selContainerView, let selContainer = selCotainerVM else {
            return
        }
        
        let rotRadian = sender.rotation
        
        switch sender.state {
        case .Began:
            beganRadian = CGFloat(selContainer.radius)
            
        case .Changed:
            let nextRotation = beganRadian + rotRadian
            selContainerView.transform = CGAffineTransformMakeRotation(nextRotation)
            
        case .Ended:
            let nextRotation = beganRadian + rotRadian
            selContainer.radius = Double(nextRotation)
            
        default:
            ()
        }
    }
    
    var beginScale: CGFloat = 1.0
    func pinch(sender: UIPinchGestureRecognizer) {
        
        guard let selContainerView = selContainerView, let selContainer = selCotainerVM as? TextContainerVMProtocol else {
            return
        }
        
        let scale = sender.scale
        
        switch sender.state {
        case .Began:
            beginScale = selContainer.textElement.fontScale
            
        case .Changed:
            let nextfontSize = beginScale * scale
            let r = selContainer.textElement.textResultWithScale(
                        nextfontSize,
                        constraintSzie: CGSize(width: 320, height: 568 * 2))
            
            selContainerView.bounds.size = r.1
            selContainerView.updateContents(r.3, contentSize: r.2.size, drawInsets: r.0)

        case .Ended:
            let nextfontSize = beginScale * scale
            let size = selContainerView.bounds.size
            selContainer.size = (Double(size.width), Double(size.height))
            selContainer.textElement.fontScale = nextfontSize
            
        default:
            ()
        }
    }
    
    @IBAction func reloadCavas(sender: AnyObject) {
        
        selContainerView = nil
        selCotainerVM = nil
        canvasView.reloadData()
    }
}


// MARK: - CanvasDataSource, CanvasDelegate
extension EditViewController {
    
    func numberOfcontainerInCanvasView(canvas: CanvasView) -> Int {
        
        return page.containerVMs.count
    }
    
    func canvasView(canvas: CanvasView, containerAtIndex index: Int) -> ContainerView {
        
        let containerView = EditorFactory.containerBy(page.containerVMs[index])
        return containerView
    }
    
    func canvasView(canvas: CanvasView, didSelectedContainerAtIndex index: Int) {
        
        selContainerView = canvas.containerViewAt(index)
        selCotainerVM = page.containerByID(selContainerView!.iD)
    }
}
