//
//  CTATabView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/30/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

enum CTATabConfigType {
    
    case None, Animation, Duration, Delay
}

protocol CTATabViewDataSource: class {
    
    func numberOfTabItemsInTabView(view: CTATabView) -> Int
    func beganOfIndexPath(view: CTATabView) -> NSIndexPath
    func tabViewBeganValue(view: CTATabView,atIndexPath indexPath: NSIndexPath) -> CGFloat
}

protocol CTATabViewDelegate: class {
    
    func tabView(view: CTATabView, didSelectedIndexPath indexPath: NSIndexPath, oldIndexPath: NSIndexPath?)
    func tabView(view: CTATabView, valueDidChanged value: CGFloat, indexPath: NSIndexPath)
    
}

class CTATabView: UIControl {

    private(set) var configCollectionView: UICollectionView!
    private(set) var tabCollectionView: UICollectionView!
    weak var dataSource: CTATabViewDataSource?
    weak var delegate: CTATabViewDelegate?
    private var currentConfigType: CTATabConfigType = .Animation
    
    
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
        tabCollectionView.delegate = self
        addSubview(tabCollectionView)
        
        let selectorLayout = CTASelectorsFlowLayout()
        configCollectionView = UICollectionView(frame: bounds, collectionViewLayout: selectorLayout)
        configCollectionView.backgroundColor = UIColor.whiteColor()
        configCollectionView.showsHorizontalScrollIndicator = false
        configCollectionView.showsVerticalScrollIndicator = false
        configCollectionView.registerClass(CTAConfigSliderCell.self, forCellWithReuseIdentifier: "ConfigSliderCell")
        configCollectionView.registerClass(CTAConfigAnimationCell.self, forCellWithReuseIdentifier: "ConfigAnimationCell")
        configCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
        configCollectionView.dataSource = self
        configCollectionView.delegate = self
        addSubview(configCollectionView)
        
        // constraints
        tabCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tabCollectionView.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        tabCollectionView.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        tabCollectionView.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        tabCollectionView.heightAnchor.constraintEqualToAnchor(heightAnchor, multiplier: 0.5).active = true
        
        configCollectionView.translatesAutoresizingMaskIntoConstraints = false
        configCollectionView.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        configCollectionView.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        configCollectionView.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        configCollectionView.bottomAnchor.constraintEqualToAnchor(tabCollectionView.topAnchor).active = true
    }
    
    func reloadData() {
//        CATransaction.begin()
//        CATransaction.setDisableActions(true)
        tabCollectionView.reloadData()
        configCollectionView.reloadData()
//        CATransaction.commit()
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
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("LabelCell", forIndexPath: indexPath) as! CTALabelCollectionViewCell
            switch indexPath.item {
            case 0:
                cell.text = "Animation"
                
            case 1:
                cell.text = "Duration"
                
            case 2:
                cell.text = "Delay"
            default:
                ()
            }
            
            return cell
            
        case configCollectionView:
            switch currentConfigType {
            case .Animation:
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ConfigAnimationCell", forIndexPath: indexPath) as! CTAConfigAnimationCell
                
                cell.dataSource = self
                cell.delegate = self
                cell.backgroundColor = UIColor.whiteColor()
                return cell
                
            case .Duration, .Delay:
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ConfigSliderCell", forIndexPath: indexPath)
                cell.backgroundColor = UIColor.whiteColor()
                return cell
                
            case .None:
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DefaultCell", forIndexPath: indexPath)
                return cell
                
            }
            
        default:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("defaultCell", forIndexPath: indexPath)
            return cell
        }
    }
}

extension CTATabView: LineFlowLayoutDelegate {
    
    func didChangeTo(collectionView: UICollectionView, itemAtIndexPath indexPath: NSIndexPath, oldIndexPath: NSIndexPath?) {
        
        switch collectionView {
        case tabCollectionView:
        
            switch indexPath.item {
            case 0:
                currentConfigType = .Animation
            case 1:
                currentConfigType = .Duration
            case 2:
                currentConfigType = .Delay
            default:
                currentConfigType = .None
            }
            
            let acount = configCollectionView.numberOfItemsInSection(0)
            
//            debug_print(indexPath.item, context: aniContext)
            configCollectionView.performBatchUpdates({ () -> Void in
                self.configCollectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
                
                if acount > 0 {
                    self.configCollectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
                }
                
                }, completion: nil)
            
        default:
            ()
        }
    }
}

extension CTATabView: CTAConfigANimationCellDataSource {
    
    func configAnimationCellBeganIndexPath(cell: CTAConfigAnimationCell) -> NSIndexPath {
        
        return dataSource?.beganOfIndexPath(self) ?? NSIndexPath(forItem: 0, inSection: 0)
    }
}

extension CTATabView: CTAConfigAnimationCellDelegate {
    
    func configAnimationCell(cell: CTAConfigAnimationCell, DidSelectedIndexPath indexPath: NSIndexPath, oldIndexPath: NSIndexPath?) {
        
        delegate?.tabView(self, didSelectedIndexPath: indexPath, oldIndexPath: oldIndexPath)
    }
}

extension CTATabView: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let acenter = collectionView.collectionViewLayout.layoutAttributesForItemAtIndexPath(indexPath)?.center {
            collectionView.setContentOffset(CGPoint(x: acenter.x - collectionView.bounds.width / 2.0, y: 0), animated: true)
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        switch collectionView {
        case configCollectionView:
            if let cell = cell as? CTACellDisplayProtocol {
                
                dispatch_async(dispatch_get_main_queue(), { [weak self] in
                    
                    if let cell = cell as? CTAConfigSliderCell {
                        cell.beganValueBlock = {[weak self] in
                            if let strongSelf = self {
                                switch strongSelf.currentConfigType {
                                    
                                case .Duration:
                                    return strongSelf.dataSource?.tabViewBeganValue(strongSelf, atIndexPath: NSIndexPath(forItem: 1, inSection: 0)) ?? 0.3
                                    
                                case .Delay:
                                    return strongSelf.dataSource?.tabViewBeganValue(strongSelf, atIndexPath: NSIndexPath(forItem: 2, inSection: 0)) ?? 0.3
                                    
                                default:
                                    return 0.3
                                }
                            }
                            return 0.3
                        }
                        
                        cell.valueDidChangedBlock = { [weak self] value in
                            if let strongSelf = self {
                                switch strongSelf.currentConfigType {
                                    
                                case .Duration:
                                    strongSelf.delegate?.tabView(strongSelf, valueDidChanged: value, indexPath: NSIndexPath(forItem: 1, inSection: 0))
                                    
                                case .Delay:
                                    strongSelf.delegate?.tabView(strongSelf, valueDidChanged: value, indexPath: NSIndexPath(forItem: 2, inSection: 0))
                                    
                                default:
                                    ()
                                }
                            }
                            
                        }
                    }
                    
                    if let _ = self {
                        cell.willBeDisplayed()
                    }
                    
                })
                
            }
            
            
        default:
            ()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        switch collectionView {
        case configCollectionView:
            if let cell = cell as? CTACellDisplayProtocol {
                cell.didEndDisplayed()
            }
            
            
        default:
            ()
        }
    }
}
