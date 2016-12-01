//
//  ContainerImgView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/24/15.
//  Copyright © 2015 botai. All rights reserved.
//

import UIKit

class ContainerImgView: ContainerView {
    
    var imageView: UIImageView!

    override func updateContents(_ contents: AnyObject, contentSize size: CGSize, drawInsets inset: CGPoint) {
        
        guard let contents = contents as? UIImage else {
            fatalError("The contents is not Image")
        }
        
        imageView.bounds.size = size
//        textView.insets = inset
        imageView.frame.origin = CGPoint(x: 0 - inset.x, y: 0 - inset.y)
        imageView.image = contents
    }
}
