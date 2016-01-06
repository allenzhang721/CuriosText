//
//  CTAScrollTuneView.swift
//  EditorToolApp
//
//  Created by Emiaostein on 12/31/15.
//  Copyright © 2015 Emiaostein. All rights reserved.
//

import UIKit

protocol ValueTuneable {
    
    var value: CGFloat {get}
    var maxiumValue: CGFloat {get}
    var minumValue: CGFloat {get}
    
    func updateValue(v: CGFloat)
    func setmaxiumValueandminumvalue(max: CGFloat, min: CGFloat)
}

class CTAScrollTuneAttributes {
    
    let lineWidth = 2
    let lineSpace = 6 * 3
    let showShortLine = true
    let count = 100
    let lineColor = UIColor.lightGrayColor()
    let indicatorColor = UIColor.redColor()
    
    var indicatorWith: Int {
        return lineSpace
    }
    
    var totalLineCount: Int {
        return count + 1
    }
}

class CTAScrollTuneView: UIControl, ValueTuneable {
    
    private let scrollView: UIScrollView
    private let backgroundLayer: CALayer
    private let maskLayer: CAShapeLayer
    private let attributes: CTAScrollTuneAttributes
    private var beganTranslateX: CGFloat = 0
    private var validRulerLength: CGFloat = 0
    private var validScrollLength: CGFloat = 0
    
   private(set) var value: CGFloat = 0.0
    var maxiumValue: CGFloat = 5.0
    var minumValue: CGFloat = 0.5
    
    var rulerUnit: CGFloat {
        
        return validRulerLength / (maxiumValue - minumValue)
    }
    
    var scrollUnit: CGFloat {
        
        return validScrollLength / (maxiumValue - minumValue)
    }
    
    init(frame: CGRect, attributes: CTAScrollTuneAttributes = CTAScrollTuneAttributes()) {
        self.attributes = attributes
        self.scrollView = UIScrollView()
        self.backgroundLayer = CALayer()
        self.maskLayer = CAShapeLayer()
        backgroundLayer.contentsScale = UIScreen.mainScreen().scale
        maskLayer.contentsScale = UIScreen.mainScreen().scale
        super.init(frame: frame)
         setup(bounds, attributes: attributes)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(frame: CGRect, attributes: CTAScrollTuneAttributes) {
        
        // Mask
        let linePath = path(bounds, attributes: attributes)
        maskLayer.path = linePath.CGPath
        
        //valid length
        validRulerLength = linePath.bounds.width - CGFloat(attributes.lineWidth)
        validScrollLength = validRulerLength

        // indicator
        let indicatorlayer = indicator(superLayerSize: frame.size, attrbutes: attributes)
        
        // backgroundLayer - show line and Indicator
        backgroundLayer.frame = CGRect(origin: CGPoint.zero, size: frame.size)
        backgroundLayer.backgroundColor = attributes.lineColor.CGColor
        backgroundLayer.addSublayer(indicatorlayer)
        backgroundLayer.mask = maskLayer
        
        // scrollView
        scrollView.frame = CGRect(origin: CGPoint.zero, size: frame.size)
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: validRulerLength + CGRectGetWidth(frame), height: CGRectGetHeight(frame))
   
        layer.addSublayer(backgroundLayer)
        addSubview(scrollView)
        beganTranslateX = CGRectGetWidth(frame) / 2.0 - CGFloat(attributes.lineWidth) / 2.0
        updateLineOffset(beganTranslateX)
    }
    
    private func indicator(superLayerSize size: CGSize, attrbutes: CTAScrollTuneAttributes) -> CALayer {
        let indicatorlayer = CALayer()
        indicatorlayer.backgroundColor = attributes.indicatorColor.CGColor
        
        let postion = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        
        indicatorlayer.bounds.size = CGSize(width: attributes.indicatorWith, height: Int(size.height))
        indicatorlayer.position = postion
        return indicatorlayer
    }
    
   private func updateLineOffset(offset: CGFloat) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        maskLayer.transform = CATransform3DMakeTranslation(offset, 0, 0)
        CATransaction.commit()
    }
    
   private func updateLineOffsetByValue(v: CGFloat) {
        
        let beganX = beganTranslateX
        let offset = -(v - minumValue) * rulerUnit + beganX
        updateLineOffset(offset)
    }
    
   private func updateScrollOffset(offset: CGFloat) {
        scrollView.setContentOffset(CGPoint(x: offset, y: scrollView.contentOffset.y), animated: false)
    }
    
   private func updateScrollOffsetByValue(v: CGFloat) {
        
        let offset = v * scrollUnit
        updateScrollOffset(offset)
    }
}

extension CTAScrollTuneView {
    
    func updateValue(v: CGFloat) {
        
        let nextValue = min(max(minumValue, v), maxiumValue)
        value = nextValue
        
        updateLineOffsetByValue(v)
        updateScrollOffsetByValue(v)
    }
    
    private func updateValueByDragging(v: CGFloat) {
        let nextValue = min(max(minumValue, v), maxiumValue)
        value = nextValue
        
        updateLineOffsetByValue(v)
    }
    
    func setmaxiumValueandminumvalue(max: CGFloat, min: CGFloat) {
        
        maxiumValue = Int(max * 1000) > Int(min * 1000) ? max : min
        minumValue = Int(max * 1000) > Int(min * 1000) ? min : max
    }
}


extension CTAScrollTuneView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
//        let nextRuleOffset = beganTranslateX - scrollView.contentOffset.x
        let nextValue = minumValue + scrollView.contentOffset.x / scrollUnit

        
        if fabs((nextValue * 100.0 - value * 100.0)) > 0.1 {
            
            if scrollView.dragging {
                sendActionsForControlEvents(.ValueChanged)
            }
        }
        
        updateValueByDragging(nextValue)
    }
}

extension CTAScrollTuneView {
    
    func path(frame: CGRect, attributes: CTAScrollTuneAttributes) -> UIBezierPath {
        let a = attributes
        let totalCount = a.totalLineCount
        
        let originX = frame.origin.x
        let originY = frame.origin.y
        let lineHeight = Int(CGRectGetHeight(frame) / 2)
        let showShortLine = attributes.showShortLine
        let bottomSpace = (Int(CGRectGetHeight(frame)) - lineHeight) / 2
        let beganX = 0
        
        let path = UIBezierPath()
        
        for i in 0..<totalCount {
            let isShortLine = showShortLine ? (i % 5 != 0) : false
            let x = beganX + i * (attributes.lineWidth + attributes.lineSpace)
            let width = attributes.lineWidth
            let height = isShortLine ? lineHeight / 2 : lineHeight
            let y = Int(CGRectGetHeight(frame)) - bottomSpace - height
            let rect = CGRect(x: x, y: y, width: width, height: height)
            
            let minX = CGRectGetMinX(rect) + originX
            let minY = CGRectGetMinY(rect) + originY
            let maxX = CGRectGetMaxX(rect) + originX
            let maxY = CGRectGetMaxY(rect) + originY
            
            let topLeft = CGPoint(x: minX, y: minY)
            let topRight = CGPoint(x: maxX, y: minY)
            let bottomRight = CGPoint(x: maxX, y: maxY)
            let bottomLeft = CGPoint(x: minX, y: maxY)
            
            path.moveToPoint(topLeft)
            path.addLineToPoint(topRight)
            path.addLineToPoint(bottomRight)
            path.addLineToPoint(bottomLeft)
            path.addLineToPoint(topLeft)
            path.closePath()
        }
        
        return path
    }
}
