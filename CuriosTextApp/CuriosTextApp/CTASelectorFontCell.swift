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
        view = CTAPickerView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 88)), showCount: 2)
        view.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(view)
        view.backgroundColor = CTAStyleKit.intoDreams1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        view.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        view.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        view.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        
        view.dataSource = self
        view.delegate = self
    }
    
    func reloadData() {
        view.reloadData()
    }
    
    override func retriveBeganValue() {
        
        guard let dataSource = dataSource else {
            return
        }
        
        if let indexPath = dataSource.selectorBeganFontIndexPath(self) {
            CTAFontsManager.updateSection(indexPath.section, withItem: indexPath.item)
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
        return (CTAVerticalItemFontsCollectionViewCell.self, "SelectorFontItemCell")
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
    
    func pickView(view: CTAPickerView, indexAtSection section: Int) -> Int {
        
        guard let index = CTAFontsManager.itemAtSection(section) else {
            return 0
        }
        
        return index
    }
    
    func pickView(view: CTAPickerView, configItemCell itemCell: CTAVerticalItemCollectionViewCell, itemAtSection section: Int, ItemAtIndex index: Int) {
        if let itemCell = itemCell as? CTAVerticalItemFontsCollectionViewCell {
            let res = CTAFontsManager.familyAndFontNameWith(NSIndexPath(forItem: index, inSection: section))
            
            guard let family = res.0, fontName = res.1, let font = UIFont(name: fontName, size: 17) else {
                return
            }
            
            if let displayFamilyName = CTFontCopyLocalizedName(font, kCTFontFamilyNameKey, nil) {
                
                let n = (displayFamilyName as NSString).stringByReplacingOccurrencesOfString("（非商用）", withString: "").stringByReplacingOccurrencesOfString("G0v1", withString: "").stringByReplacingOccurrencesOfString("(Noncommercial)", withString: "")
                
                itemCell.view.text = n
            } else {
                itemCell.view.text = family
            }
            
                itemCell.view.font = font
        }
    }
}

extension CTASelectorFontCell: CTAPickerViewDelegate {
    
    func pickView(view: CTAPickerView, itemDidChangedToIndexPath indexPath: NSIndexPath) {
        
        debug_print("color cell will began at \(indexPath)", context: colorContext)
        CTAFontsManager.updateSection(indexPath.section, withItem: indexPath.item)
    }
    
    func pickView(view: CTAPickerView, sectionDidChangedToIndexPath indexPath: NSIndexPath) {
        
    }
    
}
