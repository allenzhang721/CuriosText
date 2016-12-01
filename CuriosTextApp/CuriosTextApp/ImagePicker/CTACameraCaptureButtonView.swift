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
    
    fileprivate let outCircleLayer = CAShapeLayer()
    fileprivate let innerCircleLayer = CAShapeLayer()
    
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
    
    fileprivate func setup() {
        
        outCircleLayer.frame = bounds
        let lineWidth: CGFloat = 8
        let outPath = UIBezierPath(ovalIn: UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: lineWidth, left: lineWidth, bottom:lineWidth, right: lineWidth)))
        outPath.lineWidth = lineWidth
        outCircleLayer.path = outPath.cgPath
        outCircleLayer.strokeColor = UIColor.red.cgColor
        outCircleLayer.fillColor = UIColor.white.cgColor
        layer.addSublayer(outCircleLayer)
        
        let inset: CGFloat = 10
        innerCircleLayer.frame = bounds
        let innerPath = UIBezierPath(ovalIn: UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)))
        innerCircleLayer.path = innerPath.cgPath
        innerCircleLayer.fillColor = UIColor.red.cgColor
        layer.addSublayer(innerCircleLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        outCircleLayer.position = center
        innerCircleLayer.position = center
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1, animations: {
            self.innerCircleLayer.transform = CATransform3DMakeScale(touchScale, touchScale, 1)
        }) 
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.1, animations: {
            self.innerCircleLayer.transform = CATransform3DMakeScale(1, 1, 1)
        }) 
    }
}
