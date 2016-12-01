//
//  CTASelectorCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/5/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

protocol CTASelectorDataSource: class {
    
    func selectorBeganScale(_ cell: CTASelectorCell) -> CGFloat
    func selectorBeganRadian(_ cell: CTASelectorCell) -> CGFloat
//    func selectorBeganIndexPath(cell: CTASelectorCell) -> NSIndexPath
    func selectorBeganAlignment(_ cell: CTASelectorCell) -> NSTextAlignment
    func selectorBeganNeedShadowAndStroke(_ cell: CTASelectorCell) -> (Bool, Bool)
    func selectorBeganSpacing(_ cell: CTASelectorCell) -> (CGFloat, CGFloat)
    func selectorBeganFontIndexPath(_ cell: CTASelectorCell) -> IndexPath?
    func selectorBeganColor(_ cell: CTASelectorCell) -> UIColor?
    func selectorBeganAnimation(_ cell: CTASelectorCell) -> CTAAnimationBinder?
    func selectorBeganAlpha(_ cell: CTASelectorCell) -> CGFloat
    func selectorBeganFilter(_ cell: CTASelectorCell) -> Int
}

protocol CTASelectorControl: class {
    func retriveBeganValue()
    func addTarget(_ target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents)
    func removeAllTarget()
}

class CTASelectorCell: UICollectionViewCell, CTASelectorControl {
    weak var dataSource: CTASelectorDataSource?
    var controlView: UIControl?
    
    func beganLoad(){}
    func retriveBeganValue(){}
    func addTarget(_ target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents){}
    func removeAllTarget(){}
    
    func willBeDisplayed(){}
    func didEndDiplayed(){}
}
