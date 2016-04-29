//
//  CTASelectorSizeCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/5/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTASelectorSizeCell: CTASelectorCell {
    
    var sizeView: CTASliderView!
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
            return sizeView.value
        }
        
        set {
            sizeView.value = newValue
            text = "\(Int(sizeView.value * 100))%"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        sizeView = CTASliderView(frame: bounds, attribute: CTASliderAttributes(showMinorLine: true, seniorRatio: 0.5))
        sizeView.minumValue = 0.2
        sizeView.maxiumValue = 2.0
        addSubview(sizeView)
        hudLabel.textAlignment = .Center
        hudLabel.textColor = CTAStyleKit.selectedColor
        addSubview(hudLabel)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        sizeView.frame = bounds
        hudLabel.frame = CGRect(x: bounds.maxX - 60, y: bounds.height * 0.25, width: 60, height: bounds.height * 0.75)
    }
    

    
    override func retriveBeganValue() {
        
        guard let dataSource = dataSource else {
            return
        }
        let scale = dataSource.selectorBeganScale(self)
        sizeView.value = scale
        text = "\(Int(scale * 100))%"
        
//        sizeView.updateValue(dataSource.selectorBeganScale(self))
    }
    
    override func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        
        sizeView.addTarget(target, action: action, forControlEvents: controlEvents)
        sizeView.addTarget(self, action: #selector(CTASelectorSizeCell.valueChanged(_:)), forControlEvents: controlEvents)
    }
    
    override func removeAllTarget() {
        
        for target in sizeView.allTargets() {
            
            guard let actions = sizeView.actionsForTarget(target, forControlEvent: sizeView.allControlEvents()) else {
                continue
            }
            
            for action in actions {
                sizeView.removeTarget(target, action: Selector(action), forControlEvents: sizeView.allControlEvents())
            }
        }
    }
    
    func valueChanged(sender: AnyObject) {
        
        text = "\(Int(sizeView.value * 100))%"
    }
}
