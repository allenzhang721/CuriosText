//
//  CTASelectorTemplatesCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 5/27/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTASelectorTemplatesCell: CTASelectorCell {
    
    var target: AnyObject?
    var action: Selector?
    var templateList: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
         setup()
//        userInteractionEnabled = false
    }
    
    override func didMoveToSuperview() {
       
        
    }
    
    
    private func setup() {

        let selected: (NSData?) -> () = {[weak self] data in
            guard let sf = self, let target = sf.target, let action = sf.action else {return}
            target.performSelector(action, withObject: data)
        }
        if let templateListVC = Moduler.module_templateListVC(selected) {
            print("cell bounds = \(self.bounds)")
            templateListVC.view.frame = self.bounds
            contentView.addSubview(templateListVC.view)
            let view = templateListVC.view
            view.translatesAutoresizingMaskIntoConstraints = false
            view.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
            view.topAnchor.constraintEqualToAnchor(topAnchor).active = true
            view.rightAnchor.constraintEqualToAnchor(rightAnchor).active = true
            view.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
            
            templateList = templateListVC
        }
    }
    
    override func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        
        self.target = target
        self.action = action
    }
    override func removeAllTarget() {
        target = nil
        action = nil
    }
}
