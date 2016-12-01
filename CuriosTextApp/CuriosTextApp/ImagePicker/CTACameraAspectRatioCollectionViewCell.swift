//
//  CTACameraAspectRatioCollectionViewCell.swift
//  ImagePickerApp
//
//  Created by Emiaostein on 2/28/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import UIKit

class CTACameraAspectRatioCollectionViewCell: UICollectionViewCell {
    
    
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
        label.textColor = UIColor.lightGray
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
        
        guard let layoutAttributes = layoutAttributes as? CTAActiveCollectionViewAttributes else {
            return
        }
        
        if actived != layoutAttributes.actived {
            actived = layoutAttributes.actived
            label.textColor = actived ? .red : .lightGray
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
