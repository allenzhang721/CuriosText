//
//  CTASetPasswordViewController.swift
//  CuriosTextApp
//
//  Created by allen on 16/2/1.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation
import SVProgressHUD

enum CTASetPasswordType{
    case register, resetPassword, changePassword, setMobileNumber
}

class CTASetPasswordViewController: UIViewController, CTAPublishCellProtocol, CTATextInputProtocol, CTAAlertProtocol, CTALoadingProtocol, CTALoginProtocol{
    
    static var _instance:CTASetPasswordViewController?;
    
    static func getInstance() -> CTASetPasswordViewController{
        if _instance == nil{
            _instance = CTASetPasswordViewController();
        }
        return _instance!
    }
    
    var submitButton:UIButton!
    var passwordTextinput:UITextField!
    var passwordVisibleButton:UIButton!
    var setPasswordTitle:UILabel!
    var backButton:UIButton!
    
    var confirmTextinput:UITextField!
    
    var loadingImageView:UIImageView? = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
    
    var userModel:CTAUserModel?
    
    var resetPhone:String = ""
    var resetAreaCode:String = ""
    
    var setPasswordType:CTASetPasswordType = .register
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initView()
        self.view.backgroundColor = CTAStyleKit.commonBackgroundColor
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.resetAreaCode = ""
        self.resetPhone = ""
        self.userModel = nil
    }
    
    func initView(){
        let bouns = UIScreen.mainScreen().bounds
        let tap = UITapGestureRecognizer(target: self, action: #selector(CTASetPasswordViewController.bgViewClick(_:)))
        self.view.addGestureRecognizer(tap)
    
        self.backButton = UIButton.init(frame: CGRect.init(x: 0, y: 2, width: 40, height: 40))
        self.backButton.setImage(UIImage(named: "back-button"), forState: .Normal)
        self.backButton.setImage(UIImage(named: "back-selected-button"), forState: .Highlighted)
        self.backButton.addTarget(self, action: #selector(CTASetPasswordViewController.backButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(self.backButton)
        
        self.setPasswordTitle = UILabel.init(frame: CGRect.init(x: (bouns.width - 50)/2, y: 60*self.getVerRate(), width: 100, height: 40))
        self.setPasswordTitle.font = UIFont.systemFontOfSize(28)
        self.setPasswordTitle.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        self.setPasswordTitle.text = NSLocalizedString("SetPasswordTitle", comment: "")
        self.setPasswordTitle.sizeToFit()
        self.setPasswordTitle.frame.origin.x = (bouns.width - self.setPasswordTitle.frame.width)/2
        self.view.addSubview(self.setPasswordTitle)
        
        self.passwordTextinput = UITextField.init(frame: CGRect.init(x:128*self.getHorRate(), y: 150*self.getVerRate(), width: 190*self.getHorRate(), height: 50))
        self.passwordTextinput.placeholder = NSLocalizedString("SetPasswordPlaceholder", comment: "")
        self.passwordTextinput.secureTextEntry = true
        self.passwordTextinput.clearsOnBeginEditing = true
        self.passwordTextinput.delegate = self
        self.passwordTextinput.returnKeyType = .Done
        self.view.addSubview(self.passwordTextinput)
        self.passwordVisibleButton = UIButton.init(frame: CGRect.init(x: bouns.width - 27*self.getHorRate() - 20, y: self.passwordTextinput.frame.origin.y + 19, width: 20, height: 13))
        self.passwordVisibleButton.setImage(UIImage(named: "passwordhide-icon"), forState: .Normal)
        self.view.addSubview(self.passwordVisibleButton)
        self.passwordVisibleButton.addTarget(self, action: #selector(CTASetPasswordViewController.passwordVisibleClick(_:)), forControlEvents: .TouchUpInside)
        let passwordLabel = UILabel.init(frame: CGRect.init(x: 27*self.getHorRate(), y: self.passwordTextinput.frame.origin.y + 12, width: 50, height: 25))
        passwordLabel.font = UIFont.systemFontOfSize(16)
        passwordLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        passwordLabel.text = NSLocalizedString("PasswordLabel", comment: "")
        passwordLabel.sizeToFit()
        self.view.addSubview(passwordLabel)
        var textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: self.passwordTextinput.frame.origin.y + 49, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "space-line")
        self.view.addSubview(textLine)
    
        self.confirmTextinput = UITextField.init(frame: CGRect.init(x:128*self.getHorRate(), y: self.passwordTextinput.frame.origin.y + 50, width: 190*self.getHorRate(), height: 50))
        self.confirmTextinput.placeholder = NSLocalizedString("ConfirmPasswordPlaceholder", comment: "")
        self.confirmTextinput.secureTextEntry = true
        self.confirmTextinput.clearsOnBeginEditing = true
        self.confirmTextinput.delegate = self
        self.confirmTextinput.returnKeyType = .Done
        self.view.addSubview(self.confirmTextinput)
        let confirmLabel = UILabel.init(frame: CGRect.init(x: 27*self.getHorRate(), y: self.confirmTextinput.frame.origin.y + 12, width: 50, height: 25))
        confirmLabel.font = UIFont.systemFontOfSize(16)
        confirmLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        confirmLabel.text = NSLocalizedString("ConfirmPasswordLabel", comment: "")
        confirmLabel.sizeToFit()
        self.view.addSubview(confirmLabel)
        textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: self.confirmTextinput.frame.origin.y + 49, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "space-line")
        self.view.addSubview(textLine)
        
        
        self.submitButton = UIButton.init(frame: CGRect.init(x: (bouns.width - 40)/2, y: self.confirmTextinput.frame.origin.y + 70, width: 40, height: 28))
        self.submitButton.setTitle(NSLocalizedString("SubmitLabel", comment: ""), forState: .Normal)
        self.submitButton.setTitleColor(UIColor.init(red: 239/255, green: 51/255, blue: 74/255, alpha: 1.0), forState: .Normal)
        self.submitButton.setTitleColor(UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0), forState: .Disabled)
        self.submitButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        self.submitButton.sizeToFit()
        self.submitButton.frame.origin.x = (bouns.width - self.submitButton.frame.width)/2
        self.submitButton.addTarget(self, action: #selector(CTASetPasswordViewController.submitButtonClikc(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(self.submitButton)
        
    }
    
    func viewWillLoad(){
        self.passwordTextinput.text = ""
        self.confirmTextinput.text = ""
        self.passwordTextinput.secureTextEntry = true
        self.passwordVisibleButton.setImage(UIImage(named: "passwordhide-icon"), forState: .Normal)
        self.submitButton.enabled = false
        
        if self.userModel != nil {
            if self.resetPhone == "" {
                self.resetPhone = self.userModel!.phone
                self.resetAreaCode = self.userModel!.areaCode
            }
        }
        let bouns = UIScreen.mainScreen().bounds
        if self.setPasswordType == .changePassword{
            self.backButton.setImage(UIImage(named: "close-button"), forState: .Normal)
            self.backButton.setImage(UIImage(named: "close-selected-button"), forState: .Highlighted)
            self.setPasswordTitle.text = NSLocalizedString("ChangePasswordTitle", comment: "")
            self.setPasswordTitle.sizeToFit()
            self.setPasswordTitle.frame.origin.x = (bouns.width - self.setPasswordTitle.frame.width)/2
        }else {
            self.backButton.setImage(UIImage(named: "back-button"), forState: .Normal)
            self.backButton.setImage(UIImage(named: "back-selected-button"), forState: .Highlighted)
            self.setPasswordTitle.text = NSLocalizedString("SetPasswordTitle", comment: "")
            self.setPasswordTitle.sizeToFit()
            self.setPasswordTitle.frame.origin.x = (bouns.width - self.setPasswordTitle.frame.width)/2
            if self.navigationController != nil{
                self.navigationController!.interactivePopGestureRecognizer?.delegate = self
            }
        }
    }
    
    func changeToLoadingView() {
        self.resignView()
        self.showLoadingViewByView(self.submitButton)
    }
    
    func changeToUnloadingView(){
        self.hideLoadingViewByView(self.submitButton)
    }
    
    func submitButtonClikc(send: UIButton){
        self.submitHandler()
    }
    
    func submitHandler(){
        let passwordText = self.passwordTextinput.text
        let confirmText = self.confirmTextinput.text
        if passwordText != "" && confirmText != "" {
            if passwordText == confirmText {
                let cryptPassword = CTAEncryptManager.hash256(passwordText!)
                if self.setPasswordType == .register {
                    if self.userModel != nil {
                        self.changeToLoadingView()
                        CTAUserDomain.getInstance().updatePassword(self.userModel!.userID, newPasswd: cryptPassword, compelecationBlock: { (info) -> Void in
                            self.changeToUnloadingView()
                            if info!.result{
                                let setNameView = CTASetUserNameViewController.getInstance()
                                setNameView.userNameType = .register
                                setNameView.userModel = self.userModel
                                setNameView.userIconPath = ""
                                self.navigationController?.pushViewController(setNameView, animated: true)
                            }else {
                                if info.errorType is CTAInternetError {
                                    self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                    })
                                }else {
                                    self.showSingleAlert(NSLocalizedString("AlertTitleRegisterError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                    })
                                }
                            }
                        })
                    }
                }else if self.setPasswordType == .resetPassword {
                    self.changeToLoadingView()
                    CTAUserDomain.getInstance().resetPassword(self.resetPhone, areaCode: self.resetAreaCode, newPassword: cryptPassword, compelecationBlock: { (info) -> Void in
                        self.changeToUnloadingView()
                        if info.result{
                            let userModel = info.baseModel as! CTAUserModel
                            self.loginComplete(userModel)
                        }else {
                            if info.errorType is CTAInternetError {
                                self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                })
                            }else {
                                let error = info.errorType as! CTAResetPasswordError
                                if error == .PhoneIsEmpty {
                                    self.showSingleAlert(NSLocalizedString("AlertTitlePhoneNil", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                    })
                                }else if error == .PhoneNotExist {
                                    self.showSingleAlert(NSLocalizedString("AlertTitlePhoneNotExist", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                    })
                                }else if error == .NeedContactWithService{
                                    self.showSingleAlert(NSLocalizedString("AlertTitleConnectUs", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                    })
                                }else if error == .DataIsEmpty{
                                    self.showSingleAlert(NSLocalizedString("AlertTitleDataNil", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                    })
                                }
                            }
                        }
                    })
                }else if self.setPasswordType == .changePassword || self.setPasswordType == .setMobileNumber{
                    if self.userModel != nil {
                        self.changeToLoadingView()
                        CTAUserDomain.getInstance().updatePassword(self.userModel!.userID, newPasswd: cryptPassword, compelecationBlock: { (info) -> Void in
                            self.changeToUnloadingView()
                            if info.result{
                                if self.setPasswordType == .changePassword{
                                    SVProgressHUD.showSuccessWithStatus(NSLocalizedString("AlertPasswordset", comment: ""))
                                }else if self.setPasswordType == .setMobileNumber{
                                    SVProgressHUD.showSuccessWithStatus(NSLocalizedString("AlertPhoneSet", comment: ""))
                                }
                                
                                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                                })
                            }else {
                                if info.errorType is CTAInternetError {
                                    self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                    })
                                }else {
                                    self.showSingleAlert(NSLocalizedString("AlertTitleChangeError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                    })
                                }
                            }
                        })
                    }
                }
            }else {
                self.showSingleAlert(NSLocalizedString("AlertConfirmPasswordError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                    
                })
            }
        }else {
            self.submitButton.enabled = false
        }
    }
    
    func backButtonClick(send: UIButton){
        self.resignView()
        if self.setPasswordType == .changePassword{
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
            })
        }else {
            self.showSelectedAlert(NSLocalizedString("AlertTitlePasswordBack", comment: ""), alertMessage: "", okAlertLabel: LocalStrings.OK.description, cancelAlertLabel: LocalStrings.Cancel.description) { (result) -> Void in
                if result {
                    self.backHandler()
                }
            }

        }
    }
    
    func backHandler(){
        
        let mobile = CTASetMobileNumberViewController.getInstance()
        self.navigationController?.popToViewController(mobile, animated: true)
    }
    
    func passwordVisibleClick(send: UIButton){
        self.passwordTextinput.secureTextEntry = !self.passwordTextinput.secureTextEntry
        if self.passwordTextinput.secureTextEntry{
            self.passwordVisibleButton.setImage(UIImage(named: "passwordhide-icon"), forState: .Normal)
        }else {
            self.passwordVisibleButton.setImage(UIImage(named: "passwordshow-icon"), forState: .Normal)
        }
    }
    
    func bgViewClick(sender: UIPanGestureRecognizer){
        self.resignHandler(sender)
    }
    
}

extension CTASetPasswordViewController: UITextFieldDelegate{
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        let newText = textField.text
        let newStr = NSString(string: newText!)
        let isDelete = string == "" ? true : false
        if !isDelete {
            let passwordText = self.passwordTextinput.text
            let passwordStr = NSString(string: passwordText!)
            
            let confirmText = self.confirmTextinput.text
            let confirmStr = NSString(string: confirmText!)
            
            if passwordStr.length >= 5 && confirmStr.length >= 5 {
                self.submitButton.enabled = true
            }
        }else {
            if newStr.length <= 6 {
                self.submitButton.enabled = false
            }
        }
        
        if newStr.length < 16 || isDelete{
            return true
        }else {
            return false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        if textField == self.confirmTextinput {
            textField.resignFirstResponder()
            if self.submitButton.enabled {
                self.submitHandler()
            }
        }else if textField == self.passwordTextinput {
            self.confirmTextinput.becomeFirstResponder()
        }
        return true
    }
}

extension CTASetPasswordViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
}