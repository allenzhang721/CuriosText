//
//  CTAScollBarCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/31/15.
//  Copyright © 2015 botai. All rights reserved.
//

import UIKit

let activedColor = UIColor.redColor()
let deactivedColor = UIColor.lightGrayColor()

class CTAScollBarCell: UICollectionViewCell {
    
    var actived: Bool = false
    
    override func awakeFromNib() {
        backgroundColor = deactivedColor
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        
        super.applyLayoutAttributes(layoutAttributes)
        
        guard let layoutAttributes = layoutAttributes as? CollectionViewAttributes else {
            return
        }
        
        if actived != layoutAttributes.actived {
            actived = layoutAttributes.actived
            UIView.transitionWithView(self, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {[weak self] () -> Void in
                
                if let sr = self {
                    sr.backgroundColor = sr.actived ? activedColor : deactivedColor
                }
                
                }, completion: nil)
        }
    }
}
