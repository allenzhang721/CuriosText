//
//  CTAPreviewCanvasView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/18/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import PromiseKit
import Kingfisher

protocol CTAPreviewCanvasViewDataSource: class {
    
    func canvasViewWithPage(view: CTAPreviewCanvasView) -> PageVMProtocol?
}

class CTAPreviewCanvasView: UIView {

    weak var datasource: CTAPreviewCanvasViewDataSource?
    var collectionView: UICollectionView!
    let animationNodeManager = CTAAnimationPlayNodeManager()
    var splitedControllers: [[CTAAnimationController]]?
    var publishID = ""
    var page: PageVMProtocol? {
        return datasource?.canvasViewWithPage(self)
    }
    let cache = CTACache()
    var isCached: Bool {
        return cache.cacheFinished
    }
    
//    var isLocal: Bool = false
    var imageAccessBaseURL: NSURL? // documentImage + publishID or serverURL + publishID
    var imageAccess: ((NSURL, String) -> Promise<Result<CTAImageCache>>)?
    
    var didCachedCompletedHandler: ((Bool) -> ())? {
        
        get {
            return cache.cacheDidFinishedHandler
        }
        
        set {
            cache.cacheDidFinishedHandler = newValue
        }
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
        
        let defaultSide: CGFloat = 414.0
        collectionView = UICollectionView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: defaultSide, height: defaultSide)), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.registerClass(CTAPreviewCell.self, forCellWithReuseIdentifier: "ContainerCell")

        addSubview(collectionView)
    }
    
    func cleanViewAndCache() {
        cleanViews()
        cleanCache()
        unload()
    }
    
    func beganCache() {
        guard let page = page else {
            return
        }
        
        let imageNames = page.containerVMs.filter { container in
            if container.type == .Image {
                return true
            } else {
                return false
            }
            }.map { container in
               
                return (container as! ImageContainerVMProtocol).imageElement!.resourceName
        }
        
//        let url = NSURL(string: CTAFilePath.publishFilePath + publishID)
        let url = imageAccessBaseURL
        cache.saveAsyncImagesForKeys(imageNames, baseURL: url!, f: imageAccess!, completedHandler: nil)
    }
    
    func cleanCache() {
        cache.cacheDidFinishedHandler = nil
        cache.cleanALLObject()
    }
    
    func load() {
        let layout = collectionView.collectionViewLayout as! CTAPreviewLayout
        collectionView.dataSource = self
        collectionView.delegate = self
        layout.dataSource = self
        animationNodeManager.dataSource = self
    }
    
    func unload() {
        let layout = collectionView.collectionViewLayout as! CTAPreviewLayout
        collectionView.dataSource = nil
        collectionView.delegate = nil
        layout.dataSource = nil
        animationNodeManager.dataSource = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let defaultSide: CGFloat = 414.0
        let scale = min(bounds.width / defaultSide , bounds.height / defaultSide)
        collectionView.transform = CGAffineTransformMakeScale(scale, scale)
        collectionView.center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
    }
    
    /*
     clear all the views on the cell
     
     */
    func reloadData(needReloadAnimation: Bool = true, compeletedHander:(() -> ())?) {
        
        cleanViewAndCache()
        
        didCachedCompletedHandler = {[weak self] success in
            if let strongSelf = self where success {
                dispatch_async(dispatch_get_main_queue(), {
                    strongSelf.load()
                    CATransaction.begin()
                    CATransaction.setDisableActions(true)
                    strongSelf.collectionView.reloadSections(NSIndexSet(index: 0))
                    CATransaction.commit()
                    
                    if needReloadAnimation {
                        strongSelf.splitedControllers = nil
                        strongSelf.animationNodeManager.reloadNodes()
                    }
                })
                
                compeletedHander?()
            }
            
        }
        
        beganCache()
        

        
        
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
            dispatch_async(dispatch_get_main_queue()) {
                self.animationNodeManager.play()
            }
//            reloadData() {
//                
//            }
            
        } else if animationNodeManager.paused {
            dispatch_async(dispatch_get_main_queue()) {
                self.animationNodeManager.play()
            }
        }
    }
    
    func pause() {
            animationNodeManager.pause()
    }
    
    func stop() {
        
        if animationNodeManager.playing {
            reloadData(false) {
                dispatch_async(dispatch_get_main_queue()) {
                    self.animationNodeManager.stop()
                }
            }
            
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
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ContainerCell", forIndexPath: indexPath)

        return cell
    }
}

extension CTAPreviewCanvasView: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let acell = cell as! CTAPreviewCell
        
        let container = page!.containerVMs[indexPath.item]
        
        let id = container.iD
        let isImageContainer = (container.type == .Image)
        let needLoadContents = page!.containerShouldLoadBeforeAnimationBeganByID(id)
        debug_print(" \(needLoadContents) load \(acell.previewView)", context: aniContext)
        
        
        CTAPreviewCanvasController.configPreviewView(
            acell.previewView,
            container: container,
            publishID: publishID,
            cache: cache,
            needLoadContents: needLoadContents)
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


