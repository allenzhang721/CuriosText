//
//  CTAPreviewLayout.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/18/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

protocol CTAPreviewLayoutDataSource: class {
    
    func layout(_ layout: CTAPreviewLayout, layoutAttributesAtIndexPath indexPath: IndexPath) -> ContainerVMProtocol?
}

class CTAPreviewLayout: UICollectionViewFlowLayout {
    
    weak var dataSource: CTAPreviewLayoutDataSource?
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else {
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
                attribute.zIndex = indexPath.item
                attribute.transform = CGAffineTransform(rotationAngle: container.radius)
            }
        }
        
        return layoutAttributes
    }

}
