//
//  CTAConfigAnimationCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/31/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

protocol CTAConfigANimationCellDataSource: class {
    
    func configAnimationCellBeganIndexPath(_ cell: CTAConfigAnimationCell) -> IndexPath
}

protocol CTAConfigAnimationCellDelegate: class {
    
    func configAnimationCell(_ cell: CTAConfigAnimationCell, DidSelectedIndexPath indexPath: IndexPath, oldIndexPath: IndexPath?)
}

class CTAConfigAnimationCell: CTAConfigCell {

    var collectionView: UICollectionView!
    weak var dataSource: CTAConfigANimationCellDataSource?
    weak var delegate: CTAConfigAnimationCellDelegate?
    fileprivate var selectedTaping = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        
        let lineLayout = CTALineFlowLayout()
        lineLayout.delegate = self
        lineLayout.showCount = 4
        lineLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: lineLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CTAAnimationNameCell.self, forCellWithReuseIdentifier: "AnimatoinCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.backgroundColor = UIColor.white
        contentView.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        collectionView.reloadData()
    }
}

extension CTAConfigAnimationCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return CTAAnimationName.names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimatoinCell", for: indexPath) as! CTAAnimationNameCell
        
        cell.text = CTAAnimationName.names[indexPath.item].description
        
        return cell
    }
}

extension CTAConfigAnimationCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let att = collectionView.layoutAttributesForItem(at: indexPath) {
            selectedTaping = true
            let center = att.center
            let offset = CGPoint(x: center.x - collectionView.bounds.width / 2.0, y: 0)
            collectionView.setContentOffset(offset, animated: true)
//            delegate?.tabViewController(self, didChangedToIndexPath: indexPath, oldIndexPath: nil)
        }
    }
}

extension CTAConfigAnimationCell: LineFlowLayoutDelegate {
    
    func didChangeTo(_ collectionView: UICollectionView, itemAtIndexPath indexPath: IndexPath, oldIndexPath: IndexPath?) {

        if collectionView.isDragging || collectionView.isDecelerating || collectionView.isTracking || selectedTaping {
            selectedTaping = false
            delegate?.configAnimationCell(self, DidSelectedIndexPath: indexPath, oldIndexPath: oldIndexPath)
        }
        
    }
}

extension CTAConfigAnimationCell: CTACellDisplayProtocol {
    
    func willBeDisplayed() {
        DispatchQueue.main.async { [weak self] in
            
            if let strongSelf = self {
                let beganIndexPath = strongSelf.dataSource?.configAnimationCellBeganIndexPath(strongSelf) ?? IndexPath(item: 2, section: 0)
                
                if let acenter = strongSelf.collectionView.collectionViewLayout.layoutAttributesForItem(at: beganIndexPath)?.center {
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
