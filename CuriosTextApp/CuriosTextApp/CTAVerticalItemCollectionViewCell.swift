//
//  CTAVerticalItemCollectionViewCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/12/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

protocol CTAVerticalItemCollectionViewCellDelegate: class {
    
    func itemCellSuperActived(_ cell: CTAVerticalItemCollectionViewCell) -> Bool
    
}

class CTAVerticalItemCollectionViewCell: UICollectionViewCell {
    
//    var superActived: Bool = false
    var actived: Bool = false
    
    weak var delegate: CTAVerticalItemCollectionViewCellDelegate?
    
    func update() {
        
    }
    
}
