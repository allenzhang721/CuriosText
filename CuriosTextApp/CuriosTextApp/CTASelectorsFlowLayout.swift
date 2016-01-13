//
//  CTASelectorsFlowLayout.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/1/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTASelectorsFlowLayout: UICollectionViewFlowLayout {
    
    private var needAnimationIndexPaths = [NSIndexPath]()
    
    override func prepareLayout() {
        
        itemSize = self.collectionView!.bounds.size
        
//        print("selectorCellSize = \(itemSize)")
//        scrollDirection = .Vertical
    }
    
    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        
        super.prepareForCollectionViewUpdates(updateItems)
        
        var indexPaths = [NSIndexPath]()
        
        for updateItem in updateItems {
            
            switch updateItem.updateAction {
                
            case .Insert:
                indexPaths.append(updateItem.indexPathAfterUpdate!)
                
            case .Delete:
                indexPaths.append(updateItem.indexPathBeforeUpdate!)
                
            case .Move:
                indexPaths.append(updateItem.indexPathBeforeUpdate!)
                indexPaths.append(updateItem.indexPathAfterUpdate!)
                
            default:
                ()
            }
            
        }
        
        needAnimationIndexPaths = indexPaths
    }
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attribute = layoutAttributesForItemAtIndexPath(itemIndexPath)
        
        if let i = needAnimationIndexPaths.indexOf(itemIndexPath) {
            
            attribute?.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(collectionView!.bounds))
            attribute?.zIndex = Int.max
            needAnimationIndexPaths.removeAtIndex(i)
        }
        
        return attribute
    }
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attriubte = layoutAttributesForItemAtIndexPath(itemIndexPath)
        
        if let i = needAnimationIndexPaths.indexOf(itemIndexPath) {
            attriubte?.zIndex = Int.min
            needAnimationIndexPaths.removeAtIndex(i)
        }
        
        return attriubte
    }
}
