//
//  CTASMSVerification.swift
//  CuriosTextApp
//
//  Created by allen on 16/2/1.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation
import SVProgressHUD

enum CTASMSVerifyType{
    case register, resetPassword, setMobileNumber, changeMobileNumber
}

class CTASMSVerifyViewController: UIViewController, CTAPublishCellProtocol, CTAAlertProtocol, CTALoadingProtocol, CTALoginProtocol{
    
    static var _instance:CTASMSVerifyViewController?;
    
    static func getInstance() -> CTASMSVerifyViewController{
        if _instance == nil{
            _instance = CTASMSVerifyViewController();
        }
        return _instance!
    }
    
    var loadingImageView:UIImageView? = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CTASMSVerifyViewController.showTextClick(_:)))
        self.view.addGestureRecognizer(tap)
        
        self.hideTextInput = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        self.hideTextInput.isHidden = true
        self.hideTextInput.delegate = self
        self.hideTextInput.keyboardType = .numberPad
        self.view.addSubview(self.hideTextInput)
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 22, width: 40, height: 40))
        backButton.setImage(UIImage(named: "back-button"), for: UIControlState())
        backButton.setImage(UIImage(named: "back-selected-button"), for: .highlighted)
        backButton.addTarget(self, action: #selector(CTASMSVerifyViewController.backButtonClick(_:)), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        let enterVerifyCodeTitle = UILabel(frame: CGRect(x: 0, y: 60*self.getVerRate(), width: bouns.width, height: 40))
        enterVerifyCodeTitle.font = UIFont.boldSystemFont(ofSize: 28)
        enterVerifyCodeTitle.textColor = CTAStyleKit.normalColor
        enterVerifyCodeTitle.text = NSLocalizedString("SMSVerifyTitle", comment: "")
        enterVerifyCodeTitle.textAlignment = .center
        self.view.addSubview(enterVerifyCodeTitle)
        
        let enterVerifyCodeMess = UILabel(frame: CGRect(x: (bouns.width - 50)/2, y: 80*self.getVerRate()+40, width: 120, height: 20))
        enterVerifyCodeMess.font = UIFont.systemFont(ofSize: 14)
        enterVerifyCodeMess.textColor = CTAStyleKit.normalColor
        enterVerifyCodeMess.text = NSLocalizedString("SMSVerifyMessage", comment: "")
        enterVerifyCodeMess.sizeToFit()
        enterVerifyCodeMess.frame.origin.x = (bouns.width - enterVerifyCodeMess.frame.width)/2
        self.view.addSubview(enterVerifyCodeMess)
        
        self.phoneLabel = UILabel(frame: CGRect(x: (bouns.width - 50)/2, y: enterVerifyCodeMess.frame.origin.y+20, width: 100, height: 20))
        self.phoneLabel.font = UIFont.systemFont(ofSize: 14)
        self.phoneLabel.textColor = CTAStyleKit.normalColor
        self.view.addSubview(self.phoneLabel)
        
        self.verifyLabel1 = UILabel(frame: CGRect(x: bouns.width/2 - 123, y: 150*self.getVerRate()+50, width: 36, height: 50))
        self.verifyLabel1.font = UIFont.systemFont(ofSize: 40)
        self.verifyLabel1.textColor = CTAStyleKit.normalColor
        self.view.addSubview(self.verifyLabel1)
        self.verifyLabel1.textAlignment = .center
        
        self.verifyLabel2 = UILabel(frame: CGRect(x: bouns.width/2 - 53, y: self.verifyLabel1.frame.origin.y, width: 36, height: 50))
        self.verifyLabel2.font = UIFont.systemFont(ofSize: 40)
        self.verifyLabel2.textColor = CTAStyleKit.normalColor
        self.view.addSubview(self.verifyLabel2)
        self.verifyLabel2.textAlignment = .center
        
        self.verifyLabel3 = UILabel(frame: CGRect(x: bouns.width/2 + 17, y: self.verifyLabel1.frame.origin.y, width: 36, height: 50))
        self.verifyLabel3.font = UIFont.systemFont(ofSize: 40)
        self.verifyLabel3.textColor = CTAStyleKit.normalColor
        self.view.addSubview(self.verifyLabel3)
        self.verifyLabel3.textAlignment = .center
        
        self.verifyLabel4 = UILabel(frame: CGRect(x: bouns.width/2 + 87, y: self.verifyLabel1.frame.origin.y, width: 36, height: 50))
        self.verifyLabel4.font = UIFont.systemFont(ofSize: 40)
        self.verifyLabel4.textColor = CTAStyleKit.normalColor
        self.view.addSubview(self.verifyLabel4)
        self.verifyLabel4.textAlignment = .center
        
        var line:UIImageView = UIImageView(frame: CGRect(x: bouns.width/2 - 60, y: self.verifyLabel1.frame.origin.y+49, width: 50, height: 1))
        line.image = UIImage(named: "space-line")
        self.view.addSubview(line)
        line = UIImageView(frame: CGRect(x: bouns.width/2 + 10, y: self.verifyLabel1.frame.origin.y+49, width: 50, height: 1))
        line.image = UIImage(named: "space-line")
        self.view.addSubview(line)
        
        line = UIImageView(frame: CGRect(x: bouns.width/2 - 130, y: self.verifyLabel1.frame.origin.y+49, width: 50, height: 1))
        line.image = UIImage(named: "space-line")
        self.view.addSubview(line)
        
        line = UIImageView(frame: CGRect(x: bouns.width/2 + 80, y: self.verifyLabel1.frame.origin.y+49, width: 50, height: 1))
        line.image = UIImage(named: "space-line")
        self.view.addSubview(line)
        
        self.resendButton = UIButton(frame: CGRect(x: (bouns.width - 40)/2, y: self.verifyLabel1.frame.origin.y+70, width: 70, height: 20))
        self.resendButton.setTitle(NSLocalizedString("NoReceivedCodeLabel", comment: ""), for: UIControlState())
        self.resendButton.setTitleColor(UIColor(red: 0/255, green: 166/255, blue: 255/255, alpha: 1.0), for: UIControlState())
        self.resendButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.resendButton.sizeToFit()
        self.resendButton.frame.origin.x = (bouns.width - self.resendButton.frame.width)/2
        self.resendButton.addTarget(self, action: #selector(CTASMSVerifyViewController.reSendButtonClick(_:)), for: .touchUpInside)
        self.view.addSubview(self.resendButton)
        
    }
    
    func viewWillLoad(){
        let phoneString = NSString(string: self.phone)
        let veriyNumber = phoneString.length - 11  < 0 ? 4 : phoneString.length - 7
        if phoneString.length > 6 {
            let startNumber = Int((phoneString.length - veriyNumber)/2)
            var phoneText:String = "+"+self.areaZone + " " + phoneString.substring(with: NSMakeRange(0, startNumber)) + " "
            for _ in 0..<veriyNumber {
                phoneText = phoneText + "*"
            }
            let endNumber = phoneString.length - veriyNumber - startNumber
            phoneText = phoneText + " " + phoneString.substring(with: NSMakeRange(phoneString.length - endNumber, endNumber))
            self.phoneLabel.text = phoneText
        }else {
            self.phoneLabel.text = "+"+self.areaZone + " " + phoneString.substring(with: NSMakeRange(0, 1)) + " " + "****" + " " + phoneString.substring(with: NSMakeRange(phoneString.length - 1, 1))
        }
        
        self.phoneLabel.sizeToFit()
        self.phoneLabel.frame.origin.x = (UIScreen.main.bounds.width - self.phoneLabel.frame.width)/2
        self.resetView()
        self.hideTextInput.becomeFirstResponder()
        self.isBackDirect = false
    }
    
    func backButtonClick(_ sender: UIButton){
        if !self.isBackDirect {
            self.showSelectedAlert(NSLocalizedString("AlertTitleSMSVerifyBack", comment: ""), alertMessage: "", okAlertLabel: LocalStrings.back.description, cancelAlertLabel: LocalStrings.wait.description) { (result) -> Void in
                if result {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showTextClick(_ sender: UITapGestureRecognizer){
        let pt = sender.location(in: self.resendButton)
        if !self.resendButton.point(inside: pt, with: nil){
            self.hideTextInput.becomeFirstResponder()
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
      guard
        let t1 = self.verifyLabel1.text,
        let t2 = self.verifyLabel2.text,
        let t3 = self.verifyLabel3.text,
        let t4 = self.verifyLabel4.text else {
        return
      }
        self.changeToLoadingView()
        let code = t1 + t2 + t3 + t4
      //self.verifyLabel1.text! + self.verifyLabel2.text! + self.verifyLabel3.text! + self.verifyLabel4.text!
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
                                self.showSelectedAlert(NSLocalizedString("AlertTitlePhoneExist", comment: ""), alertMessage: "", okAlertLabel: LocalStrings.yes.description, cancelAlertLabel: LocalStrings.no.description, compelecationBlock: { (result) -> Void in
                                    if result {
                                        self.loginComplete(userModel)
                                    }else {
                                        self.pushSetPasswordView(userModel, setPasswordType: .register)
                                    }
                                })
                            }
                        }else {
                            self.isBackDirect = true
                            if info.errorType is CTAInternetError {
                                self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                    self.resetView()
                                })
                            }else {
                                let error = info.errorType as! CTAPhoneRegisterError
                                if error == .phoneIsEmpty {
                                    self.showSingleAlert(NSLocalizedString("AlertTitlePhoneNil", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                        self.resetView()
                                    })
                                }else if error == .dataIsEmpty{
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
                            self.isBackDirect = true
                            if info.errorType is CTAInternetError {
                                self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                    self.resetView()
                                })
                            }else {
                                let error = info.errorType as! CTARequestUserError
                                if error == .userIDIsEmpty {
                                    self.showSingleAlert(NSLocalizedString("AlertTitlePhoneNil", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                        self.resetView()
                                    })
                                }else if error == .userIDNotExist {
                                    self.showSingleAlert(NSLocalizedString("AlertTitlePhoneNotExist", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                        self.resetView()
                                    })
                                }else if error == .needContactWithService{
                                    self.showSingleAlert(NSLocalizedString("AlertTitleConnectUs", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                        self.resetView()
                                    })
                                }else if error == .dataIsEmpty{
                                    self.showSingleAlert(NSLocalizedString("AlertTitleDataNil", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                        self.resetView()
                                    })
                                }
                            }
                        }
                    })
                }else if self.smsType == .setMobileNumber || self.smsType == .changeMobileNumber{
                    
                    if CTAUserManager.isLogin{
                        let user = CTAUserManager.user
                        let userID = user!.userID
                        CTAUserDomain.getInstance().bindingUserPhone(userID, phone: self.phone, areaCode: self.areaZone, compelecationBlock: { (info) in
                            self.changeToUnloadingView()
                            if info.result{
                                user!.phone = self.phone
                                user!.areaCode = self.areaZone
                                CTAUserManager.save(user!)
                                if self.smsType == .setMobileNumber{
                                    self.pushSetPasswordView(user, setPasswordType: .setMobileNumber)
                                }else {
                                    SVProgressHUD.showSuccess(withStatus: NSLocalizedString("AlertPhoneSet", comment: ""))
                                    self.dismiss(animated: true, completion: nil)
                                }
                            }else {
                                self.isBackDirect = true
                                if info.errorType is CTAInternetError {
                                    self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                        self.resetView()
                                    })
                                }else {
                                    let error = info.errorType as! CTABindingUserPhoneError
                                    if error == .userIDIsEmpty {
                                        self.showSingleAlert(NSLocalizedString("AlertTitleUserNotExist", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                            self.resetView()
                                        })
                                    }else if error == .userIDNotExist {
                                        self.showSingleAlert(NSLocalizedString("AlertTitleUserNotExist", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                            self.resetView()
                                        })
                                    }else if error == .phoneIsEmpty {
                                        self.showSingleAlert(NSLocalizedString("AlertTitlePhoneNil", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                            self.resetView()
                                        })
                                    }else if error == .phoneExist {
                                        self.showSingleAlert(NSLocalizedString("AlertTitlePhoneRegistExist", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                            self.resetView()
                                        })
                                    }else if error == .needContactWithService{
                                        self.showSingleAlert(NSLocalizedString("AlertTitleConnectUs", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                            self.resetView()
                                        })
                                    }else if error == .dataIsEmpty{
                                        self.showSingleAlert(NSLocalizedString("AlertTitleDataNil", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                            self.resetView()
                                        })
                                    }
                                }
                            }
                        })
                    }
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
    
    func pushSetPasswordView(_ userModel:CTAUserModel?, setPasswordType:CTASetPasswordType){
        let setView = CTASetPasswordViewController.getInstance()
        if self.smsType == .register {
            setView.userModel = userModel
            setView.setPasswordType = setPasswordType
        }else if self.smsType == .resetPassword{
            setView.setPasswordType = setPasswordType
            setView.resetAreaCode = self.areaZone
            setView.resetPhone = self.phone
        }else if self.smsType == .setMobileNumber{
            setView.userModel = userModel
            setView.setPasswordType = setPasswordType
        }
        self.navigationController?.pushViewController(setView, animated: true)
    }
    
    func reSendButtonClick(_ sender: UIButton){
        self.hideTextInput.resignFirstResponder()
        self.showSheetAlert(nil, okAlertArray:[["title":LocalStrings.resend.description as AnyObject, "style": "Destructive" as AnyObject]], cancelAlertLabel: LocalStrings.cancel.description, compelecationBlock: { (result) -> Void in
            if result != -1{
                self.changeToLoadingView()
                let delay = DispatchTime.now() + Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                CTASocialManager.getVerificationCode(self.phone, zone: self.areaZone, completionHandler: { (result) -> Void in
                    DispatchQueue.main.asyncAfter(deadline: delay) { [weak self] in
                        if let sf = self{
                            sf.changeToUnloadingView()
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
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

extension CTASMSVerifyViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
}
