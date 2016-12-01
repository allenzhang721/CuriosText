//
//  CTASelectorAligmentsCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/11/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTASelectorAligmentsCell: CTASelectorCell {

    var view: CTASegmentControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        let normals: [UIImage] = [
            CTAStyleKit.imageOfAlignmentLeftNormal,
            CTAStyleKit.imageOfAlignmentCenterNormal,
            CTAStyleKit.imageOfAlignmentRightNormal,
            CTAStyleKit.imageOfAlignmentJustNormal
        ]
        
        let selected: [UIImage] = [
            CTAStyleKit.imageOfAlignmentLeftSelected,
            CTAStyleKit.imageOfAlignmentCenterSelected,
            CTAStyleKit.imageOfAlignmentRightSelected,
            CTAStyleKit.imageOfAlignmentJustSelected
        ]
        
        view = CTASegmentControl(frame: bounds, normal: normals, highlighted: selected, selected: selected)
        addSubview(view)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        view.frame = bounds
    }
    
    override func retriveBeganValue() {
        
        guard let dataSource = dataSource else {
            return
        }
        
        view.selectedIndex = dataSource.selectorBeganAlignment(self).rawValue
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
