//
//  CTASMSVerification.swift
//  CuriosTextApp
//
//  Created by allen on 16/2/1.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation

enum CTASMSVerifyType{
    case register, resetPassword
}

class CTASMSVerifyViewController: UIViewController, CTAPublishCellProtocol, CTAAlertProtocol, CTALoadingProtocol, CTALoginProtocol{
    
    static var _instance:CTASMSVerifyViewController?;
    
    static func getInstance() -> CTASMSVerifyViewController{
        if _instance == nil{
            _instance = CTASMSVerifyViewController();
        }
        return _instance!
    }
    
    var loadingImageView:UIImageView? = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
    
    var phone:String = ""
    var areaZone:String = ""
    var phoneLabel:UILabel!
    var hideTextInput:UITextField!
    
    var resendButton:UIButton!
    
    var verifyLabel1:UILabel!
    var verifyLabel2:UILabel!
    var verifyLabel3:UILabel!
    var verifyLabel4:UILabel!
    
    var smsType:CTASMSVerifyType = .register
    var isBackDirect:Bool = false
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initView()
        self.view.backgroundColor = UIColor.whiteColor()
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
        
        self.hideTextInput = UITextField.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 40))
        self.hideTextInput.hidden = true
        self.hideTextInput.delegate = self
        self.hideTextInput.keyboardType = .NumberPad
        self.view.addSubview(self.hideTextInput)
        
        let backButton = UIButton.init(frame: CGRect.init(x: 5, y: 2, width: 40, height: 40))
        backButton.setImage(UIImage(named: "back-button"), forState: .Normal)
        backButton.addTarget(self, action: "backButtonClick:", forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton)
        
        let enterVerifyCodeTitle = UILabel.init(frame: CGRect.init(x: (bouns.width - 50)/2, y: 100*self.getVerRate(), width: 100, height: 40))
        enterVerifyCodeTitle.font = UIFont.systemFontOfSize(28)
        enterVerifyCodeTitle.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        enterVerifyCodeTitle.text = NSLocalizedString("SMSVerifyTitle", comment: "")
        enterVerifyCodeTitle.sizeToFit()
        enterVerifyCodeTitle.frame.origin.x = (bouns.width - enterVerifyCodeTitle.frame.width)/2
        self.view.addSubview(enterVerifyCodeTitle)
        
        let enterVerifyCodeMess = UILabel.init(frame: CGRect.init(x: (bouns.width - 50)/2, y: 150*self.getVerRate(), width: 100, height: 20))
        enterVerifyCodeMess.font = UIFont.systemFontOfSize(14)
        enterVerifyCodeMess.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        enterVerifyCodeMess.text = NSLocalizedString("SMSVerifyMessage", comment: "")
        enterVerifyCodeMess.sizeToFit()
        enterVerifyCodeMess.frame.origin.x = (bouns.width - enterVerifyCodeMess.frame.width)/2
        self.view.addSubview(enterVerifyCodeMess)
        
        self.phoneLabel = UILabel.init(frame: CGRect.init(x: (bouns.width - 50)/2, y: 180*self.getVerRate(), width: 100, height: 20))
        self.phoneLabel.font = UIFont.systemFontOfSize(14)
        self.phoneLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        self.view.addSubview(self.phoneLabel)
        
        var line:UIImageView = UIImageView.init(frame: CGRect.init(x: bouns.width/2 - 60, y: 300*self.getVerRate(), width: 50, height: 1))
        line.image = UIImage(named: "textinput-line")
        self.view.addSubview(line)
        line = UIImageView.init(frame: CGRect.init(x: bouns.width/2 + 10, y: 300*self.getVerRate(), width: 50, height: 1))
        line.image = UIImage(named: "textinput-line")
        self.view.addSubview(line)
        
        line = UIImageView.init(frame: CGRect.init(x: bouns.width/2 - 130, y: 300*self.getVerRate(), width: 50, height: 1))
        line.image = UIImage(named: "textinput-line")
        self.view.addSubview(line)
        
        line = UIImageView.init(frame: CGRect.init(x: bouns.width/2 + 80, y: 300*self.getVerRate(), width: 50, height: 1))
        line.image = UIImage(named: "textinput-line")
        self.view.addSubview(line)
        
        self.verifyLabel1 = UILabel.init(frame: CGRect.init(x: bouns.width/2 - 123, y: 230*self.getVerRate(), width: 36, height: 84))
        self.verifyLabel1.font = UIFont.systemFontOfSize(60)
        self.verifyLabel1.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        self.view.addSubview(self.verifyLabel1)
        
        self.verifyLabel2 = UILabel.init(frame: CGRect.init(x: bouns.width/2 - 53, y: 230*self.getVerRate(), width: 36, height: 84))
        self.verifyLabel2.font = UIFont.systemFontOfSize(60)
        self.verifyLabel2.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        self.view.addSubview(self.verifyLabel2)
        
        self.verifyLabel3 = UILabel.init(frame: CGRect.init(x: bouns.width/2 + 17, y: 230*self.getVerRate(), width: 36, height: 84))
        self.verifyLabel3.font = UIFont.systemFontOfSize(60)
        self.verifyLabel3.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        self.view.addSubview(self.verifyLabel3)
        
        self.verifyLabel4 = UILabel.init(frame: CGRect.init(x: bouns.width/2 + 87, y: 230*self.getVerRate(), width: 36, height: 84))
        self.verifyLabel4.font = UIFont.systemFontOfSize(60)
        self.verifyLabel4.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        self.view.addSubview(self.verifyLabel4)
        
        self.resendButton = UIButton.init(frame: CGRect.init(x: (bouns.width - 40)/2, y: 320*self.getVerRate(), width: 70, height: 20))
        self.resendButton.setTitle(NSLocalizedString("NoReceivedCodeLabel", comment: ""), forState: .Normal)
        self.resendButton.setTitleColor(UIColor.init(red: 0/255, green: 166/255, blue: 255/255, alpha: 1.0), forState: .Normal)
        self.resendButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        self.resendButton.sizeToFit()
        self.resendButton.frame.origin.x = (bouns.width - self.resendButton.frame.width)/2
        self.resendButton.addTarget(self, action: "reSendButtonClick:", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.resendButton)
        
    }
    
    func viewWillLoad(){
        let phoneString = NSString(string: self.phone)
        let veriyNumber = phoneString.length - 11  < 0 ? 4 : phoneString.length - 7
        if phoneString.length > 6 {
            let startNumber = Int((phoneString.length - veriyNumber)/2)
            var phoneText:String = "+"+self.areaZone + " " + phoneString.substringWithRange(NSMakeRange(0, startNumber)) + " "
            for var i=0 ;i < veriyNumber; i++ {
                phoneText = phoneText + "*"
            }
            let endNumber = phoneString.length - veriyNumber - startNumber
            phoneText = phoneText + " " + phoneString.substringWithRange(NSMakeRange(phoneString.length - endNumber, endNumber))
            self.phoneLabel.text = phoneText
        }else {
            self.phoneLabel.text = "+"+self.areaZone + " " + phoneString.substringWithRange(NSMakeRange(0, 1)) + " " + "****" + " " + phoneString.substringWithRange(NSMakeRange(phoneString.length - 1, 1))
        }
        
        self.phoneLabel.sizeToFit()
        self.phoneLabel.frame.origin.x = (UIScreen.mainScreen().bounds.width - self.phoneLabel.frame.width)/2
        self.resetView()
        self.hideTextInput.becomeFirstResponder()
        self.isBackDirect = false
    }
    
    func backButtonClick(sender: UIButton){
        if !self.isBackDirect {
            self.showSelectedAlert(NSLocalizedString("AlertTitleSMSVerifyBack", comment: ""), alertMessage: "", okAlertLabel: NSLocalizedString("AlertBackLabel", comment: ""), cancelAlertLabel: NSLocalizedString("AlertWaitLabel", comment: "")) { (result) -> Void in
                if result {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func changeToLoadingView() {
        self.hideTextInput.resignFirstResponder()
        self.showLoadingViewByView(self.resendButton)
    }
    
    func changeToUnloadingView(){
        self.hideLoadingViewByView(self.resendButton)
        self.hideTextInput.becomeFirstResponder()
    }
    
    func submit(){
        self.changeToLoadingView()
        let code = self.verifyLabel1.text!+self.verifyLabel2.text!+self.verifyLabel3.text!+self.verifyLabel4.text!
        CTASocialManager.commitVerificationCode(code, phoneNumber: self.phone, zone: self.areaZone) { (result) -> Void in
            if result{
                if self.smsType == .register {
                    CTAUserDomain.getInstance().phoneRegister(self.phone, areaCode: self.areaZone, passwd: "", compelecationBlock: { (info) -> Void in
                        self.changeToUnloadingView()
                        if info.result{
                            if info.successType == 0{
                                let userModel = info.baseModel as! CTAUserModel
                                self.pushSetPasswordView(userModel, setPasswordType: .register)
                            }else if info.successType == 2{
                                let userModel = info.baseModel as! CTAUserModel
                                self.showSelectedAlert(NSLocalizedString("AlertTitlePhoneExist", comment: ""), alertMessage: "", okAlertLabel: NSLocalizedString("AlertYesLabel", comment: ""), cancelAlertLabel: NSLocalizedString("AlertNoLabel", comment: ""), compelecationBlock: { (result) -> Void in
                                    if result {
                                        self.loginComplete(userModel)
                                    }else {
                                        self.pushSetPasswordView(userModel, setPasswordType: .resetPassword)
                                    }
                                })
                            }
                        }else {
                            if info.errorType is CTAInternetError {
                                self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                    self.resetView()
                                })
                            }else {
                                let error = info.errorType as! CTAPhoneRegisterError
                                self.isBackDirect = true
                                if error == .PhoneIsEmpty {
                                    self.showSingleAlert(NSLocalizedString("AlertTitlePhoneNil", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                        self.resetView()
                                    })
                                }else if error == .DataIsEmpty{
                                    self.showSingleAlert(NSLocalizedString("AlertTitleDataNil", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                        self.resetView()
                                    })
                                }else {
                                    self.showSingleAlert(NSLocalizedString("AlertTitleConnectUs", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                        self.resetView()
                                    })
                                }
                            }
                        }
                    })
                }else if self.smsType == .resetPassword{
                    CTAUserDomain.getInstance().checkUserExist(self.phone, areaCode: self.areaZone, compelecationBlock: { (info) -> Void in
                        self.changeToUnloadingView()
                        if info.result{
                            self.pushSetPasswordView(nil, setPasswordType: .resetPassword)
                        }else {
                            if info.errorType is CTAInternetError {
                                self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                    self.resetView()
                                })
                            }else {
                                let error = info.errorType as! CTARequestUserError
                                self.isBackDirect = true
                                if error == .UserIDIsEmpty {
                                    self.showSingleAlert(NSLocalizedString("AlertTitlePhoneNil", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                        self.resetView()
                                    })
                                }else if error == .UserIDNotExist {
                                    self.showSingleAlert(NSLocalizedString("AlertTitlePhoneNotExist", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                        self.resetView()
                                    })
                                }else if error == .NeedContactWithService{
                                    self.showSingleAlert(NSLocalizedString("AlertTitleConnectUs", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                        self.resetView()
                                    })
                                }else if error == .DataIsEmpty{
                                    self.showSingleAlert(NSLocalizedString("AlertTitleDataNil", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                        self.resetView()
                                    })
                                }
                            }
                        }
                    })
                }
            }else {
                self.changeToUnloadingView()
                self.showSingleAlert(NSLocalizedString("AlertTitleCodeVerifyError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                    self.resetView()
                })
            }
        }
    }
    
    func resetView(){
        self.verifyLabel1.text = ""
        self.verifyLabel2.text = ""
        self.verifyLabel3.text = ""
        self.verifyLabel4.text = ""
        self.hideTextInput.text = ""
    }
    
    func pushSetPasswordView(userModel:CTAUserModel?, setPasswordType:CTASetPasswordType){
        let setView = CTASetPasswordViewController.getInstance()
        if self.smsType == .register {
            setView.userModel = userModel
            if userModel != nil {
                if userModel!.nikeName == "" || userModel!.userIconURL == "" {
                    setView.setPasswordType = .register
                }else {
                    setView.setPasswordType = setPasswordType
                }
            }else {
                setView.setPasswordType = setPasswordType
            }
            
        }else if self.smsType == .resetPassword{
            setView.setPasswordType = .resetPassword
            setView.resetAreaCode = self.areaZone
            setView.resetPhone = self.phone
        }
        self.navigationController?.pushViewController(setView, animated: true)
    }
    
    func reSendButtonClick(sender: UIButton){
        self.hideTextInput.resignFirstResponder()
        self.showSheetAlert([NSLocalizedString("AlertResendLabel", comment: "")], cancelAlertLabel: NSLocalizedString("AlertCancelLabel", comment: ""), compelecationBlock: { (result) -> Void in
            if result != -1{
                self.changeToLoadingView()
                let delay = dispatch_time(DISPATCH_TIME_NOW,
                    Int64(1.0 * Double(NSEC_PER_SEC)))
                CTASocialManager.getVerificationCode(self.phone, zone: self.areaZone, completionHandler: { (result) -> Void in
                    dispatch_after(delay, dispatch_get_main_queue()) { [weak self] in
                        if let sf = self{
                            self?.changeToUnloadingView()
                        }
                    }
                })
            }else {
                self.hideTextInput.becomeFirstResponder()
            }
        })
    }
}

extension CTASMSVerifyViewController: UITextFieldDelegate{
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        let newText = self.hideTextInput.text
        let newStr = NSString(string: newText!)
        let isDelete = string == "" ? true : false
        if !isDelete {
            if newStr.length == 0{
                self.verifyLabel1.text = string
            }
            if newStr.length == 1{
                self.verifyLabel2.text = string
            }
            if newStr.length == 2{
                self.verifyLabel3.text = string
            }
            if newStr.length == 3{
                self.verifyLabel4.text = string
                self.submit()
            }
        }else {
            if newStr.length == 1{
                self.verifyLabel1.text = ""
            }
            if newStr.length == 2{
                self.verifyLabel2.text = ""
            }
            if newStr.length == 3{
                self.verifyLabel3.text = ""
            }
            if newStr.length == 4{
                self.verifyLabel4.text = ""
            }
        }
        
        if newStr.length < 4 || isDelete{
            return true
        }else {
            return false
        }
    }
}


