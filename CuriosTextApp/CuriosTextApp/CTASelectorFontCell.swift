//
//  CTASelectorFontCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/8/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

final class CTASelectorFontCell: CTASelectorCell {
    
    private var view: CTAPickerView!
    let family = UIFont.familyNames()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        view = CTAPickerView(frame: bounds, showCount: 2)
        view.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(view)
        view.backgroundColor = CTAStyleKit.intoDreams1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        view.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        view.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        view.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        
        view.dataSource = self
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

extension CTASelectorFontCell: CTAPickerViewDataSource {
    
    func pickViewRegisterItemCellClass(view: CTAPickerView) -> (AnyClass?, String) {
        return (CTAVerticalItemFontsCollectionViewCell.self, "SelectorColorItemCell")
    }
    
    func numberOfSectionsInCollectionView(view: CTAPickerView) -> Int {
        return 5
    }
    
    func pickView(view: CTAPickerView, numberOfItemsAtSection section: Int) -> Int {
        let afamily = family[section]
        return UIFont.fontNamesForFamilyName(afamily).count
    }
    
    func pickView(view: CTAPickerView, configItemCell itemCell: CTAVerticalItemCollectionViewCell, itemAtSection section: Int, ItemAtIndex index: Int) {
        if let itemCell = itemCell as? CTAVerticalItemFontsCollectionViewCell {
            let family = UIFont.familyNames()[section]
            let fontNames = UIFont.fontNamesForFamilyName(family)
            
            if fontNames.count > 0 {
                let name = fontNames[index]
                itemCell.view.text = family
                itemCell.view.font = UIFont(name: name, size: 17)
            }
        }
    }
}
