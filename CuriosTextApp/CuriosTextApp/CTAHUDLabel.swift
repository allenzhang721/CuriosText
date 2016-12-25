//
//  CTAHUDLabel.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 3/2/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAHUDLabel: UILabel {
    
    var showGradient: Bool = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if showGradient {
            backgroundColor = UIColor(patternImage: CTAStyleKit.imageOfGradientInHubLabel(bounds.size))
        }
    }
}

