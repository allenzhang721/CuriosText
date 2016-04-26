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

let sliderWidth:CGFloat = 44.00
let thumbWidth:CGFloat = 21.00

class CTAColorPickerView: UIControl{
    
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
    
    var centerRect:CGRect = CGRect(x: 0, y: 0, width: 100, height: 100)
    var choseCell:CTAColorPickerCell?
    var centerLength:CGFloat = 0.0
    
    var isChageSlide:Bool = false
    
    var beganLocation:CGPoint = CGPoint(x: 0, y: 0)
    var panLocation:CGPoint = CGPoint(x: 0, y: 0)
    
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
        
        self.colorSlider =  CTAColorSliderView(frame: CGRect(x: 0, y: (self.lineHeight - sliderWidth)/2, width: sliderWidth, height: sliderWidth))
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
            self.canReChange = false
            self.selectedColor = changeColor
            self.canReChange = true
            sendActionsForControlEvents(.ValueChanged)
            if self.delegate != nil {
                self.delegate!.changeColor(changeColor)
            }
        }
    }
    
    func changToDefault(){
        let center = self.colorSlider.center
        self.colorSlider.center = CGPoint(x: thumbWidth/2, y: center.y)
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
            if self.adisplayLink != nil{
                self.adisplayLink?.paused = true
            }
            self.beganLocation = sender.locationInView(self)
            self.panLocation = self.beganLocation
            if !self.isChageSlide{
                let slideFrame = self.colorSlider.frame
                let slideContainer = CGRect(x: slideFrame.origin.x, y: slideFrame.origin.y , width: slideFrame.size.width, height: slideFrame.size.height )
                if slideContainer.contains(self.panLocation){
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
            }else {
                self.sliderLocation = sender.locationInView(self)
                self.panLocation = self.sliderLocation
                let velocity = sender.velocityInView(self)
                let magnitude:CGFloat = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
                let slideMult = magnitude / 200;
                let slideFactor = 0.15 * slideMult;
                self.sliderXRate = (self.sliderLocation.x-self.beganLocation.x)*slideFactor
                self.sliderYRate = (self.sliderLocation.y-self.beganLocation.y)*slideFactor*4
                
                let maxW = self.frame.size.width
                let maxH = self.frame.size.height * 2
                
                if self.sliderXRate>maxW{
                    self.sliderXRate = maxW
                }
                if self.sliderXRate<(0-maxW){
                    self.sliderXRate = (0-maxW)
                }
                if self.sliderYRate>maxH{
                    self.sliderYRate = maxH
                }
                if self.sliderYRate<(0-maxH){
                    self.sliderYRate = (0-maxH)
                }
                
                self.sliderAniIndex = 0
                if self.adisplayLink == nil {
                    self.adisplayLink = CADisplayLink(target: self,selector: #selector(CTAColorPickerView.sliderAniFrame))
                    self.adisplayLink?.addToRunLoop(NSRunLoop.currentRunLoop(),forMode: NSRunLoopCommonModes)
                }
                self.adisplayLink?.paused = false
            }
        default:
            ()
        }
    }
    
    var adisplayLink:CADisplayLink?
    var sliderLocation:CGPoint = CGPoint(x: 0, y: 0)
    var sliderXRate:CGFloat = 0
    var sliderYRate:CGFloat = 0
    var sliderAniIndex:CGFloat = 0
    
    func sliderAniFrame(){
        let maxIndex:CGFloat = 60
        let xRate = sliderXRate
        let yRate = sliderYRate
        let rate = self.easeOutFuc(sliderAniIndex, d: maxIndex, b: 0, c: 1)
        if sliderAniIndex < maxIndex{
            let xNex = self.sliderLocation.x + rate*xRate
            let yNex = self.sliderLocation.y + rate*yRate
            let newPosition = CGPoint(x: xNex, y: yNex)
            self.changeColorCellPosition(newPosition)
            sliderAniIndex = sliderAniIndex + 1
        }else {
            self.adisplayLink?.paused = true
        }
    }
    
    func easeOutFuc(t:CGFloat, d:CGFloat, b:CGFloat, c:CGFloat) ->CGFloat{
        let t1=t/d-1
        return c*(t1*t1*t1+1)+b
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
        let maxSlider = self.bounds.width - thumbWidth/2
        let minSlider = thumbWidth/2
        let xChange = newLocation.x - self.panLocation.x
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
        self.panLocation = newLocation
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
        let xChange = newLocation.x - self.panLocation.x
        let yChange = newLocation.y - self.panLocation.y
        let maxW = self.frame.size.width
        let maxH = self.frame.size.height/2
        if abs(xChange) > maxW || abs(yChange) > maxH{
            return
        }
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
        self.panLocation = newLocation
    }
    
    func changeCenterView(){
        let centerPoint = CGPoint(x: self.centerRect.origin.x + self.centerRect.size.width, y: self.centerRect.origin.y + self.centerRect.size.height)
        self.centerLength = CGFloat.max
        var centerView:CTAColorPickerCell?
        for i in 0..<self.colorViewsArray.count {
            let view = self.colorViewsArray[i]
            let viewCenter = view.center
            let a = (centerPoint.x - viewCenter.x)*(centerPoint.x - viewCenter.x) + (centerPoint.y - viewCenter.y)*(centerPoint.y - viewCenter.y)
            let length = sqrt(a)
            if length < self.centerLength {
                centerView = view
                self.centerLength = length
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
            var selectedPureColor = self.getPureColorByColor(selectedPixelColor)
            let maxValue = self.colorSlider.maximumValue
            let minValue = self.colorSlider.minimumValue
            var sliderValue:Int = 0
            var choseX:Int = 0
            var choseY:Int = 0
            var colorDValue:CGFloat = CGFloat.max
            let count = self.pureColorArray.count
            for i in 0..<count{
                let pureColor = self.pureColorArray[i]
                let newDValue = self.rateInTwoColor(pureColor, twoColor: selectedPureColor)
                if newDValue < colorDValue{
                    colorDValue = newDValue
                    sliderValue = i
                }
                if newDValue == 0{
                    break
                }
            }
            selectedPureColor = self.pureColorArray[sliderValue]
            let pureUIColor = UIColor(red: selectedPureColor.red, green: selectedPureColor.green, blue: selectedPureColor.blue, alpha: selectedPureColor.alpha)
            let grandientArray = self.getGrandientColor(pureUIColor)
            colorDValue = CGFloat.max
            var isBreak = false
            for j in 0..<grandientArray.count{
                let lineColorArray = grandientArray[j]
                for n in 0..<lineColorArray.count{
                    let cellColor = lineColorArray[n]
                    let newDValue = self.rateInTwoColor(cellColor, twoColor: selectedPixelColor)
                    if newDValue < colorDValue{
                        colorDValue = newDValue
                        choseX = n
                        choseY = j
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
            
            let slideRate:CGFloat = CGFloat(sliderValue)/CGFloat(count)
            let changeValue = slideRate*(maxValue-minValue) + minValue
            self.colorSlider.value = changeValue
            self.colorSlider.valueColor = self.currentPureColor()
            let maxSlider = self.bounds.width - thumbWidth/2
            let minSlider = thumbWidth/2
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
    
    func rateInTwoColor(oneColor:CTAPixelColor, twoColor:CTAPixelColor)->CGFloat{
        let red1 = oneColor.red
        let green1 = oneColor.green
        let blue1 = oneColor.blue
        
        let red2 = twoColor.red
        let green2 = twoColor.green
        let blue2 = twoColor.blue
        
        return abs(red1 - red2)+abs(green1 - green2)+abs(blue1 - blue2)
    }
    
    func getPureColorByColor(pixelColor:CTAPixelColor)->CTAPixelColor{
        let red = pixelColor.red
        let green = pixelColor.green
        let blue = pixelColor.blue
        var result:(CGFloat, CGFloat, CGFloat) = (0,0,0)
        var resultColor:CTAPixelColor?
        if red > green && red > blue{
            if blue > green{
                result = self.getColorNumber(red, mid: blue, min: green)
                resultColor = CTAPixelColor(red: result.0, green: result.2, blue: result.1, alpha: pixelColor.alpha)
            }else {
                result = self.getColorNumber(red, mid: green, min: blue)
                resultColor = CTAPixelColor(red: result.0, green: result.1, blue: result.2, alpha: pixelColor.alpha)
            }
        }else if green > red && green > blue{
            if red > blue{
                result = self.getColorNumber(green, mid: red, min: blue)
                resultColor = CTAPixelColor(red: result.1, green: result.0, blue: result.2, alpha: pixelColor.alpha)
            }else {
                result = self.getColorNumber(green, mid: blue, min: red)
                resultColor = CTAPixelColor(red: result.2, green: result.0, blue: result.1, alpha: pixelColor.alpha)
            }
        }else if blue > red && blue > green{
            if green > red{
                result = self.getColorNumber(blue, mid: green, min: red)
                resultColor = CTAPixelColor(red: result.2, green: result.1, blue: result.0, alpha: pixelColor.alpha)
            }else {
                result = self.getColorNumber(blue, mid: red, min: green)
                resultColor = CTAPixelColor(red: result.1, green: result.2, blue: result.0, alpha: pixelColor.alpha)
            }
        }else {
            resultColor = CTAPixelColor(red: 1, green: 0, blue: 0, alpha: pixelColor.alpha)
        }
        return resultColor!
    }
    
    func getColorNumber(max:CGFloat, mid:CGFloat, min:CGFloat)->(CGFloat, CGFloat, CGFloat){
        let rate = 1 / max
        let changeMax = max*rate
        var changeMid = mid*rate
        var changeMin = min*rate
        if max != min{
            changeMid = (mid-min)/(max-min)*1
            changeMin = 0
        }
        return (changeMax, changeMid, changeMin)
    }
}

class CTAColorSliderView:UIButton{
    var value:CGFloat = 0.0
    var maximumValue:CGFloat = 10.0
    var minimumValue:CGFloat = 0.0
    
    var slideView:UIView!
    var slideViewButton:UIButton!
    
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
        self.slideView = UIView(frame: CGRect(x: (self.bounds.width - thumbWidth)/2, y: (self.bounds.height - thumbWidth)/2, width: thumbWidth, height: thumbWidth))
        self.addSubview(self.slideView)
        self.slideView.contentMode = .ScaleAspectFill
        self.slideView.layer.cornerRadius = thumbWidth/2
        self.slideView.layer.masksToBounds = true
        self.slideViewButton = UIButton(frame: self.bounds)
        self.addSubview(self.slideViewButton)
        self.slideViewButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        
        self.slideViewButton.addTarget(self, action: #selector(CTAColorSliderView.buttonMouseDown(_:)), forControlEvents: .TouchDown)
        self.slideViewButton.addTarget(self, action: #selector(CTAColorSliderView.buttonMouseUp(_:)), forControlEvents: .TouchUpInside)
    }
    
    func buttonMouseDown(sender: UIButton){
        self.sendActionsForControlEvents(.TouchDown)
    }
    
    func buttonMouseUp(sender: UIButton){
        self.sendActionsForControlEvents(.TouchUpInside)
    }
    
    func changeColor(){
        if self.valueColor == nil {
            self.slideView.backgroundColor = UIColor.whiteColor()
        }else {
            self.slideView.backgroundColor = self.valueColor
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
