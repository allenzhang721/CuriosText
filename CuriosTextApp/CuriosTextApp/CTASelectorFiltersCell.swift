//
//  CTASelectorFiltersCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/27/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTASelectorFiltersCell: CTASelectorCell {
    
    weak var target: AnyObject?
    var action: Selector?
    weak var filterManager: FilterManager?
    var image: UIImage?
    var first = true
    
    private weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    deinit {
        print("\(#file) deinit")
    }
    
    private func setup() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 84, height: 84)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.scrollDirection = .Horizontal
        let view = UICollectionView(frame: bounds, collectionViewLayout: layout)
        view.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "FilterPreviewCell")
        contentView.addSubview(view)
        view.backgroundColor = UIColor.whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        view.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        view.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        view.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        
        view.dataSource = self
        view.delegate = self
        collectionView = view
    }
    
    override func willBeDisplayed() {
        if first {
            first = false
            collectionView.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: .None)
        }
    }
    
    //TODO: Reload Data with preview image -- Emiaostein, 6/30/16, 17:38
    func update(image: UIImage?) {
        
    }
    
    override func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        
        self.target = target
        self.action = action
    }
    override func removeAllTarget() {
        target = nil
        action = nil
    }
}

extension CTASelectorFiltersCell: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterManager?.filters.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FilterPreviewCell", forIndexPath: indexPath)
        
        if (cell.contentView.viewWithTag(1000) as? UIImageView) == nil {
            let imgView = UIImageView(frame: cell.contentView.bounds)
            imgView.tag = 1000
            cell.contentView.addSubview(imgView)
        }
        
        if cell.selectedBackgroundView == nil {
            let v = UIView(frame: cell.bounds)
            v.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
            cell.selectedBackgroundView = v
            cell.bringSubviewToFront(cell.selectedBackgroundView!)
        }
        
        if let imgView = cell.contentView.viewWithTag(1000) as? UIImageView, let filter = filterManager?.filters[indexPath.item] {
            let ID = filter.assetIdentifier
            cell.restorationIdentifier = ID
            if let img = filter.image {
                filter.data = nil
               imgView.image = img
            } else {
                if let data = filter.data {
                    if let image = image {
                        filter.createImage(from: image, complation: {[weak cell, weak filter] (img) in
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                if cell?.restorationIdentifier == ID {
                                    filter?.data = nil
                                    (cell?.viewWithTag(1000) as! UIImageView).image = img
                                    
                                }
                            })
                        })
                    }
                } else {
                    let bundle = NSBundle.mainBundle().bundleURL
                    if let image = image {
                        let ID = filter.assetIdentifier
                        cell.restorationIdentifier = ID
                       filter.createData(fromColorDirAt: bundle, filtering: image, complation: { [weak cell, weak filter] (filteredIamge) in
                        dispatch_async(dispatch_get_main_queue(), {
                            if cell?.restorationIdentifier == ID {
                                filter?.data = nil
                                (cell?.viewWithTag(1000) as! UIImageView).image = filteredIamge
                            }
                        })
                       })
                    }
                }
            }
        }
        
        return cell
    }
}

extension CTASelectorFiltersCell: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let filter = filterManager?.filters[indexPath.item] {
            let name = filter.name
            
            if let target = target, action = action {
                target.performSelector(action, withObject: name)
            }
        }
    }
}

extension CTASelectorFiltersCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: NSIndexPath) -> CGSize {
        let s = CGFloat(2) // insets
        let n = CGFloat(1) // column or row
        let l = (bounds.height - s * 2 - s * (n - 1)) / n
        return CGSize(width: l, height: l)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let s = CGFloat(2)
        return UIEdgeInsets(top: s, left: s, bottom: s, right: s)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
