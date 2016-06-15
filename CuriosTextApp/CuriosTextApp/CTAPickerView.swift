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
    func pickView(view: CTAPickerView, indexAtSection section: Int) -> Int
}

protocol CTAPickerViewDelegate: class {
    
    func pickView(view: CTAPickerView, itemDidChangedToIndexPath indexPath: NSIndexPath)
    func pickView(view: CTAPickerView, sectionDidChangedToIndexPath indexPath: NSIndexPath)
    
}

final class CTAPickerView: UIControl {
    
    weak var dataSource: CTAPickerViewDataSource?
    weak var delegate: CTAPickerViewDelegate?

    private var currentIndexPath: NSIndexPath?
    private let showCount: Int
    private var section = 0
    private var item = 0
    var collectionView: UICollectionView!
    
    var selectedIndexPath: NSIndexPath? {
        get {
            return NSIndexPath(forItem: item, inSection: section)
        }
        
        set {
            
        }
    }
    
     init(frame: CGRect, showCount: Int = 2) {
        self.showCount = showCount
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        self.showCount = 2
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let layout = CTALineFlowLayout()
        layout.showCount = showCount
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
        collectionView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CTAPickerView.tap(_:)))
        addGestureRecognizer(tap)
    }
    
    func tap(sender: UITapGestureRecognizer) {
        let location = sender.locationInView(collectionView)
        if let indexPath = collectionView.indexPathForItemAtPoint(location) {
            collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
        }
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func didEndDisplay() {
        
        if collectionView.visibleCells().count > 0 {
            
            for cell in collectionView.visibleCells() {
                if let c = cell as? CTASelectorVerticalCell {
                    c.didEndDiplayed()
                }
            }
            
        }
        
    }

    func updateTo(indexPath: NSIndexPath) {
        
        currentIndexPath = indexPath
        let section = NSIndexPath(forItem: 0, inSection: indexPath.section)
        
        if let att = collectionView.layoutAttributesForItemAtIndexPath(section) {
            let center = att.center
            let offset = CGPoint(x: center.x - collectionView.bounds.width / 2.0, y: 0)
            collectionView.setContentOffset(offset, animated: false)

            dispatch_async(dispatch_get_main_queue(), { [weak self] in
                guard let sf = self else { return}
                if let visualCells = sf.collectionView.visibleCells() as? [CTASelectorVerticalCell] where visualCells.count > 0 {
                    
                    for cell in visualCells  {
                        
                        cell.reloadData()
                    }
                }
            })
        }
    }
}

extension CTAPickerView: UICollectionViewDataSource {
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        guard let dataSource = dataSource else {
            return 5
        }
        
        return dataSource.numberOfSectionsInCollectionView(self)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CTAVerticalCell", forIndexPath: indexPath) as! CTASelectorVerticalCell
        
        cell.backgroundColor = UIColor.whiteColor()
        cell.verticalDataSource = self
        cell.verticalDelegate = self
        cell.section = indexPath.section
        cell.register()
        cell.reloadData()
        return cell
    }
}

extension CTAPickerView: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
    }
}

// MARK: - Section Cell
extension CTAPickerView: LineFlowLayoutDelegate {
    
    func didChangeTo(collectionView: UICollectionView, itemAtIndexPath indexPath: NSIndexPath, oldIndexPath: NSIndexPath?) {

        section = indexPath.section
        
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CTASelectorVerticalCell {
            item = cell.item
        }
        
        if let selectedIndexPath = selectedIndexPath {
            delegate?.pickView(self, itemDidChangedToIndexPath: selectedIndexPath)
        }
        
        if let oldIndexPath = oldIndexPath {
             debug_print("picker view did changed from \(oldIndexPath.section) to \(indexPath.section)", context: fdContext)
            
            sendActionsForControlEvents(.ValueChanged)
        }
    }
}

extension CTAPickerView: CTASelectorVerticalCellDataSource {
    
    func verticalCellRegisterItemCellClass(cell: CTASelectorVerticalCell) -> (AnyClass?, String) {
        
        return dataSource!.pickViewRegisterItemCellClass(self)
    }
    
    func verticalCell(cell: CTASelectorVerticalCell, numberOfItemsInSection section: Int) -> Int {
        
        guard let dataSource = dataSource else {
            return 5
        }
        
        return dataSource.pickView(self, numberOfItemsAtSection: section)
    }
    
    func verticalCellBeganIndex(cell: CTASelectorVerticalCell) -> Int {
        
        
        guard let dataSource = dataSource else {
            return 0
        }
        
        
        let item = dataSource.pickView(self, indexAtSection: cell.section)
        debug_print("vertical Cell began At = \(item)", context: colorContext)
        return item
    }
}

// MARK: - vertical cell
extension CTAPickerView: CTASelectorVerticalCellDelegate {
    
    func verticalCell(cell: CTASelectorVerticalCell, configItemCell itemCell: CTAVerticalItemCollectionViewCell, itemCellForItemAtIndexPath indexPath: NSIndexPath) {
        
        dataSource?.pickView(self, configItemCell: itemCell, itemAtSection: cell.section, ItemAtIndex: indexPath.item)
    }
    
    func verticalCell(cell: CTASelectorVerticalCell, didChangetoItemAtIndexPath indexPath: NSIndexPath, oldIndexPath: NSIndexPath?) {
        
        section = cell.section
        item = indexPath.item
        if let selectedIndexPath = selectedIndexPath {
            delegate?.pickView(self, itemDidChangedToIndexPath: selectedIndexPath)
        }
        
        if let oldIndexPath = oldIndexPath {
            debug_print("vertical at Section \(cell.section) did changed from \(oldIndexPath.item) to \(indexPath.item)", context: colorContext)
            
            sendActionsForControlEvents(.ValueChanged)
        }
    }
}
