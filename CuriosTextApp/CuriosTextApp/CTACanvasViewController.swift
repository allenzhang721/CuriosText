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
}

protocol CanvasViewControllerDataSource: class {
    
    func canvasViewControllerNumberOfContainers(viewcontroller: CTACanvasViewController) -> Int
    func canvasViewControllerContainerAtIndexPath(indexPath: NSIndexPath) -> ContainerVMProtocol
}


final class CTACanvasViewController: UIViewController {
    
    weak var delegate: CanvasViewControllerDelegate?
    weak var dataSource: CanvasViewControllerDataSource!
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        
        let canvasLayout = CanvasLayout()
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: canvasLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.lightGrayColor()
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.registerClass(CTACanvasTextCell.self, forCellWithReuseIdentifier: "TextCell")
        collectionView.registerClass(CTACanvasImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        view.layer.addSublayer(collectionView.layer)
        //        view.addSubview(collectionView)
        
        let tap = UITapGestureRecognizer(target: self, action: "tap:")
        view.addGestureRecognizer(tap)
        
        //        let pan = UIPanGestureRecognizer(target: self, action: "pan:")
        //        self.view.addGestureRecognizer(pan)
        
        //        let rotation = UIRotationGestureRecognizer(target: self, action: "rotation:")
        //        self.view.addGestureRecognizer(rotation)
        //
        //        let pinch = UIPinchGestureRecognizer(target: self, action: "pinch:")
        //        self.view.addGestureRecognizer(pinch)
        
    }
    
    override func viewWillLayoutSubviews() {
        
        collectionView.frame = view.bounds
    }
    
    func tap(sender: UITapGestureRecognizer) {
        
        let location = sender.locationInView(collectionView)
        guard let index = indexPathAtPoint(location) else {
            return
        }
        
        if let selectedIndexPath = collectionView.indexPathsForSelectedItems()?.first {
            guard index.compare(selectedIndexPath) != .OrderedSame else {
                return
            }
        }
        
        collectionView.selectItemAtIndexPath(index, animated: false, scrollPosition: .None)
        delegate?.canvasViewController(self, didSelectedIndexPath: index)
        
        let context = UICollectionViewFlowLayoutInvalidationContext()
        context.invalidateItemsAtIndexPaths([index])
        collectionView.collectionViewLayout.invalidateLayoutWithContext(context)
    }
    
    //    var selCotainerVM: ContainerVMProtocol?
    //    var beginPosition: CGPoint!
    //    var selectedIndexPath: NSIndexPath!
    //    func pan(sender: UIPanGestureRecognizer) {
    //
    //        guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems() where selectedIndexPaths.count > 0  else {
    //            return
    //        }
    //
    //        let translation = sender.translationInView(self.view)
    //
    //        switch sender.state {
    //        case .Began:
    //            selectedIndexPath = selectedIndexPaths.first!
    //            selCotainerVM = containerAt(selectedIndexPath)
    //            beginPosition = CGPoint(x: selCotainerVM!.position.x, y: selCotainerVM!.position.y)
    //
    //        case .Changed:
    //
    //            let nextPosition = CGPoint(x: beginPosition.x + translation.x, y: beginPosition.y + translation.y)
    //            selCotainerVM!.position = (Double(nextPosition.x), Double(nextPosition.y))
    //
    //            let cell = collectionView.cellForItemAtIndexPath(selectedIndexPath)
    //            if cell == nil {
    //
    //                let frame: CGRect
    //                if fabs(selCotainerVM!.radius) > 0 {
    //
    //                    let size = CGSize(width: selCotainerVM!.size.width, height: selCotainerVM!.size.height)
    //                    let rect = CGRect(origin: CGPoint.zero, size: size)
    //                    let r = CGRectApplyAffineTransform(rect, CGAffineTransformMakeRotation(-(CGFloat(selCotainerVM!.radius))))
    //                    frame = CGRect(x: nextPosition.x - CGRectGetWidth(r) / 2.0 , y: nextPosition.y - CGRectGetHeight(r) / 2.0, width: CGRectGetWidth(r), height: CGRectGetHeight(r))
    //                } else {
    //                    let size = CGSize(width: selCotainerVM!.size.width, height: selCotainerVM!.size.height)
    //                    let origin = CGPoint(x: nextPosition.x - CGFloat(size.width) / 2.0, y: nextPosition.y - CGFloat(size.height) / 2.0)
    //                    frame = CGRect(origin: origin, size: size)
    //                }
    //
    //                if CGRectIntersectsRect(collectionView.bounds, frame) {
    //                    collectionView.reloadItemsAtIndexPaths(selectedIndexPaths)
    //                    collectionView.selectItemAtIndexPath(selectedIndexPath, animated: false, scrollPosition: .None)
    //                }
    //
    //            } else {
    //                let context = UICollectionViewFlowLayoutInvalidationContext()
    //                context.invalidateItemsAtIndexPaths(selectedIndexPaths)
    //                collectionView.collectionViewLayout.invalidateLayoutWithContext(context)
    //            }
    //
    //        case .Ended:
    //            ()
    //        default:
    //            ()
    //        }
    //    }
    
    //    var beganRadian: CGFloat = 0.0
    //    func rotation(sender: UIRotationGestureRecognizer) {
    //
    //        guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems() where selectedIndexPaths.count > 0  else {
    //            return
    //        }
    //
    //        let rotRadian = sender.rotation
    //
    //        switch sender.state {
    //        case .Began:
    //            selectedIndexPath = selectedIndexPaths.first!
    //            selCotainerVM = containerAt(selectedIndexPath)
    //            beganRadian = CGFloat(selCotainerVM!.radius)
    //
    //        case .Changed:
    //            let nextRotation = beganRadian + rotRadian
    //            selCotainerVM!.radius = Double(nextRotation)
    //            if let _ = collectionView.cellForItemAtIndexPath(selectedIndexPath) {
    //                let context = UICollectionViewFlowLayoutInvalidationContext()
    //                context.invalidateItemsAtIndexPaths(selectedIndexPaths)
    //                collectionView.collectionViewLayout.invalidateLayoutWithContext(context)
    //            }
    //
    //        case .Ended:
    //            ()
    //
    //        default:
    //            ()
    //        }
    //    }
    
    //    var beginScale: CGFloat = 1.0
    //    func pinch(sender: UIPinchGestureRecognizer) {
    //
    //        guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems() where selectedIndexPaths.count > 0  else {
    //            return
    //        }
    //
    //        let scale = sender.scale
    //
    //        switch sender.state {
    //        case .Began:
    //            selectedIndexPath = selectedIndexPaths.first!
    //            selCotainerVM = containerAt(selectedIndexPath)
    //            beginScale = (selCotainerVM as! TextContainerVMProtocol).textElement.fontScale
    //
    //        case .Changed:
    //            let nextPosition = CGPoint(x: selCotainerVM!.position.x, y: selCotainerVM!.position.y)
    //            let nextfontSize = beginScale * scale
    //            let r = (selCotainerVM as! TextContainerVMProtocol).textElement.textResultWithScale(
    //                nextfontSize,
    //                constraintSzie: CGSize(width: CGRectGetWidth(collectionView.bounds), height: CGRectGetHeight(collectionView.bounds) * 2))
    //
    //            let size = CGSize(width: r.1.width, height: r.1.height)
    //
    //            selCotainerVM!.size = (Double(size.width), Double(size.height))
    //            (selCotainerVM as! TextContainerVMProtocol).textElement.fontScale = nextfontSize
    //
    //            let cell = collectionView.cellForItemAtIndexPath(selectedIndexPath)
    //            if cell == nil {
    //
    //                let frame: CGRect
    //
    //                if fabs(selCotainerVM!.radius) > 0 {
    //
    ////                    let size = CGSize(width: selCotainerVM!.size.width, height: selCotainerVM!.size.height)
    //                    let rect = CGRect(origin: CGPoint.zero, size: size)
    //                    let r = CGRectApplyAffineTransform(rect, CGAffineTransformMakeRotation(-(CGFloat(selCotainerVM!.radius))))
    //                    frame = CGRect(x: nextPosition.x - CGRectGetWidth(r) / 2.0 , y: nextPosition.y - CGRectGetHeight(r) / 2.0, width: CGRectGetWidth(r), height: CGRectGetHeight(r))
    //                } else {
    //                    let size = CGSize(width: selCotainerVM!.size.width, height: selCotainerVM!.size.height)
    //                    let origin = CGPoint(x: nextPosition.x - CGFloat(size.width) / 2.0, y: nextPosition.y - CGFloat(size.height) / 2.0)
    //                    frame = CGRect(origin: origin, size: size)
    //                }
    //
    //                if CGRectIntersectsRect(collectionView.bounds, frame) {
    //                    collectionView.reloadItemsAtIndexPaths(selectedIndexPaths)
    //                    collectionView.selectItemAtIndexPath(selectedIndexPath, animated: false, scrollPosition: .None)
    //                }
    //
    //            } else {
    //                let context = UICollectionViewFlowLayoutInvalidationContext()
    //                context.invalidateItemsAtIndexPaths(selectedIndexPaths)
    //                collectionView.collectionViewLayout.invalidateLayoutWithContext(context)
    //                (cell as! CTACanvasTextCell).textView.attributedText = (selCotainerVM as! TextContainerVMProtocol).textElement.attributeString
    //            }
    //
    ////            selContainerView.bounds.size = r.1
    ////            selContainerView.updateContents(r.3, contentSize: r.2.size, drawInsets: r.0)
    //
    //        case .Ended:
    //            ()
    ////            let nextfontSize = beginScale * scale
    ////            let size = selContainerView.bounds.size
    ////            selContainer.size = (Double(size.width), Double(size.height))
    ////            selContainer.textElement.fontScale = nextfontSize
    //
    //        default:
    //            ()
    //        }
    //    }
    
    
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
                guard let cell = cell as? CTACanvasTextCell, let container = container as? TextContainerVMProtocol else {
                    return
                }
                
                cell.textView.attributedText = container.textElement?.attributeString
            }
        }
    }
    
    func indexPathAtPoint(point: CGPoint) -> NSIndexPath? {
        
        let visualCells = collectionView.visibleCells()
        
        guard visualCells.count > 0 else {
            return nil
        }
        
        let reverseCell = visualCells
        
        for cell in reverseCell {
            
            let onCellPoint = cell.convertPoint(point, fromView: collectionView)
            
            if cell.pointInside(onCellPoint, withEvent: nil) {
                
                return collectionView.indexPathForCell(cell)
            }
        }
        
        return nil
    }
}

extension CTACanvasViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataSource.canvasViewControllerNumberOfContainers(self)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        switch containerAt(indexPath) {
            
        case let textContainer as TextContainerVMProtocol:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TextCell", forIndexPath: indexPath) as! CTACanvasTextCell
            cell.textView.attributedText = textContainer.textElement!.attributeString
            return cell
            
        case let imageContainer as ImageContainerVMProtocol:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! CTACanvasImageCell
            cell.imageView.image = nil
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
            return cell
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

