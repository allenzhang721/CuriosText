//
//  EditViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/23/15.
//  Copyright © 2015 botai. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol CTAEditViewControllerDelegate: class {
    
    func EditControllerDidPublished(viewController: EditViewController)
}

class EditViewController: UIViewController {
    
    struct TempValues {
        var beganPosition = CGPoint.zero
        var beganRadian: CGFloat = 0
        var beganScale: CGFloat = 0
        var oldScale: CGFloat = 0
    }
    
    @IBOutlet weak var addView: CTAEditAddView!
    private var tabViewController: CTATabViewController!
    private var canvasViewController: CTACanvasViewController!
    private var selectorViewController: CTASelectorsViewController!
    private var selectedIndexPath: NSIndexPath?
    var document: CTADocument!
    var tempValues = TempValues()
    var isFirstAppear: Bool = true
    
    weak var delegate: CTAEditViewControllerDelegate?
    
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
        
        view.backgroundColor = CTAStyleKit.ediorBackgroundColor
        
        let cameraVC = UIStoryboard(name: "ImagePicker", bundle: nil).instantiateViewControllerWithIdentifier("ImagePickerViewController") as! ImagePickerViewController
        
        cameraVC.didSelectedImageHandler = {[weak self] image in
            if let strongSelf = self, let image = image {
//                dispatch_async(dispatch_get_main_queue(), { 
                
                    
                    strongSelf.insertImage(image, size: image.size)
                    cameraVC.removeFromParentViewController()
                    cameraVC.view.removeFromSuperview()
//                })
            }
        }
     
        addChildViewController(cameraVC)
        view.addSubview(cameraVC.view)
    }
    
    override func viewDidAppear(animated: Bool) {
        if isFirstAppear {
            isFirstAppear = false
            
            
        }
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
    
    // MARK: - Style
    func setup() {
        addView.didClickHandler = {[weak self] in
            
            if let strongSelf = self {
                strongSelf.addText()
            }
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
    
    func pan(sender: UIPanGestureRecognizer) {
        guard let selectedIndexPath = selectedIndexPath, let container = selectedContainer else { return }
        
        move(container, atIndexPath: selectedIndexPath, by: sender)
    }
    
    func rotation(sender: UIRotationGestureRecognizer) {
        guard let selectedIndexPath = selectedIndexPath, let container = selectedContainer else { return }
        
        rotate(container, atIndexPath: selectedIndexPath, by: sender)
    }
    
    func pinch(sender: UIPinchGestureRecognizer) {
        guard let selectedIndexPath = selectedIndexPath, let container = selectedContainer else { return }
        
        resize(container, atIndexPath: selectedIndexPath, by: sender)
    }
    
    func doubleTap(sender: UITapGestureRecognizer) {
        guard let selectedIndexPath = selectedIndexPath, let container = selectedContainer else { return }
        
        showModifyViewControllerWith(container, atIndexPath: selectedIndexPath)
    }
}

// MARK: - Actions 
extension EditViewController {
    
    @IBAction func cancelAction(sender: AnyObject) {
        let alert = alert_EditorDismiss{[weak self] in self?.dismissViewControllerAnimated(true, completion: nil)}
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func publish(sender: AnyObject) {
        showPublishViewController()
    }
    
    @IBAction func preview(sender: AnyObject) {
        
        guard let preController = UIStoryboard(name: "AniPreView", bundle: nil).instantiateInitialViewController() as? AniPreviewCanvasViewController else { return }
        
        preController.canvas = page.toAniCanvas()
        
        presentViewController(preController, animated: true, completion: nil)
    }
}

// MARK: - Logics
extension EditViewController {
    
    func selectBottomContainer() {
        if page.containers.count > 0 {
            canvasViewController.selectAt(NSIndexPath(forItem: 0, inSection: 0))
        }
    }
    
    func selectTopContainer() {
        let count = page.containers.count
        if count > 0 {
            canvasViewController.selectAt(NSIndexPath(forItem: count - 1, inSection: 0))
        }
    }
    
    func insertImage(s: UIImage, size: CGSize) {
        
        let ID = CTAIDGenerator.fileID()
        let imageName = document.resourcePath + ID + ".jpg"
        
        let name = document.storeResource(compressJPGImage(s), withName: imageName)
        let imgContainer = EditorFactory.generateImageContainer(page.width, pageHeigh: page.height, imageSize: size, imgName: name)
        
        page.insert(imgContainer, atIndex: 0)
        
        
//        CATransaction.begin()
//        CATransaction.setDisableActions(true)
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            if let strongSelf = self {
                strongSelf.canvasViewController.reloadSection()
                strongSelf.selectBottomContainer()
            }
            
//           self.canvasViewController.insertAt(NSIndexPath(forItem: 0, inSection: 0))
            
        }
        
//        CATransaction.commit()
    }
    
    func addImage(s: UIImage, size: CGSize) {
        
        let ID = CTAIDGenerator.fileID()
        let imageName = document.resourcePath + ID + ".jpg"
        
        let name = document.storeResource(compressJPGImage(s), withName: imageName)
        let imgContainer = EditorFactory.generateImageContainer(page.width, pageHeigh: page.height, imageSize: size, imgName: name)
        
        page.append(imgContainer)
        let count = page.containers.count
        dispatch_async(dispatch_get_main_queue()) {
            self.canvasViewController.insertAt(NSIndexPath(forItem: count - 1, inSection: 0))
        }
    }
    
    func addText(s: String = "") {
        
        let textContainer = EditorFactory.generateTextContainer(page.width, pageHeigh: page.height, text:s)
        
        page.append(textContainer)
        let count = page.containers.count
        
        page.containers.forEach{debug_print($0.type, context: defaultContext)}
        
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            if let strongSelf = self {
                strongSelf.canvasViewController.insertAt(NSIndexPath(forItem: count - 1, inSection: 0))
                strongSelf.selectTopContainer()
//                strongSelf.showTopContainerModifyViewController()
            }
        }
    }
    
    func move(container: ContainerVMProtocol, atIndexPath indexPath: NSIndexPath, by sender: UIPanGestureRecognizer) {
        
        let translation = sender.translationInView(sender.view)
        
        switch sender.state {
        case .Began:
            tempValues.beganPosition = container.center
        case .Changed:
            let beganPosition = tempValues.beganPosition
            let nextPosition = CGPoint(x: beganPosition.x + translation.x, y: beganPosition.y + translation.y)
            container.center = nextPosition
            canvasViewController.updateAt(indexPath)
            
        case .Ended:
            ()
        default:
            ()
        }
    }
    
    func rotate(container: ContainerVMProtocol, atIndexPath indexPath: NSIndexPath, by sender: UIRotationGestureRecognizer) {
        let rotRadian = sender.rotation
        
        switch sender.state {
        case .Began:
            tempValues.beganRadian = CGFloat(container.radius)
            
        case .Changed:
            let nextRotation = tempValues.beganRadian + rotRadian
            container.radius = nextRotation
            canvasViewController.updateAt(indexPath)
            selectorViewController.updateIfNeed()
            
        case .Ended:
            ()
            
        default:
            ()
        }
    }
    
    func resize(container: ContainerVMProtocol, atIndexPath indexPath: NSIndexPath, by sender: UIPinchGestureRecognizer) {
        
        let scale = sender.scale
        
        switch sender.state {
        case .Began:
            tempValues.beganScale = container.scale
            tempValues.oldScale = container.scale
            
        case .Changed:
            let nextScale = scale * tempValues.beganScale
            
            if fabs(nextScale * 100.0 - tempValues.oldScale * 100.0) > 0.1 {
                let ascale = floor(nextScale * 100) / 100.0
                let canvasSize = page.size
                container.updateWithScale(ascale, constraintSzie: CGSize(width: canvasSize.width, height: canvasSize.height * 2))
                
                canvasViewController.updateAt(indexPath, updateContents: true)
                selectorViewController.updateIfNeed()
            }
            
        case .Ended:
            ()
        default:
            ()
        }
    }
    
    func showTopContainerModifyViewController() {
        guard let topContainer = page.containerVMs.last else {
            return
        }
        
        let indexPath = NSIndexPath(forItem: page.containerVMs.count - 1, inSection: 0)
        showModifyViewControllerWith(topContainer, atIndexPath: indexPath)
    }
    
    func showModifyViewControllerWith(container: ContainerVMProtocol, atIndexPath indexPath: NSIndexPath) {
        
        switch container.type {
            
        case .Text:
            let textmodifyVC = UIStoryboard(name: "Editor", bundle: nil).instantiateViewControllerWithIdentifier("TextModifyViewController") as! CTATextModifyViewController
            let textElement = (container as! TextContainerVMProtocol).textElement!
            textmodifyVC.beganWith(textElement.isEmpty ? "" : textElement.texts, attributes: textElement.textAttributes)
            
            textmodifyVC.textModifyDidCompletion = {[weak self] text in
                
                if let strongSelf = self {
                    let size = strongSelf.page.size
//                    let canvasSize = strongSelf.canvasViewController.view.bounds.size
                    (container as! TextContainerVMProtocol).updateWithText(text, constraintSize: CGSize(width: size.width, height: size.height * 2))
                    
                    strongSelf.canvasViewController.updateAt(indexPath, updateContents: true)
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
                        
                        
                        strongSelf.canvasViewController.updateAt(indexPath, updateContents: true)
                    })
                }
            }
            
            presentViewController(cameraVC, animated: true, completion: {
                
            })
            
        default:
            ()
        }
    }
    
    func showPublishViewController() {
        
        let publishViewController = UIStoryboard(name: "Editor", bundle: nil).instantiateViewControllerWithIdentifier("PublishViewController") as! CTAPublishViewController
        
        
        let cleanPage = page.cleanEmptyContainers()
        publishViewController.page = cleanPage
//        publishViewController.publishID = document.documentName
        publishViewController.baseURL = document.imagePath
        publishViewController.imageAccess = document.accessImage
        publishViewController.publishDismiss = { [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.navigationController?.popViewControllerAnimated(true)
        }
        
        publishViewController.publishWillBegan = { [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.beganGeneratePublishIconAndPublishWith(cleanPage)
        }
        
        navigationController?.pushViewController(publishViewController, animated: true)

    }
    
    func beganGeneratePublishIconAndPublishWith(aPage: CTAPage) {
        
        draw(aPage, atBegan: true, baseURL: document.imagePath, imageAccess: document.imageBy ,local: true) { [weak self] (r) in
            guard let strongSelf = self else { return }
            
            switch r {
            case .Success(let image):
                let publishName = CTAIDGenerator.fileID() + ".jpg"
                strongSelf.document.storeResource(compressJPGImage(image), withName: publishName)
                
                CTADocumentManager.saveDoucment {[weak self] (success) -> Void in
                    
                    if let strongSelf = self where success {
                        
                        CTADocumentManager.uploadFiles({ (success, publishID, publishURL) -> Void in
                            
                            if !success {
                                dispatch_async(dispatch_get_main_queue(), { 
                                    SVProgressHUD.showErrorWithStatus(LocalStrings.PublishFailure.description)
                                })
                                
                                return
                            }
                            
                            debug_print("upload = \(success)\n publishID = \(publishID)", context: previewConttext)
                            
                            let publishIconURL = publishID + "/" + publishName
                            
                            CTAPublishDomain().createPublishFile(publishID, userID: CTAUserManager.user!.userID, title: "", publishDesc: "", publishIconURL: publishIconURL, previewIconURL: "", publishURL: publishURL, compelecationBlock: { (domainInfo) -> Void in
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    strongSelf.delegate?.EditControllerDidPublished(strongSelf)
                                    strongSelf.dismissViewControllerAnimated(true, completion: {
                                        
                                    })
                                })
                            })
                        })
                    }
                }
                
            default:
                debug_print("Fail", context: defaultContext)
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
        return page.containers.count
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
    
    func canvasViewControllerWillDeleted(viewController: CTACanvasViewController) {
        
        guard let aselectedIndexPath = selectedIndexPath else {
            return
        }
        
        
        
       
        let next = aselectedIndexPath.item > 0 ? aselectedIndexPath.item - 1 : 0
        
        
        let preType = selectorViewController.currentType
        let currentCon = selectedContainer?.type
        selectedIndexPath = NSIndexPath(forItem: next, inSection: 0)
        let nextCon = selectedContainer?.type
        
        if (currentCon != nextCon) { // need update tab
            let nextIndex = selectedContainer?.featureTypes.indexOf(preType) ?? 0
            tabViewController.collectionView.reloadData()
            
            if let attri = self.tabViewController.collectionView.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: nextIndex, inSection: 0)) {
                let cener = attri.center
                self.tabViewController.collectionView.setContentOffset(CGPoint(x: cener.x - self.tabViewController.collectionView.bounds.width / 2.0, y: 0), animated: false)
            }
        }
        
        selectorViewController.updateSelector()
        
        
        page.removeAt(aselectedIndexPath.item)
        canvasViewController.removeAt(aselectedIndexPath)
        
        
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
        
        let canvasSize = page.size
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
        let aradian: CGFloat
        if radian < 0 {
            aradian = CGFloat(2 * M_PI) - fabs(radian) % CGFloat(2 * M_PI)
        } else {
            aradian = radian
        }
        
        container.radius = aradian % CGFloat(2 * M_PI)
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



