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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        view = CTAPickerView(frame: CGRect(x: 0, y: 0, width: 320, height: 88), showCount: 2)
        view.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(view)
        view.backgroundColor = CTAStyleKit.intoDreams1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        view.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        view.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        view.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        
        view.dataSource = self
//        view.reloadData()
    }
    
    override func prepareForReuse() {
        
        view.updateTo(NSIndexPath(forItem: 2, inSection: 5))
    }
    
    func reloadData() {
        view.reloadData()
    }
    
    override func retriveBeganValue() {
        
        guard let dataSource = dataSource else {
            return
        }
        
        if let indexPath = dataSource.selectorBeganFontIndexPath(self) {
            self.view.updateTo(indexPath)
        }
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
        return CTAFontsManager.families.count
    }
    
    func pickView(view: CTAPickerView, numberOfItemsAtSection section: Int) -> Int {
        let afamily = CTAFontsManager.families[section]
        
        guard let fonts  = CTAFontsManager.fontNamesWithFamily(afamily) else {
            return 0
        }
        return fonts.count
    }
    
    func pickView(view: CTAPickerView, configItemCell itemCell: CTAVerticalItemCollectionViewCell, itemAtSection section: Int, ItemAtIndex index: Int) {
        if let itemCell = itemCell as? CTAVerticalItemFontsCollectionViewCell {
            let res = CTAFontsManager.familyAndFontNameWith(NSIndexPath(forItem: index, inSection: section))
            
            guard let family = res.0, font = res.1 else {
                return
            }
                itemCell.view.text = family
                itemCell.view.font = UIFont(name: font, size: 17)
        }
    }
}
