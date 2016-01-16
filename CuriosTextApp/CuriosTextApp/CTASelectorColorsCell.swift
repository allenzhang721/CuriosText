//
//  CTASelectorColorsCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/12/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

final class CTASelectorColorsCell: CTASelectorCell {

    private var view: CTAPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        
        view = CTAPickerView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 88)), showCount: 4)
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
    
    override func beganLoad() {
        
        view.reloadData()
    }

    override func retriveBeganValue() {
        
        guard let dataSource = dataSource else {
            return
        }
        
        if let indexPath = dataSource.selectorBeganColorIndexPath(self) {
            
            debug_print("color cell will began at \(indexPath)", context: colorContext)
            CTAColorsManger.updateSection(indexPath.section, withItem: indexPath.item)
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

extension CTASelectorColorsCell: CTAPickerViewDataSource {
    
    func pickViewRegisterItemCellClass(view: CTAPickerView) -> (AnyClass?, String) {
        
        return (CTAVerticalItemColorCollectionViewCell.self, "SelectorColorItemCell")
    }
    
    func numberOfSectionsInCollectionView(view: CTAPickerView) -> Int {
        
        return CTAColorsManger.colorsCatagory.count
    }
    
    func pickView(view: CTAPickerView, numberOfItemsAtSection section: Int) -> Int {
        
        let catagory = CTAColorsManger.colorsCatagory[section]
        return CTAColorsManger.colors[catagory]!.count
    }
    
    func pickView(view: CTAPickerView, indexAtSection section: Int) -> Int {
        
        guard let index = CTAColorsManger.itemAtSection(section) else {
            return 0
        }
        
        return index
    }
    
   func pickView(view: CTAPickerView, configItemCell itemCell: CTAVerticalItemCollectionViewCell, itemAtSection section: Int, ItemAtIndex index: Int) {
    
    if let itemCell = itemCell as? CTAVerticalItemColorCollectionViewCell {
        itemCell.colorView.backgroundColor = CTAColorsManger.colorAtIndexPath(NSIndexPath(forItem: index, inSection: section))?.color
    }
    }
}

extension CTASelectorColorsCell: CTAPickerViewDelegate {
    
    func pickView(view: CTAPickerView, itemDidChangedToIndexPath indexPath: NSIndexPath) {
        
        debug_print("color cell will began at \(indexPath)", context: colorContext)
        CTAColorsManger.updateSection(indexPath.section, withItem: indexPath.item)
    }
    
    func pickView(view: CTAPickerView, sectionDidChangedToIndexPath indexPath: NSIndexPath) {
        
    }
    
}
