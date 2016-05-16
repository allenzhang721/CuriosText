//
//  CTAConfigSliderCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/31/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAConfigSliderCell: CTAConfigCell {

    var slider: CTASliderView!
    let hudLabel = CTAHUDLabel()
    var beganValueBlock: (() -> CGFloat)?
    var valueDidChangedBlock: ((CGFloat) -> ())?
    
    var text: String {
        get {
            return hudLabel.text ?? ""
        }
        
        set {
            hudLabel.text = newValue
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
    
    func setup() {
        
        slider = CTASliderView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 44)), attribute: CTASliderAttributes(showMinorLine: false, seniorRatio: 0.7))
        slider.addTarget(self, action: #selector(CTAConfigSliderCell.sliderValueChanged(_:)), forControlEvents: .ValueChanged)
        slider.maxiumValue = 3
        slider.minumValue = 0
        
        contentView.addSubview(slider)
        
        hudLabel.textAlignment = .Center
        hudLabel.textColor = CTAStyleKit.selectedColor
        contentView.addSubview(hudLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        slider.frame = bounds
        hudLabel.frame = CGRect(x: bounds.maxX - 60, y: 0, width: 60, height: bounds.height)
    }
    
    func sliderValueChanged(sender: CTASliderView) {
        
        let realValue = min(slider.maxiumValue, max(sender.value, slider.minumValue))
        valueDidChangedBlock?(realValue)
        text = "\(CGFloat(Int(realValue * 10)) / 10) s"
    }
}

extension CTAConfigSliderCell: CTACellDisplayProtocol {
    
    func willBeDisplayed() {
        let value = max(0, beganValueBlock?() ?? 0)
        let realValue = min(slider.maxiumValue, max(value, slider.minumValue))
        debug_print("animation value = \(value)", context: aniContext)
        slider.value = realValue
        text = "\(CGFloat(Int(realValue * 10)) / 10) s"
    }
    
    func didEndDisplayed() {
//        valueBlock = nil
    }
}
