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
    
}

typealias CTASelectorViewControllerDelegate = protocol<CTASelectorScaleable>

class CTASelectorsViewController: UIViewController, UICollectionViewDataSource {
    
    var container: ContainerVMProtocol? {
        return dataSource?.selectorsViewControllerContainer(self)
    }
    
    var count: Int {
        return (container == nil) ? 0 : 1
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
        
        currentType = type
        
        let acount = count
        
        collectionview.performBatchUpdates({ () -> Void in
            
            collectionview.insertItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
            
            if acount > 0 {
                collectionview.deleteItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
            }
            
            }, completion: nil)
    }
    
    func reloadData() {
        
        guard let collectionview = collectionview else {
            return
        }
        
        let currentCount = collectionview.numberOfItemsInSection(0)
        let nextCount = count
        
        collectionview.performBatchUpdates({ () -> Void in
            
            if nextCount > 0 {
                collectionview.insertItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
            }
            
            if currentCount > 0 || nextCount <= 0 {
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
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Selector\(currentType.rawValue)Cell", forIndexPath: indexPath) as! CTASelectorSizeCell
        
        cell.sizeView.updateValue(container!.scale)
        
        cell.sizeView.addTarget(self, action: "scaleChanged:", forControlEvents: .ValueChanged)
//        print((container as! TextContainerVMProtocol).textElement.fontScale)
        
        cell.backgroundColor = UIColor.whiteColor()
        
        return cell
    }
}

extension CTASelectorsViewController {
    
    func scaleChanged(sender: CTAScrollTuneView) {
        let v = CGFloat(Int(sender.value * 100.0)) / 100.0
        print("nextScale = \(v)")
        delegate?.scaleDidChanged(v)
        
    }
    
}
