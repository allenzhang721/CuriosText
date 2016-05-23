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
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    private func _setup() {
        let bouns = UIScreen.mainScreen().bounds
        let settingLabel = UILabel.init(frame: CGRect.init(x: 0, y: 8, width: bouns.width, height: 28))
        settingLabel.font = UIFont.systemFontOfSize(18)
        settingLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        settingLabel.text = title ??  NSLocalizedString("AboutLabel", comment: "")
        settingLabel.textAlignment = .Center
        self.view.addSubview(settingLabel)
        
        let backButton = UIButton.init(frame: CGRect.init(x: 0, y: 2, width: 40, height: 40))
        backButton.setImage(UIImage(named: "back-button"), forState: .Normal)
        backButton.setImage(UIImage(named: "back-selected-button"), forState: .Highlighted)
        backButton.addTarget(self, action: #selector(CTASettingViewController.backButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton)
        
        
        if let info = NSBundle.mainBundle().infoDictionary {
            
//            let appName = info["CFBundleDisplayName"]
            let appVersion = info["CFBundleShortVersionString"] as! String
//            let appBuild = info["CFBundleVersion"]
            
            let imageView = view.viewWithTag(1000) as! UIImageView
            imageView.image = _versionTag(text2:"v" + appVersion)
        }
    }
    
    
    
    private func _versionTag(rect: CGRect = CGRectMake(0, 0, 41, 21), text2: String = "v1.2.3") -> UIImage {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        _drawVersionTag(frame3: rect, text2: text2)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    private func _drawVersionTag(frame3 frame3: CGRect = CGRectMake(0, 0, 41, 21), text2: String = "v1.2.3") {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Color Declarations
        let fillColor = UIColor(red: 0.290, green: 0.290, blue: 0.290, alpha: 1.000)
        
        
        //// Subframes
        let frame = CGRectMake(frame3.minX + frame3.width - 24, frame3.minY + 16, 12, 5)
        let frame2 = CGRectMake(frame3.minX, frame3.minY, frame3.width, 16)
        
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(frame.minX, frame.minY + 5))
        bezierPath.addLineToPoint(CGPointMake(frame.minX, frame.minY))
        bezierPath.addLineToPoint(CGPointMake(frame.minX + 12, frame.minY))
        fillColor.setFill()
        bezierPath.fill()
        
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath()
        rectanglePath.moveToPoint(CGPointMake(frame2.minX + 10.5, frame2.minY))
        rectanglePath.addLineToPoint(CGPointMake(frame2.maxX - 12.23, frame2.minY))
        rectanglePath.addCurveToPoint(CGPointMake(frame2.maxX - 5.21, frame2.minY + 0.52), controlPoint1: CGPointMake(frame2.maxX - 8.56, frame2.minY), controlPoint2: CGPointMake(frame2.maxX - 6.8, frame2.minY))
        rectanglePath.addLineToPoint(CGPointMake(frame2.maxX - 4.9, frame2.minY + 0.6))
        rectanglePath.addCurveToPoint(CGPointMake(frame2.maxX, frame2.minY + 7.6), controlPoint1: CGPointMake(frame2.maxX - 1.96, frame2.minY + 1.67), controlPoint2: CGPointMake(frame2.maxX, frame2.minY + 4.47))
        rectanglePath.addCurveToPoint(CGPointMake(frame2.maxX, frame2.minY + 8), controlPoint1: CGPointMake(frame2.maxX, frame2.minY + 8), controlPoint2: CGPointMake(frame2.maxX, frame2.minY + 8))
        rectanglePath.addLineToPoint(CGPointMake(frame2.maxX, frame2.minY + 8))
        rectanglePath.addLineToPoint(CGPointMake(frame2.maxX, frame2.minY + 8))
        rectanglePath.addLineToPoint(CGPointMake(frame2.maxX, frame2.minY + 8.4))
        rectanglePath.addCurveToPoint(CGPointMake(frame2.maxX - 4.9, frame2.maxY - 0.6), controlPoint1: CGPointMake(frame2.maxX, frame2.minY + 11.53), controlPoint2: CGPointMake(frame2.maxX - 1.96, frame2.maxY - 1.67))
        rectanglePath.addCurveToPoint(CGPointMake(frame.maxX - 0.08, frame.maxY - 5), controlPoint1: CGPointMake(frame2.maxX - 6.8, frame2.maxY), controlPoint2: CGPointMake(frame.maxX + 3.44, frame.maxY - 5))
        rectanglePath.addLineToPoint(CGPointMake(frame2.minX + 12.23, frame2.maxY))
        rectanglePath.addCurveToPoint(CGPointMake(frame2.minX + 5.21, frame2.maxY - 0.52), controlPoint1: CGPointMake(frame2.minX + 8.56, frame2.maxY), controlPoint2: CGPointMake(frame2.minX + 6.8, frame2.maxY))
        rectanglePath.addLineToPoint(CGPointMake(frame2.minX + 4.9, frame2.maxY - 0.6))
        rectanglePath.addCurveToPoint(CGPointMake(frame2.minX, frame2.minY + 8.4), controlPoint1: CGPointMake(frame2.minX + 1.96, frame2.maxY - 1.67), controlPoint2: CGPointMake(frame2.minX, frame2.minY + 11.53))
        rectanglePath.addCurveToPoint(CGPointMake(frame2.minX, frame2.minY + 8), controlPoint1: CGPointMake(frame2.minX, frame2.minY + 8), controlPoint2: CGPointMake(frame2.minX, frame2.minY + 8))
        rectanglePath.addLineToPoint(CGPointMake(frame2.minX, frame2.minY + 8))
        rectanglePath.addLineToPoint(CGPointMake(frame2.minX, frame2.minY + 8))
        rectanglePath.addLineToPoint(CGPointMake(frame2.minX, frame2.minY + 7.6))
        rectanglePath.addCurveToPoint(CGPointMake(frame2.minX + 4.9, frame2.minY + 0.6), controlPoint1: CGPointMake(frame2.minX, frame2.minY + 4.47), controlPoint2: CGPointMake(frame2.minX + 1.96, frame2.minY + 1.67))
        rectanglePath.addCurveToPoint(CGPointMake(frame2.minX + 12.08, frame2.minY), controlPoint1: CGPointMake(frame2.minX + 6.8, frame2.minY), controlPoint2: CGPointMake(frame2.minX + 8.56, frame2.minY))
        rectanglePath.addLineToPoint(CGPointMake(frame2.minX + 12.23, frame2.minY))
        rectanglePath.addLineToPoint(CGPointMake(frame2.minX + 10.5, frame2.minY))
        rectanglePath.closePath()
        fillColor.setFill()
        rectanglePath.fill()
        
        
        //// Text Drawing
        let textRect = CGRectMake(frame2.minX + 3, frame2.minY + 2, 34, 11)
        let textStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = .Center
        
        let textFontAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(10), NSForegroundColorAttributeName: UIColor.whiteColor(), NSParagraphStyleAttributeName: textStyle]
        
        let textTextHeight: CGFloat = NSString(string: text2).boundingRectWithSize(CGSizeMake(textRect.width, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: textFontAttributes, context: nil).size.height
        CGContextSaveGState(context)
        CGContextClipToRect(context, textRect);
        NSString(string: text2).drawInRect(CGRectMake(textRect.minX, textRect.minY + (textRect.height - textTextHeight) / 2, textRect.width, textTextHeight), withAttributes: textFontAttributes)
        CGContextRestoreGState(context)
    }
}

extension AboutViewController {
    
    func backButtonClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}


