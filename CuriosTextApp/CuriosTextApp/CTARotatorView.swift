//
//  CTARotatorView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/7/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

let round: Double = 40

class CTARotatorView: UIControl {
    
    var maximumRadian: CGFloat = CGFloat(M_PI * round)
    var minimumRadian: CGFloat = -CGFloat(M_PI * round)
    var currentValue: CGFloat = 0
    var targetRadians = [0.0, 0.5 * CGFloat(M_PI), CGFloat(M_PI), 1.5 * CGFloat(M_PI), 2.0 * CGFloat(M_PI)]
    
    fileprivate var validRadian: CGFloat = 0.0
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
    
   fileprivate let nodeLayer = CAShapeLayer()
   fileprivate let redNodeLayer = CAShapeLayer()
   fileprivate let scrollView = UIScrollView()
    
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
        
        validRadian = CGFloat(M_PI) * nodeLayer.bounds.width * CGFloat(round)
        
        scrollView.delegate = self
        
        scrollView.showsHorizontalScrollIndicator = false
        nodeLayer.contentsScale = UIScreen.main.scale
        redNodeLayer.contentsScale = UIScreen.main.scale
        
        scrollView.frame = bounds
        scrollView.contentSize = CGSize(width: validRadian + bounds.width, height: bounds.height)
    }
    
    
    func updateRotator(_ radian: CGFloat) {
        
        let offsetx = (radian - minimumRadian) / radianUnit
//        .contentOffset =
        scrollView.setContentOffset(CGPoint(x: offsetx, y: 0), animated: false)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        nodeLayer.transform = CATransform3DMakeRotation(radian, 0, 0, 1)
        CATransaction.commit()
    }
}

extension CTARotatorView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.x
        let nextRadian: CGFloat = {
            let r = offset * radianUnit + minimumRadian
            if r < 0 {
                return 2.0 * CGFloat(M_PI) - (fabs(r).truncatingRemainder(dividingBy: (2.0 * CGFloat(M_PI))))
            } else if r >= 2.0 * CGFloat(M_PI) {
                return r.truncatingRemainder(dividingBy: (2.0 * CGFloat(M_PI)))
            } else {
                return r
            }
        }()
        
        var targetRadian = nextRadian
        if targetRadians.count > 0 {
            for  r in targetRadians {
                if fabs((nextRadian * 1000.0 - r * 1000.0)) < 10 {
                    targetRadian = r
//                    updateRotator(targetRadian)
                    break
                }
            }
        } else {
            
        }
        
        
        
        if (fabs(targetRadian * 1000 - currentValue * 1000)) > 0.1 {
            
            currentValue = targetRadian
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            nodeLayer.transform = CATransform3DMakeRotation(currentValue, 0, 0, 1)
            CATransaction.commit()
            
            sendActions(for: .valueChanged)
        }
    }
}

extension CTARotatorView {
    
    fileprivate func rotatorSize(_ bounds: CGRect) -> CGSize {
        
        let m = bounds.height / 2
        let n = bounds.width / 2
        let r = (m / 2) + (pow(n, 2) / (2 * m))
        return CGSize(width: Int(r)*3, height: Int(r)*3)
    }
    
    fileprivate func setupNodeLayer(_ bounds: CGRect) {
        
        let largeNodeRadius: CGFloat = 10.0
        let largeNodeCount = 4
        
        let normallNodeRadius: CGFloat = 6.0
        let normallNodeCount = 4 * 30
        
        let layerSize = rotatorSize(bounds)
        let r = min(layerSize.width, layerSize.height) / 2.0 - largeNodeRadius / 2.0
        let center = CGPoint(x: layerSize.width / 2.0, y: layerSize.height / 2.0)
        
        nodeLayer.contentsScale = UIScreen.main.scale
        nodeLayer.bounds.size = layerSize
        nodeLayer.position = CGPoint(x: bounds.width / 2.0, y: -(layerSize.height / 2.0 - bounds.height / 3.0 * 2.0))
        let grayNodePath = nodePath(center, r: r, count: normallNodeCount, nodeRadius: normallNodeRadius)
        nodeLayer.path = grayNodePath.cgPath
        nodeLayer.fillColor = UIColor.gray.cgColor
        
        //        let redNodeLayer = CAShapeLayer()
        redNodeLayer.contentsScale = UIScreen.main.scale
        redNodeLayer.frame = nodeLayer.bounds
        let redNodePath = nodePath(center, r: r, count: largeNodeCount, nodeRadius: largeNodeRadius)
        redNodeLayer.path = redNodePath.cgPath
        redNodeLayer.fillColor = UIColor.red.cgColor
        
    }
    
    fileprivate func nodePath(_ center: CGPoint, r: CGFloat, count: Int, nodeRadius: CGFloat) -> UIBezierPath {
        
        let path = UIBezierPath()
        
        func drawNode(_ frame: CGRect, ovalPath: UIBezierPath) {
            //// Oval Drawing
            ovalPath.move(to: CGPoint(x: frame.minX + 1.00000 * frame.width, y: frame.minY + 0.50000 * frame.height))
            ovalPath.addCurve(to: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 0.00000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 1.00000 * frame.width, y: frame.minY + 0.22386 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.77614 * frame.width, y: frame.minY + 0.00000 * frame.height))
            ovalPath.addCurve(to: CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 0.50000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.22386 * frame.width, y: frame.minY + 0.00000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 0.22386 * frame.height))
            ovalPath.addCurve(to: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 1.00000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 0.77614 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.22386 * frame.width, y: frame.minY + 1.00000 * frame.height))
            ovalPath.addCurve(to: CGPoint(x: frame.minX + 1.00000 * frame.width, y: frame.minY + 0.50000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.77614 * frame.width, y: frame.minY + 1.00000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 1.00000 * frame.width, y: frame.minY + 0.77614 * frame.height))
            ovalPath.close()
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
