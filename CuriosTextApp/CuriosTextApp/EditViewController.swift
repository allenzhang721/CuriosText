//
//  EditViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/23/15.
//  Copyright © 2015 botai. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    
    private var tabViewController: CTATabViewController!
    private var canvasViewController: CTACanvasViewController!
    private var selectorViewController: CTASelectorsViewController!
    private var selectedIndexPath: NSIndexPath?
    var document: CTADocument!
    
    private var page: CTAPage {
        return document.page!
    }
    
    private var selectedContainer: ContainerVMProtocol? {
        guard let selectedIndexPath = selectedIndexPath else { return nil }
        return page.containerVMs[selectedIndexPath.item]
    }
    private var animation: CTAAnimationBinder? {
        guard let container = selectedContainer else {return nil}
        return page.animationBinders.filter{$0.targetiD == container.iD}.first
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestures()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.destinationViewController {
        case let vc as CTATabViewController:
            tabViewController = vc
            tabViewController.dataSource = self
            tabViewController.delegate = self
            
        case let vc as CTACanvasViewController:
            canvasViewController = vc
            canvasViewController.dataSource = self
            canvasViewController.delegate = self
            
        case let vc as CTASelectorsViewController:
            selectorViewController = vc
            selectorViewController.dataSource = self
            selectorViewController.delegate = self
        default:
            ()
        }
    }
    
    // MARK: - Gestures
    private func addGestures() {
        let pan = UIPanGestureRecognizer(target: self, action: "pan:")
        canvasViewController.view.addGestureRecognizer(pan)
        
        let rotation = UIRotationGestureRecognizer(target: self, action: "rotation:")
        canvasViewController.view.addGestureRecognizer(rotation)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: "pinch:")
        canvasViewController.view.addGestureRecognizer(pinch)
    }
    
    
    private var beganPosition: CGPoint!
    func pan(sender: UIPanGestureRecognizer) {
        guard let selectedIndexPath = selectedIndexPath, let container = selectedContainer else {
            return
        }
        
        let translation = sender.translationInView(sender.view)
        
        switch sender.state {
        case .Began:
            beganPosition = container.center
        case .Changed:
            let nextPosition = CGPoint(x: beganPosition.x + translation.x, y: beganPosition.y + translation.y)
            container.center = nextPosition
            canvasViewController.updateAt(selectedIndexPath)
            
        case .Ended:
            ()
        default:
            ()
        }
    }
    
    // TODO: Need Update RotatorSelector -- Emiaostein; 2016-01-13-18:13
    private var beganRadian: CGFloat = 0
    func rotation(sender: UIRotationGestureRecognizer) {
        guard let selectedIndexPath = selectedIndexPath, let container = selectedContainer else {
            return
        }
        
        let rotRadian = sender.rotation
        
        switch sender.state {
        case .Began:
            beganRadian = CGFloat(container.radius)
            
        case .Changed:
            let nextRotation = beganRadian + rotRadian
            container.radius = nextRotation
            canvasViewController.updateAt(selectedIndexPath)
            selectorViewController.updateIfNeed()
            
        case .Ended:
            ()
            
        default:
            ()
        }
    }
    
    // TODO: Need Update SizeSelector -- Emiaostein; 2016-01-13-18:14
    private var beganScale: CGFloat = 0
    private var oldScale: CGFloat = 0
    func pinch(sender: UIPinchGestureRecognizer) {
        guard let selectedIndexPath = selectedIndexPath, let container = selectedContainer else {
            return
        }
        
        let scale = sender.scale
        
        switch sender.state {
        case .Began:
            beganScale = container.scale
            oldScale = container.scale
            
        case .Changed:
            let nextScale = scale * beganScale
            
            if fabs(nextScale * 100.0 - oldScale * 100.0) > 0.1 {
                let ascale = floor(nextScale * 100) / 100.0
                let canvasSize = canvasViewController.view.bounds.size
                container.updateWithScale(ascale, constraintSzie: CGSize(width: canvasSize.width, height: canvasSize.height * 2))
                
                canvasViewController.updateAt(selectedIndexPath, updateContents: true)
                selectorViewController.updateIfNeed()
            }
            
        case .Ended:
            ()
        default:
            ()
        }
    }
}

// MARK: - Publish
extension EditViewController {
    
    @IBAction func publish(sender: AnyObject) {
        
        CTADocumentManager.saveDoucment { (success) -> Void in
            
            if success {
                
                CTADocumentManager.uploadFiles({ (success, publishID, publishURL) -> Void in
                    
                    debug_print("upload \(success)")
                    
                    CTAPublishDomain().createPublishFile(publishID, userID: "ae7ca2d8590f4709ad73286920fa522f", title: "Emiaostein", publishDesc: "Emiaostein", publishIconURL: "", previewIconURL: "", publishURL: publishURL, compelecationBlock: { (domainInfo) -> Void in
                        
                        debug_print("publish \(domainInfo.result), publishURL = \(publishURL)")
                    })
                })
            }
        }
    }
}
























// MARK: - CTATabViewController
extension EditViewController: CTATabViewControllerDataSource, CTATabViewControllerDelegate {
    // MARK: - DataSource
    
    func tabViewControllerNumberOfItems(
        viewController: CTATabViewController)
        -> Int {
            guard let _ = selectedContainer else {
                return 0
            }
            
            return CTABarItemsFactory.textSelectorItems.count
    }
    
    func tabViewController(
        viewController: CTATabViewController,
        tabItemAtIndexPath indexPath: NSIndexPath)
        -> CTABarItem {
            
            return CTABarItemsFactory.textSelectorItems[indexPath.item]
    }
    
    // MARK: - Delegate
    
    func tabViewController(ViewController: CTATabViewController, didChangedToIndexPath indexPath: NSIndexPath, oldIndexPath: NSIndexPath?) {
        
        guard let container = selectedContainer where container.featureTypes.count > 0 else {
            return
        }
        
        selectorViewController.changeToSelector(container.featureTypes[indexPath.item])
    }
}































// MARK: - CTACanvasViewController
extension EditViewController: CanvasViewControllerDataSource, CanvasViewControllerDelegate {
    
    // MARK: - DataSource
    func canvasViewControllerNumberOfContainers(viewcontroller: CTACanvasViewController) -> Int {
        return page.containerVMs.count
    }
    
    func canvasViewControllerContainerAtIndexPath(indexPath: NSIndexPath) -> ContainerVMProtocol {
        return page.containerVMs[indexPath.item]
    }
    
    // MARK: - Delegate
    func canvasViewController(viewCOntroller: CTACanvasViewController, didSelectedIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
        tabViewController.collectionView.reloadData()
        selectorViewController.updateSelector()
    }
}

// MARK: - CTASelectorsViewController
extension EditViewController: CTASelectorsViewControllerDataSource, CTASelectorViewControllerDelegate {
    
    // MARK: - DataSource
    func selectorsViewControllerContainer(viewcontroller: CTASelectorsViewController) -> ContainerVMProtocol? {
        return selectedContainer
    }
    
    func selectorsViewControllerAnimation(ViewController: CTASelectorsViewController) -> CTAAnimationBinder? {
        return animation
    }
    
    // MARK: - Delegate
    func scaleDidChanged(scale: CGFloat) {
        guard
            let selectedIndexPath = selectedIndexPath,
            let container = selectedContainer else {
            return
        }
        
        let canvasSize = canvasViewController.view.bounds.size
        container.updateWithScale(
            scale,
            constraintSzie: CGSize(width: canvasSize.width, height: canvasSize.height * 2)
        )
        canvasViewController.updateAt(selectedIndexPath, updateContents: true)
    }
    
    func radianDidChanged(radian: CGFloat) {
        guard
            let selectedIndexPath = selectedIndexPath,
            let container = selectedContainer else {
            return
        }
        
        container.radius = radian
        canvasViewController.updateAt(selectedIndexPath, updateContents: false)
    }
    
    func fontDidChanged(fontFamily: String, fontName: String) {
        guard
            let selectedIndexPath = selectedIndexPath,
            let container = selectedContainer as? TextContainerVMProtocol else {
            return
        }
        
        debug_print("font Did Changed", context: fdContext)
        
        let canvasSize = canvasViewController.view.bounds.size
        container.updateWithFontFamily(
            fontFamily,
            FontName: fontName,
            constraintSize: CGSize(width: canvasSize.width, height: canvasSize.height * 2)
        )
        canvasViewController.updateAt(selectedIndexPath, updateContents: true)
    }
    
    func alignmentDidChanged(alignment: NSTextAlignment) {
        guard
            let selectedIndexPath = selectedIndexPath,
            let container = selectedContainer as? TextContainerVMProtocol else {
            return
        }
        
        container.updateWithTextAlignment(alignment)
        canvasViewController.updateAt(selectedIndexPath, updateContents: true)
    }
    
    func spacingDidChanged(lineSpacing: CGFloat, textSpacing: CGFloat) {
        guard
            let selectedIndexPath = selectedIndexPath,
            let container = selectedContainer as? TextContainerVMProtocol else {
            return
        }
        
        let canvasSize = canvasViewController.view.bounds.size
        container.updateWithTextSpacing(
            lineSpacing,
            textSpacing: textSpacing,
            constraintSize:CGSize(width: canvasSize.width, height: canvasSize.height * 2)
        )
        canvasViewController.updateAt(selectedIndexPath, updateContents: true)
    }
    
    func colorDidChanged(item: CTAColorItem) {
        guard
            let selectedIndexPath = selectedIndexPath,
            let container = selectedContainer as? TextContainerVMProtocol else {
            return
        }
        
        container.updateWithColor(
            item.colorHex,
            alpha: item.colorHexAlpha
        )
        canvasViewController.updateAt(selectedIndexPath, updateContents: true)
    }
}



