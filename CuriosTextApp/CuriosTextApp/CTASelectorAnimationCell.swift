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
    
    
    func animationCellWillDeleteAnimation(_ cell: CTASelectorAnimationCell, completedBlock:(() -> ())?)
    func animationCell(_ cell: CTASelectorAnimationCell, WillAppendAnimation ani: CTAAnimationName, completedBlock:(() -> ())?)
    func animationCell(_ cell: CTASelectorAnimationCell, didChangedToAniamtion ani: CTAAnimationName)
    func animationCell(_ cell: CTASelectorAnimationCell, durationDidChanged duration: CGFloat)
    func animationCell(_ cell: CTASelectorAnimationCell, delayDidChanged delay: CGFloat)
    func animationCellAnimationPlayWillBegan(_ cell: CTASelectorAnimationCell)
}

class CTASelectorAnimationCell: CTASelectorCell {

    var playView: CTAGradientButtonView!
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
    
    fileprivate func setup() {
        
        tabView = CTATabView(frame: bounds)
        tabView.backgroundColor = UIColor.white
        tabView.dataSource = self
        tabView.delegate = self
        contentView.addSubview(tabView)
        
        // Constraints
        tabView.translatesAutoresizingMaskIntoConstraints = false
        tabView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        tabView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        tabView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        tabView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        // play View
        playView = CTAGradientButtonView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        playView.didClickHandler = { [weak self] in
            self?.delegate?.animationCellAnimationPlayWillBegan(self!)
        }
        playView.image = CTAStyleKit.imageOfAnimationplay
        contentView.addSubview(playView)
        playView.translatesAutoresizingMaskIntoConstraints = false
        playView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        playView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        playView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        playView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
    }
    
    override func willBeDisplayed() {
        tabView.reloadData()
    }
    
    
    override func didEndDiplayed() {
//        tabView.delegate = nil
    }
}

extension CTASelectorAnimationCell: CTATabViewDataSource {
    
    func numberOfTabItemsInTabView(_ view: CTATabView) -> Int {
        
//        let id = animation?.targetiD
        return animation != nil ? 3 : 1
    }
    
    func beganOfIndexPath(_ view: CTATabView) -> IndexPath {
        
        if let animation = animation, let index = CTAAnimationName.names.index(of: animation.animationName) {
            playView.alpha = 1.0
            return IndexPath(item: index, section: 0)
        } else {
            playView.alpha = 0.0
            return IndexPath(item: 0, section: 0)
        }
    }
    
    func tabViewBeganValue(_ view: CTATabView,atIndexPath indexPath: IndexPath) -> CGFloat {
        
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
    
    func tabView(_ view: CTATabView, didSelectedIndexPath indexPath: IndexPath, oldIndexPath: IndexPath?) {
        
        if oldIndexPath == nil && indexPath.item == 0 {
            return
        }
        
        if let oldIndexPath = oldIndexPath {
            
            switch (indexPath.item, oldIndexPath.item) {
                
            case (let i, 0) where i > 0:
                
                DispatchQueue.main.async(execute: { [weak self] in
                    self?.delegate?.animationCell(self!, WillAppendAnimation: CTAAnimationName.names[i]) {
                        debug_print("animation after add will reload", context: animationChangedContext)
                        self?.tabView.tabCollectionView.reloadSections(IndexSet(integer: 0))
                        UIView.animate(withDuration: 0.3, animations: { 
                            self?.playView.alpha = 1.0
                        })
                    }
                    
                })
                
            case (0, let i) where i > 0:
                
                DispatchQueue.main.async(execute: { [weak self] in
                    self?.delegate?.animationCellWillDeleteAnimation(self!) {
                        
                        debug_print("animation after delete will reload", context: animationChangedContext)
                        self?.tabView.tabCollectionView.reloadSections(IndexSet(integer: 0))
                        UIView.animate(withDuration: 0.3, animations: {
                            self?.playView.alpha = 0.0
                        })
                    }
                })
                
            case (let i, let j) where i > 0 && j > 0:
                DispatchQueue.main.async(execute: { [weak self] in
                    self?.delegate?.animationCell(self!, didChangedToAniamtion: CTAAnimationName.names[i])
                })
                
                
            default:
                ()
            }
        }
    }
    
    func tabView(_ view: CTATabView, valueDidChanged value: CGFloat, indexPath: IndexPath) {
        
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
