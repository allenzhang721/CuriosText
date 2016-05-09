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
        var assetFetchResults: PHFetchResult?
        var assetCollection: PHAssetCollection?
        
        // layout
        var layoutAttributes: CTAPhotoThumbnailLayoutAttributes?
        
        // status
        var accessPhotoEnable = false
        var oldSelectedIndexPath: NSIndexPath?
        
        // preview scroll
        var beganPosition = CGPoint.zero
        let originTopConstraintCostant: CGFloat = 44
        var topConstraintTargetScrollDistance: CGFloat = 250
        let triggScrollDistance: CGFloat = 50
        
        // scroll by scrollView
        var beganScrollPanPosition: CGPoint? = nil
//        let triggerScrollPanPosition = CGPoint.zero
    }
    
    @IBOutlet weak var accessView: UIView!
    @IBOutlet weak var thumbCollectionView: UICollectionView!
    @IBOutlet weak var previewView: CTAPhotoPreviewView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var templateImage: UIImage?
    
    weak var pickerDelegate: CTAPhotoPickerProtocol?
    private var inner = Inner()

    override func awakeFromNib() {
        super.awakeFromNib()
        resetCacheSets()
        
        self.tabBarItem = UITabBarItem(title: LocalStrings.Photo.description, image: ImagePickerResource.imageOfPhotoLibrary, selectedImage: nil)
    }
    
    //    private var thumbnailSize
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accessView.hidden = true
        
        checkLibraryStatus {[weak self] (success) in
            dispatch_async(dispatch_get_main_queue(), {
                guard let Strongself = self else { return }
                Strongself.inner.accessPhotoEnable = success
                if success {
                    Strongself.setup()
                } else {
                    Strongself.accessView.hidden = false
                }
            })
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        
        previewView.templateImageView.image = templateImage
    }
    
    override func viewDidAppear(animated: Bool) {
        caculateLayoutAttributes()
        updateCacheSets()
        
//        previewView.templateImage = templateImage
    }
    
    deinit {
        resetCacheSets()
    }
}

// MARK: - Setup
extension CTAPhotoViewController {
    
    private func setup() {
        
//        previewView.templateImage = templateImage
        
        setupDelegateAndDataSource()
        setupFetchPhotos()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CTAPhotoViewController.tap(_:)))
        previewView.addGestureRecognizer(tap)
        
        if let assetFetchResults = inner.assetFetchResults where assetFetchResults.count > 0, let asset = assetFetchResults[0] as? PHAsset {
            
            thumbCollectionView.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: .None)
            inner.imageManager.requestImageForAsset(asset, targetSize: previewView.bounds.size, contentMode: .AspectFill, options: nil) {[weak self] (image, info) in
                
                if let strongSelf = self, let image = image {
                    dispatch_async(dispatch_get_main_queue(), {
                        strongSelf.previewView.image = image
                    })
                }
            }
        }
    }
    
    private func setupDelegateAndDataSource() {
        thumbCollectionView.delegate = self
        thumbCollectionView.dataSource = self
        thumbCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    private func setupFetchPhotos() { // fetch Photo Assets
        // 1. fetch options
        let allPhotos = PHFetchOptions()
        let dateSortDescritor = NSSortDescriptor(key: "creationDate", ascending: false)
        allPhotos.sortDescriptors = [dateSortDescritor]
        
        // 2. fetch result and collection
         let result = PHAsset.fetchAssetsWithOptions(allPhotos)
        guard result.count > 0 else {return}
        let collection = result[0] as? PHAssetCollection
        inner.assetFetchResults = result
        inner.assetCollection = collection
    }
}


// MARK: - Action
extension CTAPhotoViewController {
    
    @IBAction func accessClick(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    func tap(sener: UITapGestureRecognizer) {
        let location = sener.locationInView(previewView)
        let ignoreRect = previewView.ignoreRect
        if CGRectContainsPoint(ignoreRect, location) {
            let trigdistance = inner.triggScrollDistance
            previewScroll(.End(translation: trigdistance))
        }
    }
    
    @IBAction func pan(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translationInView(view)
        switch sender.state {
        case .Began:
            inner.beganPosition = sender.locationInView(view)
            
        case .Changed:
            previewScroll(.Scroll(deltaY: translation.y))
            
        case .Ended, .Cancelled:
            let position = sender.locationInView(view)
            let offset = position.y - inner.beganPosition.y
            previewScroll(.End(translation: offset))
            
        default:
            ()
        }
        sender.setTranslation(CGPoint.zero, inView: view)
    }
    
    @IBAction func dismiss(sender: AnyObject?) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func confirm(sender: AnyObject) {
        
        if let items = thumbCollectionView.indexPathsForSelectedItems() where items.count > 0, let asset = inner.assetFetchResults?[items.first!.item] as? PHAsset {
            
            let option = PHImageRequestOptions()
            option.synchronous = true
            let imageDisplayRect = previewView.imgDisplayRect
            
            inner.imageManager.requestImageForAsset(asset, targetSize: previewView.bounds.size, contentMode: .AspectFill, options: option, resultHandler: {[weak self] (image, info) in
                
                if let strongSelf = self {
                    if let image = image {
                        UIGraphicsBeginImageContextWithOptions(imageDisplayRect.size, true, UIScreen.mainScreen().scale)
                        
                        image.drawAtPoint(CGPoint(x: -imageDisplayRect.minX, y: -imageDisplayRect.minY))
                        let aimage = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            strongSelf.pickerDelegate?.pickerDidSelectedImage(aimage)
                            strongSelf.dismiss(nil)
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
        case Scroll(deltaY: CGFloat)
        case ScrollByTranslation(translation: CGFloat)
        case End(translation: CGFloat)
    }
    func previewScroll(status: PreviewStatus, compeletedHandler:(() -> ())? = nil) {
        
        let originConstant = inner.originTopConstraintCostant
        let distance = inner.topConstraintTargetScrollDistance
        let triggerDistance = inner.triggScrollDistance
        switch status {
        case .Scroll(let deltaY):
            if topConstraint.constant < originConstant {
                topConstraint.constant += deltaY
                view.layoutIfNeeded()
            } else {
                if deltaY < 0 {
                    topConstraint.constant += deltaY
                    view.layoutIfNeeded()
                }
            }
            
        case .ScrollByTranslation(let translation):
            if topConstraint.constant < originConstant {
                topConstraint.constant = translation
                view.layoutIfNeeded()
            } else {
                if translation < 0 {
                    topConstraint.constant = translation
                    view.layoutIfNeeded()
                }
            }
            
        case .End(let translationY):
            if topConstraint.constant < originConstant {
                topConstraint.constant = (translationY <= originConstant) ? -distance : (translationY >= triggerDistance) ? originConstant : -distance
            } else {
                topConstraint.constant = (translationY <= -triggerDistance) ? -distance : originConstant
            }
            
            UIView.animateWithDuration(0.3, animations: {
                self.view.layoutIfNeeded()
                }, completion: { finished in
                    if finished {
                        compeletedHandler?()
                    }
            })
        }
    }
    
    // MARK: - Authorzied Status
    private func checkLibraryStatus(completed: ((Bool) -> ())?) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .Authorized:
            completed?(true)
            
        case .NotDetermined:
            PHPhotoLibrary.requestAuthorization({ (requestedStatus) in
                if requestedStatus == .Authorized {
                    completed?(true)
                } else {
                    completed?(false)
                }
            })
            
        case .Denied, .Restricted:
            completed?(false)
        }
    }
    
    // MARK: - Assets
    private func resetCacheSets() {
        if inner.accessPhotoEnable {
            inner.imageManager.stopCachingImagesForAllAssets()
        }
        inner.previousPreheatRect = CGRect.zero
    }
    
    private func updateCacheSets() {
        guard isViewLoaded() && view.window != nil else { return }
        
        let bounds = thumbCollectionView.bounds
        let nextPreheadRect = CGRectInset(bounds, 0, -bounds.height * 0.5)
        
        let delta = fabs(nextPreheadRect.midY - inner.previousPreheatRect.midY)
        guard delta > (bounds.height / 3.0) else { return }
        
        // caculate the need add and delete asset items
        let diffRects = differentItemsRectBetween(inner.previousPreheatRect, newRect: nextPreheadRect)
        let startIndexPaths = thumbCollectionView.p_indexPathsForItemsInRect(diffRects.startRect)
        let stopIndexPaths = thumbCollectionView.p_indexPathsForItemsInRect(diffRects.stopRect)
        
        guard
            let fetchResult = inner.assetFetchResults where fetchResult.count > 0,
            let startAssets = (startIndexPaths.map{fetchResult[$0.item]}) as? [PHAsset],
            let stopAssets = (stopIndexPaths.map{fetchResult[$0.item]}) as? [PHAsset]
            else { return }
        
        inner.imageManager
            .stopCachingImagesForAssets(
                stopAssets,
                targetSize: inner.layoutAttributes!.itemSize,
                contentMode: .AspectFill,
                options: nil)
        
        inner.imageManager
            .startCachingImagesForAssets(
                startAssets,
                targetSize: inner.layoutAttributes!.itemSize,
                contentMode: .AspectFill,
                options: nil)
        
        inner.previousPreheatRect = nextPreheadRect
    }
    
    private func differentItemsRectBetween(oldRect: CGRect, newRect: CGRect) -> (stopRect: CGRect, startRect: CGRect) {
        
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
    private func caculateLayoutAttributes() {
        
        let w = thumbCollectionView.bounds.width
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
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inner.accessPhotoEnable {
            return inner.assetFetchResults?.count ?? 0
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ThumbnailCell", forIndexPath: indexPath) as! CTAPhotoThumbnailCollectionViewCell
        
        if inner.accessPhotoEnable {
            if let asset = inner.assetFetchResults?[indexPath.item] as? PHAsset {
                let localIdentifier = asset.localIdentifier
                cell.assetIdentifier = localIdentifier
                
                inner.imageManager
                    .requestImageForAsset(
                        asset,
                        targetSize: inner.layoutAttributes!.itemSize,
                        contentMode: .AspectFill,
                        options: nil) { (image, info) in
                            guard  cell.assetIdentifier == localIdentifier, let image = image else { return }
                            cell.imageView.image = image
                }
            }
        }
        
        if cell.selectedBackgroundView == nil {
            let v = UIView(frame: cell.bounds)
            v.backgroundColor = UIColor.yellowColor()
            cell.selectedBackgroundView = v
        }
        
        return cell
    }
}



extension CTAPhotoViewController: UICollectionViewDelegate {
    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if inner.accessPhotoEnable {
            if let old = inner.oldSelectedIndexPath where old.compare(indexPath) == .OrderedSame {
                return
            }
            if let asset = inner.assetFetchResults?[indexPath.item] as? PHAsset {
                inner.oldSelectedIndexPath = indexPath
                
                dispatch_async(dispatch_get_main_queue(), { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.previewScroll(.End(translation: 60)) {
                        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
                    }
//                    strongSelf.previewView.image = image
                })
                
                inner.imageManager.requestImageForAsset(asset, targetSize: previewView.bounds.size, contentMode: .AspectFill, options: nil) {[weak self] (image, info) in
                    
                    if let strongSelf = self, let image = image {
                        strongSelf.previewView.image = image
                    }
                }
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y <= 0 && scrollView.tracking {
            previewScroll(.Scroll(deltaY: 6))
        } else {
            if let position = inner.beganScrollPanPosition {
                let nextLocation = scrollView.panGestureRecognizer.locationInView(view)
                let translation = position.y - nextLocation.y
                previewScroll(.Scroll(deltaY: -translation))
                inner.beganScrollPanPosition = nextLocation
            } else {
                let location = scrollView.panGestureRecognizer.locationInView(previewView)
                let ignoreRect = previewView.ignoreRect
                if CGRectContainsPoint(ignoreRect, location) {
                    if inner.beganScrollPanPosition == nil {
                        let onViewLocation = scrollView.panGestureRecognizer.locationInView(view)
                        inner.beganScrollPanPosition = onViewLocation
                    } else {
                        let nextLocation = scrollView.panGestureRecognizer.locationInView(view)
                        let translation = inner.beganScrollPanPosition!.y - nextLocation.y
                        previewScroll(.Scroll(deltaY: -translation))
                        inner.beganScrollPanPosition = nextLocation
                    }
                }
            }
            
        }
        
        updateCacheSets()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView.contentOffset.y <= 0 {
            let trigdistance = inner.triggScrollDistance
            previewScroll(.End(translation: trigdistance))
        }
        
        if let p = inner.beganScrollPanPosition {
            
            let position = scrollView.panGestureRecognizer.locationInView(view)
            let offset = position.y - p.y
            previewScroll(.End(translation: offset))
            inner.beganScrollPanPosition = nil
        }
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y <= 0 {
            let trigdistance = inner.triggScrollDistance
            previewScroll(.End(translation: trigdistance))
        }
        
        if let p = inner.beganScrollPanPosition {
            
            let position = scrollView.panGestureRecognizer.locationInView(view)
            let offset = position.y - p.y
            previewScroll(.End(translation: offset))
            inner.beganScrollPanPosition = nil
        }
    }
}

extension CTAPhotoViewController: UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if inner.layoutAttributes == nil {
            caculateLayoutAttributes()
        }
        
        return inner.layoutAttributes!.itemSize
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        if inner.layoutAttributes == nil {
            caculateLayoutAttributes()
        }
        
        return inner.layoutAttributes!.edgeInsets
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        if inner.layoutAttributes == nil {
            caculateLayoutAttributes()
        }
        
        return inner.layoutAttributes!.lineSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        if inner.layoutAttributes == nil {
            caculateLayoutAttributes()
        }
        
        return inner.layoutAttributes!.itemSpacing
    }
}

// MARK: - Helper
extension UICollectionView {
    
    func p_indexPathsForItemsInRect(rect: CGRect) -> [NSIndexPath] {
        
        if let layoutAttributes = collectionViewLayout.layoutAttributesForElementsInRect(rect) where layoutAttributes.count > 0 {
            
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
