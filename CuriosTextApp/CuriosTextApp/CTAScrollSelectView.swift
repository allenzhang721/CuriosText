//
//  CTAScrollSelectView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/8/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAScrollSelectView: UIControl {

    private var collectionView: UICollectionView!
    var indexPath: NSIndexPath?
    
    init(frame: CGRect, direction: UICollectionViewScrollDirection) {
        super.init(frame: frame)
        setup(direction)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(direction: UICollectionViewScrollDirection) {
        let lineLayout = CTALineFlowLayout()
        lineLayout.delegate = self
        lineLayout.scrollDirection = direction
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), collectionViewLayout: lineLayout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "FontFamilyCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
//        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.dataSource = self
        addSubview(collectionView)
        
        let tap = UITapGestureRecognizer(target: self, action: "tap:")
        addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    
    func tap(sender: UITapGestureRecognizer) {
        
        sendActionsForControlEvents(.ValueChanged)
    }

}

extension CTAScrollSelectView: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FontFamilyCell", forIndexPath: indexPath)
        
        cell.backgroundColor = CTAStyleKit.black8
        return cell
    }
}

extension CTAScrollSelectView: LineFlowLayoutDelegate {
    
    func didChangeTo(collectionView: UICollectionView, itemAtIndexPath indexPath: NSIndexPath, oldIndexPath: NSIndexPath?) {
        
        self.indexPath = indexPath
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = CTAStyleKit.black7
        if let oldIndexPath = oldIndexPath, let oldCell = collectionView.cellForItemAtIndexPath(oldIndexPath) {
            oldCell.backgroundColor = CTAStyleKit.black8
        }
        sendActionsForControlEvents(.ValueChanged)
    }
}
