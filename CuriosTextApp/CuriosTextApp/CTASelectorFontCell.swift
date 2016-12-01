//
//  CTASelectorFontCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/8/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

final class CTASelectorFontCell: CTASelectorCell {
    
    fileprivate var view: CTAPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    fileprivate func setup() {
        view = CTAPickerView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width - 40, height: 88)), showCount: 2)
        view.collectionView.clipsToBounds = false
//        view.collectionView.backgroundColor = UIColor.yellowColor()
        contentView.addSubview(view)
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
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
            
        }
    }
    
    override func willBeDisplayed() {
        if let indexPath = dataSource?.selectorBeganFontIndexPath(self) {
            DispatchQueue.main.async(execute: {[weak self] in
                self?.view.updateTo(indexPath)
                })
        }
    }
    
    override func didEndDiplayed() {
        view.didEndDisplay()
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

extension CTASelectorFontCell: CTAPickerViewDataSource {
    
    func pickViewRegisterItemCellClass(_ view: CTAPickerView) -> (AnyClass?, String) {
        return (CTAVerticalItemFontsCollectionViewCell.self, "SelectorFontItemCell")
    }
    
    func numberOfSectionsInCollectionView(_ view: CTAPickerView) -> Int {
        return CTAFontsManager.families.count
    }
    
    func pickView(_ view: CTAPickerView, numberOfItemsAtSection section: Int) -> Int {
        let afamily = CTAFontsManager.families[section]
        
        guard let fonts  = CTAFontsManager.fontNamesWithFamily(afamily) else {
            return 0
        }
        return fonts.count
    }
    
    func pickView(_ view: CTAPickerView, indexAtSection section: Int) -> Int {
        
        guard let index = CTAFontsManager.itemAtSection(section) else {
            return 0
        }
        
        return index
    }
    
    func pickView(_ view: CTAPickerView, configItemCell itemCell: CTAVerticalItemCollectionViewCell, itemAtSection section: Int, ItemAtIndex index: Int) {
        if let itemCell = itemCell as? CTAVerticalItemFontsCollectionViewCell {
            let res = CTAFontsManager.familyAndFontNameWith(IndexPath(item: index, section: section))
            
            guard let family = res.0, let fontName = res.1, let font = UIFont(name: fontName, size: 17) else {
                return
            }
            
            if let displayFamilyName = CTAFontsManager.customFamilyDisplayNameBy(family) {
            
//            if let displayFamilyName = CTFontCopyLocalizedName(font, kCTFontFamilyNameKey, nil) {
            
//                let n = (displayFamilyName as NSString).stringByReplacingOccurrencesOfString("（非商用）", withString: "").stringByReplacingOccurrencesOfString("G0v1", withString: "").stringByReplacingOccurrencesOfString("(Noncommercial)", withString: "")
                
//                let n = CTAFontsManager.customFamilyDisplayNameBy(family) ?? family
                
                itemCell.view.text = displayFamilyName
            } else {
                itemCell.view.text = family
            }
            
                itemCell.view.font = font
        }
    }
}

extension CTASelectorFontCell: CTAPickerViewDelegate {
    
    func pickView(_ view: CTAPickerView, itemDidChangedToIndexPath indexPath: IndexPath) {
        
        debug_print("color cell will began at \(indexPath)", context: colorContext)
        CTAFontsManager.updateSection(indexPath.section, withItem: indexPath.item)
    }
    
    func pickView(_ view: CTAPickerView, sectionDidChangedToIndexPath indexPath: IndexPath) {
        
    }
    
}
