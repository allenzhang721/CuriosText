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
        debug_print("\(#file) deinit", context: deinitContext)
    }
    
    
    fileprivate func setup() {
        
        func selected(_ data: Data?, origin: Bool) {
            
        }
        
        if let templateListVC = Moduler.module_templateListVC({ [weak self] (pageData, origin) in
            guard let sf = self, let target = sf.target, let action = sf.action else {return}
            let object: [String: AnyObject]
            if let data = pageData {
                object = ["data": data as AnyObject, "origin": origin as AnyObject]
            } else {
                object = ["origin": origin as AnyObject]
            }
            
            target.perform(action, with: object)
            
        }) as? CTATempateListViewController {
            print("cell bounds = \(self.bounds)")
            templateListVC.view.frame = self.bounds
            contentView.addSubview(templateListVC.view)
            let view = templateListVC.view
            view?.translatesAutoresizingMaskIntoConstraints = false
            view?.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            view?.topAnchor.constraint(equalTo: topAnchor).isActive = true
            view?.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            view?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            
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
    
    override func addTarget(_ target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        
        self.target = target
        self.action = action
    }
    override func removeAllTarget() {
        target = nil
        action = nil
    }
}
