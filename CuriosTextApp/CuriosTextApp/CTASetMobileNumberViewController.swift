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
    var loadingImageView:UIImageView? = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    var registerButton:UIButton!
    var backButton:UIButton!
    
    var selectedModel:CountryZone?
    var isChangeContry:Bool = false
    var setMobileNumberType:CTASetMobileNumberType = .register
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initView()
        self.navigationController!.interactivePopGestureRecognizer?.delegate = self
        self.view.backgroundColor = CTAStyleKit.commonBackgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func initView(){
        let bouns = UIScreen.main.bounds
        let tap = UITapGestureRecognizer(target: self, action: #selector(CTASetMobileNumberViewController.bgViewClick(_:)))
        self.view.addGestureRecognizer(tap)
        
        self.backButton = UIButton(frame: CGRect(x: 0, y: 22, width: 40, height: 40))
        self.backButton.setImage(UIImage(named: "back-button"), for: UIControlState())
        self.backButton.setImage(UIImage(named: "back-selected-button"), for: .highlighted)
        self.backButton.addTarget(self, action: #selector(CTASetMobileNumberViewController.backButtonClick(_:)), for: .touchUpInside)
        self.view.addSubview(self.backButton)

        let enterMobileLabel = UILabel(frame: CGRect(x: 0, y: 60*self.getVerRate(), width: bouns.width, height: 40))
        enterMobileLabel.font = UIFont.boldSystemFont(ofSize: 28)
        enterMobileLabel.textColor = CTAStyleKit.normalColor
        enterMobileLabel.text = NSLocalizedString("EnterMobileLabel", comment: "")
        enterMobileLabel.textAlignment = .center
        self.view.addSubview(enterMobileLabel)
        
        self.initPhoneView()
        self.phoneTextinput.delegate = self
        
        self.registerButton = UIButton(frame: CGRect(x: (bouns.width - 40)/2, y: self.phoneTextinput.frame.origin.y+70, width: 40, height: 28))
        self.registerButton.setTitle(NSLocalizedString("NextButtonLabel", comment: ""), for: UIControlState())
        self.registerButton.setTitleColor(CTAStyleKit.selectedColor, for: UIControlState())
        self.registerButton.setTitleColor(CTAStyleKit.disableColor, for: .disabled)
        self.registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.registerButton.addTarget(self, action: #selector(CTASetMobileNumberViewController.registerButtonClick(_:)), for: .touchUpInside)
        self.view.addSubview(self.registerButton)
    }
    
    func viewWillLoad(){
        if isChangeContry{
            self.phoneTextinput.text = ""
            self.selectedModel = self.getCurrentContryModel()
            self.changeCountryLabelByModel(self.selectedModel)
        }
        if self.phoneTextinput.text == "" {
            self.registerButton.isEnabled = false
        }
        if self.setMobileNumberType == .setMobileNumber || self.setMobileNumberType == .changeMobileNumber{
            self.registerButton.setTitle(NSLocalizedString("NextButtonLabel", comment: ""), for: UIControlState())
            self.backButton.setImage(UIImage(named: "close-button"), for: UIControlState())
            self.backButton.setImage(UIImage(named: "close-selected-button"), for: .highlighted)
        }else {
            self.backButton.setImage(UIImage(named: "back-button"), for: UIControlState())
            self.backButton.setImage(UIImage(named: "back-selected-button"), for: .highlighted)
            if self.setMobileNumberType == .register{
                self.registerButton.setTitle(NSLocalizedString("RegisterLabel", comment: ""), for: UIControlState())
                
            }else if self.setMobileNumberType == .resetPassword{
                self.registerButton.setTitle(NSLocalizedString("NextButtonLabel", comment: ""), for: UIControlState())
            }
        }
        
        self.registerButton.sizeToFit()
        self.registerButton.frame.origin.x = (UIScreen.main.bounds.width - self.registerButton.frame.width)/2
        self.isChangeContry = false
    }
    
    func backButtonClick(_ sender: UIButton){
        self.backHandler()
    }
    
    func backHandler(){
        self.resignView()
        if self.setMobileNumberType == .setMobileNumber || self.setMobileNumberType == .changeMobileNumber{
            self.dismiss(animated: true, completion: { () -> Void in
            })
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func registerButtonClick(_ sender: UIButton){
        let phoneLabel = self.phoneTextinput.text!
        if self.selectedModel != nil && phoneLabel != ""{
            var message = NSLocalizedString("AlertMessageNumberConfirm", comment: "")
            let phoneNumber = phoneLabel.replacingOccurrences(of: "\\s", with: "", options: .regularExpression, range: nil)
            let zone = self.selectedModel!.zoneCode
            message = message + "\n" + "+"+zone+" "+phoneLabel
            self.resignView()
            self.showSelectedAlert(NSLocalizedString("AlertTitleNumberConfirm", comment: ""), alertMessage: message, okAlertLabel: LocalStrings.ok.description, cancelAlertLabel: LocalStrings.cancel.description, compelecationBlock: { (result) -> Void in
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
            self.registerButton.isEnabled = false
        }
    }
    
    func bgViewClick(_ sender: UIPanGestureRecognizer){
        self.resignHandler(sender)
    }
    
    func countryNameClick(_ sender: UIPanGestureRecognizer){
        self.resignView()
        let searchCountry = CTASearchCountryViewController.getInstance()
        searchCountry.selectedDelegate = self
        self.navigationController?.pushViewController(searchCountry, animated: true)
    }
}

extension CTASetMobileNumberViewController: CTACountryDelegate{
    func setCountryCode(_ model:CountryZone){
        self.selectedModel = model
        self.changeCountryLabelByModel(selectedModel)
    }
}

extension CTASetMobileNumberViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let newText = self.phoneTextinput.text
        let newStr = NSString(string: newText!)
        let isDelete = string == "" ? true : false
        if self.selectedModel != nil && self.selectedModel?.zoneCode == "86" {
            self.phoneTextinput.text = self.changeChinaPhone(newStr, isDelete: isDelete)
        }
        if isDelete {
            if newStr.length <= 1{
                self.registerButton.isEnabled = false
            }
        }else{
            self.registerButton.isEnabled = true
        }
        if newStr.length < 20 || isDelete{
            return true
        }else {
            return false
        }
    }
}

extension CTASetMobileNumberViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
