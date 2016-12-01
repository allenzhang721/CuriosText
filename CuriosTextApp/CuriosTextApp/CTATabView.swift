//
//  CTATabView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/30/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

enum CTATabConfigType {
    
    case none, animation, duration, delay
}

protocol CTATabViewDataSource: class {
    
    func numberOfTabItemsInTabView(_ view: CTATabView) -> Int
    func beganOfIndexPath(_ view: CTATabView) -> IndexPath
    func tabViewBeganValue(_ view: CTATabView,atIndexPath indexPath: IndexPath) -> CGFloat
}

protocol CTATabViewDelegate: class {
    
    func tabView(_ view: CTATabView, didSelectedIndexPath indexPath: IndexPath, oldIndexPath: IndexPath?)
    func tabView(_ view: CTATabView, valueDidChanged value: CGFloat, indexPath: IndexPath)
    
}

class CTATabView: UIControl {

    fileprivate(set) var configCollectionView: UICollectionView!
    fileprivate(set) var tabCollectionView: UICollectionView!
    weak var dataSource: CTATabViewDataSource?
    weak var delegate: CTATabViewDelegate?
    fileprivate var currentConfigType: CTATabConfigType = .animation
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        
        let lineLayout = CTALineFlowLayout()
        lineLayout.scrollDirection = .horizontal
        lineLayout.showCount = 4
        lineLayout.delegate = self
        tabCollectionView = UICollectionView(frame: bounds, collectionViewLayout: lineLayout)
        tabCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        tabCollectionView.backgroundColor = UIColor.white
        tabCollectionView.showsHorizontalScrollIndicator = false
        tabCollectionView.showsVerticalScrollIndicator = false
        tabCollectionView.register(CTALabelCollectionViewCell.self, forCellWithReuseIdentifier: "LabelCell")
        tabCollectionView.dataSource = self
        tabCollectionView.delegate = self
        addSubview(tabCollectionView)
        
        let selectorLayout = CTASelectorsFlowLayout()
        configCollectionView = UICollectionView(frame: bounds, collectionViewLayout: selectorLayout)
        configCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        configCollectionView.backgroundColor = UIColor.white
        configCollectionView.showsHorizontalScrollIndicator = false
        configCollectionView.showsVerticalScrollIndicator = false
        configCollectionView.register(CTAConfigSliderCell.self, forCellWithReuseIdentifier: "ConfigSliderCell")
        configCollectionView.register(CTAConfigAnimationCell.self, forCellWithReuseIdentifier: "ConfigAnimationCell")
        configCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
//        configCollectionView.userInteractionEnabled = true
        configCollectionView.dataSource = self
        configCollectionView.delegate = self
        addSubview(configCollectionView)
        
        // constraints
        tabCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tabCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tabCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tabCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tabCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        
        configCollectionView.translatesAutoresizingMaskIntoConstraints = false
        configCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        configCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        configCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        configCollectionView.bottomAnchor.constraint(equalTo: tabCollectionView.topAnchor).isActive = true
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
            
        case tabCollectionView:
            return dataSource?.numberOfTabItemsInTabView(self) ?? 1
            
        case configCollectionView:
            return 1
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            
        case tabCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelCell", for: indexPath) as! CTALabelCollectionViewCell
            switch indexPath.item {
            case 0:
                cell.text = LocalStrings.animationType.description
                
            case 1:
                cell.text = LocalStrings.animationDuration.description
                
            case 2:
                cell.text = LocalStrings.animationDelay.description
            default:
                ()
            }
            
            return cell
            
        case configCollectionView:
            switch currentConfigType {
            case .animation:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConfigAnimationCell", for: indexPath) as! CTAConfigAnimationCell
                
                cell.dataSource = self
                cell.delegate = self
                cell.backgroundColor = UIColor.white
                return cell
                
            case .duration, .delay:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConfigSliderCell", for: indexPath)
                cell.backgroundColor = UIColor.white
                return cell
                
            case .none:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
                return cell
                
            }
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "defaultCell", for: indexPath)
            return cell
        }
    }
}

extension CTATabView: LineFlowLayoutDelegate {
    
    func didChangeTo(_ collectionView: UICollectionView, itemAtIndexPath indexPath: IndexPath, oldIndexPath: IndexPath?) {
        
        switch collectionView {
        case tabCollectionView:
        
            switch indexPath.item {
            case 0:
                currentConfigType = .animation
            case 1:
                currentConfigType = .duration
            case 2:
                currentConfigType = .delay
            default:
                currentConfigType = .none
            }
            
            let acount = configCollectionView.numberOfItems(inSection: 0)
            
//            debug_print(indexPath.item, context: aniContext)
            configCollectionView.performBatchUpdates({ () -> Void in
                self.configCollectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
                
                if acount > 0 {
                    self.configCollectionView.deleteItems(at: [IndexPath(item: 0, section: 0)])
                }
                
                }, completion: nil)
            
        default:
            ()
        }
    }
}

extension CTATabView: CTAConfigANimationCellDataSource {
    
    func configAnimationCellBeganIndexPath(_ cell: CTAConfigAnimationCell) -> IndexPath {
        
        return dataSource?.beganOfIndexPath(self) ?? IndexPath(item: 0, section: 0)
    }
}

extension CTATabView: CTAConfigAnimationCellDelegate {
    
    func configAnimationCell(_ cell: CTAConfigAnimationCell, DidSelectedIndexPath indexPath: IndexPath, oldIndexPath: IndexPath?) {
        
        delegate?.tabView(self, didSelectedIndexPath: indexPath, oldIndexPath: oldIndexPath)
    }
}

extension CTATabView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let acenter = collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath)?.center {
            collectionView.setContentOffset(CGPoint(x: acenter.x - collectionView.bounds.width / 2.0, y: 0), animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case configCollectionView:
            if let cell = cell as? CTACellDisplayProtocol {
                
                DispatchQueue.main.async(execute: { [weak self] in
                    
                    if let cell = cell as? CTAConfigSliderCell {
                        cell.beganValueBlock = {[weak self] in
                            if let strongSelf = self {
                                switch strongSelf.currentConfigType {
                                    
                                case .duration:
                                    return strongSelf.dataSource?.tabViewBeganValue(strongSelf, atIndexPath: IndexPath(item: 1, section: 0)) ?? 0.3
                                    
                                case .delay:
                                    return strongSelf.dataSource?.tabViewBeganValue(strongSelf, atIndexPath: IndexPath(item: 2, section: 0)) ?? 0.3
                                    
                                default:
                                    return 0.3
                                }
                            }
                            return 0.3
                        }
                        
                        cell.valueDidChangedBlock = { [weak self] value in
                            if let strongSelf = self {
                                switch strongSelf.currentConfigType {
                                    
                                case .duration:
                                    strongSelf.delegate?.tabView(strongSelf, valueDidChanged: value, indexPath: IndexPath(item: 1, section: 0))
                                    
                                case .delay:
                                    strongSelf.delegate?.tabView(strongSelf, valueDidChanged: value, indexPath: IndexPath(item: 2, section: 0))
                                    
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
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
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
