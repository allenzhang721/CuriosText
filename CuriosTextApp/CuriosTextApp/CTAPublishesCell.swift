//
//  CTAPublishesCell.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/8.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit

class CTAPublishesCell: UICollectionViewCell{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.greenColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentView.backgroundColor = UIColor.greenColor()
    }
}