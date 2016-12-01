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
        view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    override func retriveBeganValue() {
        
        guard let dataSource = dataSource else {
            return
        }
        
        view.spacing = dataSource.selectorBeganSpacing(self)
    }
    
    override func addTarget(_ target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        
        view.addTarget(target, action: action, for: controlEvents)
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
}
