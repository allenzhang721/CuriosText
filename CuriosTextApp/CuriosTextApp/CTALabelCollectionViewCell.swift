//
//  CTALabelCollectionViewCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/30/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTALabelCollectionViewCell: UICollectionViewCell {
    
    fileprivate var actived: Bool = false
    fileprivate var label: UILabel!
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
    
    fileprivate func setup() {
        
        label = UILabel(frame: bounds)
        label.textAlignment = .center
        label.text = "^_^"
        label.textColor = CTAStyleKit.normalColor
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        contentView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        
        super.apply(layoutAttributes)
        
        guard let layoutAttributes = layoutAttributes as? CollectionViewAttributes else {
            return
        }
        
        if actived != layoutAttributes.actived {
            actived = layoutAttributes.actived
            UIView.transition(with: self, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {[weak self] () -> Void in

                if let sr = self {
                    sr.label.textColor = sr.actived ? CTAStyleKit.selectedColor : CTAStyleKit.normalColor
                }
                
                }, completion: nil)
        }
    }
}
