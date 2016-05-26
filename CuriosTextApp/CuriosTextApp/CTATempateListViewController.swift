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
    
    var selectedHandler: ((pageData: NSData?) -> ())?
    
    private var localTemplates = [TemplateModel]()
    private var onlineTemplates = [TemplateModel]()
    private var selectedTask: RetrieveDataTask?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - CollectionViewDataSource
extension CTATempateListViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.localTemplates.count + self.onlineTemplates.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TemplateImgCell", forIndexPath: indexPath)

        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            if indexPath.item < localTemplates.count {
                let temp = localTemplates[indexPath.item]
                let localDir = ""
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
        
        return cell
    }
}


// MARK: - CollectionViewDeleagte
extension CTATempateListViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.item < localTemplates.count {
            let temp = localTemplates[indexPath.item]
            let localDir = ""
            let pagePath = localDir + temp.pagePath
            let data = NSData(contentsOfFile: pagePath)
            if let preTask = selectedTask {
                preTask.cancel()
                selectedTask = nil
            }
            selectedHandler?(pageData: data)
  
        } else {
            let temp = localTemplates[indexPath.item]
            let host = ""
            let pagePath = host + temp.pagePath
            let task = BlackCatManager.sharedManager.retrieveDataWithURL(NSURL(string: pagePath)!, optionsInfo: nil, progressBlock: nil, completionHandler: {[weak self] (data, error, cacheType, URL) in
                guard let sf = self else {return }
                sf.selectedHandler?(pageData: data)
            })
            if let preTask = selectedTask {
                preTask.cancel()
                selectedTask = task
            }
        }
    }
}
