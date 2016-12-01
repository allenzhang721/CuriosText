//
//  CTACanvasCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/6/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTACanvasCell: UICollectionViewCell {
    
    var contentInset = CGPoint.zero
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        
        super.apply(layoutAttributes)
        
        guard let layoutAttributes = layoutAttributes as? ContainerLayoutAttributes else {
            return
        }
        
        contentInset = layoutAttributes.contentInset
    }
    
}
