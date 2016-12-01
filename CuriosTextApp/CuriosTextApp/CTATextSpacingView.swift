//
//  CTATextSpacingView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/11/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTATextSpacingView: UIControl {
    
    fileprivate var lineSpacingButton: UIButton!
    fileprivate var textSpacingButton: UIButton!
    fileprivate var stepControl: UISegmentedControl!
    
    fileprivate var maxLineSpacing: CGFloat = 10.0
    fileprivate var miniumLineSpacing: CGFloat = 0.0
    fileprivate var maxTextSpacing: CGFloat = 10.0
    fileprivate var minTextSpacing: CGFloat = 0.0
    
    fileprivate var lineSpacing: CGFloat = 0
    fileprivate var textSpacing: CGFloat = 0
    
    var spacing: (CGFloat, CGFloat) {
        
        get {
            return (lineSpacing, textSpacing)
        }
        
        set {
            lineSpacing = max(min(newValue.0, maxLineSpacing), miniumLineSpacing)
            textSpacing = max(min(newValue.1, maxTextSpacing), minTextSpacing)
        }
    }
    
    override init(frame: CGRect) {
        lineSpacingButton = UIButton(type: .custom)
        textSpacingButton = UIButton(type: .custom)
        stepControl = UISegmentedControl(items: ["+", "Reset", "-"])
        super.init(frame: frame)
        
        addSubview(lineSpacingButton)
        addSubview(textSpacingButton)
        addSubview(stepControl)
        lineSpacingButton.translatesAutoresizingMaskIntoConstraints = false
        textSpacingButton.translatesAutoresizingMaskIntoConstraints = false
        stepControl.translatesAutoresizingMaskIntoConstraints = false
        stepControl.addTarget(self, action: #selector(CTATextSpacingView.valueChanged(_:)), for: .valueChanged)
        setupConstraints()
    }
    
    func setupConstraints() {
        backgroundColor = UIColor.white
        lineSpacingButton.backgroundColor = UIColor.white
        textSpacingButton.backgroundColor = UIColor.white
        lineSpacingButton.tintColor = UIColor.red
        stepControl.tintColor = UIColor.red
        stepControl.isMomentary = true
        //        stepControl.backgroundColor = UIColor.lightGrayColor()
        
        lineSpacingButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        lineSpacingButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        lineSpacingButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        lineSpacingButton.centerXAnchor.constraint(equalTo: leftAnchor, constant: 44).isActive = true
        
        textSpacingButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        textSpacingButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textSpacingButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textSpacingButton.centerXAnchor.constraint(equalTo: rightAnchor, constant: -44).isActive = true
        
        lineSpacingButton.setImage(CTAStyleKit.imageOfLineSpacingNormal, for: UIControlState())
        lineSpacingButton.setImage(CTAStyleKit.imageOfLineSpacingSelected, for: .selected)
        textSpacingButton.setImage(CTAStyleKit.imageOfTextSpacingNormal, for: UIControlState())
        textSpacingButton.setImage(CTAStyleKit.imageOfTextSpacingSelected, for: .selected)
        //
        stepControl.leftAnchor.constraint(equalTo: lineSpacingButton.rightAnchor, constant: 22).isActive = true
        //        stepControl.rightAnchor.constraintEqualToAnchor(textSpacingButton.leftAnchor, constant: 22).active = true
        stepControl.heightAnchor.constraint(equalToConstant: 44).isActive = true
        stepControl.leftAnchor.constraint(equalTo: lineSpacingButton.rightAnchor, constant: 22).isActive = true
        stepControl.rightAnchor.constraint(equalTo: textSpacingButton.leftAnchor, constant: -22).isActive = true
        //        stepControl.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        stepControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        lineSpacingButton.addTarget(self, action: #selector(CTATextSpacingView.lineSpacing(_:)), for: .touchUpInside)
        textSpacingButton.addTarget(self, action: #selector(CTATextSpacingView.textSpacing(_:)), for: .touchUpInside)
        
        lineSpacingButton.isSelected = true
        
    }
    
    func valueChanged(_ sender: UISegmentedControl) {
        
        let lineSpac: CGFloat = lineSpacingButton.isSelected ? 1.0 : 0.0
        let textSpac: CGFloat = textSpacingButton.isSelected ? 1.0 : 0.0
        
        switch sender.selectedSegmentIndex {
        case 0:
            let lineSpacing = spacing.0
            let textSpacing = spacing.1
            spacing = (lineSpacing + lineSpac, textSpacing + textSpac)
            sendActions(for: .valueChanged)
            
        case 1:
            spacing = (miniumLineSpacing, minTextSpacing)
            sendActions(for: .valueChanged)
            
        case 2:
            let lineSpacing = spacing.0
            let textSpacing = spacing.1
            spacing = (lineSpacing - lineSpac, textSpacing - textSpac)
            sendActions(for: .valueChanged)
        default:
            ()
        }
    }
    
    func lineSpacing(_ sender: UIButton) {
        textSpacingButton.isSelected = false
        lineSpacingButton.isSelected = true
    }
    
    func textSpacing(_ sender: UIButton) {
        lineSpacingButton.isSelected = false
        textSpacingButton.isSelected = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
