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
        
        super.init(frame: frame)
        self.imageView = UIImageView(frame: bounds)
        imageView.layer.drawsAsynchronously = true
//        imageView.backgroundColor = UIColor.blueColor()
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.imageView = UIImageView()
        super.init(coder: aDecoder)
        self.imageView = UIImageView(frame: bounds)
        imageView.layer.drawsAsynchronously = true
//        imageView.backgroundColor = UIColor.blueColor()
        contentView.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = contentView.bounds
    }
}
