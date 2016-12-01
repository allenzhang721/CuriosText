//
//  CTACropOverlayView.swift
//  ImagePickerApp
//
//  Created by Emiaostein on 2/28/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import UIKit

@IBDesignable
class CTACropOverlayView: UIView {
    
    let cornerLayers: [CAShapeLayer] = {
       var layers = [CAShapeLayer]()
        for _ in 0..<4 {
           let l = CAShapeLayer()
            layers.append(l)
        }
        
        return layers
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        
        for (i, l) in cornerLayers.enumerated() {
            setupLayer(l, left: (i == 0 || i == 3), top: (i == 0 || i == 1))
            layer.addSublayer(l)
        }
    }
    
    fileprivate func setupLayer(_ l: CAShapeLayer, left: Bool, top: Bool) {
        
        setLayersPosition(l, rect: bounds, left: left, top: top)
        
        let abounds = l.bounds
        
        let path = UIBezierPath()
        
        var beganPoint = CGPoint.zero
        var middlePoint = CGPoint.zero
        var endPoint = CGPoint.zero
        
        switch (left, top) {
        case (true, true):  // left top
            beganPoint = CGPoint(x: abounds.minX, y: abounds.maxY)
            middlePoint = CGPoint(x: abounds.minX, y: abounds.minY)
            endPoint = CGPoint(x: abounds.maxX, y: abounds.minY)
            
        case (false, true): // right top
            beganPoint = CGPoint(x: abounds.minX, y: abounds.minY)
            middlePoint = CGPoint(x: abounds.maxX, y: abounds.minY)
            endPoint = CGPoint(x: abounds.maxX, y: abounds.maxY)
            
        case (false, false): // right bottom
            beganPoint = CGPoint(x: abounds.maxX, y: abounds.minY)
            middlePoint = CGPoint(x: abounds.maxX, y: abounds.maxY)
            endPoint = CGPoint(x: abounds.minX, y: abounds.maxY)
            
        case (true, false): // left bottom
            beganPoint = CGPoint(x: abounds.maxX, y: abounds.maxY)
            middlePoint = CGPoint(x: abounds.minX, y: abounds.maxY)
            endPoint = CGPoint(x: abounds.minX, y: abounds.minY)
        }
        
        path.move(to: beganPoint)
        path.addLine(to: middlePoint)
        path.addLine(to: endPoint)
        
        path.lineWidth = 10
        
        l.path = path.cgPath
        l.strokeColor = UIColor.white.cgColor
        l.fillColor = UIColor.clear.cgColor
    }
    
    fileprivate func setLayersPosition(_ l: CAShapeLayer, rect: CGRect, left: Bool, top: Bool) {
        
        let inset: CGFloat = 10
        let size = CGSize(width: 25, height: 25)
        
        let cx = left ? (rect.minX + size.width / 2.0 + inset) : (rect.maxX - size.width / 2.0 - inset)
        let cy = top ? (rect.minY + size.height / 2.0 + inset) : (rect.maxY - size.height / 2.0 - inset)
        let abounds = CGRect(origin: CGPoint.zero, size: size)
        
        l.frame = abounds
        l.position = CGPoint(x: cx, y: cy)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for (i, l) in cornerLayers.enumerated() {
            setLayersPosition(l, rect: bounds, left: (i == 0 || i == 3), top: (i == 0 || i == 1))
        }
    }
}

extension CTACropOverlayView {
    
    func positionByAspectRatio(_ ratio: CTAImageCropAspectRatio, animated: Bool) {
        
        let minSize = ratio.minumSize()
        
        let scale = min(bounds.width / minSize.width, bounds.height / minSize.height)
        let widthOffset = (bounds.width - minSize.width * scale)
        let heightOffset = (bounds.height - minSize.height * scale)
        let top = heightOffset / 2.0
        let bottom = top
        let left = widthOffset / 2.0
        let right = left
        
        
        if animated {
            let rect = UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
            UIView.animate( withDuration: 0.1, animations: { 
                
                for (i, l) in self.cornerLayers.enumerated() {
                    self.setLayersPosition(l, rect:  rect, left: (i == 0 || i == 3), top: (i == 0 || i == 1))
                }
            })
        }
    }
}
