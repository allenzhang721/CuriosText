//
//  CTAPhotoPreviewView.swift
//  ImagePickerApp
//
//  Created by Emiaostein on 2/29/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import UIKit

class CTAPhotoPreviewView: UIView {

    var image: UIImage? {
        get { return imageView.image }
        set { imageView.image = newValue }
    }
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(imageView)
        backgroundColor = UIColor.whiteColor()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        imageView
            .leadingAnchor
            .constraintEqualToAnchor(leadingAnchor, constant: 0)
            .active = true
        
        imageView
            .bottomAnchor
            .constraintEqualToAnchor(bottomAnchor, constant: -2)
            .active = true
        
        imageView
            .trailingAnchor
            .constraintEqualToAnchor(trailingAnchor, constant: 0)
            .active = true
        
        imageView
            .topAnchor
            .constraintEqualToAnchor(topAnchor, constant: 0)
            .active = true
    }
}
