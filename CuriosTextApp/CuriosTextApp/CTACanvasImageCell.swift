//
//  CTACanvasImageCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 2/14/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTACanvasImageCell: CTACanvasCell {

    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        self.imageView = UIImageView()
        super.init(frame: frame)

        imageView.layer.drawsAsynchronously = true
        contentView.layer.addSublayer(imageView.layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.imageView = UIImageView()
        super.init(coder: aDecoder)
        imageView.layer.drawsAsynchronously = true
        contentView.layer.addSublayer(imageView.layer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = contentView.bounds
    }
}
