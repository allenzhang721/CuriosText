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
    
    private var actived: Bool = false
    private var barItemView: CTABarItemView!
    
    override func awakeFromNib() {
        backgroundColor = deactivedColor
        
        barItemView = CTABarItemView(frame: CGRect.zero, item: nil)
        addSubview(barItemView)
        
        barItemView.backgroundColor = UIColor.darkGrayColor()
        
        barItemView.translatesAutoresizingMaskIntoConstraints = false
        barItemView.widthAnchor.constraintEqualToConstant(50).active = true
        barItemView.heightAnchor.constraintEqualToAnchor(heightAnchor).active = true
        barItemView.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        barItemView.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        
        super.applyLayoutAttributes(layoutAttributes)
        
        guard let layoutAttributes = layoutAttributes as? CollectionViewAttributes else {
            return
        }
        
        if actived != layoutAttributes.actived {
            actived = layoutAttributes.actived
            barItemView.setSelected(actived)
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
