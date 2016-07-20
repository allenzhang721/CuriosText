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
    
    @IBOutlet weak var addView: CTAGradientButtonView!
    private weak var tabViewController: CTATabViewController!
    private weak var canvasViewController: CTACanvasViewController!
    private weak var selectorViewController: CTASelectorsViewController!
    private weak var filter: FilterItem?
    private let filterManager = FilterManager()
    private var selectedIndexPath: NSIndexPath?
    var document: CTADocument!
    var tempValues = TempValues()
    var isFirstAppear: Bool = true
    
    weak var delegate: CTAEditViewControllerDelegate?
    
    private var page: CTAPage {
        get {
            return document.page!
        }
        
        set {
            document.page = newValue
        }
    }
    
    private var useTemplate: Bool = false
    private var originPage: CTAPage?
    private var isHideBar:Bool = false
    private var selectedImageIdentifier: String?
    
    private var selectedContainer: ContainerVMProtocol? {
        guard let selectedIndexPath = selectedIndexPath else { return nil }
        return page.containerVMs[selectedIndexPath.item]
    }
    private var animation: CTAAnimationBinder? {
        guard let container = selectedContainer else {return nil}
        let anis = page.animationBinders.filter{$0.targetiD == container.iD}
        return anis.count > 0 ? anis.first : nil
    }
    
    deinit {
        print("\(#file) deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestures()
        setup()
        
//        view.backgroundColor = CTAStyleKit.ediorBackgroundColor
        
        filterManager.loadDefaultFilters() // load default filters
        
        let cameraVC = UIStoryboard(name: "ImagePicker", bundle: nil).instantiateViewControllerWithIdentifier("ImagePickerViewController") as! ImagePickerViewController
        
        let cleanPage = page.cleanEmptyContainers()
        cameraVC.backgroundHex = cleanPage.backgroundColor
        cameraVC.backgroundColor = UIColor(hexString: cleanPage.backgroundColor)!
        let image = drawPageWithNoImage(cleanPage, containImage: false)
        cameraVC.templateImage = image
        
        cameraVC.didSelectedImageHandler = {[weak self, weak cameraVC] (image, backgrounColor, identifier) in
            if let strongSelf = self, let image = image {
                self?.selectedImageIdentifier = identifier
                let hex = backgrounColor.toHex().0
                strongSelf.page.changeBackColor(hex)
                    strongSelf.insertImage(image, size: image.size)
                self?.selectorViewController.updatePreImage(image)
                self?.filterManager.filters[0..<5].forEach{$0.createData(fromColorDirAt: NSBundle.mainBundle().bundleURL, filtering: image, complation: nil)}
                
                draw(strongSelf.page, atBegan: false, baseURL: strongSelf.document.imagePath, imageAccess: strongSelf.document.resourceImageBy ,local: true) { [weak self] (previewR) in
                    
                    switch previewR {
                    case .Success(let img):
                        dispatch_async(dispatch_get_main_queue(), {
                            self?.selectorViewController.updateSnapshotImage(img)
                        })
                    default:
                        dispatch_async(dispatch_get_main_queue(), {
                            self?.selectorViewController.updateSnapshotImage(image)
                            self?.selectorViewController.updatePreImage(image)
                        })
                    }
                }
                    cameraVC?.removeFromParentViewController()
                    cameraVC?.view.removeFromSuperview()
            }
        }
     
        addChildViewController(cameraVC)
        view.addSubview(cameraVC.view)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.isHideBar = true
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstAppear {
            isFirstAppear = false
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return self.isHideBar
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
            selectorViewController.filterManager = filterManager
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
        let pan = UIPanGestureRecognizer(target: self, action: #selector(EditViewController.pan(_:)))
        canvasViewController.view.addGestureRecognizer(pan)
        
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(EditViewController.rotation(_:)))
        canvasViewController.view.addGestureRecognizer(rotation)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(EditViewController.pinch(_:)))
        canvasViewController.view.addGestureRecognizer(pinch)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(EditViewController.doubleTap(_:)))
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
//        let alert = alert_EditorDismiss{[weak self] in self?.dismissViewControllerAnimated(true, completion: nil)}
//        presentViewController(alert, animated: true, completion: nil)
        
        showPhotos()
    }
    
    @IBAction func publish(sender: AnyObject) {
        showPublishViewController()
    }
    @IBAction func previewAll(sender: AnyObject) {
        
        beganPreviewForAll(true)
        
    }
    
    @IBAction func preview(sender: AnyObject?) {
        
        beganPreviewForAll(false)
        
    }
}

// MARK: - Logics
extension EditViewController {
    
    func beganPreviewForAll(playAll: Bool) {
        
        let animationID: String?
        
        if playAll {
            guard page.animationBinders.count > 0 else {
                return
            }
            animationID = page.animationBinders.first!.iD
        } else {
            guard let animation = animation else {
                return
            }
            animationID = animation.iD
        }
        
        guard let aAnimationID = animationID else {return}
        
        
        guard let preController = UIStoryboard(name: "AniPreView", bundle: nil).instantiateInitialViewController() as? AniPreviewCanvasViewController else { return }
        preController.playAllInAnimaionView = (playAll, selectorViewController.currentType == .Animation)
        let preCanvas = playAll ? page.toAniCanvas() : page.toAniCanvas().aniCanvasByAnimationWith(aAnimationID)
        preController.canvas = preCanvas
        let retriver = {[weak self] (name: String,  handler: (String, UIImage?) -> ()) in
            if let sf = self {
                let data = sf.document.cacheResourceBy(name)
                let image = data == nil ? nil : UIImage(data: data!)
                handler(name, image)
            }
        }
        preController.imageRetriver = retriver
        let v = view.snapshotViewAfterScreenUpdates(true)
        preController.view.insertSubview(v, atIndex: 0)
        
        let center = canvasViewController.view.convertPoint(canvasViewController.view.center, toView: view)
        preController.targetCenter = center
        
        presentViewController(preController, animated: false) {
        }
    }
    
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
    
    func insertImage(s: UIImage, size: CGSize) -> UIImage {
        
        let ID = CTAIDGenerator.fileID()
        let imageName = document.resourcePath + ID + ".jpg"
        let imageData = compressJPGImage(s)
        let name = document.storeResource(imageData, withName: imageName)
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
        
        return UIImage(data: imageData)!
        
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
            
            let centerPosition = CGPoint(x: page.size.width / 2.0, y: page.size.height / 2.0)
            
            let centerDistance = sqrt(pow(centerPosition.x - nextPosition.x, 2) + pow(centerPosition.y - nextPosition.y, 2))
            
            
            let xDistance = fabs(centerPosition.x - nextPosition.x)
            
            let yDistance = fabs(centerPosition.y - nextPosition.y)
            
            let targetPosition: CGPoint
            if centerDistance < 5 {
                targetPosition = centerPosition
            } else if xDistance < 10 {
                targetPosition = CGPoint(x: centerPosition.x, y: nextPosition.y)
            } else if yDistance < 10 {
                targetPosition = CGPoint(x: nextPosition.x, y: centerPosition.y)
            } else {
                targetPosition = nextPosition
            }
            
            container.center = targetPosition
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
            
            let nextRotation: CGFloat
            if tempValues.beganRadian + rotRadian < 0 {
                nextRotation = 2.0 * CGFloat(M_PI) + tempValues.beganRadian + rotRadian
            } else {
                nextRotation = tempValues.beganRadian + rotRadian
            }
            
            let tolerant = 5.0 / 180.0 * CGFloat(M_PI)
//            let tolerant180 = CGFloat(2 * M_PI)
            let target0 = fabs(nextRotation - 0)
            let target45 = fabs(nextRotation - 45.0 / 180.0 * CGFloat(M_PI))
            let target90 = fabs(nextRotation - 90.0 / 180.0 * CGFloat(M_PI))
            let target135 = fabs(nextRotation - 135.0 / 180.0 * CGFloat(M_PI))
            let target180 = fabs(nextRotation - 180.0 / 180.0 * CGFloat(M_PI))
            let target225 = fabs(nextRotation - 225.0 / 180.0 * CGFloat(M_PI))
            let target270 = fabs(nextRotation - 270.0 / 180.0 * CGFloat(M_PI))
            let target315 = fabs(nextRotation - 315.0 / 180.0 * CGFloat(M_PI))
            let target360 = fabs(nextRotation - 360.0 / 180.0 * CGFloat(M_PI))
            
            let targetRotation: CGFloat
            
            if target0 < tolerant {
                targetRotation = 0
            } else if target45 < tolerant {
                targetRotation = 45.0 / 180.0 * CGFloat(M_PI)
            } else if target90 < tolerant {
                targetRotation = 90.0 / 180.0 * CGFloat(M_PI)
            } else if target135 < tolerant {
                targetRotation = 135.0 / 180.0 * CGFloat(M_PI)
            } else if target180 < tolerant {
                targetRotation = 180.0 / 180.0 * CGFloat(M_PI)
            } else if target225 < tolerant {
                targetRotation = (225.0) / 180.0 * CGFloat(M_PI)
            } else if target270 < tolerant {
                targetRotation = (270.0) / 180.0 * CGFloat(M_PI)
            } else if target315 < tolerant {
                targetRotation = (315.0) / 180.0 * CGFloat(M_PI)
            } else if target360 < tolerant {
                targetRotation = (0) / 180.0 * CGFloat(M_PI)
            } else {
                targetRotation = nextRotation
            }
            
            container.radius = targetRotation
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
//            let nextScale = scale * tempValues.beganScale
            let nextScale = max(scale * tempValues.beganScale, 0.2)
            
            if fabs(nextScale * 100.0 - tempValues.oldScale * 100.0) > 0.1 {
                let ascale: CGFloat = floor(nextScale * 100) / 100.0
                let targetScale1 = fabs(ascale - 1)
                
                let targetScale: CGFloat
                if targetScale1 < 0.05 {
                    targetScale = 1.0
                } else {
                    targetScale = ascale
                }
                
                let canvasSize = page.size
                container.updateWithScale(targetScale, constraintSzie: CGSize(width: canvasSize.width, height: canvasSize.height * 5))
                
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
                    (container as! TextContainerVMProtocol).updateWithText(text, constraintSize: CGSize(width: size.width, height: size.height * 2))
                    
                    strongSelf.canvasViewController.updateAt(indexPath, updateContents: true)
                }
            }
            
            presentViewController(textmodifyVC, animated: true, completion: {})
            
        case .Image:
            ()
//            let cameraVC = UIStoryboard(name: "ImagePicker", bundle: nil).instantiateViewControllerWithIdentifier("ImagePickerViewController") as! ImagePickerViewController
//            
//            let cleanPage = page.cleanEmptyContainers()
//            let image = drawPageWithNoImage(cleanPage)
//            cameraVC.templateImage = image
//            cameraVC.backgroundColor = UIColor(hexString: page.backgroundColor)!
//            cameraVC.backgroundHex = page.backgroundColor
//            
//            cameraVC.didSelectedImageHandler = {[weak self] (image, backgroundColor) in
//                if let strongSelf = self {
//                    dispatch_async(dispatch_get_main_queue(), {
//                    let hex = backgroundColor.toHex().0
//                    strongSelf.page.changeBackColor(hex)
//                    strongSelf.canvasViewController.changeBackgroundColor(backgroundColor)
//                    
//                        let canvasSize = strongSelf.canvasViewController.view.bounds.size
//                        (container as! ImageContainerVMProtocol).updateWithImageSize(image!.size, constraintSize: CGSize(width: canvasSize.width, height: canvasSize.height * 2))
//                    
//                    let name = (container as! ImageContainerVMProtocol).imageElement!.resourceName
//                        let data = compressJPGImage(image!)
//                        strongSelf.document.storeResource(data, withName: name)
//                        let image = UIImage(data: data)!
//                        self?.selectorViewController.updatePreImage(image)
//                        
//                        if let f = strongSelf.filter {
//                            if let data = f.data {
//                                f.createImage(from: image, complation: {[weak self, weak f] (img) in
//                                    
//                                    dispatch_async(dispatch_get_main_queue(), {
//                                        f?.data = nil
//                                        self?.document.storeCacheResource(UIImageJPEGRepresentation(img, 1)!, withName: name)
//                                        dispatch_async(dispatch_get_main_queue(), {
//                                            self?.canvasViewController.updateAt(indexPath, updateContents: true)
//                                        })
//                                    })
//                                    })
//                            } else {
//                                let bundle = NSBundle.mainBundle().bundleURL
//                                f.createData(fromColorDirAt: bundle, filtering: image, complation: { [weak self, weak f] (filteredIamge) in
//                                    dispatch_async(dispatch_get_main_queue(), {
//                                        f?.data = nil
//                                        self?.document.storeCacheResource(UIImageJPEGRepresentation(filteredIamge, 1)!, withName: name)
//                                        dispatch_async(dispatch_get_main_queue(), {
//                                            self?.canvasViewController.updateAt(indexPath, updateContents: true)
//                                        })
//                                    })
//                                    })
//                            }
//                        } else {
//                            strongSelf.canvasViewController.updateAt(indexPath, updateContents: true)
//                        }
//                    
//                    draw(strongSelf.page, atBegan: false, baseURL: strongSelf.document.imagePath, imageAccess: strongSelf.document.resourceImageBy ,local: true) { [weak self] (previewR) in
//                        
//                        switch previewR {
//                        case .Success(let img):
//                            dispatch_async(dispatch_get_main_queue(), {
//                                self?.selectorViewController.updateSnapshotImage(img)
//                            })
//                        default:
//                            dispatch_async(dispatch_get_main_queue(), { 
//                                self?.selectorViewController.updateSnapshotImage(image)
//                                self?.selectorViewController.updatePreImage(image)
//                            })
//                        }
//                    }
//                        
//                    })
//                    strongSelf.dismissViewControllerAnimated(false, completion: nil)
//                }
//            }
//            
//            presentViewController(cameraVC, animated: true, completion: {
//                
//            })
            
        default:
            ()
        }
    }
    
    func showPublishViewController() {
        
        let publishViewController = UIStoryboard(name: "Editor", bundle: nil).instantiateViewControllerWithIdentifier("PublishViewController") as! CTAPublishViewController
        
        
        let cleanPage = page.cleanEmptyContainers()
        
        publishViewController.canvas = cleanPage.toAniCanvas()
        publishViewController.publishID = CTADocumentManager.openedDocumentPublishID!
        let retriver = {[weak self] (name: String,  handler: (String, UIImage?) -> ()) in
            if let sf = self {
                let data = sf.document.cacheResourceBy(name)
                let image = data == nil ? nil : UIImage(data: data!)
                handler(name, image)
            }
        }
        publishViewController.imageRetriver = retriver
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
            SVProgressHUD.showProgress(0, status: "\(Int(0 * 100.0))%")
            strongSelf.beganGeneratePublishIconAndPublishWith(cleanPage)
        }
        
        navigationController?.pushViewController(publishViewController, animated: true)

    }
    
    func beganGeneratePublishIconAndPublishWith(aPage: CTAPage) {
        draw(aPage, atBegan: true, baseURL: document.imagePath, imageAccess: document.imageBy ,local: true) { [weak self] (r) in
            guard let strongSelf = self else { return }
            
            switch r {
            case .Success(let image):
                
                draw(aPage, atBegan: false, baseURL: strongSelf.document.imagePath, imageAccess: strongSelf.document.imageBy ,local: true) { [weak self] (previewR) in
                    guard let sf = self else { return }
                    
                    var previewImage: UIImage?
                    var previewName = ""
                    
                    switch previewR {
                    case .Success(let apreviewImage):
                        previewImage = apreviewImage
                    case .Failure():
                        ()
                    }
                    
                    if let p = previewImage {
                        previewName = CTAIDGenerator.fileID() + ".jpg"
                        sf.document.storeResource(compressJPGImage(p, maxWidth: 640.00, needScale: true), withName: previewName)
                    }
                    
                    let publishName = CTAIDGenerator.fileID() + ".jpg"
                    sf.document.storeResource(compressJPGImage(image, maxWidth: 640.00, needScale: true), withName: publishName)
                    
                    sf.document.replaceOriginResourceIfNeed()
                    
                    CTADocumentManager.saveDoucment {[weak self] (success) -> Void in
                        
                        if let strongSelf = self where success {
                            
                            CTADocumentManager.uploadFiles({ (publishID, progress) in
                                SVProgressHUD.showProgress(progress, status: "\(Int(progress * 100.0))%")
                                }, completedBlock: { (success, publishID, publishURL) in
                                    if !success {
                                        dispatch_async(dispatch_get_main_queue(), {
                                            SVProgressHUD.showErrorWithStatus(LocalStrings.PublishFailure.description)
                                        })
                                        
                                        return
                                    }
                                    
                                    let publishIconURL = publishID + "/" + publishName
                                    let previewURL = previewName.isEmpty ? publishIconURL : publishID + "/" + previewName
                                    
                                    CTAPublishDomain().createPublishFile(publishID, userID: CTAUserManager.user!.userID, title: "", publishDesc: "", publishIconURL: publishIconURL, previewIconURL: previewURL, publishURL: publishURL, compelecationBlock: { (domainInfo) -> Void in
                                        
                                        dispatch_async(dispatch_get_main_queue(), {
                                            SVProgressHUD.dismiss()
                                            strongSelf.delegate?.EditControllerDidPublished(strongSelf)
                                            strongSelf.dismissViewControllerAnimated(true, completion: {
                                                
                                            })
                                        })
                                    })
                                    
                            })
                        }
                    }
                    
                }

            default:
                debug_print("Fail", context: defaultContext)
            }
        }
    }
    
    func showPhotos() {
        let cameraVC = UIStoryboard(name: "ImagePicker", bundle: nil).instantiateViewControllerWithIdentifier("ImagePickerViewController") as! ImagePickerViewController
        
        let indexPath = NSIndexPath(forItem: 0, inSection: 0)
        let container = canvasViewController.containerAt(indexPath)
        
        let cleanPage = page.cleanEmptyContainers()
        let image = drawPageWithNoImage(cleanPage)
        cameraVC.templateImage = image
        cameraVC.backgroundColor = UIColor(hexString: page.backgroundColor)!
        cameraVC.backgroundHex = page.backgroundColor
        cameraVC.selectedImageIdentifier = selectedImageIdentifier
        cameraVC.didSelectedImageHandler = {[weak self, weak container, weak cameraVC] (image, backgroundColor, identifier) in
            if let strongSelf = self {
                self?.selectedImageIdentifier = identifier
                dispatch_async(dispatch_get_main_queue(), {[weak cameraVC] in
                    let hex = backgroundColor.toHex().0
                    strongSelf.page.changeBackColor(hex)
                    strongSelf.canvasViewController.changeBackgroundColor(backgroundColor)
                    
                    let canvasSize = strongSelf.page.size //strongSelf.canvasViewController.view.bounds.size
//                    (container as! ImageContainerVMProtocol).updateWithImageSize(image!.size, constraintSize: CGSize(width: canvasSize.width, height: canvasSize.height * 2))
                    (container as! ImageContainerVMProtocol).updateWithImageSize(image!.size, constraintSize: CGSize(width: canvasSize.width, height: canvasSize.height))
                    
                    let name = (container as! ImageContainerVMProtocol).imageElement!.resourceName
                    let data = compressJPGImage(image!)
                    strongSelf.document.storeResource(data, withName: name)
                    let image = UIImage(data: data)!
                    self?.selectorViewController.updatePreImage(image)
                    
                    if let f = strongSelf.filter {
                        if let data = f.data {
                            f.createImage(from: image, complation: {[weak self, weak f] (img) in
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    f?.data = nil
                                    self?.document.storeCacheResource(UIImageJPEGRepresentation(img, 1)!, withName: name)
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self?.canvasViewController.updateAt(indexPath, updateContents: true)
                                    })
                                })
                                })
                        } else {
                            let bundle = NSBundle.mainBundle().bundleURL
                            f.createData(fromColorDirAt: bundle, filtering: image, complation: { [weak self, weak f] (filteredIamge) in
                                dispatch_async(dispatch_get_main_queue(), {
                                    f?.data = nil
                                    self?.document.storeCacheResource(UIImageJPEGRepresentation(filteredIamge, 1)!, withName: name)
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self?.canvasViewController.updateAt(indexPath, updateContents: true)
                                    })
                                })
                                })
                        }
                    } else {
                        strongSelf.canvasViewController.updateAt(indexPath, updateContents: true)
                    }
                    
                    draw(strongSelf.page, atBegan: false, baseURL: strongSelf.document.imagePath, imageAccess: strongSelf.document.resourceImageBy ,local: true) { [weak self, cameraVC] (previewR) in
                        
                        switch previewR {
                        case .Success(let img):
                            dispatch_async(dispatch_get_main_queue(), {
                                self?.selectorViewController.updateSnapshotImage(img)
                                UIView.animateWithDuration(0.3, animations: {[weak cameraVC] in
                                    cameraVC?.view.alpha = 0
                                    }, completion: {[weak cameraVC] (success) in
                                        cameraVC?.view.removeFromSuperview()
                                        cameraVC?.removeFromParentViewController()
                                    })
                            })
                        default:
                            dispatch_async(dispatch_get_main_queue(), {
                                self?.selectorViewController.updateSnapshotImage(image)
                                self?.selectorViewController.updatePreImage(image)
                                
                                
                                UIView.animateWithDuration(0.3, animations: {[weak cameraVC] in
                                    cameraVC?.view.alpha = 0
                                    }, completion: {[weak cameraVC] (success) in
                                        cameraVC?.view.removeFromSuperview()
                                        cameraVC?.removeFromParentViewController()
                                    })
                            })
                        }
                    }
                    
                })
            }
        }
        
        addChildViewController(cameraVC)
        view.addSubview(cameraVC.view)
        cameraVC.view.alpha = 0
        UIView.animateWithDuration(0.3) {[weak cameraVC] in
            cameraVC?.view.alpha = 1
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
        let hadSelected = selectedContainer != nil ? true : false
        let preType = selectorViewController.currentType
        let preCon = selectedContainer?.type
        selectedIndexPath = indexPath
        let nextCon = selectedContainer?.type
        if (preCon != nextCon) { // need update tab
           let nextIndex = selectedContainer?.featureTypes.indexOf(preType) ?? 0
            tabViewController.refreshItemIfNeed()
            
            if let attri = self.tabViewController.collectionView.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: nextIndex, inSection: 0)) {
                let cener = attri.center
                tabViewController.changingContainer = hadSelected ? true : false
                self.tabViewController.collectionView.setContentOffset(CGPoint(x: cener.x - self.tabViewController.collectionView.bounds.width / 2.0, y: 0), animated: false)
                dispatch_async(dispatch_get_main_queue(), {[weak self] in
                    self?.tabViewController.changingContainer = false
                    
                })
            }
        }
        
        selectorViewController.updateSelector()
    }
    
    func canvasViewControllerWillDeleted(viewController: CTACanvasViewController) {
        
        guard let aselectedIndexPath = selectedIndexPath else { return }
        
        let next = aselectedIndexPath.item > 0 ? aselectedIndexPath.item - 1 : 0
        selectedIndexPath = nil
        canvasViewController.showOverlayAndSelectedAt(NSIndexPath(forItem: next, inSection: 0))
        page.removeAt(aselectedIndexPath.item)
        canvasViewController.removeAt(aselectedIndexPath)
    }
}

// MARK: - CTASelectorsViewController
extension EditViewController: CTASelectorsViewControllerDataSource, CTASelectorViewControllerDelegate {
    
    func animationWillPlay() {
        preview(nil)
    }
    
    // MARK: - DataSource
    func selectorsViewControllerContainer(viewcontroller: CTASelectorsViewController) -> ContainerVMProtocol? {
        return selectedContainer
    }
    
    func selectorsViewControllerAnimation(ViewController: CTASelectorsViewController) -> CTAAnimationBinder? {
        
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
    }
    
    // MARK: - Delegate
    // MARK: - ScaleChanged
    func scaleDidChanged(scale: CGFloat) {
        guard
            let selectedIndexPath = selectedIndexPath,
            let container = selectedContainer else {
            return
        }
        
        let canvasSize = page.size
        container.updateWithScale(
            scale,
            constraintSzie: CGSize(width: canvasSize.width, height: canvasSize.height * 5)
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
        
        
        if radian <= 0 {
            aradian = CGFloat(2 * M_PI) - fabs(radian) % CGFloat(2 * M_PI)
        } else if radian >= CGFloat(2 * M_PI) {
            aradian = radian - CGFloat(2 * M_PI)
        }else {
            aradian = radian
        }
        debug_print("aradian = " + "\(aradian)")
        container.radius = aradian
        canvasViewController.updateAt(selectedIndexPath, updateContents: false)
    }
    
    // MARK: - Font Changed
    func fontDidChanged(fontFamily: String, fontName: String) {
        guard
            let selectedIndexPath = selectedIndexPath,
            let container = selectedContainer as? TextContainerVMProtocol else {
            return
        }
        
        let canvasSize = page.size
        container.updateWithFontFamily(
            fontFamily,
            FontName: fontName,
            constraintSize: CGSize(width: canvasSize.width, height: canvasSize.height * 5)
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
        container.updatewithNeedShadow(true, needStroke: false)
        canvasViewController.updateAt(selectedIndexPath, updateContents: true)
    }
    
    // MARK: - Shadow and Stroke Changed
    func shadowAndStrokeDidChanged(needShadow: Bool, needStroke: Bool) {
        guard
            let selectedIndexPath = selectedIndexPath,
            let container = selectedContainer as? TextContainerVMProtocol else {
                return
        }
        
        container.updatewithNeedShadow(needShadow, needStroke: needStroke)
        canvasViewController.updateAt(selectedIndexPath, updateContents: true)
    }
    
    // MARK: - Spacing Changed
    func spacingDidChanged(lineSpacing: CGFloat, textSpacing: CGFloat) {
        guard
            let selectedIndexPath = selectedIndexPath,
            let container = selectedContainer as? TextContainerVMProtocol else {
            return
        }
        
        let canvasSize = page.size
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
    
    // MARK: - template Changed
    func templateDidChanged(pageData: NSData?, origin: Bool) {
        if origin == false {
            if useTemplate == false {
                originPage = CTAPage(containers: page.containers, anis: page.animatoins)
                originPage?.changeBackColor(page.backgroundColor)
                useTemplate = true
            }
            if let data = pageData, let apage = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? CTAPage {
                apage.removeLastImageContainer()
                page.replaceBy(template: apage)
//                canvasViewController.changeBackgroundColor(UIColor(hexString: apage.backgroundColor)!)

            dispatch_async(dispatch_get_main_queue(), {[weak self] in
                self?.beganPreviewForAll(true)
                dispatch_async(dispatch_get_main_queue(), {
                    self?.canvasViewController.reloadSection()
                    self?.canvasViewController.setSelectedItemAt(indexPath: NSIndexPath(forItem: 0, inSection: 0))
                })
            })
            }
        } else {
            if useTemplate == true {
                useTemplate = false
                if let apage = originPage {
                    page.changeBackColor(apage.backgroundColor)
                    page.replaceBy(containers: apage.containers, animations: apage.animatoins)
                    canvasViewController.changeBackgroundColor(UIColor(hexString: apage.backgroundColor)!)
                    canvasViewController.reloadSection()
                    
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.canvasViewController.setSelectedItemAt(indexPath: NSIndexPath(forItem: 0, inSection: 0))
                    })
                }
            }
            print("Origin")
        }
    }
    
    // MARK: - Filter Changed
    func filterDidChanged(filterName: String) {
        if let filter = (filterManager.filters.filter{$0.name == filterName}).first {
            self.filter = filter
            guard
                let selectedIndexPath = selectedIndexPath,
                let container = selectedContainer as? ImageContainerVMProtocol,
                let imgElement = container.imageElement,
            let imageData = document.resourceBy(imgElement.resourceName),
            let image = UIImage(data:imageData) else {
                    return
            }
            let name = imgElement.resourceName
//            filter.createImage(from: image, complation: {[weak self] (filteredImage) in
//                self?.document.storeCacheResource(UIImageJPEGRepresentation(filteredImage, 1)!, withName: name)
//                dispatch_async(dispatch_get_main_queue(), { 
//                    self?.canvasViewController.updateAt(selectedIndexPath, updateContents: true)
//                })
//            })
            
            if let data = filter.data {
                    filter.createImage(from: image, complation: {[weak self, weak filter] (img) in
                        
                        dispatch_async(dispatch_get_main_queue(), {
                                filter?.data = nil
                            self?.document.storeCacheResource(UIImageJPEGRepresentation(img, 1)!, withName: name)
                            dispatch_async(dispatch_get_main_queue(), {
                                self?.canvasViewController.updateAt(selectedIndexPath, updateContents: true)
                            })
                        })
                        })
            } else {
                let bundle = NSBundle.mainBundle().bundleURL
                    filter.createData(fromColorDirAt: bundle, filtering: image, complation: { [weak self, weak filter] (filteredIamge) in
                        dispatch_async(dispatch_get_main_queue(), {
                                filter?.data = nil
                            self?.document.storeCacheResource(UIImageJPEGRepresentation(filteredIamge, 1)!, withName: name)
                            dispatch_async(dispatch_get_main_queue(), {
                                self?.canvasViewController.updateAt(selectedIndexPath, updateContents: true)
                            })
                        })
                        })
            }
            
        } else {
            self.filter = nil
        }
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
            
                strongSelf.page.appendAnimation(a) {
                
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



