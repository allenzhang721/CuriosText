//
//  CTAVerticalItemColorCollectionViewCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/12/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAVerticalItemColorCollectionViewCell: CTAVerticalItemCollectionViewCell {

    var colorView: UIView!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        
        colorView = UIView(frame: bounds)
        colorView.layer.cornerRadius = 18
        addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        colorView.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        colorView.widthAnchor.constraintEqualToConstant(36).active = true
        colorView.heightAnchor.constraintEqualToConstant(36).active = true
    }
    

}
