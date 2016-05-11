//
//  CTAHeartAnimationView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 5/11/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import pop

class CTAHeartAnimationView: UIView {
    
    let heartLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func didMoveToSuperview() {
        
        playLikeAnimation()
    }
    
    private func setup() {
        layer.addSublayer(heartLayer)
        heartLayer.fillColor = UIColor.redColor().CGColor
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        playLikeAnimation()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let minScale = min(bounds.width / 85.0 , bounds.height / 78.0)
        let layerSize = CGSize(width: 85.0 * minScale, height: 78.0 * minScale)
        let layerOrigin = CGPoint(x: bounds.width / 2.0 - layerSize.width / 2.0, y: bounds.height / 2.0 - layerSize.height / 2.0)
        let path = heartPath(frame: CGRect(origin: layerOrigin, size: layerSize))
        heartLayer.path = path
        heartLayer.frame = CGRect(origin: layerOrigin, size: layerSize)
    }
    
    func playLikeAnimation() {
        
        heartLayer.pop_removeAllAnimations()
 
        let scallY = POPSpringAnimation(propertyNamed: kPOPLayerScaleX)
        scallY.fromValue = 0.5
        scallY.toValue = 1.0
        scallY.springBounciness = 20
        
        let tranY = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        tranY.fromValue = bounds.height / 2.0 * 1.5
        tranY.toValue = bounds.height / 2.0
        tranY.springBounciness = 20

        let opacity = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
        opacity.fromValue = 0
        opacity.toValue = 1

        layer.pop_addAnimation(scallY, forKey: "scaleX")
        heartLayer.pop_addAnimation(tranY, forKey: "TranY")
        heartLayer.pop_addAnimation(opacity, forKey: "Opacity")
        
        scallY.completionBlock = {[weak self] (ani, finished) in
            
            if let sf = self where finished {
                sf.dismissAnimation()
            }
        }
    }
    
    func dismissAnimation() {
        
        heartLayer.pop_removeAllAnimations()
        let opacity = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
        opacity.fromValue = 1
        opacity.toValue = 0
        heartLayer.pop_addAnimation(opacity, forKey: "Opacity")
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        let minScale = min(bounds.width / 85.0, bounds.height / 78.0)
        let layerSize = CGSize(width: 85.0 * minScale, height: 78.0 * minScale)
        let layerOrigin = CGPoint(x: bounds.midX - layerSize.width / 2.0, y: bounds.minY - layerSize.height / 2.0)
        let path = heartPath(frame: bounds)
        heartLayer.path = path
        heartLayer.frame = CGRect(origin: layerOrigin, size: layerSize)
        
    }
    

    
    
    func heartPath(frame frame: CGRect = CGRectMake(0, 0, 85, 78)) -> CGPath {
        //// Color Declarations
        let color = UIColor(red: 1.000, green: 0.000, blue: 0.000, alpha: 1.000)
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(frame.minX + 0.49530 * frame.width, frame.minY + 0.08463 * frame.height))
        bezierPath.addLineToPoint(CGPointMake(frame.minX + 0.49789 * frame.width, frame.minY + 0.08743 * frame.height))
        bezierPath.addCurveToPoint(CGPointMake(frame.minX + 0.91208 * frame.width, frame.minY + 0.08743 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.61227 * frame.width, frame.minY + -0.03769 * frame.height), controlPoint2: CGPointMake(frame.minX + 0.79771 * frame.width, frame.minY + -0.03769 * frame.height))
        bezierPath.addCurveToPoint(CGPointMake(frame.minX + 0.91208 * frame.width, frame.minY + 0.54053 * frame.height), controlPoint1: CGPointMake(frame.minX + 1.02646 * frame.width, frame.minY + 0.21255 * frame.height), controlPoint2: CGPointMake(frame.minX + 1.02646 * frame.width, frame.minY + 0.41541 * frame.height))
        bezierPath.addLineToPoint(CGPointMake(frame.minX + 0.49789 * frame.width, frame.minY + 0.99363 * frame.height))
        bezierPath.addLineToPoint(CGPointMake(frame.minX + 0.08370 * frame.width, frame.minY + 0.54053 * frame.height))
        bezierPath.addCurveToPoint(CGPointMake(frame.minX + 0.00064 * frame.width, frame.minY + 0.27030 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.01633 * frame.width, frame.minY + 0.46684 * frame.height), controlPoint2: CGPointMake(frame.minX + -0.01136 * frame.width, frame.minY + 0.36617 * frame.height))
        bezierPath.addLineToPoint(CGPointMake(frame.minX + 0.00095 * frame.width, frame.minY + 0.26789 * frame.height))
        bezierPath.addCurveToPoint(CGPointMake(frame.minX + 0.08370 * frame.width, frame.minY + 0.08743 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.00968 * frame.width, frame.minY + 0.20186 * frame.height), controlPoint2: CGPointMake(frame.minX + 0.03726 * frame.width, frame.minY + 0.13824 * frame.height))
        bezierPath.addCurveToPoint(CGPointMake(frame.minX + 0.49530 * frame.width, frame.minY + 0.08463 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.19721 * frame.width, frame.minY + -0.03675 * frame.height), controlPoint2: CGPointMake(frame.minX + 0.38073 * frame.width, frame.minY + -0.03768 * frame.height))
        bezierPath.closePath()
//        color.setFill()
//        bezierPath.fill()
        
        return bezierPath.CGPath
    }
}
