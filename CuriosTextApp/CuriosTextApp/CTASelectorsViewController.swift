//
//  CTASelectorsViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

protocol CTASelectorsViewControllerDataSource: class {
    
    func selectorsViewControllerContainer(viewcontroller: CTASelectorsViewController) -> ContainerVMProtocol?
}

protocol CTASelectorable: class {
    
}

protocol CTASelectorScaleable: CTASelectorable {
    
    func scaleDidChanged(scale: CGFloat)
    func radianDidChanged(radian: CGFloat)
    
}

typealias CTASelectorViewControllerDelegate = protocol<CTASelectorScaleable>

class CTASelectorsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var container: ContainerVMProtocol? {
        return dataSource?.selectorsViewControllerContainer(self)
    }
    
    var count: Int {
        return (container == nil) ? 0 : 1
    }
    
    var action: String {
        
        switch currentType {
            
        case .Size:
            return "scaleChanged:"
            
        case .Rotator:
            return "radianChanged:"
            
        default:
            return ""
        }
        
    }
    
    private var began: Bool = false
    
    var dataSource: CTASelectorsViewControllerDataSource?
    var delegate: CTASelectorViewControllerDelegate?
    private var currentType: CTASelectorType = .Size
    
    @IBOutlet weak var collectionview: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func changeToSelector(type: CTASelectorType = .Size) {
        
        guard let collectionview = collectionview where container != nil else {
            return
        }
        
        if let cell = collectionview.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as? CTASelectorCell {
            
            cell.dataSource = nil
            cell.removeAllTarget()
        }
        
        currentType = type
        
        let acount = collectionview.numberOfItemsInSection(0)
        
        collectionview.performBatchUpdates({ () -> Void in
            
            collectionview.insertItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
            
            if acount > 0 {
                collectionview.deleteItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
            }
            
            }, completion: nil)
    }
    
    func updateSelector() {
        
        guard let collectionview = collectionview else {
            return
        }
        
        if let cell = collectionview.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as? CTASelectorCell {
            
            cell.dataSource = nil
            cell.removeAllTarget()
        }
        
        let currentCount = collectionview.numberOfItemsInSection(0)
        let nextCount = count
        
        collectionview.performBatchUpdates({ () -> Void in
            
            if nextCount > 0 {
                collectionview.insertItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
            }
            
            if currentCount > 0 {
                collectionview.deleteItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
            }
            }, completion: nil)
    }
    
}

extension CTASelectorsViewController {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Selector\(currentType.rawValue)Cell", forIndexPath: indexPath)
        
        print("Selector Cell")
        cell.backgroundColor = UIColor.blackColor()
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        guard let cell = cell as? CTASelectorCell else {
            return
        }
        cell.dataSource = self
        cell.retriveBeganValue()
        cell.addTarget(self, action: Selector(action), forControlEvents: .ValueChanged)
    }
}

// MARK: - SelectorDataSource
extension CTASelectorsViewController: CTASelectorDataSource {
    
    func selectorBeganScale(cell: CTASelectorCell) -> CGFloat {
        return container!.scale
    }
    
    func selectorBeganRadian(cell: CTASelectorCell) -> CGFloat {
        return container!.radius
    }
}

// MARK: - Actions
extension CTASelectorsViewController {
    
    func scaleChanged(sender: CTAScrollTuneView) {
        let v = CGFloat(Int(sender.value * 100.0)) / 100.0
        print("nextScale = \(v)")
        delegate?.scaleDidChanged(v)
        
    }
    
    func radianChanged(sender: CTARotatorView) {
        let v = CGFloat(Int(sender.radian * 100.0)) / 100.0
        delegate?.radianDidChanged(v)
    }
    
}