//
//  CTASelectorAnimationCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/30/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTASelectorAnimationCell: CTASelectorCell {

    var tabView: CTATabView!
    var animation: CTAAnimationBinder? {
        return dataSource?.selectorBeganAnimation(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        tabView = CTATabView(frame: bounds)
        tabView.backgroundColor = UIColor.whiteColor()
        tabView.dataSource = self
        contentView.addSubview(tabView)
        
        // Constraints
        tabView.translatesAutoresizingMaskIntoConstraints = false
        tabView.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
        tabView.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor).active = true
        tabView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor).active = true
        tabView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor).active = true
    }
    
    override func willBeDisplayed() {
        
    }
}

extension CTASelectorAnimationCell: CTATabViewDataSource {
    
    func numberOfTabItemsInTabView(view: CTATabView) -> Int {
        
        return animation != nil ? 3 : 1
    }
    
//    func tabView(view: CTATabView, cellForItemAtIndexPath: NSIndexPath) -> UICollectionViewCell {
//        
//        
//    }
}
