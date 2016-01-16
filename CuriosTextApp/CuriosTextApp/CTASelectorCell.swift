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
//    func selectorBeganIndexPath(cell: CTASelectorCell) -> NSIndexPath
    func selectorBeganAlignment(cell: CTASelectorCell) -> NSTextAlignment
    func selectorBeganSpacing(cell: CTASelectorCell) -> (CGFloat, CGFloat)
    func selectorBeganFontIndexPath(cell: CTASelectorCell) -> NSIndexPath?
    func selectorBeganColorIndexPath(cell: CTASelectorCell) -> NSIndexPath?
    
}

protocol CTASelectorControl: class {
    func retriveBeganValue()
    func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents)
    func removeAllTarget()
}

class CTASelectorCell: UICollectionViewCell, CTASelectorControl {
    weak var dataSource: CTASelectorDataSource?
    var controlView: UIControl?
    
    func beganLoad(){}
    func retriveBeganValue(){}
    func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents){}
    func removeAllTarget(){}
}
