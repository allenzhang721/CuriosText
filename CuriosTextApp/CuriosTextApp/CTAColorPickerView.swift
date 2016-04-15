//
//  CTAColorPickerView.swift
//  testSlider
//
//  Created by allen on 16/4/8.
//  Copyright © 2016年 com.horner.storyboard.demo. All rights reserved.
//

import UIKit

protocol CTAColorPickerProtocol{
    func changeColor(color:UIColor)
}


class CTAColorPickerView: UIView {
    
    let colors = [
        UIColor(red: 1, green: 0, blue: 0, alpha: 1),
        UIColor(red: 1, green: 1, blue: 0, alpha: 1),
        UIColor(red: 0, green: 1, blue: 0, alpha: 1),
        UIColor(red: 0, green: 1, blue: 1, alpha: 1),
        UIColor(red: 0, green: 0, blue: 1, alpha: 1),
        UIColor(red: 1, green: 0, blue: 1, alpha: 1),
        UIColor(red: 1, green: 0, blue: 0, alpha: 1),
        ]
    
    var colorSlider:CTAColorSliderView!
    var colorCellsView: UIView!
    var currentColorView: CTAColorShadowCell!
    var pureColorArray:Array<CTAPixelColor> = []
    
    var gradientArray:Array<Array<CTAPixelColor>> = []
    var colorViewsArray:Array<CTAColorPickerCell> = []
    
    let lineHeight:CGFloat = 5.0
    let cellHorCount:Int = 17
    var cellVerCount:Int = 0
    var cellViewWidth:CGFloat = 0.0
    var cellViewHeight:CGFloat = 0.0
    let colorHorCount:Int = 33
    let colorVerCount:Int = 16
    
    let horSpace = 5
    let verSpace = 4
    
    let sliderWidth:CGFloat = 21.00
    
    var centerRect:CGRect = CGRect(x: 0, y: 0, width: 100, height: 100)
    var choseCell:CTAColorPickerCell?
    var centerLength:CGFloat = 0.0
    
    var isChageSlide:Bool = false
    
    var beganLocation:CGPoint = CGPoint(x: 0, y: 0)
    
    var delegate:CTAColorPickerProtocol?
    
    var selectedColor:UIColor?{
        didSet{
            self.setSelectedColor()
        }
    }
    var canReChange:Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        
        let lineSize = CGSize(width: self.bounds.width, height: self.lineHeight)
        self.pureColorArray = lineGradientColorArray(Int(lineSize.width), colors: colors)
        let lineImg = lineGradientImage(lineSize, pixelColors: pureColorArray)
        let lineView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.lineHeight))
        lineView.image = lineImg
        self.addSubview(lineView)
        
        self.colorCellsView = UIView(frame: CGRect(x: 0, y: self.lineHeight, width: self.bounds.width, height: self.bounds.height-self.lineHeight))
        self.addSubview(self.colorCellsView)
        self.colorCellsView.clipsToBounds = true

        self.cellViewWidth  = self.bounds.width / CGFloat(self.cellHorCount)
        self.cellViewHeight = self.cellViewWidth
        let scale:CGFloat = 1.1
        self.centerRect = CGRect(x: (self.colorCellsView.frame.width - self.cellViewWidth*scale)/2, y: (self.colorCellsView.frame.height - self.cellViewHeight*scale)/2, width: self.cellViewWidth*scale-1, height: self.cellViewHeight*scale-1)
        let centerPoint = CGPoint(x: self.centerRect.origin.x + self.centerRect.size.width, y: self.centerRect.origin.y + self.centerRect.size.height)
        self.centerLength = self.cellViewWidth * 2
        
        self.currentColorView = CTAColorShadowCell(frame: CGRect(x: (self.colorCellsView.frame.width - self.cellViewWidth*1.5)/2, y: self.lineHeight + (self.colorCellsView.frame.height - self.cellViewHeight*1.5)/2, width: self.cellViewWidth*1.5, height: self.cellViewHeight*1.5))
        self.addSubview(self.currentColorView)
        self.currentColorView.layer.shadowPath = UIBezierPath(roundedRect: self.currentColorView.bounds, cornerRadius: 0).CGPath
        self.currentColorView.layer.shadowColor = UIColor.blackColor().CGColor
        self.currentColorView.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.currentColorView.layer.shadowOpacity = 1
        self.currentColorView.layer.shadowRadius = 13
        
        self.cellVerCount = lroundf(Float(self.colorCellsView.frame.height / self.cellViewHeight))
        let hChange = self.colorCellsView.frame.height - CGFloat(self.cellVerCount)*self.cellViewHeight
        for i in 0..<(self.cellVerCount+verSpace){
            for j in 0..<(self.cellHorCount+horSpace){
                let view = CTAColorPickerCell.init(frame: CGRect(x: 0, y: 0, width: self.cellViewWidth, height: self.cellViewHeight))
                self.colorCellsView.addSubview(view)
                self.colorViewsArray.append(view)
                view.positionX = j
                view.positionY = i
                view.center = CGPoint(x: CGFloat((view.positionX*2-horSpace+1)/2)*self.cellViewWidth, y: CGFloat((view.positionY*2-verSpace+1)/2)*self.cellViewHeight - hChange/2)
                let viewCenter = view.center
                if self.centerRect.contains(viewCenter) {
                    let a = (centerPoint.x - viewCenter.x)*(centerPoint.x - viewCenter.x) + (centerPoint.y - viewCenter.y)*(centerPoint.y - viewCenter.y)
                    let length = sqrt(a)
                    if length < self.centerLength {
                        self.choseCell = view
                        self.centerLength = length
                    }
                }
            }
        }
        
        self.colorSlider =  CTAColorSliderView(frame: CGRect(x: 0, y: (self.lineHeight - self.sliderWidth)/2, width: self.sliderWidth, height: self.sliderWidth))
        self.addSubview(self.colorSlider)
        self.colorSlider.minimumValue = 0.0
        self.colorSlider.maximumValue = self.bounds.width
        self.colorSlider.value = 0.0
        self.colorSlider.valueColor = self.currentPureColor()
        self.colorSlider.addTarget(self, action: #selector(CTAColorPickerView.slideMouseDown(_:)), forControlEvents: .TouchDown)
        self.colorSlider.addTarget(self, action: #selector(CTAColorPickerView.slideMouseUp(_:)), forControlEvents: .TouchUpInside)
    
        self.setCellsColorPosition()
        self.gradientArray = self.getGrandientColor(self.currentPureColor())
        self.setCellsColor()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(CTAColorPickerView.viewPanHandler(_:)))
        self.addGestureRecognizer(pan)
    }
    
    func getGrandientColor(currentColor:UIColor) -> Array<Array<CTAPixelColor>>{
        var colorArray:Array<Array<CTAPixelColor>> = []
        let curToGayArray = lineGradientColorArray(self.colorVerCount, colors: [currentColor, UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1),])
        let curToGayCount = curToGayArray.count
        for i in 0..<curToGayCount {
            let cur = curToGayArray[i]
            let whiteToBlack = lineGradientColorArray(self.colorHorCount, colors: [UIColor(red: 1, green: 1, blue: 1, alpha: 1),UIColor(red: cur.red, green: cur.green, blue: cur.blue, alpha: cur.alpha),UIColor(red: 0, green: 0, blue: 0, alpha: 1),])
            colorArray.append(whiteToBlack)
        }
        return colorArray
    }
    
    func setCellsColor(){
        for i in 0..<self.colorViewsArray.count {
            let view = self.colorViewsArray[i]
            var selectdColor:CTAPixelColor? = nil
            var colorY = view.colorY
            if colorY > self.gradientArray.count-1 {
                colorY = self.gradientArray.count*2 - 1 - colorY
            }
            let colorArray = self.gradientArray[colorY]
            var colorX = view.colorX
            if colorX > colorArray.count-1 {
                colorX = colorArray.count*2 - 1 - colorX
            }
            selectdColor = colorArray[colorX]
            view.color = selectdColor
        }
        if self.choseCell != nil {
            let choseColor = self.choseCell!.color
            self.currentColorView.color = choseColor
            var changeColor:UIColor
            if choseColor != nil{
                changeColor = UIColor(red: choseColor!.red, green: choseColor!.green, blue: choseColor!.blue, alpha: choseColor!.alpha)
            }else {
                changeColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            }
            if self.delegate != nil {
                self.delegate!.changeColor(changeColor)
            }
            self.canReChange = false
            self.selectedColor = changeColor
            self.canReChange = true
        }
    }
    
    func changToDefault(){
        let center = self.colorSlider.center
        self.colorSlider.center = CGPoint(x: self.sliderWidth/2, y: center.y)
        self.colorSlider.value = 0
        self.colorSlider.valueColor = self.currentPureColor()
        if self.choseCell != nil {
            self.choseCell?.colorX = 0
            self.choseCell?.colorY = 0
            self.setCellsColorPosition()
        }
        self.gradientArray = self.getGrandientColor(self.currentPureColor())
        self.setCellsColor()
    }
    
    func setCellsColorPosition(){
        if self.choseCell != nil {
            for i in 0..<self.colorViewsArray.count {
                let view = self.colorViewsArray[i]
                let viewCenter = view.center
                let choseCenter = self.choseCell!.center
                var xChange = self.choseCell!.colorX - lroundf(Float((choseCenter.x - viewCenter.x) / self.cellViewWidth))
                var yChange = self.choseCell!.colorY - lroundf(Float((choseCenter.y - viewCenter.y) / self.cellViewHeight))
                if xChange < 0 {
                    xChange = self.colorHorCount*2 + xChange
                }
                if xChange > (self.colorHorCount*2 - 1){
                    xChange = xChange - self.colorHorCount*2
                }
                if yChange < 0 {
                    yChange = self.colorVerCount*2 + yChange
                }
                if yChange > (self.colorVerCount*2 - 1){
                    yChange = yChange - self.colorVerCount*2
                }
                view.colorX = xChange
                view.colorY = yChange
            }
        }
    }

    func viewPanHandler(sender: UIPanGestureRecognizer) {
        switch sender.state{
        case .Began:
            self.beganLocation = sender.locationInView(self)
            if !self.isChageSlide{
                let slideFrame = self.colorSlider.frame
                let slideContainer = CGRect(x: (slideFrame.origin.x - 5), y: (slideFrame.origin.y - 5), width: (slideFrame.size.width + 10), height: (slideFrame.size.height + 10))
                if slideContainer.contains(self.beganLocation){
                    self.changeSlideStatus(true)
                }else {
                    self.changeSlideStatus(false)
                }
            }
        case .Changed:
            let newLocation = sender.locationInView(self)
            if self.isChageSlide{
                self.changeSlidePosition(newLocation)
            }else {
                self.changeColorCellPosition(newLocation)
            }
        case .Ended, .Cancelled, .Failed:
            if self.isChageSlide{
                self.changeSlideStatus(false)
            }
        default:
            ()
        }
    }
    
    func slideMouseDown(sender: UIButton){
        self.changeSlideStatus(true)
    }
    
    func slideMouseUp(sender: UIButton){
        self.changeSlideStatus(false)
    }
    
    func changeSlideStatus(flag:Bool){
        if flag{
            self.isChageSlide = true
            self.colorSlider.transform = CGAffineTransformMakeScale(1.2, 1.2)
        }else {
            self.isChageSlide = false
            self.colorSlider.transform = CGAffineTransformMakeScale(1.0, 1.0)
        }
    }
    
    func changeSlidePosition(newLocation:CGPoint){
        let maxSlider = self.bounds.width - self.sliderWidth/2
        let minSlider = self.sliderWidth/2
        let xChange = newLocation.x - self.beganLocation.x
        let center = self.colorSlider.center
        let changePosition = center.x + xChange
        if changePosition <= maxSlider && changePosition >= minSlider {
            self.colorSlider.center = CGPoint(x: center.x + xChange, y: center.y)
            let maxValue = self.colorSlider.maximumValue
            let minValue = self.colorSlider.minimumValue
            let value = (changePosition-minSlider)/(maxSlider-minSlider)*(maxValue - minValue)+minValue
            self.colorSlider.value = value
            self.colorSlider.valueColor = self.currentPureColor()
            self.gradientArray = self.getGrandientColor(self.currentPureColor())
            self.setCellsColor()
        }
        self.beganLocation = newLocation
    }
    
    func currentPureColor() -> UIColor{
        let colorCount = self.pureColorArray.count
        let value = self.colorSlider.value
        let maxValue = self.colorSlider.maximumValue
        let minValue = self.colorSlider.minimumValue
        let progress = (Double(value) / Double(maxValue - minValue))
        let t = progress * Double(colorCount - 1)
        let i = Int(t)
        let pureColor = self.pureColorArray[i]
        return UIColor(red: pureColor.red, green: pureColor.green, blue: pureColor.blue, alpha: pureColor.alpha)
    }
    
    func changeColorCellPosition(newLocation:CGPoint){
        let xChange = newLocation.x - self.beganLocation.x
        let yChange = newLocation.y - self.beganLocation.y
        for i in 0..<self.colorViewsArray.count {
            let view = self.colorViewsArray[i]
            let center = view.center
            view.center = CGPoint(x: center.x + xChange, y: center.y + yChange)
        }
        if self.choseCell != nil {
            let viewCenter = self.choseCell!.center
            if !self.centerRect.contains(viewCenter){
                self.changeCenterView()
            }
        }
        self.beganLocation = newLocation
    }
    
    func changeCenterView(){
        let centerPoint = CGPoint(x: self.centerRect.origin.x + self.centerRect.size.width, y: self.centerRect.origin.y + self.centerRect.size.height)
        self.centerLength = self.cellViewWidth * 2
        var centerView:CTAColorPickerCell?
        for i in 0..<self.colorViewsArray.count {
            let view = self.colorViewsArray[i]
            let viewCenter = view.center
            if self.centerRect.contains(viewCenter) {
                let a = (centerPoint.x - viewCenter.x)*(centerPoint.x - viewCenter.x) + (centerPoint.y - viewCenter.y)*(centerPoint.y - viewCenter.y)
                let length = sqrt(a)
                if length < self.centerLength {
                    centerView = view
                    self.centerLength = length
                }
            }
        }
        if centerView != nil {
            if self.choseCell != nil {
                self.changeCellsPosition(centerView!)
            }
            self.choseCell = centerView!
            self.setCellsColorPosition()
            self.setCellsColor()
        }
    }
    
    func changeCellsPosition(newCenter:CTAColorPickerCell){
        if self.choseCell != nil {
            let xRate = self.choseCell!.positionX - newCenter.positionX
            let yRate = self.choseCell!.positionY - newCenter.positionY
            let hChange = self.colorCellsView.frame.height - CGFloat(self.cellVerCount)*self.cellViewHeight
            let oldCenter = CGPoint(x: CGFloat((self.choseCell!.positionX*2-horSpace+1)/2)*self.cellViewWidth, y: CGFloat((self.choseCell!.positionY*2-verSpace+1)/2)*self.cellViewHeight - hChange/2)
            let newPoint = newCenter.center
            
            for i in 0..<self.colorViewsArray.count {
                let view = self.colorViewsArray[i]
                view.positionX = view.positionX + xRate
                view.positionY = view.positionY + yRate
                if view.positionX < 0 {
                    view.positionX = (self.cellHorCount+horSpace)+view.positionX
                }
                if view.positionX > (self.cellHorCount+horSpace)-1 {
                    view.positionX = view.positionX - (self.cellHorCount+horSpace)
                }
                if view.positionY < 0 {
                    view.positionY = (self.cellVerCount+verSpace)+view.positionY
                }
                if view.positionY > (self.cellVerCount+verSpace)-1 {
                    view.positionY = view.positionY - (self.cellVerCount+verSpace)
                }
                let changeCenter = CGPoint(x: CGFloat((view.positionX*2-horSpace+1)/2)*self.cellViewWidth, y: CGFloat((view.positionY*2-verSpace+1)/2)*self.cellViewHeight - hChange/2)
                view.center = CGPoint(x: newPoint.x-oldCenter.x+changeCenter.x, y: newPoint.y-oldCenter.y+changeCenter.y)
            }
        }
    }
    
    func setSelectedColor(){
        if self.selectedColor != nil && self.canReChange{
            let selectedPixelColor = changeUIColorToPixelColor(self.selectedColor!)
            let selectedInt32 = selectedPixelColor.toInt()
            let maxValue = self.colorSlider.maximumValue
            let minValue = self.colorSlider.minimumValue
            var sliderValue:Int = 0
            var choseX:Int = 0
            var choseY:Int = 0
            var colorDValue:UInt = selectedInt32
            let count = self.pureColorArray.count
            var isBreak:Bool = false
            for i in 0..<count{
                let pureColor = self.pureColorArray[i]
                let pureUIColor = UIColor(red: pureColor.red, green: pureColor.green, blue: pureColor.blue, alpha: pureColor.alpha)
                let grandientArray = self.getGrandientColor(pureUIColor)
                for j in 0..<grandientArray.count{
                    let lineColorArray = grandientArray[j]
                    for n in 0..<lineColorArray.count{
                        let cellColor = lineColorArray[n]
                        let dValue = cellColor.toInt()
                        let newDValue = dValue > selectedInt32 ? (dValue-selectedInt32) : (selectedInt32-dValue)
                        if newDValue < colorDValue{
                            colorDValue = newDValue
                            choseX = n
                            choseY = j
                            sliderValue = i
                        }
                        if newDValue == 0{
                            isBreak = true
                            break
                        }
                    }
                    if isBreak{
                        break
                    }
                }
                if isBreak{
                    break
                }
            }
            let slideRate:CGFloat = CGFloat(sliderValue)/CGFloat(count)
            let changeValue = slideRate*(maxValue-minValue) + minValue
            self.colorSlider.value = changeValue
            self.colorSlider.valueColor = self.currentPureColor()
            let maxSlider = self.bounds.width - self.sliderWidth/2
            let minSlider = self.sliderWidth/2
            let positionX=(changeValue-minValue)/(maxValue-minValue)*(maxSlider-minSlider)+minSlider
            let center = self.colorSlider.center
            self.colorSlider.center = CGPoint(x: positionX, y: center.y)
            
            if self.choseCell != nil {
                self.choseCell?.colorX = choseX
                self.choseCell?.colorY = choseY
                self.setCellsColorPosition()
            }
            self.gradientArray = self.getGrandientColor(self.currentPureColor())
            self.setCellsColor()
        }
    }
}

class CTAColorSliderView:UIButton{
    var value:CGFloat = 0.0
    var maximumValue:CGFloat = 10.0
    var minimumValue:CGFloat = 0.0
    
    var valueColor:UIColor?{
        didSet{
           self.changeColor()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initView(){
        self.contentMode = .ScaleAspectFill
        self.layer.cornerRadius = self.frame.width/2
        self.layer.masksToBounds = true
    }
    
    func changeColor(){
        if self.valueColor == nil {
            self.backgroundColor = UIColor.whiteColor()
        }else {
            self.backgroundColor = self.valueColor
        }
    }
}

class CTAColorPickerCell: UIView {
    var color:CTAPixelColor?{
        didSet{
            if color != nil {
                self.backgroundColor = UIColor(red: color!.red, green: color!.green, blue: color!.blue, alpha: color!.alpha)
            }else {
                self.backgroundColor = UIColor.blackColor()
            }
        }
    }
    
    var colorX:Int = 0
    var colorY:Int = 0
    
    var positionX:Int = 0
    var positionY:Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class CTAColorShadowCell: UIView {
    var color:CTAPixelColor?{
        didSet{
            if color != nil {
                self.colorView.backgroundColor = UIColor(red: color!.red, green: color!.green, blue: color!.blue, alpha: color!.alpha)
            }else {
                self.colorView.backgroundColor = UIColor.blackColor()
            }
        }
    }
    
    var colorView:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.colorView = UIView(frame: CGRect(x: 2, y: 2, width: frame.size.width-4, height: frame.size.height-4))
        self.addSubview(self.colorView)
        self.backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

private extension CGFloat {
    func toColorUInt8() -> UInt8 {
        return UInt8(255.0 * self)
    }
}

public struct CTAPixelColor {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat
    
    func toInt32() -> UInt32 {
        return UInt32(alpha.toColorUInt8()) | UInt32(red.toColorUInt8()) << 8 | UInt32(green.toColorUInt8()) << 16 | UInt32(blue.toColorUInt8()) << 24
    }
    
    func toInt() -> UInt{
        //let aInt = UInt(alpha * 999)
        let rInt = UInt(red * 999)
        let gInt = UInt(green * 999)
        let bInt = UInt(blue * 999)
        return rInt*1000000 + gInt * 1000 + bInt
    }
    
    func averageWith(color: CTAPixelColor, w: CGFloat) -> CTAPixelColor {
        let average = {(a: CGFloat, b: CGFloat, w: CGFloat) -> CGFloat in
            return a + w * (b - a)
        }
        let color = CTAPixelColor(
            red: average(self.red, color.red, w),
            green: average(self.green, color.green, w),
            blue: average(self.blue, color.blue, w),
            alpha: average(self.alpha, color.alpha, w))
        return color
    }
}

public func changeUIColorToPixelColor(color:UIColor) -> CTAPixelColor{
    let cgColor = color.CGColor
    let n = CGColorGetNumberOfComponents(cgColor)
    let coms = CGColorGetComponents(cgColor)
    if n >= 4 {
        let r = coms[0]
        let g = coms[1]
        let b = coms[2]
        let a = coms[3]
        let color = CTAPixelColor(red: r, green: g, blue: b, alpha: a)
        return color
    } else {
        let x = coms[0]
        let a = coms[1]
        return CTAPixelColor(red: x, green: x, blue: x, alpha: a)
    }
}

public func lineGradientColorArray(gradientCount:Int, colors: [UIColor]) -> [CTAPixelColor] {
    let colorCount = colors.count
    if colorCount <= 0 {
        return []
    }else {
        let pixelColors = colors.map(changeUIColorToPixelColor)
        var gradientArray:Array<CTAPixelColor> = []
        for x in 0..<gradientCount {
            let progress = (Double(x) / Double(gradientCount))
            let t = progress * Double(colorCount - 1)
            let i = Int(t)
            let nexti = (i + 1) >= colorCount ? colorCount - 1 : i + 1
            let deltW = CGFloat(t - floor(t))
            let c = pixelColors[i]
            let nc = pixelColors[nexti]
            let middleColor = c.averageWith(nc, w: deltW)
            gradientArray.append(middleColor)
            
        }
        return gradientArray
    }
}

public func lineGradientImage(size: CGSize, pixelColors: [CTAPixelColor]) -> UIImage {
    let colorCount = pixelColors.count
    if colorCount <= 0 {
        return UIImage()
    } else {
        let w = Int(size.width)
        let h = Int(size.height)
        let bitPerComponent = 8
        let componentCountPerPixel = 4
        let bitPerByte = 8
        let bytePerPixel = componentCountPerPixel * bitPerComponent / bitPerByte
        let bytePerRow = bytePerPixel * w
        let data = NSMutableData()
        for _ in 0..<h {
            for x in 0..<w {
                let progress = (Double(x) / Double(w))
                let t = progress * Double(colorCount - 1)
                let i = Int(t)
                let middleColor = pixelColors[i]
                var colorUint = middleColor.toInt32()
                data.appendBytes(&colorUint, length: bytePerPixel)
            }
        }
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let bitmapInfo =  CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        
        let ctx = CGBitmapContextCreate(data.mutableBytes, w, h, bitPerComponent,
                                        bytePerRow, colorSpace, bitmapInfo.rawValue)
        let img = CGBitmapContextCreateImage(ctx)!
        return UIImage(CGImage: img)
    }
}
