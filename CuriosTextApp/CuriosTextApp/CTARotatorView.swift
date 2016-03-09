//
//  CTARotatorView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/7/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTARotatorView: UIControl {
    
    var maximumRadian: CGFloat = CGFloat(M_PI * 2)
    var minimumRadian: CGFloat = -CGFloat(M_PI * 2)
    var currentValue: CGFloat = 0
    
    private var validRadian: CGFloat = 1000.0
    var radianUnit: CGFloat {
        
        return (maximumRadian - minimumRadian) / validRadian
    }
    
    var radian: CGFloat {
        
        get {
            return currentValue
        }
        
        set {
            currentValue = max(min(newValue, maximumRadian), minimumRadian)
            updateRotator(currentValue)
        }
    }
    
   private let nodeLayer = CAShapeLayer()
   private let redNodeLayer = CAShapeLayer()
   private let scrollView = UIScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        nodeLayer.addSublayer(redNodeLayer)
        layer.addSublayer(nodeLayer)
        addSubview(scrollView)
        
        setupNodeLayer(bounds)
        
        validRadian = CGFloat(M_PI) * nodeLayer.bounds.width * 2
        
        scrollView.delegate = self
        
        scrollView.showsHorizontalScrollIndicator = false
        nodeLayer.contentsScale = UIScreen.mainScreen().scale
        redNodeLayer.contentsScale = UIScreen.mainScreen().scale
        
        scrollView.frame = bounds
        scrollView.contentSize = CGSize(width: validRadian + bounds.width, height: bounds.height)
    }
    
    
    func updateRotator(radian: CGFloat) {
        
        let offsetx = (radian - minimumRadian) / radianUnit
        scrollView.contentOffset = CGPoint(x: offsetx, y: 0)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        nodeLayer.transform = CATransform3DMakeRotation(radian, 0, 0, 1)
        CATransaction.commit()
    }
}

extension CTARotatorView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.x
        
        
        let nextRadian = offset * radianUnit + minimumRadian
        
        if (fabs(nextRadian * 1000 - currentValue * 1000)) > 0.1 {
            
            currentValue = floor(nextRadian * 1000) / 1000.0
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            nodeLayer.transform = CATransform3DMakeRotation(currentValue, 0, 0, 1)
            CATransaction.commit()
            
            sendActionsForControlEvents(.ValueChanged)
            print("nextRadian = \(currentValue)")
        }
    }
}

extension CTARotatorView {
    
    private func rotatorSize(bounds: CGRect) -> CGSize {
        
        let m = bounds.height / 2
        let n = bounds.width / 2
        let r = (m / 2) + (pow(n, 2) / (2 * m))
        return CGSize(width: Int(r)*3, height: Int(r)*3)
    }
    
    private func setupNodeLayer(bounds: CGRect) {
        
        let largeNodeRadius: CGFloat = 10.0
        let largeNodeCount = 4
        
        let normallNodeRadius: CGFloat = 6.0
        let normallNodeCount = 4 * 30
        
        let layerSize = rotatorSize(bounds)
        let r = min(layerSize.width, layerSize.height) / 2.0 - largeNodeRadius / 2.0
        let center = CGPoint(x: layerSize.width / 2.0, y: layerSize.height / 2.0)
        
        nodeLayer.contentsScale = UIScreen.mainScreen().scale
        nodeLayer.bounds.size = layerSize
        nodeLayer.position = CGPoint(x: bounds.width / 2.0, y: -(layerSize.height / 2.0 - bounds.height / 3.0 * 2.0))
        let grayNodePath = nodePath(center, r: r, count: normallNodeCount, nodeRadius: normallNodeRadius)
        nodeLayer.path = grayNodePath.CGPath
        nodeLayer.fillColor = UIColor.grayColor().CGColor
        
        //        let redNodeLayer = CAShapeLayer()
        redNodeLayer.contentsScale = UIScreen.mainScreen().scale
        redNodeLayer.frame = nodeLayer.bounds
        let redNodePath = nodePath(center, r: r, count: largeNodeCount, nodeRadius: largeNodeRadius)
        redNodeLayer.path = redNodePath.CGPath
        redNodeLayer.fillColor = UIColor.redColor().CGColor
        
    }
    
    private func nodePath(center: CGPoint, r: CGFloat, count: Int, nodeRadius: CGFloat) -> UIBezierPath {
        
        let path = UIBezierPath()
        
        func drawNode(frame: CGRect, ovalPath: UIBezierPath) {
            //// Oval Drawing
            ovalPath.moveToPoint(CGPointMake(frame.minX + 1.00000 * frame.width, frame.minY + 0.50000 * frame.height))
            ovalPath.addCurveToPoint(CGPointMake(frame.minX + 0.50000 * frame.width, frame.minY + 0.00000 * frame.height), controlPoint1: CGPointMake(frame.minX + 1.00000 * frame.width, frame.minY + 0.22386 * frame.height), controlPoint2: CGPointMake(frame.minX + 0.77614 * frame.width, frame.minY + 0.00000 * frame.height))
            ovalPath.addCurveToPoint(CGPointMake(frame.minX + 0.00000 * frame.width, frame.minY + 0.50000 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.22386 * frame.width, frame.minY + 0.00000 * frame.height), controlPoint2: CGPointMake(frame.minX + 0.00000 * frame.width, frame.minY + 0.22386 * frame.height))
            ovalPath.addCurveToPoint(CGPointMake(frame.minX + 0.50000 * frame.width, frame.minY + 1.00000 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.00000 * frame.width, frame.minY + 0.77614 * frame.height), controlPoint2: CGPointMake(frame.minX + 0.22386 * frame.width, frame.minY + 1.00000 * frame.height))
            ovalPath.addCurveToPoint(CGPointMake(frame.minX + 1.00000 * frame.width, frame.minY + 0.50000 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.77614 * frame.width, frame.minY + 1.00000 * frame.height), controlPoint2: CGPointMake(frame.minX + 1.00000 * frame.width, frame.minY + 0.77614 * frame.height))
            ovalPath.closePath()
            //        UIColor.redColor().setFill()
            //        path.fill()
            
        }
        
        let center = center
        let radius: CGFloat = nodeRadius
        let r = r
        let count = count
        let ra = M_PI * 2 / Double(count)
        
        for i in 0..<count {
            
            let x = center.x + r * CGFloat(cos(ra * Double(i))) - radius / 2.0
            let y = center.y + r * CGFloat(sin(ra * Double(i))) - radius / 2.0
            let arcOrigin = CGPoint(x: x, y: y)
            let rect = CGRect(origin: arcOrigin, size: CGSize(width: radius, height: radius))
            
            drawNode(rect, ovalPath: path)
        }
        
        return path
    }
}
