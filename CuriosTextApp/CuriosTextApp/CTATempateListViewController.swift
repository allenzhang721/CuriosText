//
//  CTATempateListViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 5/26/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import Kingfisher

class CTATempateListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedHandler: ((pageData: NSData?, origin: Bool) -> ())?
    weak var originImage: UIImage?
    
    private let queue = dispatch_queue_create("templatesQueue", DISPATCH_QUEUE_CONCURRENT)
    private var localTemplates = [TemplateModel]()
    private var onlineTemplates = [TemplateModel]()
    private var selectedTask: RetrieveDataTask?
    
    deinit {
        print("\(#file) deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        
        setup()
    }
    
    func defaultSelected() {
        dispatch_async(dispatch_get_main_queue()) {[weak self] in
            guard let sf = self else {return}
            if sf.collectionView.dataSource?.collectionView(sf.collectionView, numberOfItemsInSection: 0) > 0 {
                sf.collectionView.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: .None)
            }
        }
    }
    
    func updateCurrentOriginImage(image: UIImage?) {
        originImage = image
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            guard let sf = self else {return}
            if sf.collectionView.dataSource?.collectionView(sf.collectionView, numberOfItemsInSection: 0) > 0 {
                sf.collectionView.reloadItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
                dispatch_async(dispatch_get_main_queue(), {
                    if let selectedItem = sf.collectionView.indexPathsForSelectedItems()?.first {
                        sf.collectionView.selectItemAtIndexPath(selectedItem, animated: false, scrollPosition: .None)
                    } else {
                        sf.collectionView.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: .None)
                    }
                })
            }
        }
    }
    
    func updateFirst() {
        let selected = collectionView.indexPathsForSelectedItems()?.first?.item
        if collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0) > 0 {
            collectionView.reloadData()
//            collectionView.reloadItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
            if selected == 0 {
                collectionView.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: .None)
            }
        }
    }
    
    private func setup() {
        
        dispatch_async(queue) {[weak self] in
            guard let sf = self else { return }
            let templatesURL = NSBundle.mainBundle().bundleURL.URLByAppendingPathComponent("Templates").URLByAppendingPathComponent("Templates.json")
            if let data = NSData(contentsOfURL: templatesURL), let ms = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as? [[String: AnyObject]] {
                
                for m in ms {
                    if let t = TemplateModel(m) {
                        sf.localTemplates.append(t)
                    }
                }
            }
            
            let template = TemplateModel.placeholder()
            sf.localTemplates.insert(template, atIndex: 0)
            
            dispatch_async(dispatch_get_main_queue(), {
                sf.collectionView.reloadData()
                dispatch_async(dispatch_get_main_queue(), {
                    sf.collectionView.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: .None)
                })
            })
        }
        
    }
}

// MARK: - CollectionViewDataSource
extension CTATempateListViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = localTemplates.count
        
        return count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TemplateImgCell", forIndexPath: indexPath)
        
        if let imageView = cell.contentView.viewWithTag(1000) as? UIImageView {
            if indexPath.item == 0 {
                imageView.image = originImage
                
            } else if indexPath.item < localTemplates.count {
                let temp = localTemplates[indexPath.item]
                let localDir = NSBundle.mainBundle().bundlePath + "/" + "Templates" + "/"
                let imagePath = localDir + temp.thumbImgPath
                let img = UIImage(contentsOfFile: imagePath)
                imageView.image = img
                
            } else {
                let temp = onlineTemplates[indexPath.item - localTemplates.count]
                let host = ""
                let imagePath = host + temp.thumbImgPath
                let options = [KingfisherOptionsInfoItem.Transition(.Fade(0.3))]
                imageView.kf_setImageWithURL(NSURL(string: imagePath)!, placeholderImage: nil, optionsInfo: options)
            }
        }
        
        if cell.selectedBackgroundView == nil {
            let v = UIView(frame: cell.bounds)
            v.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
            cell.selectedBackgroundView = v
            cell.bringSubviewToFront(cell.selectedBackgroundView!)
        }
        
        return cell
    }
}


// MARK: - CollectionViewDeleagte
extension CTATempateListViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.item == 0 {
            if let preTask = selectedTask {
                preTask.cancel()
                selectedTask = nil
            }
            selectedHandler?(pageData: nil, origin: true)
            
        } else { if indexPath.item < localTemplates.count {
            let temp = localTemplates[indexPath.item]
            let localDir = NSBundle.mainBundle().bundlePath + "/" + "Templates" + "/"
            let pagePath = localDir + temp.pagePath
            let data = NSData(contentsOfFile: pagePath)
            if let preTask = selectedTask {
                preTask.cancel()
                selectedTask = nil
            }
            selectedHandler?(pageData: data, origin: false)
            
        } else {
            let temp = localTemplates[indexPath.item]
            let host = ""
            let pagePath = host + temp.pagePath
            let task = BlackCatManager.sharedManager.retrieveDataWithURL(NSURL(string: pagePath)!, optionsInfo: nil, progressBlock: nil, completionHandler: {[weak self] (data, error, cacheType, URL) in
                guard let sf = self else {return }
                sf.selectedHandler?(pageData: data, origin: false)
                })
            if let preTask = selectedTask {
                preTask.cancel()
                selectedTask = task
            }
            }
        }
    }
}
