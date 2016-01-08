//
//  CTASelectorFontCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/8/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTASelectorFontCell: CTASelectorCell {

    private var selectView: CTAScrollSelectView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        self.selectView = CTAScrollSelectView(frame: bounds, direction: .Horizontal)
        addSubview(selectView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectView.frame = bounds
    }
    
    override func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        
        selectView.addTarget(target, action: action, forControlEvents: controlEvents)
    }
    
    override func removeAllTarget() {
        
        for target in selectView.allTargets() {
            
            guard let actions = selectView.actionsForTarget(target, forControlEvent: selectView.allControlEvents()) else {
                continue
            }
            
            for action in actions {
                selectView.removeTarget(target, action: Selector(action), forControlEvents: selectView.allControlEvents())
            }
        }
    }

}
