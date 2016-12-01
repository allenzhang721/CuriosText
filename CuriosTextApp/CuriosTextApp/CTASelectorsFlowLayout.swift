//
//  CTASelectorsFlowLayout.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/1/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTASelectorsFlowLayout: UICollectionViewFlowLayout {
    
    fileprivate var needAnimationIndexPaths = [IndexPath]()
    
    override func prepare() {
        
        itemSize = self.collectionView!.bounds.size
        
//        print("selectorCellSize = \(itemSize)")
//        scrollDirection = .Vertical
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        
        super.prepare(forCollectionViewUpdates: updateItems)
        
        var indexPaths = [IndexPath]()
        
        for updateItem in updateItems {
            
            switch updateItem.updateAction {
                
            case .insert:
                indexPaths.append(updateItem.indexPathAfterUpdate!)
                
            case .delete:
                indexPaths.append(updateItem.indexPathBeforeUpdate!)
                
            case .move:
                indexPaths.append(updateItem.indexPathBeforeUpdate!)
                indexPaths.append(updateItem.indexPathAfterUpdate!)
                
            default:
                ()
            }
            
        }
        
        needAnimationIndexPaths = indexPaths
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attribute = layoutAttributesForItem(at: itemIndexPath)
        
        if let i = needAnimationIndexPaths.index(of: itemIndexPath) {
            
            attribute?.transform = CGAffineTransform(translationX: 0, y: collectionView!.bounds.height)
            attribute?.zIndex = Int.max
            needAnimationIndexPaths.remove(at: i)
        }
        
        return attribute
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attriubte = layoutAttributesForItem(at: itemIndexPath)
        
        if let i = needAnimationIndexPaths.index(of: itemIndexPath) {
            attriubte?.zIndex = Int.min
            needAnimationIndexPaths.remove(at: i)
        }
        
        return attriubte
    }
}
