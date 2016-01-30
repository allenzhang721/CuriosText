//
//  CTALabelCollectionViewCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/30/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTALabelCollectionViewCell: UICollectionViewCell {
    
    private var actived: Bool = false
    private var label: UILabel!
    var text: String? {
        get {
            return label.text
        }
        
        set {
            label.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        label = UILabel(frame: bounds)
        label.textAlignment = .Center
        label.text = "^_^"
        label.textColor = CTAStyleKit.normalColor
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        contentView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
        label.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor).active = true
        label.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor).active = true
        label.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor).active = true
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
                    sr.label.textColor = sr.actived ? CTAStyleKit.selectedColor : CTAStyleKit.normalColor
                }
                
                }, completion: nil)
        }
    }
}
