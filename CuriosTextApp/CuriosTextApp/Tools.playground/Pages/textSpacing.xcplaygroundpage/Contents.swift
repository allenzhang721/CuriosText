//: [Previous](@previous)

import Foundation
import UIKit

var str = "Hello, playground"

class CTATextSpacingView: UIControl {
    
    var lineSpacingButton: UIButton!
    var textSpacingButton: UIButton!
    var stepControl: UISegmentedControl!
    
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
        
        setupConstraints()
    }
    
    func setupConstraints() {
        backgroundColor = UIColor.whiteColor()
        lineSpacingButton.backgroundColor = UIColor.whiteColor()
        textSpacingButton.backgroundColor = UIColor.whiteColor()
        stepControl.tintColor = UIColor.redColor()
//        stepControl.backgroundColor = UIColor.lightGrayColor()
        
        lineSpacingButton.widthAnchor.constraintEqualToConstant(44).active = true
        lineSpacingButton.heightAnchor.constraintEqualToConstant(44).active = true
        lineSpacingButton.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        lineSpacingButton.centerXAnchor.constraintEqualToAnchor(leftAnchor, constant: 44).active = true
        
        textSpacingButton.widthAnchor.constraintEqualToConstant(44).active = true
        textSpacingButton.heightAnchor.constraintEqualToConstant(44).active = true
        textSpacingButton.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        textSpacingButton.centerXAnchor.constraintEqualToAnchor(rightAnchor, constant: -44).active = true
        
        lineSpacingButton.setImage(UIImage(named: "a0"), forState: .Normal)
        
        textSpacingButton.setImage(UIImage(named: "a1"), forState: .Normal)
//        
        stepControl.leftAnchor.constraintEqualToAnchor(lineSpacingButton.rightAnchor, constant: 22).active = true
//        stepControl.rightAnchor.constraintEqualToAnchor(textSpacingButton.leftAnchor, constant: 22).active = true
        stepControl.heightAnchor.constraintEqualToConstant(44).active = true
        stepControl.leftAnchor.constraintEqualToAnchor(lineSpacingButton.rightAnchor, constant: 22).active = true
        stepControl.rightAnchor.constraintEqualToAnchor(textSpacingButton.leftAnchor, constant: -22).active = true
//        stepControl.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        stepControl.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

let view = CTATextSpacingView(frame: CGRect(x: 0, y: 0, width: 320, height: 88))

showView(view)


//: [Next](@next)
