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
    func canvasViewController(_ viewCOntroller: CTACanvasViewController, didSelectedIndexPath indexPath: IndexPath)
    
    func canvasViewControllerWillDeleted(_ viewController: CTACanvasViewController)
//    func canvasViewController
    
    func canvasViewControllerWillShowNeedShadowAndNeedStroke(_ viewController: CTACanvasViewController) -> (shadow: Bool, stroke: Bool)?
    
    func canvasViewControllerWillChanged(_ needShadow: Bool, needStroke: Bool)
}

protocol CanvasViewControllerDataSource: class {
    
    func canvasViewControllerNumberOfContainers(_ viewcontroller: CTACanvasViewController) -> Int
    func canvasViewControllerContainerAtIndexPath(_ indexPath: IndexPath) -> ContainerVMProtocol
}


final class CTACanvasViewController: UIViewController {
    
    struct OverlayAttributes {
        let postioin: CGPoint
        let size: CGSize
        let transform: CGAffineTransform
    }
    
    weak var delegate: CanvasViewControllerDelegate?
    weak var dataSource: CanvasViewControllerDataSource!
    fileprivate var collectionView: UICollectionView!
    var scale: CGFloat = 1.0
    weak var document: CTADocument? 
    
    let selectedOverlayLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        
        setupViews()
        setupStyles()
        setupGestures()
        setupRegisterNotifiction()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let defaultSize = 414.0
        collectionView.bounds.size = CGSize(width: defaultSize, height: defaultSize)
        collectionView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    deinit {
        debug_print("\(#file) deinit", context: deinitContext)
        removeNotification()
    }
}

// MARK: - Setup
extension CTACanvasViewController {
    
    func setupViews() {
        view.backgroundColor = CTAStyleKit.ediorBackgroundColor
        
        let canvasLayout = EditCanvasLayout()
        let defaultSide: CGFloat = 414.0
        collectionView = UICollectionView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: defaultSide, height: defaultSide)), collectionViewLayout: canvasLayout)
        scale = min(view.bounds.width / defaultSide, view.bounds.height / defaultSide)
        collectionView.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(CTACanvasTextCell.self, forCellWithReuseIdentifier: "TextCell")
        collectionView.register(CTACanvasImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        view.layer.addSublayer(collectionView.layer)
        
        // overLay
        view.layer.addSublayer(selectedOverlayLayer)
    }
    
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(CTACanvasViewController.tap(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func setupStyles() {
        selectedOverlayLayer.fillColor = UIColor.clear.cgColor
        selectedOverlayLayer.strokeColor = UIColor.yellow.cgColor
    }
    
    func setupRegisterNotifiction() {
        NotificationCenter.default.addObserver(self, selector: #selector(CTACanvasViewController.menuWillHidden(_:)), name:
            NSNotification.Name.UIMenuControllerWillHideMenu, object: nil)
    }
    
    func changeBackgroundColor(_ color: UIColor) {
        collectionView.backgroundColor = color
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setSelectedItemAt(indexPath i: IndexPath) {
        collectionView.selectItem(at: i, animated: false, scrollPosition: UICollectionViewScrollPosition())
    }
}




// MARK: - Actions
extension CTACanvasViewController {
    func tap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: collectionView)
        guard let index = indexPathAtPoint(location) else { return }
        
        showOverlayAndSelectedAt(index)
    }
}

// MARK: - Logic
extension CTACanvasViewController {
    
    func menuShowAt(_ indexPath: IndexPath) {
        self.becomeFirstResponder()
        
        let atrributes = collectionView.layoutAttributesForItem(at: indexPath)!
        let needShadowAndStroke = delegate?.canvasViewControllerWillShowNeedShadowAndNeedStroke(self)
        
        var menus = [UIMenuItem]()
        
        let deleteMenu = UIMenuItem(title: LocalStrings.delete.description, action: #selector(CTACanvasViewController.deleteItem(_:)))
        menus += [deleteMenu]
        if let needShadowAndStroke = needShadowAndStroke {
            let shadowMenu = UIMenuItem(title: needShadowAndStroke.shadow ? LocalStrings.closeShadow.description : LocalStrings.openShadow.description, action: #selector(CTACanvasViewController.changeShadow(_:)))
            let strokeMenu = UIMenuItem(title: needShadowAndStroke.stroke ? LocalStrings.closeOutline.description : LocalStrings.openOutline.description, action: #selector(CTACanvasViewController.changeStroke(_:)))
            menus += [shadowMenu, strokeMenu]
        }
        
        UIMenuController.shared.menuItems = menus
        let point = CGPoint(x: atrributes.center.x, y: atrributes.center.y - atrributes.bounds.height / 2.0)
        UIMenuController.shared.setTargetRect(CGRect(origin: point, size: CGSize.zero), in: collectionView)
        UIMenuController.shared.setMenuVisible(true, animated: true)
    }
    
    func menuWillHidden(_ sender: Notification) {
        overlayHidden()
    }
    
    func overlayShowWith(_ attribute: OverlayAttributes) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        selectedOverlayLayer.opacity = 0.0
        let path = UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: attribute.size))
        selectedOverlayLayer.path = path.cgPath
        
        selectedOverlayLayer.bounds.size = attribute.size
        selectedOverlayLayer.position = attribute.postioin
        selectedOverlayLayer.setAffineTransform(attribute.transform)
        
        
        CATransaction.commit()
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.selectedOverlayLayer.opacity = 1.0
        }) 
    }
    
    func overlayHidden() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.selectedOverlayLayer.opacity = 0.0
        }) 
    }
    
    // MARK: - Items
    func indexPathAtPoint(_ point: CGPoint) -> IndexPath? {
        let indexPaths = quickSort(collectionView.indexPathsForVisibleItems as [NSIndexPath]) {$0.item > $1.item}
        
        guard indexPaths.count > 0 else { return nil }
        
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath as IndexPath)!
            let onCellPoint = collectionView.convert(point, to: cell)
            if cell.point(inside: onCellPoint, with: nil) {
                return indexPath as IndexPath
            }
        }
        return nil
    }
    
    func quickSort<T: NSIndexPath>(_ items: [T], by compare: (T, T) -> Bool) -> [T] {
        guard items.count > 1 else {
            return items
        }
        var items = items
        
        func partition(_ items: inout [T], left: Int, right: Int, by compare: (T, T) -> Bool) -> Int {
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
        func quickSortIter(_ items: inout [T], left: Int, right: Int, by compare: (T, T) -> Bool) {
            if left < right {
                let middle = partition(&items, left: left, right: right, by: compare)
                quickSortIter(&items, left: left, right: middle-1, by: compare)
                quickSortIter(&items, left: middle+1, right: right, by: compare)
            }
        }
        
        quickSortIter(&items, left: 0, right: items.count-1, by: compare)
        return items
    }
    
    func deleteItem(_ sender: AnyObject) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.canvasViewControllerWillDeleted(strongSelf)
        }
    }
    
    func changeShadow(_ sender: AnyObject) {
        if let needShadowAndStroke = delegate?.canvasViewControllerWillShowNeedShadowAndNeedStroke(self) {
            delegate?.canvasViewControllerWillChanged(!needShadowAndStroke.shadow, needStroke: needShadowAndStroke.stroke)
        }
        
    }
    
    func changeStroke(_ sender: AnyObject) {
        if let needShadowAndStroke = delegate?.canvasViewControllerWillShowNeedShadowAndNeedStroke(self) {
            delegate?.canvasViewControllerWillChanged(needShadowAndStroke.shadow, needStroke: !needShadowAndStroke.stroke)
        }
    }
    
    func insertAt(_ indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.collectionView.insertItems(at: [indexPath])
        }
    }
    
    func removeAt(_ indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.collectionView.deleteItems(at: [indexPath])
        }
        
    }
    
    func reloadSection(_ completion: (() -> ())? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            strongSelf.collectionView.reloadSections(IndexSet(integer: 0))
            CATransaction.commit()
            completion?()
        }
    }
    
    func showOverlayAndSelectedAt(_ index: IndexPath) {
        
        if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
            if (index as NSIndexPath).compare(selectedIndexPath) != .orderedSame {
                debug_print("has selected")
                selectAt(index)
            }
        } else {
            selectAt(index)
        }

        DispatchQueue.main.async {[weak self] in
            if index.item > 0 {
                guard let sf = self else {return}
                
                let attributes = sf.collectionView.collectionViewLayout.layoutAttributesForItem(at: index)!
                let size = attributes.size
                let position = sf.collectionView.convert(attributes.center, to: sf.view)
                let transform = attributes.transform
                
                let attr = OverlayAttributes(postioin: position, size: size, transform: transform)
                
                sf.menuShowAt(index)
                sf.overlayShowWith(attr)
            }
        }
    }
    
    func selectAt(_ indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
            strongSelf.delegate?.canvasViewController(strongSelf, didSelectedIndexPath: indexPath)
            
            let context = UICollectionViewFlowLayoutInvalidationContext()
            context.invalidateItems(at: [indexPath])
            strongSelf.collectionView.collectionViewLayout.invalidateLayout(with: context)
        }
    }
    
    func updateAt(_ indexPath: IndexPath, updateContents: Bool = false) {
        let cell = collectionView.cellForItem(at: indexPath)
        let container = dataSource.canvasViewControllerContainerAtIndexPath(indexPath)
        let position = container.center
        if cell == nil {
            
            let frame: CGRect
            if fabs(container.radius) > 0 {
                
                let size = CGSize(width: container.size.width, height: container.size.height)
                let rect = CGRect(origin: CGPoint.zero, size: size)
                let r = rect.applying(CGAffineTransform(rotationAngle: -(CGFloat(container.radius))))
                frame = CGRect(x: position.x - r.width / 2.0 , y: position.y - r.height / 2.0, width: r.width, height: r.height)
            } else {
                let size = CGSize(width: container.size.width, height: container.size.height)
                let origin = CGPoint(x: position.x - CGFloat(size.width) / 2.0, y: position.y - CGFloat(size.height) / 2.0)
                frame = CGRect(origin: origin, size: size)
            }
            
            if collectionView.bounds.intersects(frame) {
                collectionView.reloadItems(at: [indexPath])
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
            }
            
        } else {
            let context = UICollectionViewFlowLayoutInvalidationContext()
            context.invalidateItems(at: [indexPath])
            collectionView.collectionViewLayout.invalidateLayout(with: context)
            
            if updateContents {
                
                switch (cell, container) {
                    
                case (let c as CTACanvasTextCell, let con as TextContainerVMProtocol):
                    c.textView.attributedText = con.textElement?.attributeString
                    
                case (let c as CTACanvasImageCell, let con as ImageContainerVMProtocol):
                    c.imageView.image = UIImage(data: (document?.cacheResourceBy(con.imageElement!.resourceName))!)
                    
                default:
                    ()
                }
            }
        }
    }
}





// MARK: - UICollectionViewDataSource and Delegate
extension CTACanvasViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataSource.canvasViewControllerNumberOfContainers(self)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch containerAt(indexPath) {
            
        case let textContainer as TextContainerVMProtocol where textContainer.type == .text:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCell", for: indexPath) as! CTACanvasTextCell
            cell.textView.attributedText = textContainer.textElement!.attributeString
            return cell
            
        case let imageContainer as ImageContainerVMProtocol where imageContainer.type == .image:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! CTACanvasImageCell
            if let data = document?.cacheResourceBy(imageContainer.imageElement!.resourceName) {
                
                debug_print(imageContainer.imageElement!.resourceName)
                
                cell.imageView.image = UIImage(data: data)
            }
            
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            return cell
        }
    }
}


extension CTACanvasViewController: CanvasDelegateLayout {
    
    func containerAt(_ indexPath: IndexPath) -> ContainerVMProtocol {
        return dataSource.canvasViewControllerContainerAtIndexPath(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = containerAt(indexPath).size
        
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, rotationForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        return CGFloat(containerAt(indexPath).radius)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, positionForItemAtIndexPath indexPath: IndexPath) -> CGPoint {
        
        return containerAt(indexPath).center
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, alphaForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        let c = containerAt(indexPath).alphaValue
        return c
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, contentInsetForItemAtIndexPath indexPath: IndexPath) -> CGPoint {
        return containerAt(indexPath).inset
    }
}

