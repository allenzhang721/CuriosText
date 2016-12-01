//
//  CTACollectionViewActiveFlowLayout.swift
//  ImagePickerApp
//
//  Created by Emiaostein on 2/28/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import UIKit

class CTAActiveCollectionViewAttributes: UICollectionViewLayoutAttributes {
    
    var actived: Bool = false
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? CTAActiveCollectionViewAttributes else {
            return false
        }
        return super.isEqual(object) && actived == object.actived
    }
    
    override func copy(with zone: NSZone?) -> Any {
        let copy = super.copy(with: zone) as! CTAActiveCollectionViewAttributes
        copy.actived = actived
        return copy
    }
}

class CTACollectionViewActiveFlowLayout: UICollectionViewFlowLayout {

    var showCount: Int = 6
    var didChangedHandler: ((_ collectionView: UICollectionView, _ indexPath: IndexPath, _ oldIndexPath: IndexPath?) -> ())?
    fileprivate var currentIndexPath: IndexPath?
    
    override class var layoutAttributesClass : AnyClass {
        return CTAActiveCollectionViewAttributes.self
    }
    
    override var collectionViewContentSize : CGSize {
        let size = super.collectionViewContentSize
        return size
    }
    
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        scrollDirection = .horizontal
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        switch scrollDirection {
        case .horizontal:
            let colSize = collectionView.bounds.size
            itemSize =
                CGSize(
                    width: colSize.width / CGFloat(showCount),
                    height: colSize.height)
            let top = (colSize.height - itemSize.height) / 2.0
            let left = (colSize.width - itemSize.width) / 2.0
            let bottom = top
            let right = left
            
            collectionView.contentInset =
                UIEdgeInsets(
                    top: top,
                    left: left,
                    bottom: bottom,
                    right: right)
            
        case .vertical:
            let colSize = collectionView.bounds.size
            itemSize =
                CGSize(
                    width: colSize.width,
                    height: colSize.height / CGFloat(showCount))
            let top = (colSize.height - itemSize.height) / 2.0
            let left = (colSize.width - itemSize.width) / 2.0
            let bottom = top
            let right = left
            
            collectionView.contentInset =
                UIEdgeInsets(
                    top: top,
                    left: left,
                    bottom: bottom,
                    right: right)
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let collectionView = collectionView, let attributes = super.layoutAttributesForElements(in: rect) as? [CTAActiveCollectionViewAttributes] else {
            return nil
        }
        
        switch scrollDirection {
        case .horizontal:
            
            let visualRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
            let activeDistance: CGFloat = itemSize.width / 2.0
            
            for attribute in attributes {
                if attribute.frame.intersects(rect) {
                    let distance = fabs((attribute.center.x - visualRect.midX))
                    if distance < activeDistance {
                        if currentIndexPath != attribute.indexPath {
                            if currentIndexPath != nil {
                                didChangedHandler?(collectionView, attribute.indexPath, currentIndexPath)
//                                delegate?.didChangeTo(collectionView, itemAtIndexPath: attribute.indexPath, oldIndexPath: currentIndexPath)
                            }
                            currentIndexPath = attribute.indexPath
                        }
                        attribute.actived = true
                    } else {
                        attribute.actived = false
                    }
                }
            }
            
        case .vertical:
            
            let visualRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
            let activeDistance: CGFloat = itemSize.height / 2.0
            
            for attribute in attributes {
                if attribute.frame.intersects(rect) {
                    let distance = fabs((attribute.center.y - visualRect.midY))
                    if distance < activeDistance {
                        if currentIndexPath != attribute.indexPath {
                            if currentIndexPath != nil {
                                didChangedHandler?(collectionView, attribute.indexPath, currentIndexPath)
                            }
                            currentIndexPath = attribute.indexPath
                        }
                        attribute.actived = true
                    } else {
                        attribute.actived = false
                    }
                }
            }
        }
        return attributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        
        guard let collectionView = collectionView else {
            return proposedContentOffset
        }
        
        switch scrollDirection {
        case .horizontal:
            
            var adjustOffset = CGFloat.greatestFiniteMagnitude
            let visualCenter =
                CGPoint(
                    x: proposedContentOffset.x + collectionView.bounds.width / 2.0,
                    y: proposedContentOffset.y + collectionView.bounds.height / 2.0)
            let targetRect = CGRect(origin: proposedContentOffset, size: collectionView.bounds.size)
            
            guard let attributes = layoutAttributesForElements(in: targetRect) else {
                return proposedContentOffset
            }
            
            let centerXs = attributes.map{$0.center.x}
            for x in centerXs {
                let adjust = x - visualCenter.x
                if fabs(adjust) < fabs(adjustOffset) {
                    adjustOffset = adjust
                }
            }
            return CGPoint(x: proposedContentOffset.x + adjustOffset, y: proposedContentOffset.y)
            
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
                for x in centerXs {
                    let adjust = x - visualCenter.x
                    if fabs(adjust) < fabs(adjustOffset) {
                        adjustOffset = adjust
                    }
                }
                return CGPoint(x: proposedContentOffset.x + adjustOffset, y: proposedContentOffset.y)
                
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
