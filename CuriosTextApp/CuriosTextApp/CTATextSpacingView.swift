//
//  CTATextSpacingView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/11/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTATextSpacingView: UIControl {
    
    private var lineSpacingButton: UIButton!
    private var textSpacingButton: UIButton!
    private var stepControl: UISegmentedControl!
    
    private var maxLineSpacing: CGFloat = 10.0
    private var miniumLineSpacing: CGFloat = 0.0
    private var maxTextSpacing: CGFloat = 10.0
    private var minTextSpacing: CGFloat = 0.0
    
    private var lineSpacing: CGFloat = 0
    private var textSpacing: CGFloat = 0
    
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
        lineSpacingButton = UIButton(type: .Custom)
        textSpacingButton = UIButton(type: .Custom)
        stepControl = UISegmentedControl(items: ["+", "Reset", "-"])
        super.init(frame: frame)
        
        addSubview(lineSpacingButton)
        addSubview(textSpacingButton)
        addSubview(stepControl)
        lineSpacingButton.translatesAutoresizingMaskIntoConstraints = false
        textSpacingButton.translatesAutoresizingMaskIntoConstraints = false
        stepControl.translatesAutoresizingMaskIntoConstraints = false
        stepControl.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
        setupConstraints()
    }
    
    func setupConstraints() {
        backgroundColor = UIColor.whiteColor()
        lineSpacingButton.backgroundColor = UIColor.whiteColor()
        textSpacingButton.backgroundColor = UIColor.whiteColor()
        lineSpacingButton.tintColor = UIColor.redColor()
        stepControl.tintColor = UIColor.redColor()
        stepControl.momentary = true
        //        stepControl.backgroundColor = UIColor.lightGrayColor()
        
        lineSpacingButton.widthAnchor.constraintEqualToConstant(44).active = true
        lineSpacingButton.heightAnchor.constraintEqualToConstant(44).active = true
        lineSpacingButton.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        lineSpacingButton.centerXAnchor.constraintEqualToAnchor(leftAnchor, constant: 44).active = true
        
        textSpacingButton.widthAnchor.constraintEqualToConstant(44).active = true
        textSpacingButton.heightAnchor.constraintEqualToConstant(44).active = true
        textSpacingButton.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        textSpacingButton.centerXAnchor.constraintEqualToAnchor(rightAnchor, constant: -44).active = true
        
        lineSpacingButton.setImage(CTAStyleKit.imageOfLineSpacingNormal, forState: .Normal)
        lineSpacingButton.setImage(CTAStyleKit.imageOfLineSpacingSelected, forState: .Selected)
        textSpacingButton.setImage(CTAStyleKit.imageOfTextSpacingNormal, forState: .Normal)
        textSpacingButton.setImage(CTAStyleKit.imageOfTextSpacingSelected, forState: .Selected)
        //
        stepControl.leftAnchor.constraintEqualToAnchor(lineSpacingButton.rightAnchor, constant: 22).active = true
        //        stepControl.rightAnchor.constraintEqualToAnchor(textSpacingButton.leftAnchor, constant: 22).active = true
        stepControl.heightAnchor.constraintEqualToConstant(44).active = true
        stepControl.leftAnchor.constraintEqualToAnchor(lineSpacingButton.rightAnchor, constant: 22).active = true
        stepControl.rightAnchor.constraintEqualToAnchor(textSpacingButton.leftAnchor, constant: -22).active = true
        //        stepControl.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        stepControl.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        
        lineSpacingButton.addTarget(self, action: "lineSpacing:", forControlEvents: .TouchUpInside)
        textSpacingButton.addTarget(self, action: "textSpacing:", forControlEvents: .TouchUpInside)
        
        lineSpacingButton.selected = true
        
    }
    
    func valueChanged(sender: UISegmentedControl) {
        
        let lineSpac: CGFloat = lineSpacingButton.selected ? 1.0 : 0.0
        let textSpac: CGFloat = textSpacingButton.selected ? 1.0 : 0.0
        
        switch sender.selectedSegmentIndex {
        case 0:
            let lineSpacing = spacing.0
            let textSpacing = spacing.1
            spacing = (lineSpacing + lineSpac, textSpacing + textSpac)
            sendActionsForControlEvents(.ValueChanged)
            
        case 1:
            spacing = (miniumLineSpacing, minTextSpacing)
            sendActionsForControlEvents(.ValueChanged)
            
        case 2:
            let lineSpacing = spacing.0
            let textSpacing = spacing.1
            spacing = (lineSpacing - lineSpac, textSpacing - textSpac)
            sendActionsForControlEvents(.ValueChanged)
        default:
            ()
        }
    }
    
    func lineSpacing(sender: UIButton) {
        textSpacingButton.selected = false
        lineSpacingButton.selected = true
    }
    
    func textSpacing(sender: UIButton) {
        lineSpacingButton.selected = false
        textSpacingButton.selected = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
