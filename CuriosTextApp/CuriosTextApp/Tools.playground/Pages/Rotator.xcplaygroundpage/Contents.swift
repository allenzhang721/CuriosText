//: [Previous](@previous)

import Foundation
import UIKit

class RotatorView: UIView {
    
    let grayRotatorLayer = CAShapeLayer()
    let redRotatorLayer = CAShapeLayer()
    
    override  init(frame: CGRect) {
        super.init(frame: frame)
        grayRotatorLayer.frame = bounds
        grayRotatorLayer.fillColor = UIColor.grayColor().CGColor
        let path = rotatorPath(frame.size)
        grayRotatorLayer.path = path.CGPath
        
        redRotatorLayer.frame = bounds
        redRotatorLayer.fillColor = UIColor.redColor().CGColor
        let apath = rotatorPath(frame.size, count: 4, largeNode: true)
        redRotatorLayer.path = apath.CGPath
        
        backgroundColor = UIColor.whiteColor()
        layer.addSublayer(grayRotatorLayer)
        grayRotatorLayer.addSublayer(redRotatorLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

func rotatorPath(size: CGSize, count: Int = 48, maxNoder: CGFloat = 8, largeNode: Bool = false) -> UIBezierPath {
    
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
    
    let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
    let radius: CGFloat = largeNode ? maxNoder : 4
    let r = min(size.width, size.height) / 2.0 - maxNoder / 2.0
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
let path = rotatorPath(CGSize(width: 100, height: 100))
let width = 88.0 + pow(160.0, 2.0) / 88.0
let view = RotatorView(frame: CGRect(x: 0, y: 0, width: Int(width), height: Int(width)))


//: [Next](@next)
