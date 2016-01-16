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
    
    override init(frame: CGRect) {
        self.view = CTARotatorView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 88)))
        super.init(frame: frame)
        contentView.addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.view = CTARotatorView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 88)))
        super.init(coder: aDecoder)
        contentView.addSubview(view)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        view.frame = bounds
    }
    
    override func retriveBeganValue() {
        
        guard let dataSource = dataSource else {
            return
        }
        
        view.radian = dataSource.selectorBeganRadian(self)
    }
    
    override func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        
        view.addTarget(target, action: action, forControlEvents: controlEvents)
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
}
