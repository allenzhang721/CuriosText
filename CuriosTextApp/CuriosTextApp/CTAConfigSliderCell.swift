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
    var beganValueBlock: (() -> CGFloat)?
    var valueDidChangedBlock: ((CGFloat) -> ())?
    
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
        slider.addTarget(self, action: "sliderValueChanged:", forControlEvents: .ValueChanged)
        slider.maxiumValue = 5
        slider.minumValue = 0
        
        contentView.addSubview(slider)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        slider.frame = bounds
    }
    
    func sliderValueChanged(sender: CTAScrollTuneView) {
        valueDidChangedBlock?(sender.value)
    }
}

extension CTAConfigSliderCell: CTACellDisplayProtocol {
    
    func willBeDisplayed() {
        let value = beganValueBlock?() ?? 0
        
        debug_print("animation value = \(value)", context: aniContext)
        slider.updateValue(value)
    }
    
    func didEndDisplayed() {
//        valueBlock = nil
    }
}
