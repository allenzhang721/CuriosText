//
//  CTASetPasswordViewController.swift
//  CuriosTextApp
//
//  Created by allen on 16/2/1.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation

enum CTASetPasswordType{
    case register, resetPassword, changePassword
}

class CTASetPasswordViewController: UIViewController, CTAPublishCellProtocol, CTATextInputProtocol, CTAAlertProtocol, CTALoadingProtocol{
    
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
        self.view.backgroundColor = UIColor.whiteColor()
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
        let tap = UITapGestureRecognizer(target: self, action: "bgViewClick:")
        self.view.addGestureRecognizer(tap)
    
        let backButton = UIButton.init(frame: CGRect.init(x: 5, y: 2, width: 40, height: 40))
        backButton.setImage(UIImage(named: "back-button"), forState: .Normal)
        backButton.addTarget(self, action: "backButtonClick:", forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton)
        
        let setPasswordTitle = UILabel.init(frame: CGRect.init(x: (bouns.width - 50)/2, y: 100*self.getVerRate(), width: 100, height: 40))
        setPasswordTitle.font = UIFont.systemFontOfSize(28)
        setPasswordTitle.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        setPasswordTitle.text = NSLocalizedString("SetPasswordTitle", comment: "")
        setPasswordTitle.sizeToFit()
        setPasswordTitle.frame.origin.x = (bouns.width - setPasswordTitle.frame.width)/2
        self.view.addSubview(setPasswordTitle)
        
        let passwordLabel = UILabel.init(frame: CGRect.init(x: 27*self.getHorRate(), y: 215*self.getVerRate(), width: 50, height: 25))
        passwordLabel.font = UIFont.systemFontOfSize(18)
        passwordLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        passwordLabel.text = NSLocalizedString("PasswordLabel", comment: "")
        passwordLabel.sizeToFit()
        self.view.addSubview(passwordLabel)
        
        self.passwordTextinput = UITextField.init(frame: CGRect.init(x:128*self.getHorRate(), y: 200*self.getVerRate(), width: 190*self.getHorRate(), height: 50))
        self.passwordTextinput.placeholder = NSLocalizedString("SetPasswordPlaceholder", comment: "")
        self.passwordTextinput.secureTextEntry = true
        self.passwordTextinput.clearsOnBeginEditing = true
        self.passwordTextinput.delegate = self
        self.view.addSubview(self.passwordTextinput)
        self.passwordVisibleButton = UIButton.init(frame: CGRect.init(x: bouns.width - 27*self.getHorRate() - 20, y: 221*self.getVerRate(), width: 20, height: 13))
        self.passwordVisibleButton.setImage(UIImage(named: "passwordhide-icon"), forState: .Normal)
        self.view.addSubview(self.passwordVisibleButton)
        self.passwordVisibleButton.addTarget(self, action: "passwordVisibleClick:", forControlEvents: .TouchUpInside)
        var textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: 249*self.getVerRate(), width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "textinput-line")
        self.view.addSubview(textLine)
        
        let confirmLabel = UILabel.init(frame: CGRect.init(x: 27*self.getHorRate(), y: 265*self.getVerRate(), width: 50, height: 25))
        confirmLabel.font = UIFont.systemFontOfSize(18)
        confirmLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        confirmLabel.text = NSLocalizedString("ConfirmPasswordLabel", comment: "")
        confirmLabel.sizeToFit()
        self.view.addSubview(confirmLabel)
        
        self.confirmTextinput = UITextField.init(frame: CGRect.init(x:128*self.getHorRate(), y: 250*self.getVerRate(), width: 190*self.getHorRate(), height: 50))
        self.confirmTextinput.placeholder = NSLocalizedString("ConfirmPasswordPlaceholder", comment: "")
        self.confirmTextinput.secureTextEntry = true
        self.confirmTextinput.clearsOnBeginEditing = true
        self.confirmTextinput.delegate = self
        self.view.addSubview(self.confirmTextinput)

        textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: 299*self.getVerRate(), width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "textinput-line")
        self.view.addSubview(textLine)
        
        
        self.submitButton = UIButton.init(frame: CGRect.init(x: (bouns.width - 40)/2, y: 320*self.getVerRate(), width: 40, height: 28))
        self.submitButton.setTitle(NSLocalizedString("SubmitLabel", comment: ""), forState: .Normal)
        self.submitButton.setTitleColor(UIColor.init(red: 239/255, green: 51/255, blue: 74/255, alpha: 1.0), forState: .Normal)
        self.submitButton.setTitleColor(UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0), forState: .Disabled)
        self.submitButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        self.submitButton.sizeToFit()
        self.submitButton.frame.origin.x = (bouns.width - self.submitButton.frame.width)/2
        self.submitButton.addTarget(self, action: "submitButtonClikc:", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.submitButton)
        
    }
    
    func viewWillLoad(){
        self.passwordTextinput.text = ""
        self.confirmTextinput.text = ""
        self.passwordTextinput.secureTextEntry = true
        self.passwordVisibleButton.setImage(UIImage(named: "passwordhide-icon"), forState: .Normal)
        self.submitButton.enabled = false
    }
    
    func changeToLoadingView() {
        self.resignView()
        self.showLoadingViewByView(self.submitButton)
    }
    
    func changeToUnloadingView(){
        self.hideLoadingViewByView(self.submitButton)
    }
    
    func submitButtonClikc(send: UIButton){
        let passwordText = self.passwordTextinput.text
        let confirmText = self.confirmTextinput.text
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
                            setNameView.isResetView = true
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
                        CTAUserManager.save(userModel)
                        self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
                        })
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
            }else if self.setPasswordType == .changePassword{
                if self.userModel != nil {
                    self.changeToLoadingView()
                    CTAUserDomain.getInstance().updatePassword(self.userModel!.userID, newPasswd: cryptPassword, compelecationBlock: { (info) -> Void in
                        self.changeToUnloadingView()
                        if info.result{
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
    }
    
    func backButtonClick(send: UIButton){
        self.resignView()
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
            if newStr.length == 6 {
                self.submitButton.enabled = false
            }
        }
        
        if newStr.length < 16 || isDelete{
            return true
        }else {
            return false
        }
    }
}