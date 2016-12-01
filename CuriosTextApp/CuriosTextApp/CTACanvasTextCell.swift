//
//  CTACanvasTextCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/5/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTACanvasTextCell: CTACanvasCell {
    
    let textView: TextView
    
    override init(frame: CGRect) {
        self.textView = TextView()
        super.init(frame: frame)
        
        textView.text = ""
        textView.layer.drawsAsynchronously = true
        textView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        contentView.layer.addSublayer(textView.layer)
    }

    required init?(coder aDecoder: NSCoder) {
        self.textView = TextView()
        super.init(coder: aDecoder)
        textView.frame = bounds
        textView.layer.drawsAsynchronously = true
        addSubview(textView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textView.insets = contentInset
//        CGRect(x: 0 - contentInset.x, y: 0 - contentInset.y, width: bounds.size.width + 2 * contentInset.x, height: bounds.size.height + 2 * contentInset.y)
        textView.bounds.size = CGSize(width: contentView.bounds.width + 2 * contentInset.x , height: contentView.bounds.height + 2 * contentInset.y)
        textView.center = contentView.center
    }
}
