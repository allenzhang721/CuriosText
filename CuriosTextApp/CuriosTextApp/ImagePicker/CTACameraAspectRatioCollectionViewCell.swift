//
//  CTACameraAspectRatioCollectionViewCell.swift
//  ImagePickerApp
//
//  Created by Emiaostein on 2/28/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import UIKit

class CTACameraAspectRatioCollectionViewCell: UICollectionViewCell {
    
    
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
        label.textColor = UIColor.lightGrayColor()
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
        
        guard let layoutAttributes = layoutAttributes as? CTAActiveCollectionViewAttributes else {
            return
        }
        
        if actived != layoutAttributes.actived {
            actived = layoutAttributes.actived
            label.textColor = actived ? .redColor() : .lightGrayColor()
//            UIView.transitionWithView(self, duration: 0.1, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {[weak self] () -> Void in
//                
//                if let sr = self {
//                    sr.label.textColor = sr.actived ? .lightGrayColor() : .redColor()
//                }
//                
//                }, completion: nil)
        }
    }
}
