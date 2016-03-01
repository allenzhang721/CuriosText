//
//  CTAAnimationNameCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 2/25/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAAnimationNameCell: CTAActivableCollectionViewCell {

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
    
    override func didActived(actived: Bool) {
        
        label.textColor = actived ? CTAStyleKit.selectedColor : CTAStyleKit.normalColor
    }
}
