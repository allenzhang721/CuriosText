//
//  ContainerTextView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/24/15.
//  Copyright © 2015 botai. All rights reserved.
//

import UIKit

class ContainerTextView: ContainerView {

    var textView: TextView!
    
    override func updateContents(_ contents: AnyObject, contentSize size: CGSize, drawInsets inset: CGPoint) {
        
        guard let contents = contents as? NSAttributedString else {
            fatalError("The contents is not AttributeString")
        }
        
//        textView.bounds.size = size
        textView.insets = inset
        textView.backgroundColor = UIColor.red
//        textView.frame.origin = CGPoint(x: 0 - inset.x, y: 0 - inset.y)
        textView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        textView.attributedText = contents
    }
}
