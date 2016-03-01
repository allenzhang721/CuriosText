//
//  CTACameraCaptureButtonView.swift
//  ImagePickerApp
//
//  Created by Emiaostein on 2/28/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import UIKit

private let touchScale: CGFloat = 0.8

@IBDesignable
class CTACameraCaptureButton: UIControl {
    
    private let outCircleLayer = CAShapeLayer()
    private let innerCircleLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
    }
    
    private func setup() {
        
        outCircleLayer.frame = bounds
        let lineWidth: CGFloat = 8
        let outPath = UIBezierPath(ovalInRect: UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: lineWidth, left: lineWidth, bottom:lineWidth, right: lineWidth)))
        outPath.lineWidth = lineWidth
        outCircleLayer.path = outPath.CGPath
        outCircleLayer.strokeColor = UIColor.redColor().CGColor
        outCircleLayer.fillColor = UIColor.whiteColor().CGColor
        layer.addSublayer(outCircleLayer)
        
        let inset: CGFloat = 10
        innerCircleLayer.frame = bounds
        let innerPath = UIBezierPath(ovalInRect: UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)))
        innerCircleLayer.path = innerPath.CGPath
        innerCircleLayer.fillColor = UIColor.redColor().CGColor
        layer.addSublayer(innerCircleLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        outCircleLayer.position = center
        innerCircleLayer.position = center
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        UIView.animateWithDuration(0.1) {
            self.innerCircleLayer.transform = CATransform3DMakeScale(touchScale, touchScale, 1)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        UIView.animateWithDuration(0.1) {
            self.innerCircleLayer.transform = CATransform3DMakeScale(1, 1, 1)
        }
    }
}
