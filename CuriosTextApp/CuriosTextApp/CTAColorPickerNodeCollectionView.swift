//
//  CTAColorPickerNodeCollectionView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 5/31/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAColorPickerNodeCollectionView: UIControl {
 
    fileprivate(set) var selectedColor: UIColor?
    var collectionView: UICollectionView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func willBeganDisplay() {
        if let color = selectedColor {
            if let indexPath = CTAColorsManger.indexPathOfColor(color.toHex().0) {
                collectionView.scrollToItem(at: IndexPath(item: indexPath.section, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
            }
        }
    }
    
    func selectColor(_ color: UIColor?) {
        selectedColor = color
        
        for cell in collectionView.visibleCells {
            if let colorPicker = cell.contentView.viewWithTag(1000) as? CTAColorPickerNodeView {
                colorPicker.changedToColor(selectedColor)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
        let layout = ColorPickerLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let ratio = CGFloat(0.8)
        let lastRatio = 1 - ratio
        layout.itemSize = CGSize(width: bounds.width * ratio, height: bounds.height)
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: bounds.width * lastRatio / 2.0, bottom: 0, right: bounds.width * lastRatio / 2.0)
    }
    
    func colorChanged(_ sender: CTAColorPickerNodeView) {
        selectedColor = sender.selectedColor
        
        for c in collectionView.visibleCells {
            if let colorPickerNodeView = c.viewWithTag(1000) as? CTAColorPickerNodeView {
                colorPickerNodeView.changedToColor(sender.selectedColor)
            }
        }
        
        sendActions(for: .valueChanged)
    }
}

extension CTAColorPickerNodeCollectionView: UICollectionViewDataSource {
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CTAColorsManger.colorsCatagory.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        if cell.contentView.viewWithTag(1000) == nil {
            let colors: [UIColor] = {
                var c = [UIColor]()
                for _ in 0..<9 {
                    c.append(UIColor(red: 0, green: 0, blue: 0, alpha: 1))
                }
                return c
            }()
            let colorPickNodeView = CTAColorPickerNodeView(frame: cell.bounds, colors: colors)
            colorPickNodeView.backgroundColor = UIColor.white
            colorPickNodeView.tag = 1000
            colorPickNodeView.addTarget(self, action: #selector(CTAColorPickerNodeCollectionView.colorChanged(_:)), for: UIControlEvents.touchUpInside)
            cell.contentView.addSubview(colorPickNodeView)
            cell.backgroundColor = UIColor.white
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
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint)
        -> CGPoint {
            guard let collectionView = collectionView else {
                return proposedContentOffset
            }
            
            switch scrollDirection {
            case .horizontal:
                
                var adjustOffset = CGFloat.greatestFiniteMagnitude
                let visualCenter = CGPoint(
                    x: proposedContentOffset.x + collectionView.bounds.width / 2.0,
                    y: proposedContentOffset.y + collectionView.bounds.height / 2.0)
                let targetRect = CGRect(origin: proposedContentOffset, size: collectionView.bounds.size)
                
                guard let attributes = layoutAttributesForElements(in: targetRect) else {
                    return proposedContentOffset
                }
                
                let centerXs = attributes.map{$0.center.x}
                if fabs(velocity.x) == 0 {
                    for x in centerXs {
                        let adjust = x - visualCenter.x
                        if fabs(adjust) < fabs(adjustOffset) {
                            adjustOffset = adjust
                        }
                    }
                } else {
                    if velocity.x < 0 {
                        adjustOffset = 0
                        for x in centerXs {
                            let adjust = x - visualCenter.x
                            if adjust < adjustOffset {
                                adjustOffset = adjust
                            }
                        }
                    } else {
                        adjustOffset = 0
                        for x in centerXs {
                            let adjust = x - visualCenter.x
                            if adjust > adjustOffset {
                                adjustOffset = adjust
                            }
                        }
                    }
                }
                
                let offset = adjustOffset < 0 ? adjustOffset : adjustOffset
                let point = CGPoint(x: proposedContentOffset.x + offset, y: proposedContentOffset.y)
                //                collectionView.setContentOffset(point, animated: false)
                return point
                
                
            case .vertical:
                
                var adjustOffset = CGFloat.greatestFiniteMagnitude
                let visualCenter = CGPoint(
                    x: proposedContentOffset.x + collectionView.bounds.width / 2.0,
                    y: proposedContentOffset.y + collectionView.bounds.height / 2.0)
                let targetRect = CGRect(origin: proposedContentOffset, size: collectionView.bounds.size)
                
                guard let attributes = layoutAttributesForElements(in: targetRect) else {
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
