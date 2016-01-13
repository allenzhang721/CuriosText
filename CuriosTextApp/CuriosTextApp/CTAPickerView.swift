//
//  CTAColorPickerView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/12/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

protocol CTAPickerViewDataSource: class {
    
    func pickViewRegisterItemCellClass(view: CTAPickerView) -> (AnyClass?, String)
    func numberOfSectionsInCollectionView(view: CTAPickerView) -> Int
    func pickView(view: CTAPickerView, numberOfItemsAtSection section: Int) -> Int
    func pickView(view: CTAPickerView, configItemCell itemCell: CTAVerticalItemCollectionViewCell, itemAtSection section: Int, ItemAtIndex index: Int)
    
}

final class CTAPickerView: UIControl {
    
    weak var dataSource: CTAPickerViewDataSource?
    
    private var section = 0
    private var item = 0
//    private var currentIndexPath: NSIndexPath?
    private var collectionView: UICollectionView!
    
    var selectedIndexPath: NSIndexPath? {
        get {
            return NSIndexPath(forItem: item, inSection: section)
        }
        
        set {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
        let layout = CTALineFlowLayout()
        layout.showCount = 4
        layout.scrollDirection = .Horizontal
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        addSubview(collectionView)
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        collectionView.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        collectionView.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        collectionView.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        
        collectionView.registerClass(CTASelectorVerticalCell.self, forCellWithReuseIdentifier: "CTAVerticalCell")
        
        layout.delegate = self
        collectionView.dataSource = self
        
    }

}

extension CTAPickerView: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        guard let dataSource = dataSource else {
            return 1
        }
        
        return dataSource.numberOfSectionsInCollectionView(self)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CTAVerticalCell", forIndexPath: indexPath) as! CTASelectorVerticalCell
        
        cell.backgroundColor = (indexPath.section == 0) ? UIColor.yellowColor() : UIColor.blueColor()
        cell.verticalDataSource = self
        cell.verticalDelegate = self
        cell.section = indexPath.section
        cell.register()
        return cell
    }
    
}

// MARK: - Section Cell
extension CTAPickerView: LineFlowLayoutDelegate {
    
    func didChangeTo(collectionView: UICollectionView, itemAtIndexPath indexPath: NSIndexPath, oldIndexPath: NSIndexPath?) {
        
        
        section = indexPath.section
        item = (collectionView.cellForItemAtIndexPath(indexPath) as! CTASelectorVerticalCell).item
        sendActionsForControlEvents(.ValueChanged)
    }
}

extension CTAPickerView: CTASelectorVerticalCellDataSource {
    
    func verticalCellRegisterItemCellClass(cell: CTASelectorVerticalCell) -> (AnyClass?, String) {
        
        return dataSource!.pickViewRegisterItemCellClass(self)
    }
    
    func verticalCell(cell: CTASelectorVerticalCell, numberOfItemsInSection section: Int) -> Int {
        
        guard let dataSource = dataSource else {
            return 0
        }
        
        return dataSource.pickView(self, numberOfItemsAtSection: section)
    }
}


// MARK: - vertical cell
extension CTAPickerView: CTASelectorVerticalCellDelegate {
    
    func verticalCell(cell: CTASelectorVerticalCell, configItemCell itemCell: CTAVerticalItemCollectionViewCell, itemCellForItemAtIndexPath indexPath: NSIndexPath) {
        
        dataSource?.pickView(self, configItemCell: itemCell, itemAtSection: cell.section, ItemAtIndex: indexPath.item)
    }
    
    func verticalCell(cell: CTASelectorVerticalCell, didChangetoItemAtIndexPath indexPath: NSIndexPath, oldIndexPath: NSIndexPath?) {
        
        item = indexPath.item
        sendActionsForControlEvents(.ValueChanged)
    }
}
