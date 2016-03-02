//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

var str = "Hello, playground"

let slider = CTASliderView(frame: CGRect(x: 0, y: 0 , width: 300, height: 50), attribute: CTASliderAttributes(showMinorLine: true, seniorRatio: 0.5))
slider.backgroundColor = UIColor.whiteColor()

let atr = CTASliderAttributes(showMinorLine: true, seniorRatio: 0.5)

let path = CTASliderView.calibrationPath(slider.bounds, attributes: atr)
let ip = CTASliderView.indicatorPath(slider.bounds, attributes: atr)

class View: UIView {
    
    var slider: CTASliderView!
    var slider2: UISlider!
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        slider = CTASliderView(frame: CGRect(x: 0, y: 30 , width: 300, height: 50), attribute: CTASliderAttributes(showMinorLine: true, seniorRatio: 0.5))
        slider.backgroundColor = UIColor.whiteColor()
        slider2 = UISlider(frame: CGRect(x: 0, y: 80, width: 300, height: 44))
        
        slider2.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
        
        slider.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
        
        slider2.minimumValue = Float(slider.minumValue - 5)
        slider2.maximumValue = Float(slider.maxiumValue + 5)
        slider2.value = Float(slider.value)
        
        addSubview(slider)
        addSubview(slider2)
    }
    
    func valueChanged(sender: AnyObject) {
        
        switch sender {
        case is UISlider:
            slider.value = CGFloat(slider2.value)
            
        case is CTASliderView:
            slider2.value = Float(slider.value)
            print(slider.value)
            
        default:
            ()
        }
    }
}

public class StyleKitName : NSObject {
    
    //// Drawing Methods
    
    public class func drawCanvas1(frame frame: CGRect = CGRectMake(68, 47, 106, 55)) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Color Declarations
        let gradientColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        let gradientColor2 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 0.000)
        
        //// Gradient Declarations
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [gradientColor.CGColor, gradientColor2.CGColor], [0, 1])!
        
        //// Rectangle Drawing
        let rectangleRect = CGRectMake(frame.minX + floor(frame.width * 0.00000 + 0.5), frame.minY + floor(frame.height * 0.00000 + 0.5), floor(frame.width * 1.00000 + 0.5) - floor(frame.width * 0.00000 + 0.5), floor(frame.height * 1.00000 + 0.5) - floor(frame.height * 0.00000 + 0.5))
        let rectanglePath = UIBezierPath(rect: rectangleRect)
        CGContextSaveGState(context)
        rectanglePath.addClip()
        CGContextDrawLinearGradient(context, gradient,
                                             CGPointMake(rectangleRect.maxX, rectangleRect.midY),
                                             CGPointMake(rectangleRect.minX, rectangleRect.midY),
                                             CGGradientDrawingOptions())
        CGContextRestoreGState(context)
    }
    
    //// Generated Images
    
    public class func imageOfCanvas1(frame frame: CGRect = CGRectMake(68, 47, 106, 55)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        StyleKitName.drawCanvas1(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        
        let imageOfCanvas1 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageOfCanvas1
    }
    
}

let av = View(frame: CGRect(x: 0, y: 0, width: 80, height: 200))

XCPlaygroundPage.currentPage.liveView = av

let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 88))
label.text = "555"
//label.backgroundColor = UIColor.yellowColor()
let image = UIImage(named: "gradient")
label.backgroundColor = UIColor.init(patternImage: StyleKitName.imageOfCanvas1(frame: label.bounds))
label.textAlignment = .Center
//label.layer.contents = image?.CGImage
//label.contentMode = .ScaleAspectFill
label
