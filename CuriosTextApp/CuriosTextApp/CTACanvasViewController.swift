//
//  CTACanvasViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

var xxx = 100

protocol CanvasViewControllerEditable: class {
    
    // add
    // remove
    // updateValue: trig delegate
    // setValue: don't trig delegate
}

protocol CanvasViewControllerDelegate: class {
    
    // willAdd
    // DidAdd
    // willRemove
    // WillSelect
    // DidSelect
    // DidUpdateValueAtIndexPath
    func canvasViewController(viewCOntroller: CTACanvasViewController, didSelectedIndexPath indexPath: NSIndexPath)
    
    func canvasViewControllerWillDeleted(viewController: CTACanvasViewController)
}

protocol CanvasViewControllerDataSource: class {
    
    func canvasViewControllerNumberOfContainers(viewcontroller: CTACanvasViewController) -> Int
    func canvasViewControllerContainerAtIndexPath(indexPath: NSIndexPath) -> ContainerVMProtocol
}


final class CTACanvasViewController: UIViewController {
    
    weak var delegate: CanvasViewControllerDelegate?
    weak var dataSource: CanvasViewControllerDataSource!
    private var collectionView: UICollectionView!
    var scale: CGFloat = 1.0
    var document: CTADocument?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        
        let canvasLayout = CanvasLayout()
        
        let defaultSide: CGFloat = 414.0
        collectionView = UICollectionView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: defaultSide, height: defaultSide)), collectionViewLayout: canvasLayout)
        scale = min(view.bounds.width / defaultSide, view.bounds.height / defaultSide)
        
        collectionView.transform = CGAffineTransformMakeScale(scale, scale)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.1)
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.registerClass(CTACanvasTextCell.self, forCellWithReuseIdentifier: "TextCell")
        collectionView.registerClass(CTACanvasImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        view.layer.addSublayer(collectionView.layer)
        //        view.addSubview(collectionView)
        
        let tap = UITapGestureRecognizer(target: self, action: "tap:")
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.bounds.size = CGSize(width: 414.0, height: 414.0)
        collectionView.center = CGPoint(x: view.bounds.width / 2.0, y: view.bounds.height / 2.0)
    }
    
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func showMenu(indexPath: NSIndexPath) {
        
        self.becomeFirstResponder()
        let cell = collectionView.cellForItemAtIndexPath(indexPath)!
        let deleteMenu = UIMenuItem(title: "删除", action: "deleteItem:")
        UIMenuController.sharedMenuController().menuItems = [deleteMenu]
//        let point = CGPointApplyAffineTransform(cell.center, CGAffineTransformMakeScale(scale, scale))
        let point = cell.center
        UIMenuController.sharedMenuController().setTargetRect(CGRect(origin: point, size: CGSize.zero), inView: collectionView)
        UIMenuController.sharedMenuController().setMenuVisible(true, animated: true)
        
    }
    
    
    // MARK: - Actions
        
    func deleteItem(sender: AnyObject) {
            delegate?.canvasViewControllerWillDeleted(self)
    }
    
    func tap(sender: UITapGestureRecognizer) {
        
        let location = sender.locationInView(collectionView)
        guard let index = indexPathAtPoint(location) else {
            return
        }
        
        if index.item > 0 {
            showMenu(index)
        }
        
        
        if let selectedIndexPath = collectionView.indexPathsForSelectedItems()?.first {
            guard index.compare(selectedIndexPath) != .OrderedSame else {
                return
            }
        }
        
        selectAt(index)
    }

    func insertAt(indexPath: NSIndexPath) {
        collectionView.insertItemsAtIndexPaths([indexPath])
//        collectionView.reloadSections(NSIndexSet(index: 0))
//        collectionView.reloadItemsAtIndexPaths([indexPath])
    }
    
    func removeAt(indexPath: NSIndexPath) {
        collectionView.deleteItemsAtIndexPaths([indexPath])
    }
    
    func reloadSection() {
        collectionView.reloadSections(NSIndexSet(index: 0))
    }
    
    func selectAt(indexPath: NSIndexPath) {
        
        collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        delegate?.canvasViewController(self, didSelectedIndexPath: indexPath)
        
        let context = UICollectionViewFlowLayoutInvalidationContext()
        context.invalidateItemsAtIndexPaths([indexPath])
        collectionView.collectionViewLayout.invalidateLayoutWithContext(context)
    }
    
    
    func updateAt(indexPath: NSIndexPath, updateContents: Bool = false) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        let container = dataSource.canvasViewControllerContainerAtIndexPath(indexPath)
        let position = container.center
        if cell == nil {
            
            let frame: CGRect
            if fabs(container.radius) > 0 {
                
                let size = CGSize(width: container.size.width, height: container.size.height)
                let rect = CGRect(origin: CGPoint.zero, size: size)
                let r = CGRectApplyAffineTransform(rect, CGAffineTransformMakeRotation(-(CGFloat(container.radius))))
                frame = CGRect(x: position.x - CGRectGetWidth(r) / 2.0 , y: position.y - CGRectGetHeight(r) / 2.0, width: CGRectGetWidth(r), height: CGRectGetHeight(r))
            } else {
                let size = CGSize(width: container.size.width, height: container.size.height)
                let origin = CGPoint(x: position.x - CGFloat(size.width) / 2.0, y: position.y - CGFloat(size.height) / 2.0)
                frame = CGRect(origin: origin, size: size)
            }
            
            if CGRectIntersectsRect(collectionView.bounds, frame) {
                collectionView.reloadItemsAtIndexPaths([indexPath])
                collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            }
            
        } else {
            let context = UICollectionViewFlowLayoutInvalidationContext()
            context.invalidateItemsAtIndexPaths([indexPath])
            collectionView.collectionViewLayout.invalidateLayoutWithContext(context)
            
            if updateContents {
                
                switch (cell, container) {
                    
                case (let c as CTACanvasTextCell, let con as TextContainerVMProtocol):
                    c.textView.attributedText = con.textElement?.attributeString
                    
                case (let c as CTACanvasImageCell, let con as ImageContainerVMProtocol):
                    c.imageView.image = UIImage(data: (document?.resourceBy(con.imageElement!.resourceName))!)
                    
                default:
                    ()
                }
                
//                guard let cell = cell as? CTACanvasTextCell, let container = container as? TextContainerVMProtocol else {
//                    return
//                }
            }
        }
    }
    
    func indexPathAtPoint(point: CGPoint) -> NSIndexPath? {
        
        let indexPaths = quickSort(collectionView.indexPathsForVisibleItems()) {$0.item > $1.item}
        
        guard indexPaths.count > 0 else {
            return nil
        }
            
            debug_print(indexPaths, context: defaultContext)
            
            for indexPath in indexPaths {
                
                let cell = collectionView.cellForItemAtIndexPath(indexPath)!
                let onCellPoint = collectionView.convertPoint(point, toView: cell)
                
                if cell.pointInside(onCellPoint, withEvent: nil) {
                    
                    return indexPath
                }
            }
        
        return nil
    }
}

public func quickSort<T: NSIndexPath>(items: [T], @noescape by compare: (T, T) -> Bool) -> [T] {
    guard items.count > 1 else {
        return items
    }
    var items = items
    
    func partition(inout items: [T], left: Int, right: Int, @noescape by compare: (T, T) -> Bool) -> Int {
        let random = left + Int(arc4random_uniform(UInt32(right-left)))
        let key = items[random]
        (items[left], items[random]) = (items[random], items[left])
        var j = left
        for i in (left+1)...right {
            if compare(items[i], key) {
                j+=1
                if i != j {
                    (items[i], items[j]) = (items[j], items[i])
                }
            }
        }
        (items[left], items[j]) = (items[j], items[left])
        return j
    }
    func quickSortIter(inout items: [T], left: Int, right: Int, @noescape by compare: (T, T) -> Bool) {
        if left < right {
            let middle = partition(&items, left: left, right: right, by: compare)
            quickSortIter(&items, left: left, right: middle-1, by: compare)
            quickSortIter(&items, left: middle+1, right: right, by: compare)
        }
    }
    
    quickSortIter(&items, left: 0, right: items.count-1, by: compare)
    return items
}

// MARK: - UICollectionViewDataSource and Delegate
extension CTACanvasViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataSource.canvasViewControllerNumberOfContainers(self)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        switch containerAt(indexPath) {
            
        case let textContainer as TextContainerVMProtocol where textContainer.type == .Text:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TextCell", forIndexPath: indexPath) as! CTACanvasTextCell
            cell.textView.attributedText = textContainer.textElement!.attributeString
            return cell
            
        case let imageContainer as ImageContainerVMProtocol where imageContainer.type == .Image:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! CTACanvasImageCell
            if let data = document?.resourceBy(imageContainer.imageElement!.resourceName) {
                
                debug_print(imageContainer.imageElement!.resourceName)
                cell.imageView.image = UIImage(data: data)
            }
            
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
            return cell
        }
    }
    
    // MARK: - Menu 
    
    func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        
        if action != "deleteItem:" {
            return false
        } else {
            return true
        }
    }
}


extension CTACanvasViewController: CanvasDelegateLayout {
    
    func containerAt(indexPath: NSIndexPath) -> ContainerVMProtocol {
        return dataSource.canvasViewControllerContainerAtIndexPath(indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let size = containerAt(indexPath).size
        
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, rotationForItemAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(containerAt(indexPath).radius)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, positionForItemAtIndexPath indexPath: NSIndexPath) -> CGPoint {
        
        return containerAt(indexPath).center
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, alphaForItemAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, contentInsetForItemAtIndexPath indexPath: NSIndexPath) -> CGPoint {
        return containerAt(indexPath).inset
    }
}

