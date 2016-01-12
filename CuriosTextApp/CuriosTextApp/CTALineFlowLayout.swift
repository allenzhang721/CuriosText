//
//  FlowLayout.swift
//  EditorToolApp
//
//  Created by Emiaostein on 12/28/15.
//  Copyright © 2015 Emiaostein. All rights reserved.
//

import UIKit

class CollectionViewAttributes: UICollectionViewLayoutAttributes {
    
    var actived: Bool = false
    
    override func isEqual(object: AnyObject?) -> Bool {
        
        guard let object = object as? CollectionViewAttributes else {
            return false
        }
        
        return super.isEqual(object) && actived == object.actived
    }
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        
        let copy = super.copyWithZone(zone) as! CollectionViewAttributes
        copy.actived = actived
        return copy
    }
}

protocol LineFlowLayoutDelegate: class {
    
    func didChangeTo(collectionView: UICollectionView, itemAtIndexPath indexPath: NSIndexPath, oldIndexPath: NSIndexPath?)
}

final class CTALineFlowLayout: UICollectionViewFlowLayout {
    
    var showCount: Int = 2
    
    weak var delegate: LineFlowLayoutDelegate?
    
    private var currentIndexPath: NSIndexPath?
    
    override class func layoutAttributesClass() -> AnyClass {
        
        return CollectionViewAttributes.self
    }
    
    override func prepareLayout() {
        
        guard let collectionView = collectionView else {
            return
        }
        
//        scrollDirection = .Horizontal
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        switch scrollDirection {
            
        case .Horizontal:
            let colSize = collectionView.bounds.size
            itemSize = CGSize(width: colSize.width / CGFloat(showCount), height: colSize.height)
            let top = (colSize.height - itemSize.height) / 2.0
            let left = (colSize.width - itemSize.width) / 2.0
            let bottom = top
            let right = left
            
            collectionView.contentInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
            
        case .Vertical:
            let colSize = collectionView.bounds.size
            itemSize = CGSize(width: colSize.width, height: colSize.height / CGFloat(showCount))
            let top = (colSize.height - itemSize.height) / 2.0
            let left = (colSize.width - itemSize.width) / 2.0
            let bottom = top
            let right = left
            
            collectionView.contentInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
            
        }
        
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let collectionView = collectionView, let attributes = super.layoutAttributesForElementsInRect(rect) as? [CollectionViewAttributes] else {
            return nil
        }
        
        switch scrollDirection {
            
        case .Horizontal:
            let visualRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
            //        let minAlpha: CGFloat = 0.6
            //        let minScale: CGFloat = 1.0
            //        let maxScale: CGFloat = 1.4
            let activeDistance: CGFloat = itemSize.width / 2.0
            
            for attribute in attributes {
                if CGRectIntersectsRect(attribute.frame, rect) {
                    
                    
                    let distance = fabs((attribute.center.x - CGRectGetMidX(visualRect)))
                    //                let normalizedDistance = distance / activeDistance
                    if distance < activeDistance {
                        if currentIndexPath != attribute.indexPath {
                            
                            let s = currentIndexPath != nil
                            if s {
                                delegate?.didChangeTo(collectionView, itemAtIndexPath: attribute.indexPath, oldIndexPath: currentIndexPath)
                            }
                            currentIndexPath = attribute.indexPath
                            
                        }
                        //                    let alpha = minAlpha + (1.0 - minAlpha) * (1 - normalizedDistance)
                        //                    let scale = minScale + (maxScale - minScale) * (1 - normalizedDistance)
                        //                    attribute.alpha = alpha
                        //                    attribute.transform = CGAffineTransformMakeScale(scale, scale)
                        
                        //                        print("active")
                        attribute.actived = true
                        
                    } else {
                        //                    attribute.alpha = minAlpha
                        //                    attribute.transform = CGAffineTransformMakeScale(minScale, minScale)
                        //                        print("dactive")
                        attribute.actived = false
                    }
                }
            }
            
        case .Vertical:
            
            let visualRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
            let activeDistance: CGFloat = itemSize.height / 2.0
            
            for attribute in attributes {
                if CGRectIntersectsRect(attribute.frame, rect) {
                    
                    let distance = fabs((attribute.center.y - CGRectGetMidY(visualRect)))
                    if distance < activeDistance {
                        if currentIndexPath != attribute.indexPath {
                            delegate?.didChangeTo(collectionView, itemAtIndexPath: attribute.indexPath, oldIndexPath: currentIndexPath)
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
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
        
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
            return CGPoint(x: proposedContentOffset.x + adjustOffset, y: proposedContentOffset.y)
            
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
    
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
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
            return CGPoint(x: proposedContentOffset.x + adjustOffset, y: proposedContentOffset.y)
            
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
