//
//  CTASelectorFontNameCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/8/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTASelectorFontNameCell: UICollectionViewCell {

    private var selectView: CTAScrollSelectView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        self.selectView = CTAScrollSelectView(frame: bounds, direction: .Horizontal)
        addSubview(selectView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectView.frame = bounds
    }

}
