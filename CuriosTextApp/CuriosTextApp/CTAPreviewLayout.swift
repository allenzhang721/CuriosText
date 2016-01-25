//
//  CTAPreviewLayout.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/18/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

protocol CTAPreviewLayoutDataSource: class {
    
    func layout(layout: CTAPreviewLayout, layoutAttributesAtIndexPath indexPath: NSIndexPath) -> ContainerVMProtocol?
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
                
                attribute.size = container.size
                attribute.center = container.center
                attribute.transform = CGAffineTransformMakeRotation(container.radius)
            }
        }
        
        return layoutAttributes
    }

}
