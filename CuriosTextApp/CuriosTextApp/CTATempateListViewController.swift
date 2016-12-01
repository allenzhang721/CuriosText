//
//  CTATempateListViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 5/26/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import Kingfisher
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class CTATempateListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedHandler: ((_ pageData: Data?, _ origin: Bool) -> ())?
    weak var originImage: UIImage?
    
    fileprivate let queue = DispatchQueue(label: "templatesQueue", attributes: DispatchQueue.Attributes.concurrent)
    fileprivate var localTemplates = [TemplateModel]()
    fileprivate var onlineTemplates = [TemplateModel]()
    fileprivate var selectedTask: RetrieveDataTask?
    
    deinit {
        debug_print("\(#file) deinit", context: deinitContext)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        
        setup()
    }
    
    func defaultSelected() {
        DispatchQueue.main.async {[weak self] in
            guard let sf = self else {return}
            if sf.collectionView.dataSource?.collectionView(sf.collectionView, numberOfItemsInSection: 0) > 0 {
                sf.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionViewScrollPosition())
            }
        }
    }
    
    func updateCurrentOriginImage(_ image: UIImage?) {
        originImage = image
        DispatchQueue.main.async { [weak self] in
            guard let sf = self else {return}
            if sf.collectionView.dataSource?.collectionView(sf.collectionView, numberOfItemsInSection: 0) > 0 {
                sf.collectionView.reloadData()
                DispatchQueue.main.async(execute: {
                    if let selectedItem = sf.collectionView.indexPathsForSelectedItems?.first {
                        sf.collectionView.selectItem(at: selectedItem, animated: false, scrollPosition: UICollectionViewScrollPosition())
                    } else {
                        sf.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionViewScrollPosition())
                    }
                })
            }
        }
    }
    
    func updateFirst() {
        let selected = collectionView.indexPathsForSelectedItems?.first?.item
        if collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0) > 0 {
            collectionView.reloadData()
//            collectionView.reloadItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
            if selected == 0 {
                collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionViewScrollPosition())
            }
        }
    }
    
    fileprivate func setup() {
        
        queue.async {[weak self] in
            guard let sf = self else { return }
            let templatesURL = Bundle.main.bundleURL.appendingPathComponent("Templates").appendingPathComponent("Templates.json")
            if let data = try? Data(contentsOf: templatesURL), let ms = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [[String: AnyObject]] {
                
                for m in ms {
                    if let t = TemplateModel(m) {
                        sf.localTemplates.append(t)
                    }
                }
            }
            
            let template = TemplateModel.placeholder()
            sf.localTemplates.insert(template, at: 0)
            
            DispatchQueue.main.async(execute: {
                sf.collectionView.reloadData()
                DispatchQueue.main.async(execute: {
                    sf.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionViewScrollPosition())
                })
            })
        }
        
    }
}

// MARK: - CollectionViewDataSource
extension CTATempateListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = localTemplates.count
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TemplateImgCell", for: indexPath)
        
        if let imageView = cell.contentView.viewWithTag(1000) as? UIImageView {
            if indexPath.item == 0 {
                imageView.image = originImage
                
            } else if indexPath.item < localTemplates.count {
                let temp = localTemplates[indexPath.item]
                let localDir = Bundle.main.bundlePath + "/" + "Templates" + "/"
                let imagePath = localDir + temp.thumbImgPath
                let img = UIImage(contentsOfFile: imagePath)
                imageView.image = img
                
            } else {
                let temp = onlineTemplates[indexPath.item - localTemplates.count]
                let host = ""
                let imagePath = host + temp.thumbImgPath
                let options = [KingfisherOptionsInfoItem.transition(.fade(0.3))]
                imageView.kf.setImage(with: URL(string: imagePath)!, placeholder: nil, options: options)
            }
        }
        
        if cell.selectedBackgroundView == nil {
            let v = UIView(frame: cell.bounds)
            v.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            cell.selectedBackgroundView = v
            cell.bringSubview(toFront: cell.selectedBackgroundView!)
        }
        
        return cell
    }
}


// MARK: - CollectionViewDeleagte
extension CTATempateListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 {
            if let preTask = selectedTask {
                preTask.cancel()
                selectedTask = nil
            }
            selectedHandler?(nil, true)
            
        } else { if indexPath.item < localTemplates.count {
            let temp = localTemplates[indexPath.item]
            let localDir = Bundle.main.bundlePath + "/" + "Templates" + "/"
            let pagePath = localDir + temp.pagePath
            let data = try? Data(contentsOf: URL(fileURLWithPath: pagePath))
            if let preTask = selectedTask {
                preTask.cancel()
                selectedTask = nil
            }
            selectedHandler?(data, false)
            
        } else {
            let temp = localTemplates[indexPath.item]
            let host = ""
            let pagePath = host + temp.pagePath
            let task = BlackCatManager.sharedManager.retrieveDataWithURL(URL(string: pagePath)!, optionsInfo: nil, progressBlock: nil, completionHandler: {[weak self] (data, error, cacheType, URL) in
                guard let sf = self else {return }
                sf.selectedHandler?(data, false)
                })
            if let preTask = selectedTask {
                preTask.cancel()
                selectedTask = task
            }
            }
        }
    }
}
