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
    var originImage: UIImage?
    
    private let queue = dispatch_queue_create("templatesQueue", DISPATCH_QUEUE_CONCURRENT)
    private var localTemplates = [TemplateModel]()
    private var onlineTemplates = [TemplateModel]()
    private var selectedTask: RetrieveDataTask?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        collectionView.delegate = self
        
        //        let time: NSTimeInterval = 3.0
        //        let delay = dispatch_time(DISPATCH_TIME_NOW,
        //                                  Int64(time * Double(NSEC_PER_SEC)))
        //        dispatch_after(delay, dispatch_get_main_queue()) {
        //            self.collectionView.reloadData()
        //
        //        }
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
        
        cell.backgroundColor = UIColor.redColor()
        
        return cell
    }
}


// MARK: - CollectionViewDeleagte
extension CTATempateListViewController: UICollectionViewDelegate {
    
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
