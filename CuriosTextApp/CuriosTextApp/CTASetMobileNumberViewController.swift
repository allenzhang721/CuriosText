//
//  CTARegisterViewController.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/31.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation

enum CTASetMobileNumberType{
    case register, resetPassword, setMobileNumber, changeMobileNumber
}

class CTASetMobileNumberViewController: UIViewController, CTAPhoneProtocol, CTAAlertProtocol, CTALoadingProtocol{
    
    static var _instance:CTASetMobileNumberViewController?;
    
    static func getInstance() -> CTASetMobileNumberViewController{
        if _instance == nil{
            _instance = CTASetMobileNumberViewController();
        }
        return _instance!
    }
    
    var phoneTextinput:UITextField = UITextField()
    var countryNameLabel:UILabel = UILabel()
    var areaCodeLabel:UILabel = UILabel()
    var loadingImageView:UIImageView? = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
    var registerButton:UIButton!
    var backButton:UIButton!
    
    var selectedModel:CountryZone?
    var isChangeContry:Bool = false
    var setMobileNumberType:CTASetMobileNumberType = .register
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initView()
        self.navigationController!.interactivePopGestureRecognizer?.delegate = self
        self.view.backgroundColor = CTAStyleKit.lightGrayBackgroundColor
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func initView(){
        let bouns = UIScreen.mainScreen().bounds
        let tap = UITapGestureRecognizer(target: self, action: #selector(CTASetMobileNumberViewController.bgViewClick(_:)))
        self.view.addGestureRecognizer(tap)
        
        self.backButton = UIButton.init(frame: CGRect.init(x: 0, y: 2, width: 40, height: 40))
        self.backButton.setImage(UIImage(named: "back-button"), forState: .Normal)
        self.backButton.setImage(UIImage(named: "back-selected-button"), forState: .Highlighted)
        self.backButton.addTarget(self, action: #selector(CTASetMobileNumberViewController.backButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(self.backButton)

        let enterMobileLabel = UILabel.init(frame: CGRect.init(x: (bouns.width - 50)/2, y: 60*self.getVerRate(), width: 100, height: 40))
        enterMobileLabel.font = UIFont.systemFontOfSize(28)
        enterMobileLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        enterMobileLabel.text = NSLocalizedString("EnterMobileLabel", comment: "")
        enterMobileLabel.sizeToFit()
        enterMobileLabel.frame.origin.x = (bouns.width - enterMobileLabel.frame.width)/2
        self.view.addSubview(enterMobileLabel)
        
        self.initPhoneView()
        self.phoneTextinput.delegate = self
        
        self.registerButton = UIButton.init(frame: CGRect.init(x: (bouns.width - 40)/2, y: self.phoneTextinput.frame.origin.y+70, width: 40, height: 28))
        self.registerButton.setTitle(NSLocalizedString("NextButtonLabel", comment: ""), forState: .Normal)
        self.registerButton.setTitleColor(UIColor.init(red: 239/255, green: 51/255, blue: 74/255, alpha: 1.0), forState: .Normal)
        self.registerButton.setTitleColor(UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0), forState: .Disabled)
        self.registerButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        self.registerButton.addTarget(self, action: #selector(CTASetMobileNumberViewController.registerButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(self.registerButton)
    }
    
    func viewWillLoad(){
        if isChangeContry{
            self.phoneTextinput.text = ""
            self.selectedModel = self.getCurrentContryModel()
            self.changeCountryLabelByModel(self.selectedModel)
        }
        if self.phoneTextinput.text == "" {
            self.registerButton.enabled = false
        }
        if self.setMobileNumberType == .setMobileNumber || self.setMobileNumberType == .changeMobileNumber{
            self.registerButton.setTitle(NSLocalizedString("NextButtonLabel", comment: ""), forState: .Normal)
            self.backButton.setImage(UIImage(named: "close-button"), forState: .Normal)
            self.backButton.setImage(UIImage(named: "close-selected-button"), forState: .Highlighted)
        }else {
            self.backButton.setImage(UIImage(named: "back-button"), forState: .Normal)
            self.backButton.setImage(UIImage(named: "back-selected-button"), forState: .Highlighted)
            if self.setMobileNumberType == .register{
                self.registerButton.setTitle(NSLocalizedString("RegisterLabel", comment: ""), forState: .Normal)
                
            }else if self.setMobileNumberType == .resetPassword{
                self.registerButton.setTitle(NSLocalizedString("NextButtonLabel", comment: ""), forState: .Normal)
            }
        }
        
        self.registerButton.sizeToFit()
        self.registerButton.frame.origin.x = (UIScreen.mainScreen().bounds.width - self.registerButton.frame.width)/2
        self.isChangeContry = false
    }
    
    func backButtonClick(sender: UIButton){
        self.backHandler()
    }
    
    func backHandler(){
        self.resignView()
        if self.setMobileNumberType == .setMobileNumber || self.setMobileNumberType == .changeMobileNumber{
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
            })
        }else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func registerButtonClick(sender: UIButton){
        let phoneLabel = self.phoneTextinput.text!
        if self.selectedModel != nil && phoneLabel != ""{
            var message = NSLocalizedString("AlertMessageNumberConfirm", comment: "")
            let phoneNumber = phoneLabel.stringByReplacingOccurrencesOfString("\\s", withString: "", options: .RegularExpressionSearch, range: nil)
            let zone = self.selectedModel!.zoneCode
            message = message + "\n" + "+"+zone+" "+phoneLabel
            self.resignView()
            self.showSelectedAlert(NSLocalizedString("AlertTitleNumberConfirm", comment: ""), alertMessage: message, okAlertLabel: LocalStrings.OK.description, cancelAlertLabel: LocalStrings.Cancel.description, compelecationBlock: { (result) -> Void in
                if result {
                    if self.setMobileNumberType == .setMobileNumber || self.setMobileNumberType == .changeMobileNumber{
                        if CTAUserManager.isLogin{
                            let user = CTAUserManager.user
                            let userPhone = user!.phone
                            let userArea  = user!.areaCode
                            if userPhone == phoneNumber && userArea == zone{
                                self.showSingleAlert(NSLocalizedString("AlertTitleLinkPhoneReady", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                })
                                return
                            }
                        }else {
                            return
                        }
                    }
                    self.showLoadingViewByView(sender)
                    CTASocialManager.getVerificationCode(phoneNumber, zone: zone, completionHandler: { (result) -> Void in
                        self.hideLoadingViewByView(sender)
                        if result {
                            let verify = CTASMSVerifyViewController.getInstance()
                            verify.phone = phoneNumber
                            verify.areaZone = zone
                            if self.setMobileNumberType == .register{
                                verify.smsType = .register
                            }else if self.setMobileNumberType == .resetPassword{
                                verify.smsType = .resetPassword
                            }else if self.setMobileNumberType == .setMobileNumber{
                                verify.smsType = .setMobileNumber
                            }else if self.setMobileNumberType == .changeMobileNumber{
                                verify.smsType = .changeMobileNumber
                            }
                            self.navigationController?.pushViewController(verify, animated: true)
                        }else {
                            self.showSingleAlert(NSLocalizedString("AlertTitleNumberVerifyError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                            })
                        }
                    
                    })
                }
            })
        }else {
            self.registerButton.enabled = false
        }
    }
    
    func bgViewClick(sender: UIPanGestureRecognizer){
        self.resignHandler(sender)
    }
    
    func countryNameClick(sender: UIPanGestureRecognizer){
        self.resignView()
        let searchCountry = CTASearchCountryViewController.getInstance()
        searchCountry.selectedDelegate = self
        self.navigationController?.pushViewController(searchCountry, animated: true)
    }
}

extension CTASetMobileNumberViewController: CTACountryDelegate{
    func setCountryCode(model:CountryZone){
        self.selectedModel = model
        self.changeCountryLabelByModel(selectedModel)
    }
}

extension CTASetMobileNumberViewController: UITextFieldDelegate{
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        let newText = self.phoneTextinput.text
        let newStr = NSString(string: newText!)
        let isDelete = string == "" ? true : false
        if self.selectedModel != nil && self.selectedModel?.zoneCode == "86" {
            self.phoneTextinput.text = self.changeChinaPhone(newStr, isDelete: isDelete)
        }
        if isDelete {
            if newStr.length <= 1{
                self.registerButton.enabled = false
            }
        }else{
            self.registerButton.enabled = true
        }
        if newStr.length < 20 || isDelete{
            return true
        }else {
            return false
        }
    }
}

extension CTASetMobileNumberViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.phoneTextinput.isFirstResponder() {
            return false
        }
        return true
    }
    
}