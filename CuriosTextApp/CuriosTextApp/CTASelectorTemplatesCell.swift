//
//  CTASelectorTemplatesCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 5/27/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTASelectorTemplatesCell: CTASelectorCell {
    
    weak var target: AnyObject?
    var action: Selector?
    var templateList: CTATempateListViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
         setup()
//        userInteractionEnabled = false
    }
    
    deinit {
        print("\(#file) deinit")
    }
    
    
    private func setup() {
        
        func selected(data: NSData?, origin: Bool) {
            
        }
        
        if let templateListVC = Moduler.module_templateListVC({ [weak self] (pageData, origin) in
            guard let sf = self, let target = sf.target, let action = sf.action else {return}
            let object: [String: AnyObject]
            if let data = pageData {
                object = ["data": data, "origin": origin]
            } else {
                object = ["origin": origin]
            }
            
            target.performSelector(action, withObject: object)
            
        }) as? CTATempateListViewController {
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
    
    override func willBeDisplayed() {
        templateList?.updateFirst()
//
//        templateList?.defaultSelected()
    }
//    override func beganLoad() {
        
//        templateList?.updateCurrentOriginImage(<#T##image: UIImage?##UIImage?#>)
//        templateList?.defaultSelected()
//    }
    
//    reti
    
    override func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        
        self.target = target
        self.action = action
    }
    override func removeAllTarget() {
        target = nil
        action = nil
    }
}
