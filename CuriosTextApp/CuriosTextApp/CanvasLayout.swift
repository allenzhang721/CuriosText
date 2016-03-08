//
//  CanvasLayout.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

protocol CanvasDelegateLayout: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, rotationForItemAtIndexPath indexPath: NSIndexPath) -> CGFloat
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, positionForItemAtIndexPath indexPath: NSIndexPath) -> CGPoint
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, alphaForItemAtIndexPath indexPath: NSIndexPath) -> CGFloat
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, contentInsetForItemAtIndexPath indexPath: NSIndexPath) -> CGPoint
    
}

class ContainerLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var contentInset: CGPoint = CGPoint.zero
    
    override func isEqual(object: AnyObject?) -> Bool {
        
        guard let object = object as? ContainerLayoutAttributes else {
            return false
        }
        
        return super.isEqual(object) && CGPointEqualToPoint(contentInset, object.contentInset)
    }
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        
        let copy = super.copyWithZone(zone) as! ContainerLayoutAttributes
        copy.contentInset = contentInset
        return copy
    }
}

class CanvasLayout: UICollectionViewFlowLayout {
    
    override class func layoutAttributesClass() -> AnyClass {
        return ContainerLayoutAttributes.self
    }
    
    override func prepareLayout() {
        
        collectionView?.scrollEnabled = false
    }
    
    override func collectionViewContentSize() -> CGSize {
        
        return collectionView!.bounds.size
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let attributes = super.layoutAttributesForElementsInRect(rect) else {
            return nil
        }
        
        for a in attributes {
            let indexPath = a.indexPath
            guard let layoutDelegate = collectionView?.delegate as? CanvasDelegateLayout else {
                continue
            }
            
            a.center = layoutDelegate.collectionView(collectionView!, layout: self, positionForItemAtIndexPath: indexPath)
            a.size = layoutDelegate.collectionView!(collectionView!, layout: self, sizeForItemAtIndexPath: indexPath)
//            a.zIndex = indexPath.item
            a.transform = CGAffineTransformMakeRotation(layoutDelegate.collectionView(collectionView!, layout: self, rotationForItemAtIndexPath: indexPath))
        }
        return attributes
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attribute = super.layoutAttributesForItemAtIndexPath(indexPath)
        
        guard let layoutDelegate = collectionView?.delegate as? CanvasDelegateLayout else {
            return nil
        }
        
        attribute?.center = layoutDelegate.collectionView(collectionView!, layout: self, positionForItemAtIndexPath: indexPath)
        attribute?.size = layoutDelegate.collectionView!(collectionView!, layout: self, sizeForItemAtIndexPath: indexPath)
        attribute?.zIndex = indexPath.item
         attribute?.transform = CGAffineTransformMakeRotation(layoutDelegate.collectionView(collectionView!, layout: self, rotationForItemAtIndexPath: indexPath))
        
        if let containerAttr = attribute as? ContainerLayoutAttributes {
            containerAttr.contentInset = layoutDelegate.collectionView(collectionView!, layout: self, contentInsetForItemAtIndexPath: indexPath)
        }
        
        return attribute
    }
}
