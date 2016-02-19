//
//  CTAPhoneProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/31.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation

protocol CTAPhoneProtocol: CTAPublishCellProtocol, CTASystemLanguageProtocol, CTATextInputProtocol{
    var phoneTextinput:UITextField{get}
    var countryNameLabel:UILabel{get}
    var areaCodeLabel:UILabel{get}
    func initPhoneView()
    func getCurrentContryModel() -> CountryZone?
    func getChinaModel() -> CountryZone?
    func getHongkongModel() -> CountryZone?
    func getUsaModel() -> CountryZone?
    func changeCountryLabelByModel(selectedModel:CountryZone?)
    func countryNameClick(sender: UIPanGestureRecognizer)
    func changeChinaPhone(phone:NSString, isDelete:Bool) -> String
}

extension CTAPhoneProtocol where Self: UIViewController{
    func initPhoneView(){
        let bouns = UIScreen.mainScreen().bounds

        self.countryNameLabel.frame = CGRect.init(x: 128*self.getHorRate(), y: 162*self.getVerRate(), width: 230*self.getHorRate(), height: 25)
        self.countryNameLabel.font = UIFont.systemFontOfSize(18)
        self.countryNameLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        self.countryNameLabel.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: "countryNameClick:")
        self.countryNameLabel.addGestureRecognizer(tap)
        self.view.addSubview(self.countryNameLabel)
        let countryLabel = UILabel.init(frame: CGRect.init(x: 27*self.getHorRate(), y: self.countryNameLabel.frame.origin.y, width: 82, height: 25))
        countryLabel.font = UIFont.systemFontOfSize(18)
        countryLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        countryLabel.text = NSLocalizedString("CountryLabel", comment: "")
        self.view.addSubview(countryLabel)
        let nextImage = UIImageView.init(frame: CGRect.init(x: bouns.width - 25*self.getHorRate() - 11, y: self.countryNameLabel.frame.origin.y+2, width: 11, height: 20))
        nextImage.image = UIImage(named: "next-icon")
        self.view.addSubview(nextImage)
        var textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: self.countryNameLabel.frame.origin.y+37, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "textinput-line")
        self.view.addSubview(textLine)
        
        
        self.phoneTextinput.frame = CGRect.init(x: 128*self.getHorRate(), y: self.countryNameLabel.frame.origin.y+38, width: 230*self.getHorRate(), height: 50)
        self.phoneTextinput.placeholder = NSLocalizedString("PhonePlaceholder", comment: "")
        self.view.addSubview(self.phoneTextinput)
        self.phoneTextinput.keyboardType = .NumberPad
        self.phoneTextinput.clearButtonMode = .WhileEditing
        textLine = UIImageView.init(frame: CGRect.init(x: 125*self.getHorRate(), y: self.phoneTextinput.frame.origin.y+49, width: 230*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "textinput-line")
        self.view.addSubview(textLine)
        
        self.areaCodeLabel.frame = CGRect.init(x: 27*self.getHorRate(), y: self.phoneTextinput.frame.origin.y+12, width: 50, height: 25)
        self.areaCodeLabel.font = UIFont.systemFontOfSize(18)
        self.areaCodeLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        self.view.addSubview(self.areaCodeLabel)
        textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: self.phoneTextinput.frame.origin.y+49, width: 90*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "textinput-line")
        self.view.addSubview(textLine)
        
        
    }
    
    func getCurrentContryModel() -> CountryZone?{
        let language = self.getCurrentLanguage()
        var model:CountryZone?
        if language.containsString("zh-Hans") || language.containsString("zh-Hans"){
            model = self.getChinaModel()
        }else if language == "zh-HK"{
            model = self.getHongkongModel()
        }else {
            model = self.getUsaModel()
        }
        return model;
    }
    
    func getChinaModel() -> CountryZone?{
        let allCountryLocale = LocaleHelper.allCountriesFromLocalFile()
        let array = allCountryLocale["Z"]!
        for var i=0 ; i < array.count; i++ {
            if array[i].zoneCode == "86" {
                return array[i]
            }
        }
        return nil
    }
    
    func getHongkongModel() -> CountryZone?{
        let allCountryLocale = LocaleHelper.allCountriesFromLocalFile()
        let array = allCountryLocale["X"]!
        for var i=0 ; i < array.count; i++ {
            if array[i].zoneCode == "852" {
                return array[i]
            }
        }
        return nil
    }
    
    func getUsaModel() -> CountryZone?{
        let allCountryLocale = LocaleHelper.allCountriesFromLocalFile()
        let array = allCountryLocale["U"]!
        for var i=0 ; i < array.count; i++ {
            if array[i].zoneCode == "1" {
                return array[i]
            }
        }
        return nil
    }
    
    func changeCountryLabelByModel(selectedModel:CountryZone?){
        if selectedModel != nil {
            self.countryNameLabel.text = selectedModel!.displayName
            self.areaCodeLabel.text = "+"+selectedModel!.zoneCode
        }else {
            self.countryNameLabel.text = ""
            self.areaCodeLabel.text = ""
        }
        self.areaCodeLabel.sizeToFit()
    }
    
    func changeChinaPhone(phone:NSString, isDelete:Bool) -> String{
        let count = phone.length
        var newString:String = phone as String
        if !isDelete {
            if count == 3{
                let newText = (phone as String) + " "
                newString = newText
            }else if count == 8{
                let newText = (phone as String) + " "
                newString = newText
            }else if count == 13 {
                let nilStr = phone.substringWithRange(NSMakeRange(3, 1))
                if nilStr == " " {
                    let newStr = phone.substringWithRange(NSMakeRange(0, 3))+phone.substringWithRange(NSMakeRange(4, 4))+phone.substringWithRange(NSMakeRange(9, 4))
                    newString = newStr
                }
            }
        }else {
            if count == 12 {
                let nilStr = phone.substringWithRange(NSMakeRange(8, 1))
                if nilStr != " " {
                    let newStr = phone.substringWithRange(NSMakeRange(0, 3))+" "+phone.substringWithRange(NSMakeRange(3, 4))+" "+phone.substringWithRange(NSMakeRange(7, 4))+" "
                    newString = newStr
                }
            }
            if count  == 10 {
                let nilStr = phone.substringWithRange(NSMakeRange(8, 1))
                if nilStr == " " {
                    let newStr = phone.substringWithRange(NSMakeRange(0, 8))+" "
                    newString = newStr
                }
            } else if count == 5 {
                let nilStr = phone.substringWithRange(NSMakeRange(3, 1))
                if nilStr == " " {
                    let newStr = phone.substringWithRange(NSMakeRange(0, 3))+" "
                    newString = newStr
                }
            }
        }
        return newString
    }
}

protocol CTATextInputProtocol{
    func resignView()
    func resignHandler(sender: UIGestureRecognizer)
}

extension CTATextInputProtocol where Self: UIViewController{
    func resignView(){
        let subViews = self.view.subviews
        for var i=0 ; i<subViews.count; i++ {
            if subViews[i] is UITextField {
                (subViews[i] as! UITextField).resignFirstResponder()
            }
        }
    }
    
    func resignHandler(sender: UIGestureRecognizer){
        var isHave:Bool = false
        let subViews = self.view.subviews
        for var i=0; i<subViews.count; i++ {
            let view = subViews[i]
            let pt = sender.locationInView(view)
            if view.pointInside(pt, withEvent: nil){
                isHave = true
            }
        }
        if !isHave {
            self.resignView()
        }
    }
}