//
//  CTAAnimationNameCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 2/25/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAAnimationNameCell: CTAActivableCollectionViewCell {

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
    
    override func didActived(_ actived: Bool) {
        
        label.textColor = actived ? CTAStyleKit.selectedColor : CTAStyleKit.normalColor
    }
}
