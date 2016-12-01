//
//  CTAPhotoViewController.swift
//  ImagePickerApp
//
//  Created by Emiaostein on 2/29/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import UIKit
import Photos

class CTAPhotoViewController: UIViewController, CTAPhotoPickerDelegate, CTAPhotoPickerTemplateable {
    
    struct CTAPhotoThumbnailLayoutAttributes {
        let itemSize: CGSize
        let itemSpacing: CGFloat
        let lineSpacing: CGFloat
        let edgeInsets: UIEdgeInsets
    }
    
    struct Inner {
        // asset cache
        let imageManager = PHCachingImageManager()
        var previousPreheatRect = CGRect.zero
        
        // asset
        var assetFetchResults: PHFetchResult<PHAsset>?
        var assetCollection: PHAssetCollection?
        
        // layout
        var layoutAttributes: CTAPhotoThumbnailLayoutAttributes?
        
        // status
        var accessPhotoEnable = false
        var oldSelectedIndexPath: IndexPath?
        
        // preview scroll
        var beganPosition = CGPoint.zero
        let originTopConstraintCostant: CGFloat = 44
        var topConstraintTargetScrollDistance: CGFloat = 250
        let triggScrollDistance: CGFloat = 50
        
        // scroll by scrollView
        var beganScrollPanPosition: CGPoint? = nil
//        let triggerScrollPanPosition = CGPoint.zero
        
        var showAlbums = false
    }
    
    @IBOutlet weak var zoomButton: UIButton!
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var cancelItem: UIBarButtonItem!
    @IBOutlet weak var nextItem: UIBarButtonItem!
    @IBOutlet weak var titleItem: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var titleLabel: UIButton!
    @IBOutlet weak var accessView: UIView!
    @IBOutlet weak var thumbCollectionView: UICollectionView!
    @IBOutlet weak var previewView: CTAPhotoPreviewView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var photolistViewController: CTAPhotoAlbumListViewController?
    
    var templateImage: UIImage?
    var backgroundColor: UIColor = UIColor.white
    var backgroundColorHex: String = "FFFFFF"
    var selectedImageIdentifier: String? = nil
    var beganIndex: Int?
    
    weak var pickerDelegate: CTAPhotoPickerProtocol?
    fileprivate var inner = Inner()

    override func awakeFromNib() {
        super.awakeFromNib()
        resetCacheSets()
        
        let selectedImage = ImagePickerResource.imageOfPhotoLibrarySelected.withRenderingMode(.alwaysOriginal)
        let normalImage = ImagePickerResource.imageOfPhotoLibrary.withRenderingMode(.alwaysOriginal)
        
        
        self.tabBarItem = UITabBarItem(title: LocalStrings.photo.description, image: normalImage, selectedImage: selectedImage)
    }
    
    deinit {
        debug_print("\(#file) deinit", context: deinitContext)
        resetCacheSets()
    }
    
    //    private var thumbnailSize
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accessView.isHidden = true
        
        checkLibraryStatus {[weak self] (success) in
            DispatchQueue.main.async(execute: {
                guard let Strongself = self else { return }
                Strongself.inner.accessPhotoEnable = success
                if success {
                    Strongself.setup()
                } else {
                    Strongself.accessView.isHidden = false
                }
            })
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        previewView.templateImageView.image = templateImage
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        caculateLayoutAttributes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        updateCacheSets()
        
//        previewView.templateImage = templateImage
    }
    
    fileprivate func fetchBeganPhoto() {
        if let beganIndex = beganIndex {
            thumbCollectionView.selectItem(at: IndexPath(item: beganIndex, section: 0), animated: false, scrollPosition: .top)
            
            if let assetFetchResults = inner.assetFetchResults, assetFetchResults.count > 0, let asset = assetFetchResults[beganIndex] as? PHAsset {
                
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                inner.imageManager.requestImage(for: asset, targetSize: previewView.bounds.size, contentMode: .aspectFill, options: options) {[weak self] (image, info) in
                    
                    if let strongSelf = self, let image = image {
                        DispatchQueue.main.async(execute: {
                            strongSelf.previewView.image = image
                        })
                    }
                }
            }
        } else {
            fetchPreviewPhoto()
        }
    }
    
    func changePhotoAlbum(_ fetchResult: PHFetchResult<PHAsset>) {
        inner.assetFetchResults = fetchResult
        thumbCollectionView.reloadData()
        fetchPreviewPhoto()
    }
}

// MARK: - Setup
extension CTAPhotoViewController {
    
    fileprivate func setup() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CTAPhotoViewController.tap(_:)))
        previewView.addGestureRecognizer(tap)
        
        previewView.backgroundColor = backgroundColor
        
        zoomButton.isSelected = true
        previewView.didChangedHandler = {[weak self] scaledToMax in
            guard let sf = self else {return}
            sf.zoomButton.isSelected = scaledToMax
        }
        
        setupDelegateAndDataSource()
        fetchAllPhotos()
        fetchBeganPhoto()
    }
    
    fileprivate func setupDelegateAndDataSource() {
        thumbCollectionView.delegate = self
        thumbCollectionView.dataSource = self
        thumbCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    fileprivate func fetchAllPhotos() { // fetch Photo Assets
        // 1. fetch options
        let allPhotos = PHFetchOptions()
        let dateSortDescritor = NSSortDescriptor(key: "modificationDate", ascending: false)
        allPhotos.sortDescriptors = [dateSortDescritor]
        
        // 2. fetch result and collection
         let result = PHAsset.fetchAssets(with: allPhotos)
        guard result.count > 0 else {return}
//        let collection = result[0] as? PHAssetCollection
        inner.assetFetchResults = result
//        inner.assetCollection = collection
      
        if let ID = selectedImageIdentifier {
            result.enumerateObjects({[weak self] (asset, i, stop) in
                if let asset = asset as? PHAsset, asset.localIdentifier == ID {
                    self?.beganIndex = i
                    stop.pointee = true
                }
            })
        }
    }
    
    fileprivate func fetchPreviewPhoto() {
        if let assetFetchResults = inner.assetFetchResults, assetFetchResults.count > 0, let asset = assetFetchResults[0] as? PHAsset {
            
            thumbCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionViewScrollPosition())
            
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            inner.imageManager.requestImage(for: asset, targetSize: previewView.bounds.size, contentMode: .aspectFill, options: options) {[weak self] (image, info) in
                
                if let strongSelf = self, let image = image {
                    DispatchQueue.main.async(execute: {
                        strongSelf.previewView.image = image
                    })
                }
            }
        }
    }
    
    fileprivate func arrowFlipTo(_ up: Bool) {
        if up {
            UIView.animate(withDuration: 0.2, animations: {
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            })
            
        } else {
            UIView.animate(withDuration: 0.2, animations: { 
                self.arrowImageView.transform = CGAffineTransform.identity
            })
            
        }
    }
    
    fileprivate func showBarItems(_ show: Bool) {
        if show {
//            cancelItem.image = UIImage(named: "close-button")
            nextItem.image = UIImage(named: "next-button")
        } else {
//            cancelItem.image = nil
            nextItem.image = nil
        }
    }
}


// MARK: - Action
extension CTAPhotoViewController {
    
    @IBAction func changeBackgroundColor(_ sender: AnyObject) {
        if backgroundColorHex == "FFFFFF" || backgroundColorHex == "#FFFFFF" {
            backgroundColorHex = "000000"
            backgroundButton.isSelected = true
        } else {
            backgroundColorHex = "FFFFFF"
            backgroundButton.isSelected = false
        }
        
        backgroundColor = UIColor(hexString: backgroundColorHex)!
        previewView.backgroundColor = backgroundColor
    }
    
    @IBAction func changeScale(_ sender: AnyObject?) {
        previewView.changeScale()
    }
    
    @IBAction func changeAlbumClick(_ sender: AnyObject?) {
        
        if photolistViewController == nil {
            let vc = UIStoryboard(name: "PhotoAlbumList", bundle: nil).instantiateInitialViewController() as! CTAPhotoAlbumListViewController
            vc.view.frame = CGRect(x: 0, y: 44, width: view.bounds.width, height: view.bounds.height - 44)
            
            tabBarController!.addChildViewController(vc)
            tabBarController?.view.addSubview(vc.view)
            
            photolistViewController = vc
        }
        
        guard let vc = photolistViewController else { return }
        
        
        
        if !inner.showAlbums {
            inner.showAlbums = true
            
            vc.didSelectedHandler = {[weak self] (assetsResult, title) in
                self?.inner.showAlbums = false
                self?.arrowFlipTo(false)
                self?.showBarItems(true)
                self?.changePhotoAlbum(assetsResult! as! PHFetchResult<PHAsset>)
                DispatchQueue.main.async(execute: {
                    self?.titleLabel.setTitle(title, for: UIControlState())
                    UIView.animate(withDuration: 0.2, animations: {
                        vc.view.transform = CGAffineTransform(translationX: 0, y: self!.view.bounds.height - 44)
                    }) 
                    
                })
            }
            arrowFlipTo(true)
            showBarItems(false)
            vc.view.transform = CGAffineTransform(translationX: 0, y: view.bounds.height - 44)
            
            UIView.animate(withDuration: 0.3, animations: {
                vc.view.transform = CGAffineTransform.identity
            }) 
        } else {
            inner.showAlbums = false
            arrowFlipTo(false)
            showBarItems(true)
            vc.didSelectedHandler = nil
            UIView.animate(withDuration: 0.2, animations: {
                vc.view.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height - 44)
            }) 
        }
        
        
        
        
        
    }
    
    @IBAction func accessClick(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    func tap(_ sener: UITapGestureRecognizer) {
        let location = sener.location(in: previewView)
        let ignoreRect = previewView.ignoreRect
        if ignoreRect.contains(location) {
            let trigdistance = inner.triggScrollDistance
            previewScroll(.end(translation: trigdistance))
        }
    }
    
    @IBAction func pan(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        switch sender.state {
        case .began:
            inner.beganPosition = sender.location(in: view)
            
        case .changed:
            previewScroll(.scroll(deltaY: translation.y))
            
        case .ended, .cancelled:
            let position = sender.location(in: view)
            let offset = position.y - inner.beganPosition.y
            previewScroll(.end(translation: offset))
            
        default:
            ()
        }
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    @IBAction func dismiss(_ sender: AnyObject?) {
        
        if inner.showAlbums {
            changeAlbumClick(nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func confirm(_ sender: AnyObject) {
        
        if let items = thumbCollectionView.indexPathsForSelectedItems, items.count > 0, let asset = inner.assetFetchResults?[items.first!.item] {
            
            let localIdentifier = asset.localIdentifier
            let option = PHImageRequestOptions()
            option.isSynchronous = true
            let imageDisplayRect = previewView.imgDisplayRect
            
            inner.imageManager.requestImage(for: asset, targetSize: previewView.bounds.size, contentMode: .aspectFill, options: option, resultHandler: {[weak self] (image, info) in
                
                if let strongSelf = self {
                    if let image = image {
                        let imageScale = image.scale//UIScreen.mainScreen().scale
                        let displaySize = imageDisplayRect.size
                        let newSize = CGSize(width: displaySize.width*imageScale, height: displaySize.height*imageScale)
                        let origin = CGPoint(x: -imageDisplayRect.minX * imageScale, y: -imageDisplayRect.minY * imageScale)
                        UIGraphicsBeginImageContextWithOptions(newSize, true, 1)
                        
//                        let drawRect = CGRect(x: origin.x, y: origin.y, width: newSize.width, height: newSize.width)
//                        image.drawInRect(drawRect)
                        image.draw(at: origin)
                        let aimage = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                        
                        DispatchQueue.main.async(execute: {
                            strongSelf.pickerDelegate?.pickerDidSelectedImage(aimage!, backgroundColor: strongSelf.backgroundColor, identifier: localIdentifier)
//                            strongSelf.dismiss(nil)
                        })
                    }
                    //                    strongSelf.dismiss(nil)
                }
                })
        }
    }
}

// MARK: - Logics
extension CTAPhotoViewController {
    
    // MARK: - Preview Scroll
    enum PreviewStatus {
        case scroll(deltaY: CGFloat)
        case scrollByTranslation(translation: CGFloat)
        case end(translation: CGFloat)
    }
    func previewScroll(_ status: PreviewStatus, compeletedHandler:(() -> ())? = nil) {
        
        let originConstant = inner.originTopConstraintCostant
        let distance = inner.topConstraintTargetScrollDistance
        let triggerDistance = inner.triggScrollDistance
        switch status {
        case .scroll(let deltaY):
            if topConstraint.constant < originConstant {
                topConstraint.constant += deltaY
                view.layoutIfNeeded()
            } else {
                if deltaY < 0 {
                    topConstraint.constant += deltaY
                    view.layoutIfNeeded()
                }
            }
            
        case .scrollByTranslation(let translation):
            if topConstraint.constant < originConstant {
                topConstraint.constant = translation
                view.layoutIfNeeded()
            } else {
                if translation < 0 {
                    topConstraint.constant = translation
                    view.layoutIfNeeded()
                }
            }
            
        case .end(let translationY):
            if topConstraint.constant < originConstant {
                topConstraint.constant = (translationY <= originConstant) ? -distance : (translationY >= triggerDistance) ? originConstant : -distance
            } else {
                topConstraint.constant = (translationY <= -triggerDistance) ? -distance : originConstant
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                }, completion: { finished in
                    if finished {
                        compeletedHandler?()
                    }
            })
        }
    }
    
    // MARK: - Authorzied Status
    fileprivate func checkLibraryStatus(_ completed: ((Bool) -> ())?) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completed?(true)
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (requestedStatus) in
                if requestedStatus == .authorized {
                    completed?(true)
                } else {
                    completed?(false)
                }
            })
            
        case .denied, .restricted:
            completed?(false)
        }
    }
    
    // MARK: - Assets
    fileprivate func resetCacheSets() {
        if inner.accessPhotoEnable {
            inner.imageManager.stopCachingImagesForAllAssets()
        }
        inner.previousPreheatRect = CGRect.zero
    }
    
    fileprivate func updateCacheSets() {
        guard isViewLoaded && view.window != nil else { return }
        
        let bounds = thumbCollectionView.bounds
        let nextPreheadRect = bounds.insetBy(dx: 0, dy: -bounds.height * 0.5)
        
        let delta = fabs(nextPreheadRect.midY - inner.previousPreheatRect.midY)
        guard delta > (bounds.height / 3.0) else { return }
        
        // caculate the need add and delete asset items
        let diffRects = differentItemsRectBetween(inner.previousPreheatRect, newRect: nextPreheadRect)
        let startIndexPaths = thumbCollectionView.p_indexPathsForItemsInRect(diffRects.startRect)
        let stopIndexPaths = thumbCollectionView.p_indexPathsForItemsInRect(diffRects.stopRect)
        
        guard
            let fetchResult = inner.assetFetchResults, fetchResult.count > 0,
            let startAssets = (startIndexPaths.map{fetchResult[$0.item]}) as? [PHAsset],
            let stopAssets = (stopIndexPaths.map{fetchResult[$0.item]}) as? [PHAsset]
            else { return }
        
        inner.imageManager
            .stopCachingImages(
                for: stopAssets,
                targetSize: inner.layoutAttributes!.itemSize,
                contentMode: .aspectFill,
                options: nil)
        
        inner.imageManager
            .startCachingImages(
                for: startAssets,
                targetSize: inner.layoutAttributes!.itemSize,
                contentMode: .aspectFill,
                options: nil)
        
        inner.previousPreheatRect = nextPreheadRect
    }
    
    fileprivate func differentItemsRectBetween(_ oldRect: CGRect, newRect: CGRect) -> (stopRect: CGRect, startRect: CGRect) {
        
        var stopRect = oldRect
        var startRect = newRect
        
        let newMaxY = newRect.maxY
        let newMinY = newRect.minY
        let oldMaxY = oldRect.maxY
        let oldMinY = oldRect.minY
        
        if newMaxY > oldMaxY {
            startRect = CGRect(x: newRect.minX, y: oldMaxY, width: newRect.width, height: newMaxY - oldMaxY)
        }
        
        if newMaxY < oldMaxY {
            stopRect = CGRect(x: newRect.minX, y: newMaxY, width: newRect.width, height: oldMaxY - newMaxY)
        }
        
        if oldMinY > newMinY {
            startRect = CGRect(x: newRect.minX, y: newMinY, width: newRect.width, height: oldMinY - newMinY)
        }

        if oldMinY < newMinY {
            stopRect = CGRect(x: newRect.minX, y: oldMinY, width: newRect.width, height: newMinY - oldMinY)
        }
        
        return (stopRect, startRect)
    }
    
    
    // MARK: - LayoutAttributes
    fileprivate func caculateLayoutAttributes() {
        
        let w = UIScreen.main.bounds.width
        let columCount: CGFloat = 4
        let edgeInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        let itemSpacing: CGFloat = 0
        let lineSpacing: CGFloat = 0
        
        let itemW = Int((w - edgeInsets.left - edgeInsets.right - itemSpacing * (columCount)) / columCount)
        let itemSize = CGSize(width: itemW, height: itemW)
        
        inner.layoutAttributes = CTAPhotoThumbnailLayoutAttributes(
            itemSize: itemSize,
            itemSpacing: itemSpacing,
            lineSpacing: lineSpacing,
            edgeInsets: edgeInsets)
        
        inner.topConstraintTargetScrollDistance = w * 0.5 + (w * 0.5 - inner.originTopConstraintCostant) - inner.originTopConstraintCostant
    }
}


// MARK: - Delegate and DataSource

extension CTAPhotoViewController: UICollectionViewDataSource {
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inner.accessPhotoEnable {
            return inner.assetFetchResults?.count ?? 0
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath) as! CTAPhotoThumbnailCollectionViewCell
        
        if inner.accessPhotoEnable {
            if let asset = inner.assetFetchResults?[indexPath.item] {
                let localIdentifier = asset.localIdentifier
                cell.assetIdentifier = localIdentifier
                
                inner.imageManager
                    .requestImage(
                        for: asset,
                        targetSize: inner.layoutAttributes!.itemSize,
                        contentMode: .aspectFill,
                        options: nil) { (image, info) in
                            guard  cell.assetIdentifier == localIdentifier, let image = image else { return }
                            cell.imageView.image = image
                }
            }
        }
        
        if cell.selectedBackgroundView == nil {
            let v = UIView(frame: cell.bounds)
            v.backgroundColor = UIColor.white.withAlphaComponent(0.7)
            cell.selectedBackgroundView = v
//            v.layer.borderWidth = 1.5
//            v.layer.borderColor = UIColor.yellowColor().CGColor
            cell.bringSubview(toFront: cell.selectedBackgroundView!)
        }
        
        return cell
    }
}



extension CTAPhotoViewController: UICollectionViewDelegate {
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if inner.accessPhotoEnable {
            if let old = inner.oldSelectedIndexPath, (old as NSIndexPath).compare(indexPath) == .orderedSame {
                return
            }
            if let asset = inner.assetFetchResults?[indexPath.item] {
                inner.oldSelectedIndexPath = indexPath
                
                DispatchQueue.main.async(execute: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.previewScroll(.end(translation: 60)) {
                        collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
                    }
//                    strongSelf.previewView.image = image
                })
                
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                inner.imageManager.requestImage(for: asset, targetSize: previewView.bounds.size, contentMode: .aspectFill, options: options) {[weak self] (image, info) in
                    
                    if let strongSelf = self, let image = image {
                        strongSelf.previewView.image = image
                    }
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y <= 0 && scrollView.isTracking {
            if scrollView.isDragging {
                previewScroll(.scroll(deltaY: 6))
            }
        } else {
            if let position = inner.beganScrollPanPosition {
                if scrollView.contentOffset.y + scrollView.bounds.height < scrollView.contentSize.height {
                    let nextLocation = scrollView.panGestureRecognizer.location(in: view)
                    let translation = position.y - nextLocation.y
                    previewScroll(.scroll(deltaY: -translation))
                    inner.beganScrollPanPosition = nextLocation
                } else {
                    
                }
                
            } else {
                let location = scrollView.panGestureRecognizer.location(in: previewView)
                let ignoreRect = previewView.ignoreRect
                if ignoreRect.contains(location) {
                    if inner.beganScrollPanPosition == nil {
                        let onViewLocation = scrollView.panGestureRecognizer.location(in: view)
                        inner.beganScrollPanPosition = onViewLocation
                    } else {
                        let nextLocation = scrollView.panGestureRecognizer.location(in: view)
                        let translation = inner.beganScrollPanPosition!.y - nextLocation.y
                        previewScroll(.scroll(deltaY: -translation))
                        inner.beganScrollPanPosition = nextLocation
                    }
                }
            }
            
        }
        
        updateCacheSets()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView.contentOffset.y <= 0 {
            let trigdistance = inner.triggScrollDistance
            previewScroll(.end(translation: trigdistance))
        }
        
        if let p = inner.beganScrollPanPosition {
            
            
            if scrollView.contentOffset.y + scrollView.bounds.height < scrollView.contentSize.height {
                let position = scrollView.panGestureRecognizer.location(in: view)
                let offset = position.y - p.y
                previewScroll(.end(translation: offset))
            } else {
                let trigdistance = inner.triggScrollDistance
                previewScroll(.end(translation: trigdistance))
                
            }
            inner.beganScrollPanPosition = nil
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y <= 0 {
            let trigdistance = inner.triggScrollDistance
            previewScroll(.end(translation: trigdistance))
        }
        
        if let p = inner.beganScrollPanPosition {
            
            let position = scrollView.panGestureRecognizer.location(in: view)
            let offset = position.y - p.y
            previewScroll(.end(translation: offset))
            inner.beganScrollPanPosition = nil
        }
    }
}

extension CTAPhotoViewController: UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if inner.layoutAttributes == nil {
            caculateLayoutAttributes()
        }
        
        return inner.layoutAttributes!.itemSize
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if inner.layoutAttributes == nil {
            caculateLayoutAttributes()
        }
        
        return inner.layoutAttributes!.edgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if inner.layoutAttributes == nil {
            caculateLayoutAttributes()
        }
        
        return inner.layoutAttributes!.lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if inner.layoutAttributes == nil {
            caculateLayoutAttributes()
        }
        
        return inner.layoutAttributes!.itemSpacing
    }
}

// MARK: - Helper
extension UICollectionView {
    
    func p_indexPathsForItemsInRect(_ rect: CGRect) -> [IndexPath] {
        
        if let layoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect), layoutAttributes.count > 0 {
            
            return layoutAttributes.map{$0.indexPath}
        } else {
          return []
        }
    }
}

extension CTAPhotoViewController {

    
//    private func updatePhotoCacheAssets() {
//        
//        var indexPaths = [NSIndexPath]()
//        for i in 0..<inner.assetFetchResults!.count {
//            let indexPath = NSIndexPath(forItem: i, inSection: 0)
//            indexPaths.append(indexPath)
//        }
//        
//        let startAssets = assetToStartCaching(indexPaths)
//        
//        if inner.layoutAttributes == nil {
//            caculateLayoutAttributes()
//        }
//        
//        let itemSize = inner.layoutAttributes!.itemSize
//        let scale = UIScreen.mainScreen().scale
//        
//        inner.imageManager
//            .startCachingImagesForAssets(
//                startAssets,
//                targetSize: CGSize(width: itemSize.width * scale, height: itemSize.height * scale),
//                contentMode: .AspectFill,
//                options: nil)
//    }
    
//    private func assetToStartCaching(indexPaths: [NSIndexPath]) -> [PHAsset] {
//        var assets = [PHAsset]()
//        for i in indexPaths {
//            let asset = inner.assetFetchResults![i.item]  as! PHAsset
//            assets.append(asset)
//        }
//        
//        return assets
//    }
}
