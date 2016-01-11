//
//  CTASelectorSpacingCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/11/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTASelectorSpacingCell: CTASelectorCell {

    var view: CTATextSpacingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        
        view = CTATextSpacingView(frame: bounds)
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
        view.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        view.rightAnchor.constraintEqualToAnchor(rightAnchor).active = true
        view.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
    }
    
    override func retriveBeganValue() {
        
        guard let dataSource = dataSource else {
            return
        }
        
        view.spacing = dataSource.selectorBeganSpacing(self)
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
