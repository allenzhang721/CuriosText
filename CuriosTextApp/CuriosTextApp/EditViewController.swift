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
    
    private var container: ContainerVMProtocol? {
        guard let selectedIndexPath = selectedIndexPath else {
            return nil
        }
        return page.containerVMs[selectedIndexPath.item]
    }
    
    private var tabItems: [CTATabItem]? {
        
        guard let container = container else {
            return nil
        }
        
        switch container.type {
        case .Text:
            return CTATabItemFactory.shareInstance.textTabItems
            
        default:
            return [CTATabItem]()
        }
    }
    
    private let page = EditorFactory.generateRandomPage()
    
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
        
        guard let selectedIndexPath = selectedIndexPath, let container = container else {
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
    
    private var beganRadian: CGFloat = 0
    func rotation(sender: UIRotationGestureRecognizer) {
        
        guard let selectedIndexPath = selectedIndexPath, let container = container else {
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
            
        case .Ended:
            ()
            
        default:
            ()
        }
    }
    
    private var beganScale: CGFloat = 0
    private var oldScale: CGFloat = 0
    func pinch(sender: UIPinchGestureRecognizer) {
        guard let selectedIndexPath = selectedIndexPath, let container = container else {
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
            }
            
        case .Ended:
            ()
        default:
            ()
        }
    }
}

// MARK: - CTATabViewController
extension EditViewController: CTATabViewControllerDataSource, LineFlowLayoutDelegate {
// MARK: - DataSource
    
    func tableViewControllerNumberOfItems(viewController: CTATabViewController) -> Int {
        
        guard let items = tabItems else {
            return 0
        }
        
        return items.count
    }
    
    func tableViewController(viewController: CTATabViewController, tabItemAtIndexPath indexPath: NSIndexPath) -> CTATabItem {
        
        guard let items = tabItems else {
            return CTATabItem()
        }
        
        return items[indexPath.item]
    }
    
    // MARK: - Delegate
    
    func didChangeTo(collectionView: UICollectionView, itemAtIndexPath indexPath: NSIndexPath, oldIndexPath: NSIndexPath?) {
        
        guard let items = tabItems, let selectorItem = items[indexPath.item].userInfo as? CTASelectorTabItem else {
            return
        }
        
        selectorViewController.changeToSelector(selectorItem.type)
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
        
        return container
    }
    
    // MARK: - Delegate
    
    func scaleDidChanged(scale: CGFloat) {
        
        guard let selectedIndexPath = selectedIndexPath, let container = container else {
            return
        }
        
        let canvasSize = canvasViewController.view.bounds.size
        container.updateWithScale(scale, constraintSzie: CGSize(width: canvasSize.width, height: canvasSize.height * 2))
        
        canvasViewController.updateAt(selectedIndexPath, updateContents: true)
    }
    
    func radianDidChanged(radian: CGFloat) {
        
        guard let selectedIndexPath = selectedIndexPath, let container = container else {
            return
        }
        
        container.radius = radian
        canvasViewController.updateAt(selectedIndexPath, updateContents: false)
    }
}



