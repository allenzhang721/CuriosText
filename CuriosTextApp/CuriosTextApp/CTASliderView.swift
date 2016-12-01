import Foundation
import UIKit

protocol ValueTuneable {
    
    var value: CGFloat {get set}
    var maxiumValue: CGFloat {get set}
    var minumValue: CGFloat {get set}
}

public struct CTASliderAttributes {
    
    public enum CTASliderLineAlignment {
        case top, center, bottom
    }
    
    public enum CTASliderCalibrationCount: Int {
        case normal = 100
        case middle = 200
        case long = 300
    }
    
    public let seniorlineLengthRatio: CGFloat  // the Ratio is base on view.bounds.height
    public let minorLineLengthRatio: CGFloat
    public let lineWidth: CGFloat = 2
    public let lineSpacing: CGFloat = 20
    
    public let lineAlignment: CTASliderLineAlignment = .bottom
    public let calibrationCount: CTASliderCalibrationCount = .normal
    
    public let lineColor = UIColor.lightGray
    public let indicatorColor = UIColor.red
    
    public var indicatorWidth: CGFloat {
        return lineSpacing
    }
    
    public init(showMinorLine: Bool = true, seniorRatio: CGFloat = 1.0) {
        
        let nextRatio = max(0.1, min(seniorRatio, 1))
        seniorlineLengthRatio = nextRatio
        minorLineLengthRatio = showMinorLine ? 0.5 * seniorlineLengthRatio : seniorlineLengthRatio
    }
}

open class CTASliderView: UIControl, ValueTuneable {
    
    var targetValues = [CGFloat]()
    
    fileprivate var leftValue: CGFloat = 0.5
    fileprivate var rightValue: CGFloat = 2.5
    fileprivate var currentValue: CGFloat = 0.0
    
    fileprivate var calibrationUnit: CGFloat = 1.0
    
    fileprivate let indicatorLayer = CAShapeLayer()
    fileprivate let calibrationLayer = CAShapeLayer()
    fileprivate let containerLayer = CALayer()
    fileprivate let scrollView = UIScrollView()
    
    fileprivate(set) var attributes = CTASliderAttributes()
    
    open var maxiumValue: CGFloat {
        get {
            return rightValue
        }
        
        set {
            let nextMaxValue = max(leftValue, min(rightValue, newValue))
            if rightValue != nextMaxValue {
                rightValue = nextMaxValue
            }
        }
    }
    
    open var minumValue: CGFloat {
        get {
            return leftValue
        }
        
        set {
            let nextminValue = min(rightValue, min(leftValue, newValue))
            if leftValue != nextminValue {
                leftValue = nextminValue
            }
        }
    }
    
    open var value: CGFloat {
        get {
            return currentValue
        }
        
        set {
            let nextValue = max(min(newValue, maxiumValue), minumValue)
            if currentValue != nextValue {
                currentValue = nextValue
                updateOffsetByValue(nextValue)
            }
        }
    }
    
    public init(frame: CGRect, attribute: CTASliderAttributes) {
        self.attributes = attribute
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    fileprivate func setup() {
        indicatorLayer.contentsScale = UIScreen.main.scale
        indicatorLayer.fillColor = attributes.indicatorColor.cgColor
        calibrationLayer.contentsScale = UIScreen.main.scale
        containerLayer.contentsScale = UIScreen.main.scale
        containerLayer.backgroundColor = attributes.lineColor.cgColor
        
        containerLayer.addSublayer(indicatorLayer)
        containerLayer.mask = calibrationLayer
        layer.addSublayer(containerLayer)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        scrollView.delegate = self
        addSubview(scrollView)
    }
    
    fileprivate func layout() {
        
        containerLayer.frame = bounds
        indicatorLayer.frame = containerLayer.bounds
        scrollView.frame = bounds
        
        // scrollView
        let count = attributes.calibrationCount.rawValue
        let lw = attributes.lineWidth
        let ls = attributes.lineSpacing
        
        let h = bounds.height
        let w = CGFloat(count) * (lw + ls)
        let contentSize = CGSize(width: w + bounds.width , height: h)
        
        scrollView.contentSize = contentSize
        calibrationLayer.frame = CGRect(origin: CGPoint.zero, size: contentSize)
        
        let calibrationPath = CTASliderView.calibrationPath(bounds, attributes: attributes)
        calibrationLayer.path = calibrationPath.cgPath
        
        let indicatorPath = CTASliderView.indicatorPath(bounds, attributes: attributes)
        indicatorLayer.path = indicatorPath.cgPath
        
        let nextUnit = (rightValue - leftValue) / w
        
        if calibrationUnit != nextUnit {
            calibrationUnit = nextUnit
        }
        
        updateOffsetByValue(value)
    }
    
    fileprivate func updateCalibarationOffset(_ offset: CGFloat) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        calibrationLayer.frame.origin.x = -offset
        CATransaction.commit()
    }
    
    fileprivate func updateOffsetByValue(_ v: CGFloat) {
        
        let offset = (v - leftValue) / calibrationUnit
        updateCalibarationOffset(offset)
        scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: false)
    }
}

// MARK: - UIScrollView Delegate
extension CTASliderView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView.isTracking || scrollView.isDragging || scrollView.isDecelerating else {
            return
        }
        
        //floor(nextScale * 100) / 100.0
        let offset = scrollView.contentOffset
        let v = floor(offset.x * calibrationUnit * 1000) / 1000.0
        let nextValue = leftValue + CGFloat(v)
        
        var targetValue = nextValue
        for v in targetValues {
            if fabs(v * 1000.0 - nextValue * 1000.0) < 3 {
                targetValue = v
                updateOffsetByValue(targetValue)
                break
            }
        }
        
        
        //if fabs(nextScale * 100.0 - oldScale * 100.0) > 0.1
        if fabs(targetValue * 1000.0 - currentValue * 1000.0) > 0.1 {
            currentValue = targetValue
            sendActions(for: .valueChanged)
            //        print(currentValue)
            updateCalibarationOffset(offset.x)
        }
        
    }
}

extension CTASliderView {
    
    public class func indicatorPath(_ bounds: CGRect, attributes: CTASliderAttributes) -> UIBezierPath {
        
        let w = attributes.lineSpacing
        let h = bounds.height
        let x = (bounds.width - w) / 2.0
        let y: CGFloat = 0
        
        return UIBezierPath(
            rect: CGRect(
                x: x,
                y: y,
                width: w,
                height: h)
        )
    }
    
    public class func calibrationPath(_ rect: CGRect, attributes: CTASliderAttributes) -> UIBezierPath {
        
        let path = UIBezierPath()
        
        let lw = attributes.lineWidth
        let ls = attributes.lineSpacing
        let sr = attributes.seniorlineLengthRatio
        let mr = attributes.minorLineLengthRatio
        let alignment = attributes.lineAlignment
        let count = attributes.calibrationCount.rawValue
        
        /* Calibration
         
         |----|----|
         
         |  -> senior line
         -  -> minor line
         
         calibartionLength = count * (lineWidth + lineSpacing) + lineWidth
         */
        
        let height = rect.height
        let originX = (rect.width - lw) / 2.0
        
        let maxRatio = max(sr, mr)
        let realRectHeight = height * maxRatio
        let topInset = (height - realRectHeight) / 2.0
        
        let seniorLength = height * sr
        let minorLength = height * mr
        let seniorY: CGFloat
        let minorY: CGFloat
        
        switch alignment {
        case .top:
            seniorY = topInset
            minorY = topInset
            
        case .center:
            seniorY = topInset + realRectHeight * (1 - sr) / 2.0
            minorY = topInset + realRectHeight * (1 - mr) / 2.0
            
        case .bottom:
            seniorY = topInset + (realRectHeight - seniorLength)
            minorY = topInset + (realRectHeight - minorLength)
        }
        
        for i in 0..<count + 1 {
            let isMinor = (i % 5 != 0)
            
            let x = originX + CGFloat(i) * (lw + ls)
            let y = isMinor ? minorY : seniorY
            let w = lw
            let h = isMinor ? minorLength : seniorLength
            
            let lineRect = CGRect(x: x, y: y, width: w, height: h)
            
            let minX = lineRect.minX
            let minY = lineRect.minY
            let maxX = lineRect.maxX
            let maxY = lineRect.maxY
            
            let tl = CGPoint(x: minX, y: minY)  // top left
            let tr = CGPoint(x: maxX, y: minY)  // top right
            let br = CGPoint(x: maxX, y: maxY)  // bottom right
            let bl = CGPoint(x: minX, y: maxY)  // bottom left
            
            path.move(to: tl)
            path.addLine(to: tr)
            path.addLine(to: br)
            path.addLine(to: bl)
            path.addLine(to: tl)
            path.close()
        }
        return path
    }
}
