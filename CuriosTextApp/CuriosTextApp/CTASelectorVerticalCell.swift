//
//  CTASelectorVerticalCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/12/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

protocol CTASelectorVerticalCellDataSource: class {
    func verticalCellClass(cell: CTASelectorVerticalCell) -> (AnyClass?, String)
    func verticalCell(cell: CTASelectorVerticalCell, numberOfItemsInSection section: Int) -> Int
    
}

protocol CTASelectorVerticalCellDelegate: class {
    func verticalCell(cell: CTASelectorVerticalCell, configItemCell itemCell: CTAVerticalItemCollectionViewCell, itemCellForItemAtIndexPath indexPath: NSIndexPath)
    
    func verticalCell(cell: CTASelectorVerticalCell, didChangetoIndexPath indexPath: NSIndexPath, oldIndexPath: NSIndexPath?)
}

final class CTASelectorVerticalCell: CTASelectorCell {

    weak var verticalDataSource: CTASelectorVerticalCellDataSource!
    weak var verticalDelegate: CTASelectorVerticalCellDelegate?
    private var collectionView: UICollectionView!
    var cellIdentifier: String!
    var section: Int = 0
    var item: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        setup()
    }
    
    func reload() {
        collectionView.reloadData()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reload()
    }
    
    private func setup() {
        
        let layout = CTALineFlowLayout()
        layout.scrollDirection = .Vertical
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        contentView.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        collectionView.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        collectionView.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        collectionView.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        
        collectionView.dataSource = self
        layout.delegate = self
    }
    
    func register() {
        
        if let cellClass = verticalDataSource?.verticalCellClass(self) {
            cellIdentifier = cellClass.1
            collectionView.registerClass(cellClass.0, forCellWithReuseIdentifier: cellIdentifier)
        } else {
            cellIdentifier = "VerticalEmptyCell"
            collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        }
    }
}

extension CTASelectorVerticalCell: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let verticalDataSource = verticalDataSource else {
            return 0
        }
        
        return verticalDataSource.verticalCell(self, numberOfItemsInSection: section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell
        
        if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as? CTAVerticalItemColorCollectionViewCell {
            cell = aCell
            
            if let verticalDelegate = verticalDelegate {
                verticalDelegate.verticalCell(self, configItemCell: aCell, itemCellForItemAtIndexPath: indexPath)
            }
            
        } else {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        }
        
        return cell
    }
}

extension CTASelectorVerticalCell: LineFlowLayoutDelegate {
    
    func didChangeTo(collectionView: UICollectionView, itemAtIndexPath indexPath: NSIndexPath, oldIndexPath: NSIndexPath?) {
        
        guard let verticalDelegate = verticalDelegate else {
            return
        }
        item = indexPath.item
        verticalDelegate.verticalCell(self, didChangetoIndexPath: indexPath, oldIndexPath: oldIndexPath)
    }
}
