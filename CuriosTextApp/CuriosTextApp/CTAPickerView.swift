//
//  CTAColorPickerView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/12/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

protocol CTAPickerViewDataSource: class {
    
    func pickViewRegisterItemCellClass(_ view: CTAPickerView) -> (AnyClass?, String)
    func numberOfSectionsInCollectionView(_ view: CTAPickerView) -> Int
    func pickView(_ view: CTAPickerView, numberOfItemsAtSection section: Int) -> Int
    func pickView(_ view: CTAPickerView, configItemCell itemCell: CTAVerticalItemCollectionViewCell, itemAtSection section: Int, ItemAtIndex index: Int)
    func pickView(_ view: CTAPickerView, indexAtSection section: Int) -> Int
}

protocol CTAPickerViewDelegate: class {
    
    func pickView(_ view: CTAPickerView, itemDidChangedToIndexPath indexPath: IndexPath)
    func pickView(_ view: CTAPickerView, sectionDidChangedToIndexPath indexPath: IndexPath)
    
}

final class CTAPickerView: UIControl {
    
    weak var dataSource: CTAPickerViewDataSource?
    weak var delegate: CTAPickerViewDelegate?

    fileprivate var currentIndexPath: IndexPath?
    fileprivate let showCount: Int
    fileprivate var section = 0
    fileprivate var item = 0
    var collectionView: UICollectionView!
    
    var selectedIndexPath: IndexPath? {
        get {
            return IndexPath(item: item, section: section)
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
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        addSubview(collectionView)
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        collectionView.register(CTASelectorVerticalCell.self, forCellWithReuseIdentifier: "CTAVerticalCell")
        
        layout.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CTAPickerView.tap(_:)))
        addGestureRecognizer(tap)
    }
    
    func tap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location) {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func didEndDisplay() {
        
        if collectionView.visibleCells.count > 0 {
            
            for cell in collectionView.visibleCells {
                if let c = cell as? CTASelectorVerticalCell {
                    c.didEndDiplayed()
                }
            }
            
        }
        
    }

    func updateTo(_ indexPath: IndexPath) {
        
        currentIndexPath = indexPath
        let section = IndexPath(item: 0, section: indexPath.section)
        
        if let att = collectionView.layoutAttributesForItem(at: section) {
            let center = att.center
            let offset = CGPoint(x: center.x - collectionView.bounds.width / 2.0, y: 0)
            collectionView.setContentOffset(offset, animated: false)

            DispatchQueue.main.async(execute: { [weak self] in
                guard let sf = self else { return}
                if let visualCells = sf.collectionView.visibleCells as? [CTASelectorVerticalCell], visualCells.count > 0 {
                    
                    for cell in visualCells  {
                        
                        cell.reloadData()
                    }
                }
            })
        }
    }
}

extension CTAPickerView: UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        guard let dataSource = dataSource else {
            return 5
        }
        
        return dataSource.numberOfSectionsInCollectionView(self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CTAVerticalCell", for: indexPath) as! CTASelectorVerticalCell
        
        cell.backgroundColor = UIColor.white
        cell.verticalDataSource = self
        cell.verticalDelegate = self
        cell.section = indexPath.section
        cell.register()
        cell.reloadData()
        return cell
    }
}

extension CTAPickerView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
}

// MARK: - Section Cell
extension CTAPickerView: LineFlowLayoutDelegate {
    
    func didChangeTo(_ collectionView: UICollectionView, itemAtIndexPath indexPath: IndexPath, oldIndexPath: IndexPath?) {

        section = indexPath.section
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CTASelectorVerticalCell {
            item = cell.item
        }
        
        if let selectedIndexPath = selectedIndexPath {
            delegate?.pickView(self, itemDidChangedToIndexPath: selectedIndexPath)
        }
        
        if let oldIndexPath = oldIndexPath {
             debug_print("picker view did changed from \(oldIndexPath.section) to \(indexPath.section)", context: fdContext)
            
            sendActions(for: .valueChanged)
        }
    }
}

extension CTAPickerView: CTASelectorVerticalCellDataSource {
    
    func verticalCellRegisterItemCellClass(_ cell: CTASelectorVerticalCell) -> (AnyClass?, String) {
        
        return dataSource!.pickViewRegisterItemCellClass(self)
    }
    
    func verticalCell(_ cell: CTASelectorVerticalCell, numberOfItemsInSection section: Int) -> Int {
        
        guard let dataSource = dataSource else {
            return 5
        }
        
        return dataSource.pickView(self, numberOfItemsAtSection: section)
    }
    
    func verticalCellBeganIndex(_ cell: CTASelectorVerticalCell) -> Int {
        
        
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
    
    func verticalCell(_ cell: CTASelectorVerticalCell, configItemCell itemCell: CTAVerticalItemCollectionViewCell, itemCellForItemAtIndexPath indexPath: IndexPath) {
        
        dataSource?.pickView(self, configItemCell: itemCell, itemAtSection: cell.section, ItemAtIndex: indexPath.item)
    }
    
    func verticalCell(_ cell: CTASelectorVerticalCell, didChangetoItemAtIndexPath indexPath: IndexPath, oldIndexPath: IndexPath?) {
        
        section = cell.section
        item = indexPath.item
        if let selectedIndexPath = selectedIndexPath {
            delegate?.pickView(self, itemDidChangedToIndexPath: selectedIndexPath)
        }
        
        if let oldIndexPath = oldIndexPath {
            debug_print("vertical at Section \(cell.section) did changed from \(oldIndexPath.item) to \(indexPath.item)", context: colorContext)
            
            sendActions(for: .valueChanged)
        }
    }
}
