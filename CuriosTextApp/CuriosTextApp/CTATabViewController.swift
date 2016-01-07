//
//  CTATabViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

protocol CTATabViewControllerDataSource: class {
    
    func tableViewControllerNumberOfItems(viewController: CTATabViewController) -> Int
    func tableViewController(viewController: CTATabViewController, tabItemAtIndexPath indexPath: NSIndexPath) -> CTATabItem
}

class CTATabItem {
    
    let userInfo: AnyObject?
    
    init(userInfo: AnyObject? = nil) {
        self.userInfo = userInfo
    }
}

class CTATabViewController: UIViewController {

    weak var delegate: LineFlowLayoutDelegate?
    weak var dataSource: CTATabViewControllerDataSource?
    @IBOutlet weak var collectionView: UICollectionView!
    var layout: CTALineFlowLayout {
        return collectionView.collectionViewLayout as! CTALineFlowLayout
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        layout.delegate = delegate
    }
}

extension CTATabViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let dataSource = dataSource else {
            return 0
        }
        
        return dataSource.tableViewControllerNumberOfItems(self)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TabCell", forIndexPath: indexPath)

        
        return cell
        
    }
    
}
