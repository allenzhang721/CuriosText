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
    
    var radian: CGFloat {
        get {
            return view.radian
        }
        
        set {
            view.radian = newValue
            hudLabel.text = "\(Int(ceil((radian.truncatingRemainder(dividingBy: CGFloat(2 * M_PI))) / CGFloat(M_PI) * 180)))º"
        }
    }
    
    override init(frame: CGRect) {
        self.view = CTARotatorView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width, height: 88)))
        super.init(frame: frame)
        contentView.addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.view = CTARotatorView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width, height: 88)))
        super.init(coder: aDecoder)
        contentView.addSubview(view)
        hudLabel.textAlignment = .right
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
    
    override func addTarget(_ target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        
        view.addTarget(target, action: action, for: controlEvents)
        view.addTarget(self, action: #selector(CTASelectorRotatorCell.valueChanged(_:)), for: controlEvents)
    }
    
    override func removeAllTarget() {
        
        for target in view.allTargets {
            
            guard let actions = view.actions(forTarget: target, forControlEvent: view.allControlEvents) else {
                continue
            }
            
            for action in actions {
                view.removeTarget(target, action: Selector(action), for: view.allControlEvents)
            }
        }
    }
    
    func valueChanged(_ sender: AnyObject) {
        let radian: CGFloat
        if view.radian < 0 {
            radian = CGFloat(2 * M_PI) - fabs(view.radian).truncatingRemainder(dividingBy: CGFloat(2 * M_PI))
        } else {
            radian = view.radian
        }
        
        hudLabel.text = "\(Int(ceil((radian.truncatingRemainder(dividingBy: CGFloat(2 * M_PI))) / CGFloat(M_PI) * 180)))º"
    }
}
