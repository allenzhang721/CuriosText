//
//  CTAPreviewLayout.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/18/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

protocol CTAPreviewLayoutDataSource: class {
    
    func layout(layout: CTAPreviewLayout, layoutAttributesAtIndexPath indexPath: NSIndexPath) -> CTAPreviewContainer?
}

class CTAPreviewLayout: UICollectionViewFlowLayout {
    
    weak var dataSource: CTAPreviewLayoutDataSource?
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let layoutAttributes = super.layoutAttributesForElementsInRect(rect) else {
            return nil
        }
        
        if let dataSource = dataSource {
            
            for attribute in layoutAttributes {
                
                let indexPath = attribute.indexPath
                guard let container = dataSource.layout(self, layoutAttributesAtIndexPath: indexPath) else {
                    continue
                }
                
                attribute.bounds = container.bounds
                attribute.center = container.center
                attribute.transform = container.transform
                attribute.alpha = container.alpha
            }
        }
        
        return layoutAttributes
    }

}
