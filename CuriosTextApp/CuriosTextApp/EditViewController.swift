//
//  EditViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/23/15.
//  Copyright © 2015 botai. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet weak var addView: CTAEditAddView!
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
        let anis = page.animationBinders.filter{$0.targetiD == container.iD}
        return anis.count > 0 ? anis.first : nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestures()
        setup()
        
        
        let cameraVC = UIStoryboard(name: "ImagePicker", bundle: nil).instantiateViewControllerWithIdentifier("ImagePickerViewController") as! ImagePickerViewController
        
        cameraVC.didSelectedImageHandler = {[weak self] image in
            if let strongSelf = self, let image = image {
                strongSelf.addImage(image, size: image.size)
                cameraVC.removeFromParentViewController()
                cameraVC.view.removeFromSuperview()
            }
        }
     
        addChildViewController(cameraVC)
        view.addSubview(cameraVC.view)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.destinationViewController {
        case let vc as CTATabViewController:
            tabViewController = vc
            tabViewController.dataSource = self
            tabViewController.delegate = self
            
        case let vc as CTACanvasViewController:
            canvasViewController = vc
            canvasViewController.document = document
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
    
    // MARK: - Setup
    func setup() {
        
        addView.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.1)
        addView.didClickHandler = {[weak self] in
            
            if let strongSelf = self {
                strongSelf.addText()
            }
            
//            if let strongSelf = self {
//                
//                let cameraVC = UIStoryboard(name: "ImagePicker", bundle: nil).instantiateViewControllerWithIdentifier("ImagePickerViewController") as! ImagePickerViewController
//                
//                cameraVC.didSelectedImageHandler = {[weak self] image in
//                    if let strongSelf = self, let image = image {
//                        strongSelf.addImage(image, size: image.size)
//                    }
//                }
//                
//                strongSelf.presentViewController(cameraVC, animated: true, completion: {
//                    
//                    
//                })
//            }
            
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
        
        let doubleTap = UITapGestureRecognizer(target: self, action: "doubleTap:")
        doubleTap.numberOfTapsRequired = 2
        canvasViewController.view.addGestureRecognizer(doubleTap)
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
    
    func doubleTap(sender: UITapGestureRecognizer) {
        guard let selectedIndexPath = selectedIndexPath, let container = selectedContainer else {
            return
        }
        
        switch container.type {
            
        case .Text:
            let textmodifyVC = UIStoryboard(name: "Editor", bundle: nil).instantiateViewControllerWithIdentifier("TextModifyViewController") as! CTATextModifyViewController
            let textElement = (container as! TextContainerVMProtocol).textElement!
            textmodifyVC.beganWith(textElement.texts, attributes: textElement.textAttributes)
            
            textmodifyVC.textModifyDidCompletion = {[weak self] text in
                
                if let strongSelf = self {
                    let canvasSize = strongSelf.canvasViewController.view.bounds.size
                    (container as! TextContainerVMProtocol).updateWithText(text, constraintSize: CGSize(width: canvasSize.width, height: canvasSize.height * 2))
                    
                    strongSelf.canvasViewController.updateAt(selectedIndexPath, updateContents: true)
                }
                
            }
            
            presentViewController(textmodifyVC, animated: true, completion: { 
                
                
            })
            debug_print("double tap TEXT ")
            
        case .Image:
            debug_print("double tap Img")
            let cameraVC = UIStoryboard(name: "ImagePicker", bundle: nil).instantiateViewControllerWithIdentifier("ImagePickerViewController") as! ImagePickerViewController
            
            cameraVC.didSelectedImageHandler = {[weak self] image in
                if let strongSelf = self {
                    dispatch_async(dispatch_get_main_queue(), { 
                    let canvasSize = strongSelf.canvasViewController.view.bounds.size
                    (container as! ImageContainerVMProtocol).updateWithImageSize(image!.size, constraintSize: CGSize(width: canvasSize.width, height: canvasSize.height * 2))
                    
                    strongSelf.document.storeResource(UIImageJPEGRepresentation(image!, 0.1)!, withName: (container as! ImageContainerVMProtocol).imageElement!.resourceName)
                    
                        
                        strongSelf.canvasViewController.updateAt(selectedIndexPath, updateContents: true)
                    })
                }
            }
            
            presentViewController(cameraVC, animated: true, completion: { 
                
                
            }) 
            
        default:
            ()
        }
    }
}

// MARK: - Actions 
extension EditViewController {
    
    func addImage(s: UIImage, size: CGSize) {
        
        let ID = CTAIDGenerator.fileID()
        let imageName = document.resourcePath + ID + ".jpg"
        
        let name = document.storeResource(compressJPGImage(s), withName: imageName)
       let imgContainer = EditorFactory.generateImageContainer(page.width, pageHeigh: page.height, imageSize: size, imgName: name)
        
        page.append(imgContainer)
        canvasViewController.insertAt(NSIndexPath(forItem: page.containers.count - 1, inSection: 0))
    }
    
    func addText(s: String = "") {
        
        let textContainer = EditorFactory.generateTextContainer(page.width, pageHeigh: page.height, text: s.isEmpty ? "Double click to Edit" : s)
        
        page.append(textContainer)
        canvasViewController.insertAt(NSIndexPath(forItem: page.containers.count - 1, inSection: 0))
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func publishPreviewClick(sender: AnyObject) {
        CTADocumentManager.saveDoucment {[weak self] (success) -> Void in
            
            if let strongSelf = self where success {
                
                draw(strongSelf.page, atBegan: false, baseURL: strongSelf.document.imagePath, local: false) { (r) in
                    
                    switch r {
                    case .Success(let image):
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            let previewVC = UIStoryboard(name: "Editor", bundle: nil).instantiateViewControllerWithIdentifier("PublishImageViewController") as! CTAPublishImageViewController
                            
                            previewVC.image = image
                            
                            strongSelf.presentViewController(previewVC, animated: true, completion: nil)
                        })
                        
                    default:
                        debug_print("Fail", context: defaultContext)
                    }
                }
            }
        }
        
        
    }
    
}

// MARK: - Publish
extension EditViewController {
    
    @IBAction func publish(sender: AnyObject) {
        
        CTADocumentManager.saveDoucment { (success) -> Void in
            
            if success {
                
                CTADocumentManager.uploadFiles({ (success, publishID, publishURL) -> Void in
                    
                    debug_print("upload = \(success)\n publishID = \(publishID)", context: previewConttext)
                    
                    CTAPublishDomain().createPublishFile(publishID, userID: CTAUserManager.user!.userID, title: "Emiaostein", publishDesc: "Emiaostein", publishIconURL: "", previewIconURL: "", publishURL: publishURL, compelecationBlock: { (domainInfo) -> Void in
                        
                        debug_print("publish \(domainInfo.result), publishURL = \(publishURL) \n \(domainInfo)", context: previewConttext)
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
            guard let selectedContainer = selectedContainer else {
                return 0
            }
            
            switch selectedContainer {
                
                case let s where s.type == .Text:
                return CTABarItemsFactory.textSelectorItems.count
                
            case let s where s.type == .Image:
                return CTABarItemsFactory.imgSelectorItems.count
                
            default:
                return CTABarItemsFactory.emptySelectorItems.count
            }
    }
    
    func tabViewController(
        viewController: CTATabViewController,
        tabItemAtIndexPath indexPath: NSIndexPath)
        -> CTABarItem {
            
            switch selectedContainer! {
                
            case let s where s.type == .Text:
                return CTABarItemsFactory.textSelectorItems[indexPath.item]
                
            case let s where s.type == .Image:
                return CTABarItemsFactory.imgSelectorItems[indexPath.item]
                
            default:
                return CTABarItemsFactory.emptySelectorItems[indexPath.item]
            }
            
//            return CTABarItemsFactory.textSelectorItems[indexPath.item]
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
        let preType = selectorViewController.currentType
        let preCon = selectedContainer?.type
        selectedIndexPath = indexPath
        let nextCon = selectedContainer?.type
        if (preCon != nextCon) { // need update tab
           let nextIndex = selectedContainer?.featureTypes.indexOf(preType) ?? 0
            tabViewController.collectionView.reloadData()
            
            if let attri = self.tabViewController.collectionView.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: nextIndex, inSection: 0)) {
                let cener = attri.center
                self.tabViewController.collectionView.setContentOffset(CGPoint(x: cener.x - self.tabViewController.collectionView.bounds.width / 2.0, y: 0), animated: false)
            }
        }
        
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
        
        debug_print("animation= \(animation) load", context: animationChangedContext)
        return animation
    }
    
    func selectorsViewController(viewController: CTASelectorsViewController, needChangedFromSelectorType type: CTAContainerFeatureType) -> CTAContainerFeatureType {
        
        guard let container = selectedContainer where container.featureTypes.count > 0 else {
            return type
        }
        
        if container.featureTypes.contains(type) {
            return type
        } else {
            return container.featureTypes[0]
        }
        
//        selectorViewController.changeToSelector(container.featureTypes[indexPath.item])
    }
    
    // MARK: - Delegate
    // MARK: - ScaleChanged
    func scaleDidChanged(scale: CGFloat) {
        guard
            let selectedIndexPath = selectedIndexPath,
            let container = selectedContainer else {
            return
        }
        
        print("Scale did Changed = \(scale)")
        
        let canvasSize = canvasViewController.view.bounds.size
        container.updateWithScale(
            scale,
            constraintSzie: CGSize(width: canvasSize.width, height: canvasSize.height * 2)
        )
        canvasViewController.updateAt(selectedIndexPath, updateContents: true)
    }
    
    // MARK: - RadianChanged
    func radianDidChanged(radian: CGFloat) {
        guard
            let selectedIndexPath = selectedIndexPath,
            let container = selectedContainer else {
            return
        }
        
        container.radius = radian
        canvasViewController.updateAt(selectedIndexPath, updateContents: false)
    }
    
    // MARK: - Font Changed
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
    
    // MARK: - Alignment Changed
    func alignmentDidChanged(alignment: NSTextAlignment) {
        guard
            let selectedIndexPath = selectedIndexPath,
            let container = selectedContainer as? TextContainerVMProtocol else {
            return
        }
        
        container.updateWithTextAlignment(alignment)
        canvasViewController.updateAt(selectedIndexPath, updateContents: true)
    }
    
    // MARK: - Spacing Changed
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
    
    // MARK: - Color Changed
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
    
    // MARK: - Animation Changed
    func animationDurationDidChanged(t: CGFloat) {
        guard var animation = animation else {
            return
        }
        animation.duration = Float(t)
    }
    
    func animationDelayDidChanged(t: CGFloat) {
        guard var animation = animation else {
            return
        }
        animation.delay = Float(t)
    }
    
    func animationWillBeDeleted(completedBlock:(() -> ())?) {
        
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            
            if let animation = strongSelf.animation, let index = (strongSelf.page.animationBinders.indexOf {$0.iD == animation.iD}) {
                let id = animation.targetiD
                debug_print("animation targetID = \(!id.isEmpty ? id.substringFromIndex(id.endIndex.advancedBy(-4)) : "None") will delete index \(index)", context: animationChangedContext)
                strongSelf.page.removeAnimationAtIndex(index) {
//                    debug_print("animation targetID = \(!id.isEmpty ? id.substringFromIndex(id.endIndex.advancedBy(-4)) : "None") delete completed", context: animationChangedContext)
                    completedBlock?()
                }
            }
        }
    }
    func animationWillBeInserted(a: CTAAnimationName, completedBlock:(() -> ())?) {
        
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let container = strongSelf.selectedContainer {
                
                let a = EditorFactory.generateAnimationFor(container.iD, animationName: a)
                debug_print("animation will add", context: animationChangedContext)
                strongSelf.page.appendAnimation(a) {
                    debug_print("animation add completed", context: animationChangedContext)
                    completedBlock?()
                }
                
            }
        }
    }
    
    func animationWillChanged(a: CTAAnimationName) {
        
        if var animation = animation {
            animation.updateAnimationName(a)
        }
    }
}



