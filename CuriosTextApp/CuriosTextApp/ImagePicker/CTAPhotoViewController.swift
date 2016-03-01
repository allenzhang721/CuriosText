//
//  CTAPhotoViewController.swift
//  ImagePickerApp
//
//  Created by Emiaostein on 2/29/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import UIKit
import Photos

class CTAPhotoViewController: UIViewController, CTAPhotoPickerDelegate {
    
    struct CTAPhotoThumbnailLayoutAttributes {
        let itemSize: CGSize
        let itemSpacing: CGFloat
        let lineSpacing: CGFloat
        let edgeInsets: UIEdgeInsets
    }

    @IBOutlet weak var thumbCollectionView: UICollectionView!
    @IBOutlet weak var previewView: CTAPhotoPreviewView!
    private var layoutAttributes: CTAPhotoThumbnailLayoutAttributes?
    private let imageManager = PHCachingImageManager()
    private var assetFetchResults: PHFetchResult?
    private var assetCollection: PHAssetCollection?
    private var panGesture: UIPanGestureRecognizer?
    
    private var accessPhotoEnable = false
    private var previewfolded = false
    private var previewFoldBeganPosition: CGPoint?
    private var selectedIndexPath: NSIndexPath?
    
    weak var pickerDelegate: CTAPhotoPickerProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tabBarItem = UITabBarItem(title: "Photo", image: ImagePickerResource.imageOfPhotoLibrary, selectedImage: nil)
    }
    
//    private var thumbnailSize
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLibraryStatus {[weak self] (success) in
            dispatch_async(dispatch_get_main_queue(), {
                guard let Strongself = self else {
                    return
                }
                Strongself.accessPhotoEnable = success
                if success {
                    Strongself.setup()
                }
            })
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    private func setup() {
        
        setupDelegateAndDataSource()
        setupFetchPhotos()
        updatePhotoCacheAssets()
        
        if let assetFetchResults = assetFetchResults where assetFetchResults.count > 0, let asset = assetFetchResults[0] as? PHAsset {
            
            imageManager.requestImageForAsset(asset, targetSize: previewView.bounds.size, contentMode: .AspectFill, options: nil) {[weak self] (image, info) in
                
                if let strongSelf = self, let image = image {
                    dispatch_async(dispatch_get_main_queue(), {
                        strongSelf.previewView.image = image
//                        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
                    })
                }
            }
        }
    }
    
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
    
//    private func setupGesture() {
//        if panGesture == nil {
//            panGesture = UIPanGestureRecognizer(target: self, action: "pan:")
//            panGesture?.delegate = self
//            thumbCollectionView.addGestureRecognizer(panGesture!)
//        }
//    }
    
    private func setupDelegateAndDataSource() {
        thumbCollectionView.delegate = self
        thumbCollectionView.dataSource = self
        thumbCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    private func setupFetchPhotos() { // fetch Photo Assets
        // 1. fetch options
        let allPhotos = PHFetchOptions()
        let dateSortDescritor = NSSortDescriptor(key: "creationDate", ascending: true)
        allPhotos.sortDescriptors = [dateSortDescritor]

        // 2. fetch result and collection
        let result = PHAsset.fetchAssetsWithOptions(allPhotos)
        let collection = result[0] as? PHAssetCollection
        assetFetchResults = result
        assetCollection = collection
    }
    
    override func viewDidAppear(animated: Bool) {
        caculateLayoutAttributes()
//        updatePhotoCacheAssets()
    }
}


// MARK: - Action
extension CTAPhotoViewController {
    
    @IBAction func dismiss(sender: AnyObject?) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func confirm(sender: AnyObject) {
        
        if let items = thumbCollectionView.indexPathsForSelectedItems() where items.count > 0, let asset = assetFetchResults?[items.first!.item] as? PHAsset {
            
            let option = PHImageRequestOptions()
            option.synchronous = true
            
            imageManager.requestImageForAsset(asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .AspectFill, options: option, resultHandler: {[weak self] (image, info) in
                
                if let strongSelf = self {
                    if let image = image {
                        strongSelf.pickerDelegate?.pickerDidSelectedImage(image)
                    }
                    strongSelf.dismiss(nil)
                }
            })
        }
    }
    
    
}



// MARK: - UICollectionViewDataSource
extension CTAPhotoViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if accessPhotoEnable {
            return assetFetchResults?.count ?? 0
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ThumbnailCell", forIndexPath: indexPath) as! CTAPhotoThumbnailCollectionViewCell
        
        if accessPhotoEnable {
            if let asset = assetFetchResults?[indexPath.item] as? PHAsset {
                imageManager.requestImageForAsset(asset, targetSize: layoutAttributes!.itemSize, contentMode: .AspectFill, options: nil) { (image, info) in
                    
                    if let image = image {
                        cell.imageView.image = image
                    }
                }
            }
            
            if cell.selectedBackgroundView == nil {
                let v = UIView(frame: cell.bounds)
                v.backgroundColor = UIColor.yellowColor()
                cell.selectedBackgroundView = v
            }
            
        }
        
        return cell
    }
}


// MARK: - UICollectionViewDelegate
extension CTAPhotoViewController: UICollectionViewDelegate {
    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        if accessPhotoEnable {
//            
//            let dragging = scrollView.dragging
//            let expended = !previewfolded
//            
//            switch (dragging, expended) {
//                
//            case (true, true):
//                let pan = scrollView.panGestureRecognizer
//                let position = pan.locationInView(previewView)
//                
//                if CGRectContainsPoint(previewView.bounds, position) {
//                    if previewFoldBeganPosition == nil {
//                        previewFoldBeganPosition = pan.locationInView(view)
//                    }
//                    
//                    let nextPosition = pan.locationInView(view)
//                    let transitionY = nextPosition.y - previewFoldBeganPosition!.y
//                    if transitionY < 0 {
//                        previewView.transform = CGAffineTransformMakeTranslation(0, transitionY)
//                    }
//                }
//                
//            case (true, false):
//                if scrollView.contentOffset.y <= previewView.bounds.height - 44 && !CGAffineTransformEqualToTransform(previewView.transform, CGAffineTransformIdentity) {
//                    previewView.transform = CGAffineTransformMakeTranslation(0, -scrollView.contentOffset.y)
//                }
//                
//                
//                
//                
//            case (false, false):
//                ()
//            case (false, true):
//                ()
//            }
//        }
//    }
//    
//    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        
//        if previewfolded == false {
//             previewfolded = true
//            if  previewFoldBeganPosition != nil {
//               
//                previewFoldBeganPosition = nil
//                UIView.animateWithDuration(0.3, animations: {
//                    
//                    self.previewView.transform = CGAffineTransformMakeTranslation(0, -self.previewView.bounds.height + 44)
//                })
//            }
//            
//        } else {
//            previewfolded = false
//            if previewFoldBeganPosition != nil {
//            UIView.animateWithDuration(0.3, animations: { 
//                self.previewView.transform = CGAffineTransformIdentity
//            })
//            }
//        }
//        
//    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if accessPhotoEnable {
            if let asset = assetFetchResults?[indexPath.item] as? PHAsset {
                imageManager.requestImageForAsset(asset, targetSize: previewView.bounds.size, contentMode: .AspectFill, options: nil) {[weak self] (image, info) in
                    
                    if let strongSelf = self, let image = image {
                        dispatch_async(dispatch_get_main_queue(), { 
                            strongSelf.previewView.image = image
                            collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
                        })
                    }
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CTAPhotoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if layoutAttributes == nil {
            caculateLayoutAttributes()
        }
        
        return layoutAttributes!.itemSize
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        if layoutAttributes == nil {
            caculateLayoutAttributes()
        }
        
        return layoutAttributes!.edgeInsets
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        if layoutAttributes == nil {
            caculateLayoutAttributes()
        }
        
        return layoutAttributes!.lineSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        if layoutAttributes == nil {
            caculateLayoutAttributes()
        }
        
        return layoutAttributes!.itemSpacing
    }
}

// MARK: - Helper
extension CTAPhotoViewController {
    private func caculateLayoutAttributes() {
        
        let w = thumbCollectionView.bounds.width
        let columCount: CGFloat = 4
        let edgeInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        let itemSpacing: CGFloat = 0
        let lineSpacing: CGFloat = 0
        
        let itemW = Int((w - edgeInsets.left - edgeInsets.right - itemSpacing * (columCount)) / columCount)
        let itemSize = CGSize(width: itemW, height: itemW)
        
        layoutAttributes = CTAPhotoThumbnailLayoutAttributes(
            itemSize: itemSize,
            itemSpacing: itemSpacing,
            lineSpacing: lineSpacing,
            edgeInsets: edgeInsets)
    }
    
    private func updatePhotoCacheAssets() {
        
        var indexPaths = [NSIndexPath]()
        for i in 0..<assetFetchResults!.count {
            let indexPath = NSIndexPath(forItem: i, inSection: 0)
            indexPaths.append(indexPath)
        }
        
        let startAssets = assetToStartCaching(indexPaths)
        
        if layoutAttributes == nil {
            caculateLayoutAttributes()
        }
        
        let itemSize = layoutAttributes!.itemSize
        let scale = UIScreen.mainScreen().scale
        
        imageManager
            .startCachingImagesForAssets(
                startAssets,
                targetSize: CGSize(width: itemSize.width * scale, height: itemSize.height * scale),
                contentMode: .AspectFill,
                options: nil)
    }
    
    private func assetToStartCaching(indexPaths: [NSIndexPath]) -> [PHAsset] {
        var assets = [PHAsset]()
        for i in indexPaths {
            let asset = assetFetchResults![i.item]  as! PHAsset
            assets.append(asset)
        }
        
        return assets
    }
}
