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
            DispatchQueue.main.async { 
                self.addButton.setImage(newValue, for: UIControlState())
            }
        }
        
        get {
           return addButton.image(for: UIControlState())
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
    
    fileprivate func setup() {
        addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        addButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        addButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        addButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        addButton.setImage(CTAStyleKit.imageOfAddInEditor, for: UIControlState())
        addButton.addTarget(self, action: #selector(CTAGradientButtonView.addClick(_:)), for: .touchUpInside)
    }
    
    func addClick(_ sender: AnyObject) {
        
        didClickHandler?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if needGradient {
        backgroundColor = UIColor.init(patternImage: CTAStyleKit.imageOfGradientInEditor(imageSize: bounds.size))
        }
    }
}
