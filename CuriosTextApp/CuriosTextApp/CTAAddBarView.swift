//
//  CTAAddBarView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/27/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAAddBarView: UIControl {
    
    let imageView = UIImageView(image: CTAStyleKit.imageOfAdd)
    private var shapeLayer: CAShapeLayer {
        return layer as! CAShapeLayer
    }
    
    override class func layerClass() -> AnyClass {
        return CAShapeLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        imageView.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        
        shapeLayer.fillColor = UIColor.whiteColor().CGColor
        shapeLayer.contentsScale = UIScreen.mainScreen().scale
        
        backgroundColor = UIColor.clearColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shapeLayer.path == nil {
            
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.TopLeft, .TopRight], cornerRadii: CGSize(width: 4, height: 4)).CGPath
            
            shapeLayer.path = path
            shapeLayer.shadowPath = path
            shapeLayer.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7).CGColor
            shapeLayer.shadowOffset = CGSize(width: 0, height: -0.0)
            shapeLayer.shadowOpacity = 0.2
            shapeLayer.shadowRadius = 2.0
        }
        
       
        
        
    }
}
