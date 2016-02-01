//
//  CTAConfigAnimationCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/31/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAConfigAnimationCell: CTAConfigCell {

    var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        let lineLayout = CTALineFlowLayout()
        lineLayout.delegate = self
        
        lineLayout.scrollDirection = .Horizontal
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: lineLayout)
        collectionView.dataSource = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "AnimatoinCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        collectionView.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        collectionView.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        collectionView.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
    }

}

extension CTAConfigAnimationCell: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return CTAColorsManger.colors["red"]!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AnimatoinCell", forIndexPath: indexPath)
        
        cell.backgroundColor = CTAColorsManger.colors["red"]![indexPath.item].color
        
        return cell
        
    }
}

extension CTAConfigAnimationCell: LineFlowLayoutDelegate {
    
    func didChangeTo(collectionView: UICollectionView, itemAtIndexPath indexPath: NSIndexPath, oldIndexPath: NSIndexPath?) {
        
        
    }
}
