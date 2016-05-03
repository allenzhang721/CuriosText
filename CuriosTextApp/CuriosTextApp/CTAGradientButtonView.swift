//
//  CTAEditAddView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 2/23/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAGradientButtonView: UIView {

    var image: UIImage? {
        set {
            dispatch_async(dispatch_get_main_queue()) { 
                self.addButton.setImage(newValue, forState: .Normal)
            }
        }
        
        get {
           return addButton.imageForState(.Normal)
        }
        
    }
    var needGradient = true
    let addButton = UIButton()
    var didClickHandler: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        addButton.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        addButton.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        addButton.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        addButton.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        
        addButton.setImage(CTAStyleKit.imageOfAddInEditor, forState: .Normal)
        addButton.addTarget(self, action: #selector(CTAGradientButtonView.addClick(_:)), forControlEvents: .TouchUpInside)
    }
    
    func addClick(sender: AnyObject) {
        
        didClickHandler?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if needGradient {
        backgroundColor = UIColor.init(patternImage: CTAStyleKit.imageOfGradientInEditor(frame: bounds))
        }
    }
}
