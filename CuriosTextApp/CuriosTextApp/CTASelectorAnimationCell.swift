//
//  CTASelectorAnimationCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/30/16.
//  Copyright © 2016 botai. All rights reserved.
//

// This is Internal Layer

import UIKit

protocol CTASelectorAnimationCellDelegate: class {
    
    
    func animationCellWillDeleteAnimation(cell: CTASelectorAnimationCell, completedBlock:(() -> ())?)
    func animationCell(cell: CTASelectorAnimationCell, WillAppendAnimation ani: CTAAnimationName, completedBlock:(() -> ())?)
    func animationCell(cell: CTASelectorAnimationCell, didChangedToAniamtion ani: CTAAnimationName)
    func animationCell(cell: CTASelectorAnimationCell, durationDidChanged duration: CGFloat)
    func animationCell(cell: CTASelectorAnimationCell, delayDidChanged delay: CGFloat)
}

class CTASelectorAnimationCell: CTASelectorCell {

    var tabView: CTATabView!
    weak var delegate: CTASelectorAnimationCellDelegate?
    var animation: CTAAnimationBinder? {
        return dataSource?.selectorBeganAnimation(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        tabView = CTATabView(frame: bounds)
        tabView.backgroundColor = UIColor.whiteColor()
        tabView.dataSource = self
        tabView.delegate = self
        contentView.addSubview(tabView)
        
        // Constraints
        tabView.translatesAutoresizingMaskIntoConstraints = false
        tabView.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
        tabView.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor).active = true
        tabView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor).active = true
        tabView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor).active = true
    }
    
    override func willBeDisplayed() {
        tabView.reloadData()
    }
    
    
    override func didEndDiplayed() {
//        tabView.delegate = nil
    }
}

extension CTASelectorAnimationCell: CTATabViewDataSource {
    
    func numberOfTabItemsInTabView(view: CTATabView) -> Int {
        
        let id = animation?.targetiD
        debug_print("animation targetID \(id != nil ? id!.substringFromIndex(id!.endIndex.advancedBy(-4)) : "None") will load and have \(animation != nil ? 3 : 1) tab", context: animationChangedContext)
        return animation != nil ? 3 : 1
    }
    
    func beganOfIndexPath(view: CTATabView) -> NSIndexPath {
        
        if let animation = animation, let index = CTAAnimationName.names.indexOf(animation.animationName) {
            debug_print(animation.animationName.description, context: aniContext)
            return NSIndexPath(forItem: index, inSection: 0)
        } else {
            return NSIndexPath(forItem: 0, inSection: 0)
        }
    }
    
    func tabViewBeganValue(view: CTATabView,atIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        guard let animation = animation else {
            return 0
        }
        switch indexPath.item {
        case 1:
            return CGFloat(animation.duration) ?? 0
        case 2:
            return CGFloat(animation.delay) ?? 0
            
        default:
            return 0
        }
    }
}

extension CTASelectorAnimationCell: CTATabViewDelegate {
    
    func tabView(view: CTATabView, didSelectedIndexPath indexPath: NSIndexPath, oldIndexPath: NSIndexPath?) {
        
        if oldIndexPath == nil && indexPath.item == 0 {
            return
        }
        
        if let oldIndexPath = oldIndexPath {
            
            switch (indexPath.item, oldIndexPath.item) {
                
            case (let i, 0) where i > 0:
                
                dispatch_async(dispatch_get_main_queue(), { [weak self] in
                    self?.delegate?.animationCell(self!, WillAppendAnimation: CTAAnimationName.names[i]) {
                        debug_print("animation after add will reload", context: animationChangedContext)
                        self?.tabView.tabCollectionView.reloadSections(NSIndexSet(index: 0))
                    }
                    
                })
                
            case (0, let i) where i > 0:
                
                dispatch_async(dispatch_get_main_queue(), { [weak self] in
                    self?.delegate?.animationCellWillDeleteAnimation(self!) {
                        
                        debug_print("animation after delete will reload", context: animationChangedContext)
                        self?.tabView.tabCollectionView.reloadSections(NSIndexSet(index: 0))
                    }
                })
                
//                tabView.reloadData()
                
            case (let i, let j) where i > 0 && j > 0:
                dispatch_async(dispatch_get_main_queue(), { [weak self] in
                    self?.delegate?.animationCell(self!, didChangedToAniamtion: CTAAnimationName.names[i])
                })
                
                
            default:
                ()
            }
        }
    }
    
    func tabView(view: CTATabView, valueDidChanged value: CGFloat, indexPath: NSIndexPath) {
        
        switch indexPath.item {
        case 1:
            delegate?.animationCell(self, durationDidChanged: value)
        case 2:
            delegate?.animationCell(self, delayDidChanged: value)
        default:
            ()
        }
    }
}
