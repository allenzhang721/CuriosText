//
//  CTALoginViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTALoginViewController: UIViewController, CTAPhoneProtocol, CTALoadingProtocol, CTALoginProtocol, CTAAlertProtocol{
    
    static var _instance:CTALoginViewController?;
    
    static func getInstance() -> CTALoginViewController{
        if _instance == nil{
            _instance = CTALoginViewController();
        }
        return _instance!
    }
    
    
    var phoneTextinput:UITextField = UITextField()
    var countryNameLabel:UILabel = UILabel()
    var areaCodeLabel:UILabel = UILabel()
    
    var passwordTextinput:UITextField!
    var passwordVisibleButton:UIButton!
    var loginButton:UIButton!
    
    var selectedModel:CountryZone?
    var isChangeContry:Bool = false
    
    var loadingImageView:UIImageView? = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initView(){
        let bouns = UIScreen.mainScreen().bounds
        let tap = UITapGestureRecognizer(target: self, action: "bgViewClick:")
        self.view.addGestureRecognizer(tap)
        
        let closeButton = UIButton.init(frame: CGRect.init(x: 10, y: 10, width: 35, height: 35))
        closeButton.setImage(UIImage(named: "close-button"), forState: .Normal)
        closeButton.addTarget(self, action: "closeButtonClick:", forControlEvents: .TouchUpInside)
        self.view.addSubview(closeButton)
        
        let iconImage = UIImageView.init(frame: CGRect.init(x: (bouns.width - 60)/2, y: 100*self.getVerRate(), width: 60, height: 62))
        iconImage.image = UIImage(named: "defaultpublish-icon")
        self.view.addSubview(iconImage)
        
        self.initPhoneView()
        self.phoneTextinput.delegate = self
        
        let passwordLabel = UILabel.init(frame: CGRect.init(x: 27*self.getHorRate(), y: 315*self.getVerRate(), width: 50, height: 25))
        passwordLabel.font = UIFont.systemFontOfSize(18)
        passwordLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        passwordLabel.text = NSLocalizedString("PasswordLabel", comment: "")
        passwordLabel.sizeToFit()
        self.view.addSubview(passwordLabel)
        
        self.passwordTextinput = UITextField.init(frame: CGRect.init(x:128*self.getHorRate(), y: 300*self.getVerRate(), width: 190*self.getHorRate(), height: 50))
        self.passwordTextinput.placeholder = NSLocalizedString("PasswordPlaceholder", comment: "")
        self.passwordTextinput.secureTextEntry = true
        self.passwordTextinput.clearsOnBeginEditing = true
        self.passwordTextinput.delegate = self
        self.view.addSubview(self.passwordTextinput)
        self.passwordVisibleButton = UIButton.init(frame: CGRect.init(x: bouns.width - 27*self.getHorRate() - 20, y: 321*self.getVerRate(), width: 20, height: 13))
        self.passwordVisibleButton.setImage(UIImage(named: "passwordhide-icon"), forState: .Normal)
        self.view.addSubview(self.passwordVisibleButton)
        self.passwordVisibleButton.addTarget(self, action: "passwordVisibleClick:", forControlEvents: .TouchUpInside)
        let textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: 349*self.getVerRate(), width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "textinput-line")
        self.view.addSubview(textLine)
        
        self.loginButton = UIButton.init(frame: CGRect.init(x: (bouns.width - 40)/2, y: 370*self.getVerRate(), width: 40, height: 28))
        self.loginButton.setTitle(NSLocalizedString("LoginButtonLabel", comment: ""), forState: .Normal)
        self.loginButton.setTitleColor(UIColor.init(red: 239/255, green: 51/255, blue: 74/255, alpha: 1.0), forState: .Normal)
        self.loginButton.setTitleColor(UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0), forState: .Disabled)
        self.loginButton.setTitleColor(UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0), forState: .Disabled)
        self.loginButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        self.loginButton.sizeToFit()
        self.loginButton.frame.origin.x = (bouns.width - self.loginButton.frame.width)/2
        self.loginButton.addTarget(self, action: "loginButtonClick:", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.loginButton)
        
        
        let spaceView = UIImageView.init(frame: CGRect.init(x: (bouns.width - 215)/2, y: bouns.height - 170*self.getVerRate(), width: 215, height: 3))
        spaceView.image = UIImage(named: "login-spaceline")
        self.view.addSubview(spaceView)
        
        let otherAccountLabel = UILabel.init(frame: CGRect.init(x: (bouns.width - 215)/2, y: bouns.height - 175*self.getVerRate(), width: 50, height: 14))
        otherAccountLabel.font = UIFont.systemFontOfSize(12)
        otherAccountLabel.textColor = UIColor.init(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
        otherAccountLabel.text = NSLocalizedString("OtherAccountLoginLabel", comment: "")
        otherAccountLabel.sizeToFit()
        otherAccountLabel.frame.origin.x = (bouns.width - otherAccountLabel.frame.width)/2
        self.view.addSubview(otherAccountLabel)
        
        let weichatButton = UIButton.init(frame: CGRect.init(x: (bouns.width - 44)/2, y: bouns.height - 130*self.getVerRate(), width: 44, height: 44))
        weichatButton.setImage(UIImage(named: "weichat-icon"), forState: .Normal)
        weichatButton.addTarget(self, action: "weichatButtonClick:", forControlEvents: .TouchUpInside)
        self.view.addSubview(weichatButton)
        
        let forgetButton = UIButton.init(frame: CGRect.init(x: 27, y: bouns.height - 52*self.getVerRate(), width: 20, height: 84))
        forgetButton.setTitle(NSLocalizedString("ForgetPasswordLabel", comment: ""), forState: .Normal)
        forgetButton.setTitleColor(UIColor.init(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0), forState: .Normal)
        forgetButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        forgetButton.sizeToFit()
        forgetButton.addTarget(self, action: "forgetButtonClick:", forControlEvents: .TouchUpInside)
        self.view.addSubview(forgetButton)
        
        let registerButton = UIButton.init(frame: CGRect.init(x: 27*self.getHorRate(), y: bouns.height - 52*self.getVerRate(), width: 20, height: 84))
        registerButton.setTitle(NSLocalizedString("RegisterLabel", comment: ""), forState: .Normal)
        registerButton.setTitleColor(UIColor.init(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0), forState: .Normal)
        registerButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        registerButton.sizeToFit()
        registerButton.frame.origin.x = bouns.width - 27*self.getHorRate() - registerButton.frame.width
        registerButton.addTarget(self, action: "registerButtonClick:", forControlEvents: .TouchUpInside)
        self.view.addSubview(registerButton)
    }
    
    func viewWillLoad(){
        if isChangeContry{
            self.phoneTextinput.text = ""
            self.passwordTextinput.text = ""
            self.passwordTextinput.secureTextEntry = true
            self.passwordVisibleButton.setImage(UIImage(named: "passwordhide-icon"), forState: .Normal)
            self.loginButton.enabled = false
            self.selectedModel = self.getCurrentContryModel()
            self.changeCountryLabelByModel(self.selectedModel)
        }
        self.isChangeContry = false
    }
    
    func bgViewClick(sender: UIPanGestureRecognizer){
        self.resignHandler(sender)
    }
    
    func closeButtonClick(sender: UIButton){
        self.resignView()
        self.dismissViewControllerAnimated(false) { () -> Void in
            
        }
    }
    
    func passwordVisibleClick(sender: UIButton){
        self.passwordTextinput.secureTextEntry = !self.passwordTextinput.secureTextEntry
        if self.passwordTextinput.secureTextEntry{
            self.passwordVisibleButton.setImage(UIImage(named: "passwordhide-icon"), forState: .Normal)
        }else {
            self.passwordVisibleButton.setImage(UIImage(named: "passwordshow-icon"), forState: .Normal)
        }
    }
    
    func countryNameClick(sender: UIPanGestureRecognizer){
        self.resignView()
        let searchCountry = CTASearchCountryViewController.getInstance()
        searchCountry.selectedDelegate = self
        self.navigationController?.pushViewController(searchCountry, animated: true)
    }
    
    func changeToLoadingView(button:UIButton){
        button.hidden = true
        self.loadingImageView?.center = button.center
        self.showLoadingView()
    }
    
    func changeToUnloadingView(button:UIButton){
        button.hidden = false
        self.hideLoadingView()
    }
    
    func loginButtonClick(sender: UIButton){
        self.resignView()
        let phoneLabel = self.phoneTextinput.text!
        let phoneNumber = phoneLabel.stringByReplacingOccurrencesOfString("\\s", withString: "", options: .RegularExpressionSearch, range: nil)
        let zone = self.selectedModel!.zoneCode
        let passwordText = self.passwordTextinput.text
        let cryptPassword = CTAEncryptManager.hash256(passwordText!)
        self.changeToLoadingView(self.loginButton)
        CTAUserDomain.getInstance().login(phoneNumber, areaCode: zone, passwd: cryptPassword) { (info) -> Void in
            self.changeToUnloadingView(self.loginButton)
            if info.result{
                let userModel = info.baseModel as! CTAUserModel
                self.loginComplete(userModel)
            }else {
                if info.errorType is CTAInternetError {
                    self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                    })
                }else {
                    let error = info.errorType as! CTAUserLoginError
                    if error == .UserNameOrPasswordWrong {
                        self.showSingleAlert(NSLocalizedString("AlertTitleLoginFaile", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                        })
                    }else if error == .PhoneNotExist{
                        self.showSingleAlert(NSLocalizedString("AlertTitleLoginFaile", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                        })
                    }else if error == .DataIsEmpty{
                        self.showSingleAlert(NSLocalizedString("AlertTitleDataNil", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                        })
                    }else {
                        self.showSingleAlert(NSLocalizedString("AlertTitleConnectUs", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                        })
                    }
                }
            }
        }
    }
    
    func forgetButtonClick(sender: UIButton){
        self.resignView()
        let setMobileView = CTASetMobileNumberViewController.getInstance()
        setMobileView.isChangeContry = true
        setMobileView.setMobileNumberType = .resetPassword
        self.navigationController?.pushViewController(setMobileView, animated: true)
    }
    
    func registerButtonClick(sender: UIButton){
        self.resignView()
        let setMobileView = CTASetMobileNumberViewController.getInstance()
        setMobileView.isChangeContry = true
        setMobileView.setMobileNumberType = .register
        self.navigationController?.pushViewController(setMobileView, animated: true)
    }
    
    func weichatButtonClick(sender: UIButton){
        CTASocialManager.OAuth(.WeChat) { (resultDic, urlResponse, error) -> Void in
            print(resultDic)
        }
    }
}

extension CTALoginViewController: CTACountryDelegate{
    func setCountryCode(model:CountryZone){
        self.selectedModel = model
        self.changeCountryLabelByModel(selectedModel)
    }
}

extension CTALoginViewController: UITextFieldDelegate{
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        let newText = textField.text
        let newStr = NSString(string: newText!)
        let isDelete = string == "" ? true : false
        if textField == self.phoneTextinput{
            if self.selectedModel != nil && self.selectedModel?.zoneCode == "86" {
                self.phoneTextinput.text = self.changeChinaPhone(newStr, isDelete: isDelete)
            }
            if !isDelete{
                let password = self.passwordTextinput.text
                let passwordStr = NSString(string: password!)
                if passwordStr.length >= 5 && newStr.length > 0{
                    self.loginButton.enabled = true
                }
            }else {
                if newStr.length == 1 {
                    self.loginButton.enabled = false
                }
            }
            if newStr.length < 20 || isDelete{
                return true
            }else {
                return false
            }
        }else if textField == self.passwordTextinput{
            if !isDelete {
                let phone = self.phoneTextinput.text
                let phoneStr = NSString(string: phone!)
                if newStr.length >= 5 && phoneStr.length > 0{
                    self.loginButton.enabled = true
                }
            }else {
                if newStr.length == 6 {
                    self.loginButton.enabled = false
                }
            }
            if newStr.length < 16 || isDelete{
                return true
            }else {
                return false
            }
        }
        return true
    }
}
