//
//  CTASelectorSizeCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/5/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTASelectorSizeCell: CTASelectorCell {

    let sizeView: CTAScrollTuneView
    
    override init(frame: CGRect) {
        self.sizeView = CTAScrollTuneView(frame: CGRect(x: 0, y: 0, width: 320, height: 88))
        super.init(frame: frame)
        
        contentView.addSubview(sizeView)
    }

    required init?(coder aDecoder: NSCoder) {
        self.sizeView = CTAScrollTuneView(frame: CGRect(x: 0, y: 0, width: 320, height: 88))
        super.init(coder: aDecoder)
        contentView.addSubview(sizeView)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        sizeView.frame = bounds
    }

}
