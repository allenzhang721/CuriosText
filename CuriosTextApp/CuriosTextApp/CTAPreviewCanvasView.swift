//
//  CTAPreviewCanvasView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/18/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

protocol CTAPreviewCanvasViewDataSource: class {
    
    func canvasViewWithPage(view: CTAPreviewCanvasView) -> PageVMProtocol
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

                    let preView = (collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) as? CTAPreviewCell)?.previewView

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
//    var headNode: CTAAnimationPlayNode?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        animationNodeManager.dataSource = self
        setup()
//        animationNodeManager.reloadNodes()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        animationNodeManager.dataSource = self
        setup()
//        animationNodeManager.reloadNodes()
    }
    
    private func setup() {
        let layout = CTAPreviewLayout()
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.registerClass(CTAPreviewCell.self, forCellWithReuseIdentifier: "ContainerCell")
        
        collectionView.dataSource = self
        layout.dataSource = self
//        layer.addSublayer(collectionView.layer)
        addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    
    
    func reloadData() {
        
        cleanViews()
        animationNodeManager.reloadNodes()
        collectionView.reloadData()
    }

    func cleanViews() {
        
        let visualCells = collectionView.visibleCells() as! [CTAPreviewCell]
        
        for cell in visualCells {
            cell.previewView.clearViews()
        }
    }
}

extension CTAPreviewCanvasView: CTAPreviewControl {
    
    func play() {
        guard let page = page else {
            return
        }

        animationNodeManager.play()
    }
    
    func pause() {

    }
    
    func stop() {

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
        
        let id = page!.containerVMs[indexPath.item].iD
        let needLoadContents = page!.containerShouldLoadBeforeAnimationBeganByID(id)
        CTAPreviewCanvasController.configPreviewView(cell.previewView, container: page!.containerVMs[indexPath.item], needLoadContents: needLoadContents)
        
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


