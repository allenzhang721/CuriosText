//
//  CanvasLayout.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

protocol CanvasDelegateLayout: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, rotationForItemAtIndexPath indexPath: IndexPath) -> CGFloat
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, positionForItemAtIndexPath indexPath: IndexPath) -> CGPoint
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, alphaForItemAtIndexPath indexPath: IndexPath) -> CGFloat
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, contentInsetForItemAtIndexPath indexPath: IndexPath) -> CGPoint
    
}

class ContainerLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var contentInset: CGPoint = CGPoint.zero
    
    override func isEqual(_ object: Any?) -> Bool {
        
        guard let object = object as? ContainerLayoutAttributes else {
            return false
        }
        
        return super.isEqual(object) && contentInset.equalTo(object.contentInset)
    }
    
    override func copy(with zone: NSZone?) -> Any {
        
        let copy = super.copy(with: zone) as! ContainerLayoutAttributes
        copy.contentInset = contentInset
        return copy
    }
}

class EditCanvasLayout: UICollectionViewFlowLayout {
    
    override class var layoutAttributesClass : AnyClass {
        return ContainerLayoutAttributes.self
    }
    
    override func prepare() {
        
        collectionView?.isScrollEnabled = false
    }
    
    override var collectionViewContentSize : CGSize {
        
        return collectionView!.bounds.size
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        for a in attributes {
            let indexPath = a.indexPath
            guard let layoutDelegate = collectionView?.delegate as? CanvasDelegateLayout else {
                continue
            }
            
//            a = layoutAttributesForItemAtIndexPath(index)
            
            a.center = layoutDelegate.collectionView(collectionView!, layout: self, positionForItemAtIndexPath: indexPath)
            a.size = layoutDelegate.collectionView!(collectionView!, layout: self, sizeForItemAt: indexPath)
            a.zIndex = indexPath.item
            a.alpha = layoutDelegate.collectionView(collectionView!, layout: self, alphaForItemAtIndexPath: indexPath)
            a.transform = CGAffineTransform(rotationAngle: layoutDelegate.collectionView(collectionView!, layout: self, rotationForItemAtIndexPath: indexPath))
        }
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attribute = super.layoutAttributesForItem(at: indexPath)
        
        guard let layoutDelegate = collectionView?.delegate as? CanvasDelegateLayout else {
            return nil
        }
        
        attribute?.center = layoutDelegate.collectionView(collectionView!, layout: self, positionForItemAtIndexPath: indexPath)
        attribute?.size = layoutDelegate.collectionView!(collectionView!, layout: self, sizeForItemAt: indexPath)
        attribute?.zIndex = indexPath.item
        attribute?.alpha = layoutDelegate.collectionView(collectionView!, layout: self, alphaForItemAtIndexPath: indexPath)
         attribute?.transform = CGAffineTransform(rotationAngle: layoutDelegate.collectionView(collectionView!, layout: self, rotationForItemAtIndexPath: indexPath))
        
        if let containerAttr = attribute as? ContainerLayoutAttributes {
            containerAttr.contentInset = layoutDelegate.collectionView(collectionView!, layout: self, contentInsetForItemAtIndexPath: indexPath)
        }
        
        return attribute
    }
}
