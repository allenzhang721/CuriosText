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
    
    fileprivate weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    deinit {
        debug_print("\(#file) deinit", context: deinitContext)
    }
    
    fileprivate func setup() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 84, height: 84)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 2, left: 20, bottom: 2, right: 20)
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: bounds, collectionViewLayout: layout)
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "FilterPreviewCell")
        contentView.addSubview(view)
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        view.dataSource = self
        view.delegate = self
        collectionView = view
    }
    
    override func willBeDisplayed() {
        if first {
            first = false
            let index = dataSource?.selectorBeganFilter(self) ?? 0
            DispatchQueue.main.async(execute: { [weak self] in
                self?.collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            })
        } else {
            reloadData()
        }
    }
    
    //TODO: Reload Data with preview image -- Emiaostein, 6/30/16, 17:38
    func update(_ image: UIImage?) {
        self.image = image
        filterManager?.cleanImage()
        reloadData()
    }
    
    fileprivate func reloadData() {
        let selected = collectionView.indexPathsForSelectedItems?.first?.item
        collectionView.reloadData()
        if let s = selected {
            collectionView.selectItem(at: IndexPath(item: s, section: 0), animated: false, scrollPosition: UICollectionViewScrollPosition())
        }
    }
    
    override func addTarget(_ target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        
        self.target = target
        self.action = action
    }
    override func removeAllTarget() {
        target = nil
        action = nil
    }
}

extension CTASelectorFiltersCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterManager?.filters.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterPreviewCell", for: indexPath)
        
        if (cell.contentView.viewWithTag(1000) as? UIImageView) == nil {
            let imgView = UIImageView(frame: cell.contentView.bounds)
            imgView.tag = 1000
            imgView.clipsToBounds = true
            imgView.contentMode = .scaleAspectFill
            cell.contentView.addSubview(imgView)
        }
        
        if cell.selectedBackgroundView == nil {
            let v = UIView(frame: cell.bounds)
            v.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            cell.selectedBackgroundView = v
            cell.bringSubview(toFront: cell.selectedBackgroundView!)
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
                            
                            DispatchQueue.main.async(execute: {
                                if cell?.restorationIdentifier == ID {
                                    filter?.data = nil
                                    (cell?.viewWithTag(1000) as! UIImageView).image = img
                                    
                                }
                            })
                        })
                    }
                } else {
                    let bundle = Bundle.main.bundleURL
                    if let image = image {
                        let ID = filter.assetIdentifier
                        cell.restorationIdentifier = ID
                       filter.createData(fromColorDirAt: bundle, filtering: image, complation: { [weak cell, weak filter] (filteredIamge) in
                        DispatchQueue.main.async(execute: {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let filter = filterManager?.filters[indexPath.item] {
            let name = filter.name
            
            if let target = target, let action = action {
                target.perform(action, with: name)
            }
        }
    }
}

extension CTASelectorFiltersCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let s = CGFloat(2) // insets
        let n = CGFloat(1) // column or row
        let l = (bounds.height - s * 2 - s * (n - 1)) / n
        return CGSize(width: l, height: l)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let s = CGFloat(2)
        return UIEdgeInsets(top: s, left: s, bottom: s, right: s)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
