//
//  CTATabViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

protocol CTATabViewControllerDataSource: class {
    
    func tabViewControllerNumberOfItems(_ viewController: CTATabViewController) -> Int
    func tabViewController(_ viewController: CTATabViewController, tabItemAtIndexPath indexPath: IndexPath) -> CTABarItem

}

protocol CTATabViewControllerDelegate: class {
    
    func tabViewController(_ ViewController: CTATabViewController, didChangedToIndexPath indexPath: IndexPath, oldIndexPath: IndexPath?)
}

class CTATabViewController: UIViewController {

    weak var delegate: CTATabViewControllerDelegate?
    weak var dataSource: CTATabViewControllerDataSource?
    @IBOutlet weak var collectionView: UICollectionView!
    
    var changingContainer = false
    
    var layout: CTALineFlowLayout {
        return collectionView.collectionViewLayout as! CTALineFlowLayout
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = CTALineFlowLayout()
        layout.showCount = 4
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.delegate = self
        
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        layout.scrollDirection = .horizontal
        layout.delegate = self
        
        view.backgroundColor = CTAStyleKit.commonBackgroundColor
    }
    
    deinit {
        debug_print("\(#file) deinit", context: deinitContext)
    }
    
    func refreshItemIfNeed() {
        collectionView.reloadData()
    }
}

extension CTATabViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let dataSource = dataSource else {
            return 0
        }
        
        return dataSource.tabViewControllerNumberOfItems(self)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCell", for: indexPath) as! CTAScollBarCell
        
        if let dataSource = dataSource {
            cell.barItemView.setItem(dataSource.tabViewController(self, tabItemAtIndexPath: indexPath))
        }

        return cell
    }
}

extension CTATabViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let att = collectionView.layoutAttributesForItem(at: indexPath) {
//            tapping = true
            let center = att.center
            let offset = CGPoint(x: center.x - collectionView.bounds.width / 2.0, y: 0)
            collectionView.setContentOffset(offset, animated: true)
//            delegate?.tabViewController(self, didChangedToIndexPath: indexPath, oldIndexPath: nil)
        }
        
//        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
//        collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .CenteredHorizontally)
    }
}

extension CTATabViewController: LineFlowLayoutDelegate {
    
    func didChangeTo(
        _ collectionView: UICollectionView,
        itemAtIndexPath indexPath: IndexPath,
        oldIndexPath: IndexPath?) {
        
        
//        print("will change")
//        if (collectionView.dragging || collectionView.tracking || collectionView.decelerating) || tapping == true {
//            print("didchange")
        
        
        if changingContainer {
            changingContainer = false
//            delegate?.tabViewController(self, didChangedToIndexPath: indexPath, oldIndexPath: oldIndexPath)
            
        } else {
            delegate?.tabViewController(self, didChangedToIndexPath: indexPath, oldIndexPath: oldIndexPath)
        }
        
    }
}
