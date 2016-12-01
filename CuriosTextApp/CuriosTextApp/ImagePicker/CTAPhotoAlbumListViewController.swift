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
    fileprivate var allPhotos: PHFetchResult<PHAsset>?
    fileprivate var albums: PHFetchResult<PHAssetCollection>?
    fileprivate var albumAssets = [PHFetchResult<AnyObject>]()
    fileprivate let imageFetcher = PHCachingImageManager()
    
    let allPhotoTitle = NSLocalizedString("AllPhotos", comment: "")
    
    var didSelectedHandler: ((PHFetchResult<AnyObject>?, String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let allPhotos = PHFetchOptions()
        let dateSortDescritor = NSSortDescriptor(key: "modificationDate", ascending: false)
        allPhotos.sortDescriptors = [dateSortDescritor]
        
        // 2. fetch result and collection
        let result = PHAsset.fetchAssets(with: allPhotos)
        
        
        self.allPhotos = result
        albumAssets.append(self.allPhotos! as! PHFetchResult<AnyObject>)
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "estimatedAssetCount > 0")
        albums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: options)
        
        if let albums = albums {
            for a in 0..<albums.count {
                if let album = albums[a] as? PHAssetCollection {
                    let options = PHFetchOptions()
                    //                    options.fetchLimit = 1
                    let assetResult = PHAsset.fetchAssets(in: album, options: options)
                    if assetResult.count > 0 {
                        albumAssets.append(assetResult as! PHFetchResult<AnyObject>)
                    }
                }
            }
        }
    }
}

// MARK: - TableViewDataSource
extension CTAPhotoAlbumListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumAssets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoAlbumListCell")! as UITableViewCell

        if let coverImageView = cell.contentView.viewWithTag(1000) as? UIImageView {
            
                    if let asset = albumAssets[indexPath.row].firstObject as? PHAsset {
                        var assetID = "assetID"
                        let id = asset.localIdentifier
                        objc_setAssociatedObject(cell, &assetID, id, .OBJC_ASSOCIATION_COPY_NONATOMIC)
                        
                        coverImageView.image = nil
                        imageFetcher.requestImage(for: asset, targetSize: CGSize(width: 120, height: 120), contentMode: .aspectFill, options: nil, resultHandler: { (image, dic) in
                            
                            if let nextAssetID = objc_getAssociatedObject(cell, &assetID) as? String, nextAssetID == id {
                                
                                coverImageView.image = image
                            }
                        })
                    } else {
                        coverImageView.image = nil
                    }
        }
        
        if let titleLabel = cell.contentView.viewWithTag(2000) as? UILabel {
                let t = indexPath.row == 0 ? allPhotoTitle : albums?[indexPath.row - 1].localizedTitle
            titleLabel.text = t
            
        }
        
        if let countLabel = cell.contentView.viewWithTag(2001) as? UILabel {
            countLabel.text = "\(self.albumAssets[indexPath.row].count)"
        }
        
        return cell
    }
}

extension CTAPhotoAlbumListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let assets = albumAssets[indexPath.item]
        let t = indexPath.row == 0 ? allPhotoTitle : albums?[indexPath.row - 1].localizedTitle
        didSelectedHandler?(assets, t!)
    }
}

