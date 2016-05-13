//
//  CTAPhotoAlbumListViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 5/13/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import Photos

class CTAPhotoAlbumListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var allPhotos: PHFetchResult?
    private var albums: PHFetchResult?
    private var albumAssets = [PHFetchResult]()
    private let imageFetcher = PHCachingImageManager()
    
    var didSelectedHandler: ((PHFetchResult?) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let allPhotos = PHFetchOptions()
        let dateSortDescritor = NSSortDescriptor(key: "modificationDate", ascending: false)
        allPhotos.sortDescriptors = [dateSortDescritor]
        
        // 2. fetch result and collection
        let result = PHAsset.fetchAssetsWithOptions(allPhotos)
        
        
        self.allPhotos = result
        albumAssets.append(self.allPhotos!)
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "estimatedAssetCount > 0")
        albums = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .AlbumRegular, options: options)
        
        if let albums = albums {
            for a in 0..<albums.count {
                if let album = albums[a] as? PHAssetCollection {
                    let options = PHFetchOptions()
                    //                    options.fetchLimit = 1
                    let assetResult = PHAsset.fetchAssetsInAssetCollection(album, options: options)
                    if assetResult.count > 0 {
                        albumAssets.append(assetResult)
                    }
                }
            }
        }
    }
}

// MARK: - TableViewDataSource
extension CTAPhotoAlbumListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumAssets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoAlbumListCell")! as UITableViewCell

        if let coverImageView = cell.contentView.viewWithTag(1000) as? UIImageView {
            
                    if let asset = albumAssets[indexPath.row].firstObject as? PHAsset {
                        var assetID = "assetID"
                        let id = asset.localIdentifier
                        objc_setAssociatedObject(cell, &assetID, id, .OBJC_ASSOCIATION_COPY_NONATOMIC)
                        
                        coverImageView.image = nil
                        imageFetcher.requestImageForAsset(asset, targetSize: CGSize(width: 120, height: 120), contentMode: .AspectFill, options: nil, resultHandler: { (image, dic) in
                            
                            if let nextAssetID = objc_getAssociatedObject(cell, &assetID) as? String where nextAssetID == id {
                                
                                coverImageView.image = image
                            }
                        })
                    } else {
                        coverImageView.image = nil
                    }
        }
        
        if let titleLabel = cell.contentView.viewWithTag(2000) as? UILabel {
                let t = indexPath.row == 0 ? "All Photos" : (albums?[indexPath.row - 1] as? PHAssetCollection)?.localizedTitle
            titleLabel.text = t
            
        }
        
        if let countLabel = cell.contentView.viewWithTag(2001) as? UILabel {
            countLabel.text = "\(self.albumAssets[indexPath.row].count)"
        }
        
        return cell
    }
}

extension CTAPhotoAlbumListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let assets = albumAssets[indexPath.item]
        didSelectedHandler?(assets)
    }
}

