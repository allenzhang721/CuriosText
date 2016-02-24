//
//  CTAPreviewCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/18/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAPreviewCell: UICollectionViewCell {
    
    var previewView: CTAPreviewView!
    
//    override func awakeFromNib() {
//        setup()
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func injected() {
        
        setup()
    }
    
    func setup() {
        previewView = CTAPreviewView(frame: bounds)
        contentView.addSubview(previewView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewView.frame = bounds
    }
}
