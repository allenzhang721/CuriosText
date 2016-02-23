//
//  CTAPreviewCanvasView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/18/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

protocol CTAPreviewCanvasViewDataSource: class {
    
    func canvasViewWithPage(view: CTAPreviewCanvasView) -> PageVMProtocol?
}

class CTAPreviewCanvasView: UIView {

    weak var datasource: CTAPreviewCanvasViewDataSource?
    var collectionView: UICollectionView!
    let animationNodeManager = CTAAnimationPlayNodeManager()
    var splitedControllers: [[CTAAnimationController]]?
    
    var page: PageVMProtocol? {
        return datasource?.canvasViewWithPage(self)
    }
    
    var controllers: [[CTAAnimationController]] {
        guard let page = page else {
            return []
        }
        
        if let splitedControllers = splitedControllers  {
            return splitedControllers
        } else {
            
            let groups = CTAPreviewCanvasController.splits(page.animationBinders)
            
            var controllerNodes = [[CTAAnimationController]]()
            for group in groups {

                var controllers = [CTAAnimationController]()
                for binder in group {
                    let targetID = binder.targetiD
                    guard let container = page.containerByID(targetID), let index = page.indexByID(targetID) else {
                        continue
                    }
                    
                    let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0))

                    let preView = (cell as? CTAPreviewCell)?.previewView
                    
                    debug_print("index = \(index) \(cell)", context: aniContext)

                    let controller = CTAAnimationController(preView: preView, binder: binder, container: container, canvasSize: bounds.size)

                    controllers.append(controller)
                }
                
                controllerNodes += [controllers]
            }
            
            splitedControllers = controllerNodes
            return splitedControllers!
        }
    }
    
    var nodeCount: Int {
        return controllers.count
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let layout = CTAPreviewLayout()
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.registerClass(CTAPreviewCell.self, forCellWithReuseIdentifier: "ContainerCell")
        
        collectionView.dataSource = self
        layout.dataSource = self
        animationNodeManager.dataSource = self
//        layer.addSublayer(collectionView.layer)
        addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    
    /*
     clear all the views on the cell
     
     */
    func reloadData(needReloadAnimation: Bool = true) {
        
        cleanViews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        collectionView.reloadSections(NSIndexSet(index: 0))
        CATransaction.commit()
        
        if needReloadAnimation {
            splitedControllers = nil
            animationNodeManager.reloadNodes()
        }
    }

    // Clear all the views on the cell
    func cleanViews() {
        
        let visualCells = collectionView.visibleCells() as! [CTAPreviewCell]
        
        for cell in visualCells {
            cell.previewView.clearViews()
        }
    }
}

extension CTAPreviewCanvasView: CTAPreviewControl {
    
    func play() {
        guard let _ = page else {
            return
        }
        
        if animationNodeManager.stoped {
            reloadData()
            animationNodeManager.play()
        } else if animationNodeManager.paused {
            animationNodeManager.play()
        }
    }
    
    func pause() {
            animationNodeManager.pause()
    }
    
    func stop() {
        
        if animationNodeManager.playing {
            reloadData(false)
            animationNodeManager.stop()
        }
    }
    
    func clear() {
        
        let visualCells = collectionView.visibleCells() as! [CTAPreviewCell]
        
        for cell in visualCells {
            cell.previewView.clearViews()
        }
    }
}

extension CTAPreviewCanvasView: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let page = page else {
            return 0
        }
        
        return page.containerVMs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ContainerCell", forIndexPath: indexPath) as! CTAPreviewCell
        
        let container = page!.containerVMs[indexPath.item]
        
        let id = container.iD
        let needLoadContents = page!.containerShouldLoadBeforeAnimationBeganByID(id)
        
        debug_print(" \(needLoadContents) load \(cell.previewView)", context: aniContext)
        
        CTAPreviewCanvasController.configPreviewView(
            cell.previewView,
            container: container,
            needLoadContents: needLoadContents)
        
        return cell
    }
}

extension CTAPreviewCanvasView: CTAPreviewLayoutDataSource {
    
    func layout(layout: CTAPreviewLayout, layoutAttributesAtIndexPath indexPath: NSIndexPath) -> ContainerVMProtocol? {
        
        guard let page = page else {
            return nil
        }
        
        return page.containerVMs[indexPath.item]
    }
}

extension CTAPreviewCanvasView: CTAAnimationPlayNodeManagerDataSource {
    
    func numberOfNodesForNodeManager(manager: CTAAnimationPlayNodeManager) -> Int {
        
        return nodeCount
    }
    
    func nodeManager(manager: CTAAnimationPlayNodeManager, animationControllersForNodeAtIndex index: Int) -> [CTAAnimationController] {
        
        return controllers[index]
    }
}


