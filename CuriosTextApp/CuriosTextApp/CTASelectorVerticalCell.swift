//
//  CTASelectorVerticalCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/12/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

protocol CTASelectorVerticalCellDataSource: class {
    func verticalCellRegisterItemCellClass(cell: CTASelectorVerticalCell) -> (AnyClass?, String)
    func verticalCell(cell: CTASelectorVerticalCell, numberOfItemsInSection section: Int) -> Int
    
}

protocol CTASelectorVerticalCellDelegate: class {
    func verticalCell(cell: CTASelectorVerticalCell, configItemCell itemCell: CTAVerticalItemCollectionViewCell, itemCellForItemAtIndexPath indexPath: NSIndexPath)
    
    func verticalCell(cell: CTASelectorVerticalCell, didChangetoItemAtIndexPath indexPath: NSIndexPath, oldIndexPath: NSIndexPath?)
}

final class CTASelectorVerticalCell: CTASelectorCell {
    
    var actived: Bool = false
    
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
//        collectionView.reloadItemsAtIndexPaths(collectionView.indexPathsForVisibleItems())
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
        
        if let cellClass = verticalDataSource?.verticalCellRegisterItemCellClass(self) {
            cellIdentifier = cellClass.1
            collectionView.registerClass(cellClass.0, forCellWithReuseIdentifier: cellIdentifier)
        } else {
            cellIdentifier = "VerticalEmptyCell"
            collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        }
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        
        super.applyLayoutAttributes(layoutAttributes)
        
        guard let layoutAttributes = layoutAttributes as? CollectionViewAttributes else {
            return
        }
        
        if !actived {
            alpha = 0.8
        } else {
            alpha = 1.0
        }
        
        if actived != layoutAttributes.actived {
            actived = layoutAttributes.actived
            UIView.transitionWithView(self, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {[weak self] () -> Void in
                
                if let sr = self {
                    sr.alpha = sr.actived ? 1.0 : 0.8
                    
                    if let cells = sr.collectionView.visibleCells() as? [CTAVerticalItemCollectionViewCell] {
                        
                        for cell in cells {
                            cell.update()
                        }
                    }
                }
                
                }, completion: nil)
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
        
        if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as? CTAVerticalItemCollectionViewCell {
            cell = aCell
            
            aCell.delegate = self
            
            if let verticalDelegate = verticalDelegate {
                verticalDelegate.verticalCell(self, configItemCell: aCell, itemCellForItemAtIndexPath: indexPath)
            }
            
        } else {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        }
        
        return cell
    }
}

extension CTASelectorVerticalCell: CTAVerticalItemCollectionViewCellDelegate {
    
    func itemCellSuperActived(cell: CTAVerticalItemCollectionViewCell) -> Bool {
        return actived
    }
}


extension CTASelectorVerticalCell: LineFlowLayoutDelegate {
    
    func didChangeTo(collectionView: UICollectionView, itemAtIndexPath indexPath: NSIndexPath, oldIndexPath: NSIndexPath?) {
        
        item = indexPath.item
        
        guard let verticalDelegate = verticalDelegate where actived == true else {
            return
        }
 
        verticalDelegate.verticalCell(self, didChangetoItemAtIndexPath: indexPath, oldIndexPath: oldIndexPath)
    }
}
