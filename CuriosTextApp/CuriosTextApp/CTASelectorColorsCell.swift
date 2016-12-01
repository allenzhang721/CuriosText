//
//  CTASelectorColorsCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/12/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

final class CTASelectorColorsCell: CTASelectorCell {

//    private var view: CTAPickerView!
    
//    private var view: CTAColorPickerView!
    
    fileprivate var view: CTAColorPickerNodeCollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    fileprivate func setup() {
        
        clipsToBounds = false
//        backgroundColor = UIColor.clearColor()
        view = CTAColorPickerNodeCollectionView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width, height: 88)))
//        view.backgroundColor = UIColor.clearColor()
        contentView.addSubview(view)
//        view.backgroundColor = CTAStyleKit.intoDreams1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
//        view.dataSource = self
//        view.delegate = self
    }
    
    override func beganLoad() {
        
//        view.reloadData()
    }

    override func retriveBeganValue() {
        
        guard let dataSource = dataSource else {
            return
        }
        
        let color = dataSource.selectorBeganColor(self)
//        view.selectedColor = color
        view.selectColor(color)
        
//        if let color = dataSource.selectorBeganColor(self) {
//        
//            view.selectedColor = color
////            debug_print("color cell will began at \(indexPath)", context: colorContext)
////            CTAColorsManger.updateSection(indexPath.section, withItem: indexPath.item)
////            self.view.updateTo(indexPath)
//        } else {
////            view.
//        }
    }
    
    override func willBeDisplayed() {
        view.willBeganDisplay()
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

//extension CTASelectorColorsCell: CTAPickerViewDataSource {
//    
//    func pickViewRegisterItemCellClass(view: CTAPickerView) -> (AnyClass?, String) {
//        
//        return (CTAVerticalItemColorCollectionViewCell.self, "SelectorColorItemCell")
//    }
//    
//    func numberOfSectionsInCollectionView(view: CTAPickerView) -> Int {
//        
//        return CTAColorsManger.colorsCatagory.count
//    }
//    
//    func pickView(view: CTAPickerView, numberOfItemsAtSection section: Int) -> Int {
//        
//        let catagory = CTAColorsManger.colorsCatagory[section]
//        return CTAColorsManger.colors[catagory]!.count
//    }
//    
//    func pickView(view: CTAPickerView, indexAtSection section: Int) -> Int {
//        
//        guard let index = CTAColorsManger.itemAtSection(section) else {
//            return 0
//        }
//        
//        return index
//    }
//    
//   func pickView(view: CTAPickerView, configItemCell itemCell: CTAVerticalItemCollectionViewCell, itemAtSection section: Int, ItemAtIndex index: Int) {
//    
//    if let itemCell = itemCell as? CTAVerticalItemColorCollectionViewCell {
//        itemCell.colorView.backgroundColor = CTAColorsManger.colorAtIndexPath(NSIndexPath(forItem: index, inSection: section))?.color
//    }
//    }
//}
//
//extension CTASelectorColorsCell: CTAPickerViewDelegate {
//    
//    func pickView(view: CTAPickerView, itemDidChangedToIndexPath indexPath: NSIndexPath) {
//        
//        debug_print("color cell will began at \(indexPath)", context: colorContext)
//        CTAColorsManger.updateSection(indexPath.section, withItem: indexPath.item)
//    }
//    
//    func pickView(view: CTAPickerView, sectionDidChangedToIndexPath indexPath: NSIndexPath) {
//        
//    }
//    
//}
