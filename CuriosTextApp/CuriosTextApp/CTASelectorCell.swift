//
//  CTASelectorCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/5/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

protocol CTASelectorDataSource: class {
    
    func selectorBeganScale(cell: CTASelectorCell) -> CGFloat
    func selectorBeganRadian(cell: CTASelectorCell) -> CGFloat
}

protocol CTASelectorControl: class {
    
    func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents)
    
    func removeAllTarget()
}

class CTASelectorCell: UICollectionViewCell, CTASelectorControl {
    
    weak var dataSource: CTASelectorDataSource?
    
    func retriveBeganValue(){}
    
    func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents){}
    
    func removeAllTarget(){}
}
