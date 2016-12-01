//
//  CTAScollBarCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/31/15.
//  Copyright © 2015 botai. All rights reserved.
//

import UIKit

let activedColor = UIColor.red
let deactivedColor = UIColor.lightGray

class CTAScollBarCell: UICollectionViewCell {
    
    fileprivate var actived: Bool = false
    var barItemView: CTABarItemView!
    
    override func awakeFromNib() {
        
        barItemView = CTABarItemView(frame: CGRect.zero, item: nil)
        contentView.addSubview(barItemView)
        
        barItemView.translatesAutoresizingMaskIntoConstraints = false
        barItemView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        barItemView.heightAnchor.constraint(equalTo: heightAnchor, constant: -16).isActive = true
        barItemView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        barItemView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        
        super.apply(layoutAttributes)
        
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
