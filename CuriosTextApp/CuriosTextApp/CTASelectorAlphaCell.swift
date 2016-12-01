//
//  CTASelectorAlphaCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 7/28/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTASelectorAlphaCell: CTASelectorCell {

    var sliderView: CTASliderView!
    let hudLabel = CTAHUDLabel()
    var text: String {
        get {
            return hudLabel.text ?? ""
        }
        
        set {
            hudLabel.text = newValue
        }
    }
    var value: CGFloat {
        get {
            return sliderView.value
        }
        
        set {
            sliderView.value = newValue
            text = "\(Int(sliderView.value * 100))%"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        sliderView = CTASliderView(frame: bounds, attribute: CTASliderAttributes(showMinorLine: true, seniorRatio: 0.5))
        sliderView.targetValues = [1.0]
        sliderView.minumValue = 0.0
        sliderView.maxiumValue = 1.0
        addSubview(sliderView)
        hudLabel.textAlignment = .center
        hudLabel.textColor = CTAStyleKit.selectedColor
        addSubview(hudLabel)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        sliderView.frame = bounds
        hudLabel.frame = CGRect(x: bounds.maxX - 60, y: bounds.height * 0.25, width: 60, height: bounds.height * 0.75)
    }
    
    
    
    override func retriveBeganValue() {
        
        guard let dataSource = dataSource else {
            return
        }
        let scale = dataSource.selectorBeganAlpha(self)
        sliderView.value = scale
        text = "\(Int(max(0, min(1, scale)) * 100))%"
    }
    
    override func addTarget(_ target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        
        sliderView.addTarget(target, action: action, for: controlEvents)
        sliderView.addTarget(self, action: #selector(CTASelectorAlphaCell.valueChanged(_:)), for: controlEvents)
    }
    
    override func removeAllTarget() {
        
        for target in sliderView.allTargets {
            
            guard let actions = sliderView.actions(forTarget: target, forControlEvent: sliderView.allControlEvents) else {
                continue
            }
            
            for action in actions {
                sliderView.removeTarget(target, action: Selector(action), for: sliderView.allControlEvents)
            }
        }
    }
    
    func valueChanged(_ sender: AnyObject) {
        
        text = "\(Int(max(0, min(1, sliderView.value)) * 100))%"
    }

}
