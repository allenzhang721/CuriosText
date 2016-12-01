//
//  CanvasLayout.swift
//  PopApp
//
//  Created by Emiaostein on 4/3/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import UIKit

protocol CanvasLayoutDataSource: class {
    
    func layerAttributesForItemAtIndexPath(_ indexPath: IndexPath) -> Layerable?
}

class CanvasLayout: UICollectionViewFlowLayout {
    
    weak var dataSource: CanvasLayoutDataSource?
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let attributesCollection = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        var nextAs = [UICollectionViewLayoutAttributes]()
        for a in attributesCollection {
            let indexPath = a.indexPath
            if let nextA = layoutAttributesForItem(at: indexPath) {
                nextAs.append(nextA)
            }
        }
        return nextAs
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard let a = super.layoutAttributesForItem(at: indexPath) else {
            return nil
        }
        
        guard let dataSource = dataSource, let layerAttr = dataSource.layerAttributesForItemAtIndexPath(indexPath) else {
            return a
        }
        
        a.size = layerAttr.size
        a.center = layerAttr.position
        a.transform3D = layerAttr.transform
        a.alpha = layerAttr.alpha
        a.zIndex = a.indexPath.item
        
        return a
    }
}
