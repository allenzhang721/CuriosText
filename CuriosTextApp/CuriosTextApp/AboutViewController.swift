//
//  AboutViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 5/23/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        _setup()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    fileprivate func _setup() {
        let bounds = UIScreen.main.bounds
        let settingLabel = UILabel.init(frame: CGRect.init(x: 0, y: 28, width: bounds.width, height: 28))
        settingLabel.font = UIFont.systemFont(ofSize: 18)
        settingLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        settingLabel.text = title ??  NSLocalizedString("AboutLabel", comment: "")
        settingLabel.textAlignment = .center
        self.view.addSubview(settingLabel)
        
        let backButton = UIButton.init(frame: CGRect.init(x: 0, y: 22, width: 40, height: 40))
        backButton.setImage(UIImage(named: "back-button"), for: UIControlState())
        backButton.setImage(UIImage(named: "back-selected-button"), for: .highlighted)
        backButton.addTarget(self, action: #selector(CTASettingViewController.backButtonClick(_:)), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        let textLine = UIImageView(frame: CGRect(x: 0, y: 63, width: bounds.width, height: 1))
        textLine.image = UIImage(named: "space-line")
        self.view.addSubview(textLine)
        
        
        if let info = Bundle.main.infoDictionary {
            
            let appVersion = info["CFBundleShortVersionString"] as! String
            
            let versionLabel = view.viewWithTag(1000) as! UILabel
            versionLabel.text = "Version " + appVersion
        }
        
        self.view.backgroundColor = CTAStyleKit.commonBackgroundColor
    }
    
    fileprivate func _versionTag(_ rect: CGRect = CGRect(x: 0, y: 0, width: 41, height: 21), text2: String = "1.0.0") -> UIImage {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        _drawVersionTag(rect, text2: text2)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    fileprivate func _drawVersionTag(_ frame3: CGRect = CGRect(x: 0, y: 0, width: 41, height: 21), text2: String = "v1.2.3") {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Color Declarations
        let fillColor = UIColor(red: 0.290, green: 0.290, blue: 0.290, alpha: 1.000)
        
        
        //// Subframes
        let frame = CGRect(x: frame3.minX + frame3.width - 24, y: frame3.minY + 16, width: 12, height: 5)
        let frame2 = CGRect(x: frame3.minX, y: frame3.minY, width: frame3.width, height: 16)
        
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: frame.minX, y: frame.minY + 5))
        bezierPath.addLine(to: CGPoint(x: frame.minX, y: frame.minY))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 12, y: frame.minY))
        fillColor.setFill()
        bezierPath.fill()
        
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath()
        rectanglePath.move(to: CGPoint(x: frame2.minX + 10.5, y: frame2.minY))
        rectanglePath.addLine(to: CGPoint(x: frame2.maxX - 12.23, y: frame2.minY))
        rectanglePath.addCurve(to: CGPoint(x: frame2.maxX - 5.21, y: frame2.minY + 0.52), controlPoint1: CGPoint(x: frame2.maxX - 8.56, y: frame2.minY), controlPoint2: CGPoint(x: frame2.maxX - 6.8, y: frame2.minY))
        rectanglePath.addLine(to: CGPoint(x: frame2.maxX - 4.9, y: frame2.minY + 0.6))
        rectanglePath.addCurve(to: CGPoint(x: frame2.maxX, y: frame2.minY + 7.6), controlPoint1: CGPoint(x: frame2.maxX - 1.96, y: frame2.minY + 1.67), controlPoint2: CGPoint(x: frame2.maxX, y: frame2.minY + 4.47))
        rectanglePath.addCurve(to: CGPoint(x: frame2.maxX, y: frame2.minY + 8), controlPoint1: CGPoint(x: frame2.maxX, y: frame2.minY + 8), controlPoint2: CGPoint(x: frame2.maxX, y: frame2.minY + 8))
        rectanglePath.addLine(to: CGPoint(x: frame2.maxX, y: frame2.minY + 8))
        rectanglePath.addLine(to: CGPoint(x: frame2.maxX, y: frame2.minY + 8))
        rectanglePath.addLine(to: CGPoint(x: frame2.maxX, y: frame2.minY + 8.4))
        rectanglePath.addCurve(to: CGPoint(x: frame2.maxX - 4.9, y: frame2.maxY - 0.6), controlPoint1: CGPoint(x: frame2.maxX, y: frame2.minY + 11.53), controlPoint2: CGPoint(x: frame2.maxX - 1.96, y: frame2.maxY - 1.67))
        rectanglePath.addCurve(to: CGPoint(x: frame.maxX - 0.08, y: frame.maxY - 5), controlPoint1: CGPoint(x: frame2.maxX - 6.8, y: frame2.maxY), controlPoint2: CGPoint(x: frame.maxX + 3.44, y: frame.maxY - 5))
        rectanglePath.addLine(to: CGPoint(x: frame2.minX + 12.23, y: frame2.maxY))
        rectanglePath.addCurve(to: CGPoint(x: frame2.minX + 5.21, y: frame2.maxY - 0.52), controlPoint1: CGPoint(x: frame2.minX + 8.56, y: frame2.maxY), controlPoint2: CGPoint(x: frame2.minX + 6.8, y: frame2.maxY))
        rectanglePath.addLine(to: CGPoint(x: frame2.minX + 4.9, y: frame2.maxY - 0.6))
        rectanglePath.addCurve(to: CGPoint(x: frame2.minX, y: frame2.minY + 8.4), controlPoint1: CGPoint(x: frame2.minX + 1.96, y: frame2.maxY - 1.67), controlPoint2: CGPoint(x: frame2.minX, y: frame2.minY + 11.53))
        rectanglePath.addCurve(to: CGPoint(x: frame2.minX, y: frame2.minY + 8), controlPoint1: CGPoint(x: frame2.minX, y: frame2.minY + 8), controlPoint2: CGPoint(x: frame2.minX, y: frame2.minY + 8))
        rectanglePath.addLine(to: CGPoint(x: frame2.minX, y: frame2.minY + 8))
        rectanglePath.addLine(to: CGPoint(x: frame2.minX, y: frame2.minY + 8))
        rectanglePath.addLine(to: CGPoint(x: frame2.minX, y: frame2.minY + 7.6))
        rectanglePath.addCurve(to: CGPoint(x: frame2.minX + 4.9, y: frame2.minY + 0.6), controlPoint1: CGPoint(x: frame2.minX, y: frame2.minY + 4.47), controlPoint2: CGPoint(x: frame2.minX + 1.96, y: frame2.minY + 1.67))
        rectanglePath.addCurve(to: CGPoint(x: frame2.minX + 12.08, y: frame2.minY), controlPoint1: CGPoint(x: frame2.minX + 6.8, y: frame2.minY), controlPoint2: CGPoint(x: frame2.minX + 8.56, y: frame2.minY))
        rectanglePath.addLine(to: CGPoint(x: frame2.minX + 12.23, y: frame2.minY))
        rectanglePath.addLine(to: CGPoint(x: frame2.minX + 10.5, y: frame2.minY))
        rectanglePath.close()
        fillColor.setFill()
        rectanglePath.fill()
        
        
        //// Text Drawing
        let textRect = CGRect(x: frame2.minX + 3, y: frame2.minY + 2, width: 34, height: 11)
        let textStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = .center
        
        let textFontAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 10), NSForegroundColorAttributeName: UIColor.white, NSParagraphStyleAttributeName: textStyle]
        
        let textTextHeight: CGFloat = NSString(string: text2).boundingRect(with: CGSize(width: textRect.width, height: CGFloat.infinity), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: textFontAttributes, context: nil).size.height
        context?.saveGState()
        context?.clip(to: textRect);
        NSString(string: text2).draw(in: CGRect(x: textRect.minX, y: textRect.minY + (textRect.height - textTextHeight) / 2, width: textRect.width, height: textTextHeight), withAttributes: textFontAttributes)
        context?.restoreGState()
    }
}

extension AboutViewController {
    
    func backButtonClick(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
}


