//
//  ContentImageCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 4/10/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class ContentImageCell: ContentCell {
    
    var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
        }
    }
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        contentView.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let append: CGFloat = 0.0
//        textLayer.insets = CGPoint(x: bounds.width * append * 0.5 * 0.5, y: 0)
        imageView.bounds.size = CGSize(width: bounds.width * (1.0 + append), height: bounds.height)
        imageView.center = CGPoint(x: contentView.bounds.midX, y: contentView.bounds.midY)
    }
}
