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
    var templateList: CTATempateListViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
         setup()
//        userInteractionEnabled = false
    }
    
    override func didMoveToSuperview() {
       
        
    }
    
    
    private func setup() {
        
//        ((pageData: NSData?, origin: Bool) -> ())?

//        let selected: (NSData?, Bool) -> () = {[weak self] (data, origin) in
//            guard let sf = self, let target = sf.target, let action = sf.action else {return}
//            target.performSelector(action, withObject: ["data": data, "origin": origin])
//        }
        
        func selected(data: NSData?, origin: Bool) {
            guard let target = target, let action = action else {return}
            let object: [String: AnyObject]
            if let data = data {
                object = ["data": data, "origin": origin]
            } else {
                object = ["origin": origin]
            }
            
            target.performSelector(action, withObject: object)
        }
        
        if let templateListVC = Moduler.module_templateListVC(selected) as? CTATempateListViewController {
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
