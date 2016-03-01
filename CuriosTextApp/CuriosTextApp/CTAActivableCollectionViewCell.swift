//
//  CTAActivableCollectionViewCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 2/25/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAActivableCollectionViewCell: UICollectionViewCell {
    
    private var actived: Bool = false
    
    func didActived(actived: Bool) {
        
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        
        super.applyLayoutAttributes(layoutAttributes)
        
        guard let layoutAttributes = layoutAttributes as? CollectionViewAttributes else {
            return
        }
        
        if actived != layoutAttributes.actived {
            actived = layoutAttributes.actived
            didActived(actived)
            //            UIView.transitionWithView(self, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {[weak self] () -> Void in
            //
            //                if let sr = self {
            //                    sr.barItemView.setSelected(sr.actived)
            ////                    sr.backgroundColor = sr.actived ? activedColor : deactivedColor
            //                }
            //                
            //                }, completion: nil)
        }
    }
}
