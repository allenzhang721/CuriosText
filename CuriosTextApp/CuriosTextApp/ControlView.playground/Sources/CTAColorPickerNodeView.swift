import Foundation
import UIKit

//private extension UIColor {
//    
//    func toHexs() -> (String, CGFloat) {
//        
//        let component = CGColorGetComponents(self.CGColor)
//        let r = component[0]
//        let g = component[1]
//        let b = component[2]
//        let a = component[3]
//        
//        let hex = NSString(format: "#%02lX%02lX%02lX", lroundf(Float(r * CGFloat(255.0))), lroundf(Float(g * CGFloat(255.0))), lroundf(Float(b * CGFloat(255.0)))) as String
//        return (hex, a)
//    }
//}

open class CTAColorPickerNodeView: UIControl {
    
    fileprivate(set) var selectedColor: UIColor?
    fileprivate var colors = [UIColor]()
    fileprivate var colorHexs = [String]()
    fileprivate var colorLayers = [CAShapeLayer]()
    fileprivate var indicatorLayer = CAShapeLayer()
    fileprivate var selectedLayer: CAShapeLayer?
    
//    func hex(color: UIColor) -> String {
//        let r = color.toHex()
//        return r.0
//    }

    public init(frame: CGRect, colors: [UIColor]) {
        super.init(frame: frame)
        self.colors = colors
        for c in colors {
            let l = CAShapeLayer()
            l.fillColor = c.cgColor
            l.lineWidth = 0.5
            l.strokeColor = UIColor.lightGray.cgColor
            layer.addSublayer(l)
            colorLayers.append(l)
        }
        
        let hexs = colors.map{$0.toHex().0}
        self.colorHexs = hexs
        
        indicatorLayer.lineWidth = 2
        indicatorLayer.fillColor = UIColor.clear.cgColor
        indicatorLayer.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        indicatorLayer.strokeColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1.000).cgColor
        indicatorLayer.path = selectedPath(CGRect(x: 0, y: 0, width: 15, height: 15)).cgPath
        layer.addSublayer(indicatorLayer)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        addGestureRecognizer(tap)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changedToColor(_ color: UIColor?) {
        
        if let c = color, let index = colorHexs.index(of: c.toHex().0) {
            selectedColor = colors[index]
            selectedLayer = colorLayers[index]
            changedIndicator(colorLayers[index].position, hidden: false)
        } else {
            selectedColor = nil
            selectedLayer = nil
            changedIndicator(CGPoint.zero, hidden: true)
        }
    }
    
    func changeColors(_ colors: [UIColor]) {
        self.colors = colors
        for (i, c) in colors.enumerated() {
            let l = colorLayers[i]
            l.fillColor = c.cgColor
        }
        
        let hexs = colors.map{$0.toHex().0}
        self.colorHexs = hexs
    }
    
    func changedIndicator(_ position: CGPoint, hidden: Bool) {
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        indicatorLayer.position = position
        indicatorLayer.isHidden = hidden
        CATransaction.commit()
    }
    
    @objc fileprivate func tap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        
        for (i, l) in colorLayers.enumerated() {
            if l.frame.contains(location) {
                if let selectedLayer = selectedLayer, selectedLayer == l {
                    
                    
                } else {
                    selectedColor = colors[i]
                    selectedLayer = l
                    changedToColor(colors[i])
                    sendActions(for: .touchUpInside)
                }
            }
        }
    }
    
    override open func layoutSubviews() {
        
        let lineSpacing = CGFloat(0)
        let itemSpacing = CGFloat(2)
        let top = CGFloat(10)
        let bottom = CGFloat(10)
        let left = CGFloat(2)
        let right = CGFloat(2)
        
        let count = colors.count
        let last = count % 2
        let first = (count - last) / 2
        let second = (count - last) / 2 + last
        
        let rect = UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
        let itemHeight = (rect.height - lineSpacing) / 2.0
        let itemWidth = (rect.width - CGFloat(second - 1) * itemSpacing) / CGFloat(second)
        let firstLineLeft = (rect.width - itemWidth * CGFloat(first) - itemSpacing * CGFloat(first - 1)) / 2.0
        let pathSide = CGFloat(30)
        let pathX = (itemWidth - pathSide) / 2.0
        let pathY = (itemHeight - pathSide) / 2.0
        
        for (i, l) in colorLayers.enumerated() {
            let path = UIBezierPath(ovalIn: CGRect(x: pathX, y: pathY, width: pathSide, height: pathSide))
            if i < first {
                let x = rect.minX + firstLineLeft + itemSpacing * CGFloat(i) + itemWidth * CGFloat(i)
                let y = rect.minY
                l.frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
            } else {
                let x = rect.minX + itemSpacing * CGFloat(i - first) + itemWidth * CGFloat(i - first)
                let y = rect.minY + itemHeight + lineSpacing
                l.frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
            }
            l.path = path.cgPath
        }
        
        changedToColor(selectedColor)
    }
    
    func selectedPath(_ frame: CGRect = CGRect(x: 0, y: 0, width: 20, height: 20)) -> UIBezierPath {
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 0.48333 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.33333 * frame.width, y: frame.minY + 0.83333 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.33333 * frame.width, y: frame.minY + 0.83333 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.33333 * frame.width, y: frame.minY + 0.83333 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 1.00000 * frame.width, y: frame.minY + 0.13333 * frame.height))
        bezierPath.lineCapStyle = .round;
        
        bezierPath.lineJoinStyle = .round;
        
        bezierPath.lineWidth = 2
        
        return bezierPath
    }
    
}
