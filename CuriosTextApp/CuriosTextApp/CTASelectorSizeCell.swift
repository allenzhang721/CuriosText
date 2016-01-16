//
//  CTASelectorSizeCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/5/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTASelectorSizeCell: CTASelectorCell {
    
    var sizeView: CTAScrollTuneView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        sizeView = CTAScrollTuneView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 88)))
        addSubview(sizeView)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        sizeView.frame = bounds
    }
    

    
    override func retriveBeganValue() {
        
        guard let dataSource = dataSource else {
            return
        }
        
        sizeView.updateValue(dataSource.selectorBeganScale(self))
    }
    
    override func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        
        sizeView.addTarget(target, action: action, forControlEvents: controlEvents)
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
}
