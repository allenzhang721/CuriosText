//
//  CTATabView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/30/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

protocol CTATabViewDataSource: class {
    
    func numberOfTabItemsInTabView(view: CTATabView) -> Int
    func tabView(view: CTATabView, cellForItemAtIndexPath: NSIndexPath) -> UICollectionViewCell
}


class CTATabView: UIControl {

    private(set) var configCollectionView: UICollectionView!
    private(set) var tabCollectionView: UICollectionView!
    weak var dataSource: CTATabViewDataSource?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        let lineLayout = CTALineFlowLayout()
        lineLayout.scrollDirection = .Horizontal
        lineLayout.showCount = 4
        lineLayout.delegate = self
        tabCollectionView = UICollectionView(frame: bounds, collectionViewLayout: lineLayout)
        tabCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        tabCollectionView.backgroundColor = UIColor.whiteColor()
        tabCollectionView.showsHorizontalScrollIndicator = false
        tabCollectionView.showsVerticalScrollIndicator = false
        tabCollectionView.registerClass(CTALabelCollectionViewCell.self, forCellWithReuseIdentifier: "LabelCell")
        tabCollectionView.dataSource = self
        addSubview(tabCollectionView)
        
        let selectorLayout = CTASelectorsFlowLayout()
        configCollectionView = UICollectionView(frame: bounds, collectionViewLayout: selectorLayout)
        configCollectionView.backgroundColor = UIColor.whiteColor()
        configCollectionView.showsHorizontalScrollIndicator = false
        configCollectionView.showsVerticalScrollIndicator = false
        configCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "ConfigCell")
        configCollectionView.dataSource = self
        addSubview(configCollectionView)
        
        // constraints
        tabCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tabCollectionView.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        tabCollectionView.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        tabCollectionView.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        tabCollectionView.heightAnchor.constraintEqualToConstant(30).active = true
        
        configCollectionView.translatesAutoresizingMaskIntoConstraints = false
        configCollectionView.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        configCollectionView.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        configCollectionView.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        configCollectionView.bottomAnchor.constraintEqualToAnchor(tabCollectionView.topAnchor).active = true
    }
}

extension CTATabView: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
            
        case tabCollectionView:
            return dataSource?.numberOfTabItemsInTabView(self) ?? 1
            
        case configCollectionView:
            return 1
            
        default:
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            
        case tabCollectionView:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("LabelCell", forIndexPath: indexPath)
            return cell
            
        case configCollectionView:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ConfigCell", forIndexPath: indexPath)
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("defaultCell", forIndexPath: indexPath)
            return cell
        }
    }
}

extension CTATabView: LineFlowLayoutDelegate {
    
    func didChangeTo(collectionView: UICollectionView, itemAtIndexPath indexPath: NSIndexPath, oldIndexPath: NSIndexPath?) {
        
        
    }
}
