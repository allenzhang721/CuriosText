//
//  CTASelectorVerticalCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/12/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

protocol CTASelectorVerticalCellDataSource: class {
    func verticalCellRegisterItemCellClass(_ cell: CTASelectorVerticalCell) -> (AnyClass?, String)
    func verticalCell(_ cell: CTASelectorVerticalCell, numberOfItemsInSection section: Int) -> Int
    func verticalCellBeganIndex(_ cell: CTASelectorVerticalCell) -> Int
}

protocol CTASelectorVerticalCellDelegate: class {
    func verticalCell(_ cell: CTASelectorVerticalCell, configItemCell itemCell: CTAVerticalItemCollectionViewCell, itemCellForItemAtIndexPath indexPath: IndexPath)
    
    func verticalCell(_ cell: CTASelectorVerticalCell, didChangetoItemAtIndexPath indexPath: IndexPath, oldIndexPath: IndexPath?)
}

final class CTASelectorVerticalCell: CTASelectorCell {
    
    var actived: Bool = false
    
    weak var verticalDataSource: CTASelectorVerticalCellDataSource!
    weak var verticalDelegate: CTASelectorVerticalCellDelegate?
    var collectionView: UICollectionView!
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
    
    func updateTo(_ item: Int) {
        
        let indexPath = IndexPath(item: item, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
    }
    
    override func didEndDiplayed() {
//        actived = false
    }
    
    fileprivate func setup() {
        
        let layout = CTALineFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        contentView.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        collectionView.dataSource = self
        layout.delegate = self
    }
    
    func register() {
        
        if let cellClass = verticalDataSource?.verticalCellRegisterItemCellClass(self) {
            cellIdentifier = cellClass.1
            collectionView.register(cellClass.0, forCellWithReuseIdentifier: cellIdentifier)
        } else {
            cellIdentifier = "VerticalEmptyCell"
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        }
    }
    
    func reloadData() {
        collectionView.reloadData()
        
        if let index = verticalDataSource?.verticalCellBeganIndex(self) {
            debug_print("verticalCell reloadData and will scroll to item = \(index)", context: colorContext)
            DispatchQueue.main.async(execute: { [weak self] () -> Void in
                if let sf = self {
                    
                    sf.load(index)
                }
            })
            
        }
    }
    
    fileprivate func load(_ index: Int) {
        
        let items = collectionView(collectionView, numberOfItemsInSection: 0)
        let next = min(index, items - 1)
        
        collectionView?.scrollToItem(at: IndexPath(item: next, section: 0), at: .centeredVertically, animated: false)
        
        DispatchQueue.main.async { [weak self] in
            if let sf = self {
                sf.alpha = sf.actived ? 1.0 : 0.8
                
                if let cells = sf.collectionView.visibleCells as? [CTAVerticalItemCollectionViewCell] {
                    
                    for cell in cells {
                        cell.update()
                    }
                }
            }
        }
        
//        guard let attribute = collectionView?.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) else {
//            return
//        }
//            let center = attribute.center
//            collectionView.setContentOffset(CGPoint(x: 0, y: center.y - collectionView.bounds.height / 2.0), animated: false)
    }
    
    // 没有产生 boundsChange，就不会调用
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        
        super.apply(layoutAttributes)
        
        guard let layoutAttributes = layoutAttributes as? CollectionViewAttributes else {
            return
        }
        
        if actived {
            alpha = 1.0
        } else {
            alpha = 0.8
        }
        
        if actived != layoutAttributes.actived {
            actived = layoutAttributes.actived
            
            DispatchQueue.main.async(execute: {[weak self] in
                
                if let sf = self {
                    sf.alpha = sf.actived ? 1.0 : 0.8
                    
                    if let cells = sf.collectionView.visibleCells as? [CTAVerticalItemCollectionViewCell] {
                        
                        for cell in cells {
                            cell.update()
                        }
                    }
                }
//                UIView.transitionWithView(self, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {[weak self] () -> Void in
//                    
//                    if let sr = self {
//                        sr.alpha = sr.actived ? 1.0 : 0.8
//                        
//                        if let cells = sr.collectionView.visibleCells() as? [CTAVerticalItemCollectionViewCell] {
//                            
//                            for cell in cells {
//                                cell.update()
//                            }
//                        }
//                    }
//                    
//                    }, completion: nil)
            })
        }
    }
}

extension CTASelectorVerticalCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let verticalDataSource = verticalDataSource else {
            return 5
        }
        
        let items = verticalDataSource.verticalCell(self, numberOfItemsInSection: self.section)
        
        return items
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell
        
        if let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CTAVerticalItemCollectionViewCell {
            cell = aCell
            
            aCell.delegate = self
//            aCell.actived = false
            if let verticalDelegate = verticalDelegate {
                verticalDelegate.verticalCell(self, configItemCell: aCell, itemCellForItemAtIndexPath: indexPath)
            }
            
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        }
        
        return cell
    }
}

extension CTASelectorVerticalCell: CTAVerticalItemCollectionViewCellDelegate {
    
    func itemCellSuperActived(_ cell: CTAVerticalItemCollectionViewCell) -> Bool {
        return actived
    }
}


extension CTASelectorVerticalCell: LineFlowLayoutDelegate {
    
    func didChangeTo(_ collectionView: UICollectionView, itemAtIndexPath indexPath: IndexPath, oldIndexPath: IndexPath?) {
        
        item = indexPath.item
        guard let verticalDelegate = verticalDelegate, let _ = oldIndexPath, actived == true else {
            return
        }
 
        verticalDelegate.verticalCell(self, didChangetoItemAtIndexPath: indexPath, oldIndexPath: oldIndexPath)
    }
}
