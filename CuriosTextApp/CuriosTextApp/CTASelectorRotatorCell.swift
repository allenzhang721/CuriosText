//
//  CTASelectorRotatorCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/7/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTASelectorRotatorCell: CTASelectorCell {

    let view: CTARotatorView
    let hudLabel = CTAHUDLabel()
    
    override init(frame: CGRect) {
        self.view = CTARotatorView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 88)))
        super.init(frame: frame)
        contentView.addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.view = CTARotatorView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 88)))
        super.init(coder: aDecoder)
        contentView.addSubview(view)
        hudLabel.textAlignment = .Right
        hudLabel.textColor = CTAStyleKit.selectedColor
        hudLabel.showGradient = false
        contentView.addSubview(hudLabel)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        view.frame = bounds
        let hr: CGFloat = 0.55
        let yr = 1 - hr
        hudLabel.frame = CGRect(x: bounds.maxX - 70, y: bounds.height * yr, width: 60, height: bounds.height * hr)
    }
    
    override func retriveBeganValue() {
        
        guard let dataSource = dataSource else {
            return
        }
        let radian = dataSource.selectorBeganRadian(self)
        view.radian = radian
        hudLabel.text = "\(Int(ceil(view.radian / CGFloat(M_PI) * 180)))º"
    }
    
    override func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        
        view.addTarget(target, action: action, forControlEvents: controlEvents)
        view.addTarget(self, action: "valueChanged:", forControlEvents: controlEvents)
    }
    
    override func removeAllTarget() {
        
        for target in view.allTargets() {
            
            guard let actions = view.actionsForTarget(target, forControlEvent: view.allControlEvents()) else {
                continue
            }
            
            for action in actions {
                view.removeTarget(target, action: Selector(action), forControlEvents: view.allControlEvents())
            }
        }
    }
    
    func valueChanged(sender: AnyObject) {
        
        hudLabel.text = "\(Int(ceil(view.radian / CGFloat(M_PI) * 180)))º"
    }
}
