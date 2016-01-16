//
//  ContainerFactory.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/18/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation
import UIKit

class EditorFactory {
    
    class func containerBy(page: PageVMProtocol) -> [ContainerView] {
        
        var containerViews = [ContainerView]()
        
        for (_, vm) in page.containerVMs.enumerate() {
            let containerView = self.containerBy(vm)
            containerViews += [containerView]
        }
        
        return containerViews
    }
    
    class func containerBy(containerVM: ContainerVMProtocol) -> ContainerView {
        
        switch containerVM.type {
        case .Empty:
            return self.containerWithEmptyBy(containerVM)
            
        case .Text:
            
            return self.containerWithTextBy(containerVM as! TextContainerVMProtocol)
        }
    }
    
    class func canvasBy(page: CTAPage) -> CanvasView {
        
        let canvasView = CanvasView(frame: CGRect(x: 0, y: 0, width: page.width, height: page.height))
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(rect: canvasView.bounds).CGPath
        canvasView.layer.mask = mask
        return canvasView
        
    }
    
    class func generateRandomPage() -> CTAPage {
        
        var containers = [CTAContainer]()
        for _ in 0..<3 {
            
            let con = self.generateTextContainer(320.0, pageHeigh: 320.0, text: "我叫陈星宇 \nWhat can i do for you ?", attributes: CTATextAttributes())
            containers += [con]
        }
        
        let page = CTAPage(containers: containers)
        return page
    }
}

extension EditorFactory {
    
    private class func containerWithEmptyBy(viewPro: protocol<ViewPropertiesRetrivevale, ContainerIdentifiable>) -> ContainerView {
        
        let containerView = ContainerView(frame: CGRect(x: 0, y: 0, width: viewPro.size.width, height: viewPro.size.height))
        containerView.layer.position = viewPro.center
        containerView.addID(viewPro.iD)
        
        return containerView
    }
    
    private class func containerWithTextBy(containerVM: TextContainerVMProtocol) -> ContainerView {
        
        // TODO: Finish The Cal process -- Emiaostein; 2015-12-27-01:13
        //        func aStr(text: String, attributes: [String: AnyObject]) -> (containerSize: CGSize, contentsRect: CGRect, contentsInset: CGPoint, contents: NSAttributedString) {
        //
        //            let attribute = attributes
        //
        //            let family = attribute[TextAttributeName.fontFamily]!
        //            let fontName = attribute[TextAttributeName.fontName]!
        //            let fontSize = attribute[TextAttributeName.fontSize]!
        //            let matrix = attribute[TextAttributeName.fontMatrix] as! [String: AnyObject]
        //            let scale = matrix[TextAttributeName.fontMatrixScale] as! CGFloat
        //            let scaleMatrix = NSValue(CGAffineTransform: CGAffineTransformMakeScale(scale, scale))
        //
        //
        //            let fontAttributes: [String: AnyObject] = [
        //                UIFontDescriptorFamilyAttribute: family,
        //                UIFontDescriptorNameAttribute: fontName,
        //                UIFontDescriptorSizeAttribute: fontSize,
        //                UIFontDescriptorMatrixAttribute: scaleMatrix,
        //                //    UIFontDescriptorTraitsAttribute: weightstraits
        //                //    UIFontDescriptorFixedAdvanceAttribute: fixAdvance
        //            ]
        //
        //            // font
        //            let fontdes = UIFontDescriptor(fontAttributes: fontAttributes)
        //            let font = UIFont(descriptor: fontdes, size: -1)
        //
        //            // textColor
        //            let textColor: UIColor = {
        //                let rgba = attribute[TextAttributeName.ForegroundColor] as! [String: AnyObject]
        //                let r = rgba[TextAttributeName.ForegroundColorR] as! CGFloat
        //                let g = rgba[TextAttributeName.ForegroundColorG] as! CGFloat
        //                let b = rgba[TextAttributeName.ForegroundColorB] as! CGFloat
        //                let a = rgba[TextAttributeName.ForegroundColorA] as! CGFloat
        //                let color = UIColor(red: r, green: g, blue: b, alpha: a)
        //                return color
        //            }()
        //
        //            // kern
        //            let kern = attribute[TextAttributeName.kern]!
        //
        //            // paragraph linespacing and alignment
        //            let paragraphStyle: NSParagraphStyle = {
        //
        //                let paragraph = attribute[TextAttributeName.paragraph] as! [String: AnyObject]
        //                let lineSpacing = paragraph[TextAttributeName.paragraphLineSpacing] as! CGFloat
        //                let alignment = NSTextAlignment(rawValue: (paragraph[TextAttributeName.paragraphAlignment] as! Int))!
        //                let p = NSMutableParagraphStyle()
        //                p.alignment = alignment
        //                p.lineSpacing = lineSpacing
        //                return p
        //            }()
        //
        //
        //            // shadow on, offset, color and blurRadius
        //            let shadowOn = attribute[TextAttributeName.shadowOn] as! Bool
        //            let shadowDic = attribute[TextAttributeName.shadow] as! [String: AnyObject]
        //
        //            let shadow: NSShadow = {
        //                let s = NSShadow()
        //
        //                let shadowOffset: CGSize = {
        //                    let offsetDic = shadowDic[TextAttributeName.shadowOffset] as! [String: AnyObject]
        //                    print(offsetDic)
        //                    let shadowOffsetWidth = offsetDic[TextAttributeName.shadowOffsetWidth] as! CGFloat
        //                    let shadowOffsetHeight = offsetDic[TextAttributeName.shadowOffsetHeight] as! CGFloat
        //                    let offset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        //                    return offset
        //                }()
        //
        //                let shadowColor: UIColor = {
        //                    let shadowDic = attribute[TextAttributeName.shadow] as! [String: AnyObject]
        //                    let rgba = shadowDic[TextAttributeName.shadowColor] as! [String: AnyObject]
        //                    let r = rgba[TextAttributeName.shadowColorR] as! CGFloat
        //                    let g = rgba[TextAttributeName.shadowColorG] as! CGFloat
        //                    let b = rgba[TextAttributeName.shadowColorB] as! CGFloat
        //                    let a = rgba[TextAttributeName.shadowColorA] as! CGFloat
        //                    let color = UIColor(red: r, green: g, blue: b, alpha: a)
        //                    return color
        //                }()
        //
        //                let blur = shadowDic[TextAttributeName.shadowBlurRadius] as! CGFloat
        //
        //                s.shadowColor = shadowColor
        //                s.shadowOffset = shadowOffset
        //                s.shadowBlurRadius = blur
        //
        //                return s
        //            }()
        //
        //            if shadowOn {
        //
        //            }
        //
        //            var strAttributes: [String: AnyObject] = [
        //                NSFontAttributeName: font,
        //                NSParagraphStyleAttributeName: paragraphStyle,
        //                NSForegroundColorAttributeName: textColor,
        //                //    NSBackgroundColorAttributeName: textBackgroundColor,
        //                NSKernAttributeName:kern,
        //                //                    NSShadowAttributeName: shadow,
        //                //    NSObliquenessAttributeName: NSNumber(float: -1.1)
        //                //    NSExpansionAttributeName: NSNumber(float: 2.0)
        //            ]
        //
        //            if shadowOn {
        //                strAttributes[NSShadowAttributeName] = shadow
        //            } else {
        //                strAttributes[NSShadowAttributeName] = nil
        //            }
        //
        ////            let textAttributes = toAttributeStringAttribute(attributes)
        //
        //            let attr = NSAttributedString(string: text, attributes: strAttributes)
        //
        //            func cal(attributeString: NSAttributedString, attrs: [String: AnyObject]) -> (containerSize: CGSize, contentsRect: CGRect, contentInset: CGPoint) {
        //
        //                let textSize = attributeString.boundingRectWithSize(CGSize(width: 320, height: 568 * 2), options: .UsesLineFragmentOrigin, context: nil).size
        //                let fontSize = font.pointSize * scale
        //                let shadowOffset = shadow.shadowOffset
        //                let shadowBlur = shadow.shadowBlurRadius
        //
        //                let containerSize = textSize
        //                let contentInset = CGPoint(x: 80.0 / 17.0 * fontSize, y: 0)
        //                let contentSize = CGSize(width: textSize.width + contentInset.x * 2 + shadowOffset.width + shadowBlur, height: textSize.height + contentInset.y + shadowOffset.height + shadowBlur)
        //                let contentOrigin = CGPoint(x: -contentInset.x, y: -contentInset.y)
        //                let contentRect = CGRect(origin: contentOrigin, size: contentSize)
        //
        //                return (containerSize, contentRect, contentInset)
        //            }
        //
        //            let r = cal(attr, attrs: attributes)
        //
        //            return (r.containerSize, r.contentsRect, r.contentInset, attr)
        //        }
        
        
        let str = containerVM.textElement!.attributeString
        let textViewInset = containerVM.textElement!.rectInset()
        let textSize = containerVM.textElement!.textSizeWithConstraintSize(CGSize(width: 320, height: 568 * 2))
        let textRect = containerVM.textElement!.textFrameWithTextSize(textsize: textSize)
        let containerView = ContainerTextView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: Double(textSize.width),
                height: Double(textSize.height)
            )
        )
        
        containerView.layer.position = containerVM.center
        containerView.addID(containerVM.iD)
        
        let textView = TextView(frame: textRect)
        textView.insets = textViewInset
        textView.attributedText = str
        textView.numberOfLines = 0
        containerView.textView = textView
        containerView.transform = CGAffineTransformMakeRotation(CGFloat(containerVM.radius))
        containerView.addSubview(textView)
        return containerView
    }
    
    //    class func containerWithImgBy(imgModel: TextRetrievable) -> CTAContainer {
    //
    //    }
    
    
}

extension EditorFactory {
    
    class func generateTextContainer(
        pageWidth: Double,
        pageHeigh: Double,
        text: String,
        attributes: CTATextAttributes)
        -> CTAContainer {
            
            let textElement = CTATextElement(text: text, attributes: attributes)
            let textSize = textElement.textSizeWithConstraintSize(CGSize(width: pageWidth, height: pageHeigh * 2))
            
            return CTAContainer(
                x: pageWidth / 2.0,
                y: pageHeigh / 2.0,
                width: Double(textSize.width),
                height: Double(textSize.height),
                rotation: 0.0,
                alpha: 1.0,
                scale: 1.0,
                inset: CGPoint.zero,
                element: textElement
            )
    }
    
    class func demoString(fontsize: CGFloat) -> NSAttributedString
    {
        // Create the attributed string
        let demoString = NSMutableAttributedString(string:"for old are you ?\nWhat should i do for you ?")
        
        // Declare the fonts
        let demoStringFont1 = UIFont(name:"Zapfino", size:fontsize)
        
        // Declare the paragraph styles
        let demoStringParaStyle1 = NSMutableParagraphStyle()
        demoStringParaStyle1.lineSpacing = 1.0
        demoStringParaStyle1.tabStops = [
            NSTextTab(textAlignment: NSTextAlignment.Left, location: 28.000000, options: [:]),
            NSTextTab(textAlignment: NSTextAlignment.Left, location: 56.000000, options: [:]),
            NSTextTab(textAlignment: NSTextAlignment.Left, location: 84.000000, options: [:]),
            NSTextTab(textAlignment: NSTextAlignment.Left, location: 112.000000, options: [:]),
            NSTextTab(textAlignment: NSTextAlignment.Left, location: 140.000000, options: [:]),
            NSTextTab(textAlignment: NSTextAlignment.Left, location: 168.000000, options: [:]),
            NSTextTab(textAlignment: NSTextAlignment.Left, location: 196.000000, options: [:]),
            NSTextTab(textAlignment: NSTextAlignment.Left, location: 224.000000, options: [:]),
            NSTextTab(textAlignment: NSTextAlignment.Left, location: 252.000000, options: [:]),
            NSTextTab(textAlignment: NSTextAlignment.Left, location: 280.000000, options: [:]),
            NSTextTab(textAlignment: NSTextAlignment.Left, location: 308.000000, options: [:]),
            NSTextTab(textAlignment: NSTextAlignment.Left, location: 336.000000, options: [:]), ]
        
        
        // Create the attributes and add them to the string
        demoString.addAttribute(NSParagraphStyleAttributeName, value:demoStringParaStyle1, range:NSMakeRange(0,44))
        demoString.addAttribute(NSFontAttributeName, value:demoStringFont1!, range:NSMakeRange(0,44))
        
        return NSAttributedString(attributedString:demoString)
    }
    
    class func demoString() -> NSAttributedString
    {
        // Create the attributed string
        let demoString = NSMutableAttributedString(string:"\thow old \tare you ?\nWhat should i do for you ?")
        
        // Declare the fonts
        let demoStringFont1 = UIFont(name:"Zapfino", size:12.0)
        
        // Declare the paragraph styles
        let demoStringParaStyle1 = NSMutableParagraphStyle()
        demoStringParaStyle1.lineSpacing = 1.0
        demoStringParaStyle1.tabStops = [
            NSTextTab(textAlignment: NSTextAlignment.Left, location: 28.000000, options: [:]),
            NSTextTab(textAlignment: NSTextAlignment.Left, location: 56.000000, options: [:]),
            NSTextTab(textAlignment: NSTextAlignment.Left, location: 84.000000, options: [:]),
            NSTextTab(textAlignment: NSTextAlignment.Left, location: 112.000000, options: [:]),
            NSTextTab(textAlignment: NSTextAlignment.Left, location: 140.000000, options: [:]),
            NSTextTab(textAlignment: NSTextAlignment.Left, location: 168.000000, options: [:]),
            NSTextTab(textAlignment: NSTextAlignment.Left, location: 196.000000, options: [:]),
            NSTextTab(textAlignment: NSTextAlignment.Left, location: 224.000000, options: [:]),
            NSTextTab(textAlignment: NSTextAlignment.Left, location: 252.000000, options: [:]),
            NSTextTab(textAlignment: NSTextAlignment.Left, location: 280.000000, options: [:]),
            NSTextTab(textAlignment: NSTextAlignment.Left, location: 308.000000, options: [:]),
            NSTextTab(textAlignment: NSTextAlignment.Left, location: 336.000000, options: [:]), ]
        
        
        // Create the attributes and add them to the string
        demoString.addAttribute(NSParagraphStyleAttributeName, value:demoStringParaStyle1, range:NSMakeRange(0,44))
        demoString.addAttribute(NSFontAttributeName, value:demoStringFont1!, range:NSMakeRange(0,44))
        
        return NSAttributedString(attributedString:demoString)
    }
    
}