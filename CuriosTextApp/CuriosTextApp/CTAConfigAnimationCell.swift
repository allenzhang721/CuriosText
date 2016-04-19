//
//  CTAConfigAnimationCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/31/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

protocol CTAConfigANimationCellDataSource: class {
    
    func configAnimationCellBeganIndexPath(cell: CTAConfigAnimationCell) -> NSIndexPath
}

protocol CTAConfigAnimationCellDelegate: class {
    
    func configAnimationCell(cell: CTAConfigAnimationCell, DidSelectedIndexPath indexPath: NSIndexPath, oldIndexPath: NSIndexPath?)
}

class CTAConfigAnimationCell: CTAConfigCell {

    var collectionView: UICollectionView!
    weak var dataSource: CTAConfigANimationCellDataSource?
    weak var delegate: CTAConfigAnimationCellDelegate?
    private var selectedTaping = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        let lineLayout = CTALineFlowLayout()
        lineLayout.delegate = self
        lineLayout.showCount = 4
        lineLayout.scrollDirection = .Horizontal
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: lineLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(CTAAnimationNameCell.self, forCellWithReuseIdentifier: "AnimatoinCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        collectionView.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        collectionView.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        collectionView.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
//        collectionView.reloadData()
    }
}

extension CTAConfigAnimationCell: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return CTAAnimationName.names.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AnimatoinCell", forIndexPath: indexPath) as! CTAAnimationNameCell
        
        cell.text = CTAAnimationName.names[indexPath.item].description
        
        return cell
    }
}

extension CTAConfigAnimationCell: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let att = collectionView.layoutAttributesForItemAtIndexPath(indexPath) {
            selectedTaping = true
            let center = att.center
            let offset = CGPoint(x: center.x - collectionView.bounds.width / 2.0, y: 0)
            collectionView.setContentOffset(offset, animated: true)
//            delegate?.tabViewController(self, didChangedToIndexPath: indexPath, oldIndexPath: nil)
        }
    }
}

extension CTAConfigAnimationCell: LineFlowLayoutDelegate {
    
    func didChangeTo(collectionView: UICollectionView, itemAtIndexPath indexPath: NSIndexPath, oldIndexPath: NSIndexPath?) {

        if collectionView.dragging || collectionView.decelerating || collectionView.tracking || selectedTaping {
            selectedTaping = false
            delegate?.configAnimationCell(self, DidSelectedIndexPath: indexPath, oldIndexPath: oldIndexPath)
        }
        
    }
}

extension CTAConfigAnimationCell: CTACellDisplayProtocol {
    
    func willBeDisplayed() {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            
            if let strongSelf = self {
                let beganIndexPath = strongSelf.dataSource?.configAnimationCellBeganIndexPath(strongSelf) ?? NSIndexPath(forItem: 2, inSection: 0)
                
                if let acenter = strongSelf.collectionView.collectionViewLayout.layoutAttributesForItemAtIndexPath(beganIndexPath)?.center {
                    strongSelf.collectionView.setContentOffset(CGPoint(x: acenter.x - strongSelf.bounds.width / 2.0, y: 0), animated: false)
                }
            }
        }
//        collectionView.scrollToItemAtIndexPath(beganIndexPath, atScrollPosition: .CenteredHorizontally, animated: false)
    }
    
    func didEndDisplayed() {
        dataSource = nil
        delegate = nil
    }
}
