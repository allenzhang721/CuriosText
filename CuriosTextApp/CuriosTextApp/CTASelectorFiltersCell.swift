//
//  CTASelectorFiltersCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/27/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTASelectorFiltersCell: CTASelectorCell {
    
    private var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        let layout = UICollectionViewFlowLayout()
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
    }
}

extension CTASelectorFiltersCell: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FilterPreviewCell", forIndexPath: indexPath)
        
        if (cell.contentView.viewWithTag(1000) as? UIImageView) == nil {
            let imgView = UIImageView(frame: cell.contentView.bounds)
            imgView.tag = 1000
            cell.contentView.addSubview(imgView)
        }
        
        if let imgView = cell.contentView.viewWithTag(1000) as? UIImageView {
            
            imgView.backgroundColor = UIColor.redColor()
        }
        
        return cell
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
