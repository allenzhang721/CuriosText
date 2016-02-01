//
//  CTAConfigSliderCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/31/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAConfigSliderCell: CTAConfigCell {

    var slider: CTAScrollTuneView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
        slider = CTAScrollTuneView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 44)), attributes: CTAScrollTuneAttributes(showShortLine: false))
        
        contentView.addSubview(slider)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        slider.frame = bounds
    }
}
