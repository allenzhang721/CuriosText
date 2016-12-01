//
//  CTAScrollSelectView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/8/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAScrollSelectView: UIControl {

    fileprivate var collectionView: UICollectionView!
    var indexPath: IndexPath?
    
    init(frame: CGRect, direction: UICollectionViewScrollDirection) {
        super.init(frame: frame)
        setup(direction)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ direction: UICollectionViewScrollDirection) {
        let lineLayout = CTALineFlowLayout()
        lineLayout.delegate = self
        lineLayout.scrollDirection = direction
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), collectionViewLayout: lineLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "FontFamilyCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
//        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.dataSource = self
        addSubview(collectionView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CTAScrollSelectView.tap(_:)))
        addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    
    func tap(_ sender: UITapGestureRecognizer) {
        
        sendActions(for: .valueChanged)
    }

}

extension CTAScrollSelectView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FontFamilyCell", for: indexPath)
        
        cell.backgroundColor = UIColor.black
        return cell
    }
}

extension CTAScrollSelectView: LineFlowLayoutDelegate {
    
    func didChangeTo(_ collectionView: UICollectionView, itemAtIndexPath indexPath: IndexPath, oldIndexPath: IndexPath?) {
        
        self.indexPath = indexPath
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.black
        if let oldIndexPath = oldIndexPath, let oldCell = collectionView.cellForItem(at: oldIndexPath) {
            oldCell.backgroundColor = UIColor.black
        }
        sendActions(for: .valueChanged)
    }
}
