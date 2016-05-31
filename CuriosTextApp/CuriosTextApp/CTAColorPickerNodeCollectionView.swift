//
//  CTAColorPickerNodeCollectionView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 5/31/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAColorPickerNodeCollectionView: UIControl {
 
    private(set) var selectedColor: UIColor?
    var collectionView: UICollectionView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.dataSource = self
        addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func selectColor(color: UIColor?) {
        selectedColor = color
        
        for cell in collectionView.visibleCells() {
            if let colorPicker = cell.contentView.viewWithTag(1000) as? CTAColorPickerNodeView {
                colorPicker.changedToColor(selectedColor)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
        let layout = ColorPickerLayout()
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        layout.itemSize = CGSize(width: bounds.width * 0.9, height: bounds.height)
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: bounds.width * 0.05, bottom: 0, right: bounds.width * 0.05)
    }
    
    func colorChanged(sender: CTAColorPickerNodeView) {
        selectedColor = sender.selectedColor
        sendActionsForControlEvents(.ValueChanged)
    }
}

extension CTAColorPickerNodeCollectionView: UICollectionViewDataSource {
    
    internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CTAColorsManger.colorsCatagory.count
    }
    
    internal func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
        if cell.contentView.viewWithTag(1000) == nil {
            let colors: [UIColor] = {
                var c = [UIColor]()
                for _ in 0..<9 {
                    c.append(UIColor(red: 0, green: 0, blue: 0, alpha: 1))
                }
                return c
            }()
            let colorPickNodeView = CTAColorPickerNodeView(frame: cell.bounds, colors: colors)
            colorPickNodeView.backgroundColor = UIColor.whiteColor()
            colorPickNodeView.tag = 1000
            colorPickNodeView.addTarget(self, action: #selector(CTAColorPickerNodeCollectionView.colorChanged(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.contentView.addSubview(colorPickNodeView)
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        if let colorPickerNodeView = cell.contentView.viewWithTag(1000) as? CTAColorPickerNodeView {
            let catagory = CTAColorsManger.colorsCatagory[indexPath.item]
            let colors = CTAColorsManger.colors[catagory]!.map{$0.color}
            colorPickerNodeView.changeColors(colors)
            colorPickerNodeView.changedToColor(selectedColor)
        }
        
        return cell
    }
}


// MARK: ---------- Layout ----------
private class ColorPickerLayout: UICollectionViewFlowLayout {
    override func targetContentOffsetForProposedContentOffset(
        proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint)
        -> CGPoint {
            guard let collectionView = collectionView else {
                return proposedContentOffset
            }
            
            switch scrollDirection {
            case .Horizontal:
                
                var adjustOffset = CGFloat.max
                let visualCenter = CGPoint(
                    x: proposedContentOffset.x + CGRectGetWidth(collectionView.bounds) / 2.0,
                    y: proposedContentOffset.y + CGRectGetHeight(collectionView.bounds) / 2.0)
                let targetRect = CGRect(origin: proposedContentOffset, size: collectionView.bounds.size)
                
                guard let attributes = layoutAttributesForElementsInRect(targetRect) else {
                    return proposedContentOffset
                }
                
                let centerXs = attributes.map{$0.center.x}
                for x in centerXs {
                    let adjust = x - visualCenter.x
                    if fabs(adjust) < fabs(adjustOffset) {
                        adjustOffset = adjust
                    }
                }
                let offset = adjustOffset < 0 ? adjustOffset + 0.5 : adjustOffset
                let point = CGPoint(x: proposedContentOffset.x + offset, y: proposedContentOffset.y)
                //                collectionView.setContentOffset(point, animated: false)
                return point
                
                
            case .Vertical:
                
                var adjustOffset = CGFloat.max
                let visualCenter = CGPoint(
                    x: proposedContentOffset.x + CGRectGetWidth(collectionView.bounds) / 2.0,
                    y: proposedContentOffset.y + CGRectGetHeight(collectionView.bounds) / 2.0)
                let targetRect = CGRect(origin: proposedContentOffset, size: collectionView.bounds.size)
                
                guard let attributes = layoutAttributesForElementsInRect(targetRect) else {
                    return proposedContentOffset
                }
                
                let centerYs = attributes.map{$0.center.y}
                for y in centerYs {
                    let adjust = y - visualCenter.y
                    if fabs(adjust) < fabs(adjustOffset) {
                        adjustOffset = adjust
                    }
                }
                return CGPoint(x: proposedContentOffset.x, y: proposedContentOffset.y + adjustOffset)
            }
    }
}