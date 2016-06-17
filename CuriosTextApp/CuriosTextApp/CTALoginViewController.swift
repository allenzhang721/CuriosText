//
//  CTALoginViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class CTALoginViewController: UIViewController, CTAPhoneProtocol, CTALoadingProtocol, CTALoginProtocol, CTAAlertProtocol, CTASocialLoginable{
    
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
    
    var otherAccountView:UIView!
    var wechatButton:UIButton!
    var weiboButton:UIButton!
    
    var loadingImageView:UIImageView? = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
    
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(CTALoginViewController.bgViewClick(_:)))
        self.view.addGestureRecognizer(tap)
        
        let closeButton = UIButton.init(frame: CGRect.init(x: 5, y: 2, width: 40, height: 40))
        closeButton.setImage(UIImage(named: "close-button"), forState: .Normal)
        closeButton.setImage(UIImage(named: "close-selected-button"), forState: .Highlighted)
        closeButton.addTarget(self, action: #selector(CTALoginViewController.closeButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(closeButton)
        
        let iconImage = UIImageView.init(frame: CGRect.init(x: (bouns.width - 60)/2, y: 60*self.getVerRate(), width: 60, height: 62))
        iconImage.image = UIImage(named: "Launch-icon")
        self.view.addSubview(iconImage)
        
        self.initPhoneView()
        self.phoneTextinput.delegate = self
    
        self.passwordTextinput = UITextField.init(frame: CGRect.init(x:128*self.getHorRate(), y: self.phoneTextinput.frame.origin.y+50, width: 190*self.getHorRate(), height: 50))
        self.passwordTextinput.font = UIFont.systemFontOfSize(16)
        self.passwordTextinput.placeholder = NSLocalizedString("PasswordPlaceholder", comment: "")
        self.passwordTextinput.secureTextEntry = true
        self.passwordTextinput.clearsOnBeginEditing = true
        self.passwordTextinput.delegate = self
        self.passwordTextinput.returnKeyType = .Go
        self.view.addSubview(self.passwordTextinput)
        let passwordLabel = UILabel.init(frame: CGRect.init(x: 27*self.getHorRate(), y: self.passwordTextinput.frame.origin.y+12, width: 50, height: 25))
        passwordLabel.font = UIFont.systemFontOfSize(16)
        passwordLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        passwordLabel.text = NSLocalizedString("PasswordLabel", comment: "")
        passwordLabel.sizeToFit()
        self.view.addSubview(passwordLabel)
        self.passwordVisibleButton = UIButton.init(frame: CGRect.init(x: bouns.width - 27*self.getHorRate() - 20, y: self.passwordTextinput.frame.origin.y+19, width: 20, height: 13))
        self.passwordVisibleButton.setImage(UIImage(named: "passwordhide-icon"), forState: .Normal)
        self.view.addSubview(self.passwordVisibleButton)
        self.passwordVisibleButton.addTarget(self, action: #selector(CTALoginViewController.passwordVisibleClick(_:)), forControlEvents: .TouchUpInside)
        let textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: self.passwordTextinput.frame.origin.y+49, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "space-line")
        self.view.addSubview(textLine)
        
        self.loginButton = UIButton.init(frame: CGRect.init(x: (bouns.width - 40)/2, y: self.passwordTextinput.frame.origin.y+70, width: 40, height: 28))
        self.loginButton.setTitle(NSLocalizedString("LoginButtonLabel", comment: ""), forState: .Normal)
        self.loginButton.setTitleColor(UIColor.init(red: 239/255, green: 51/255, blue: 74/255, alpha: 1.0), forState: .Normal)
        self.loginButton.setTitleColor(UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0), forState: .Disabled)
        self.loginButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        self.loginButton.sizeToFit()
        self.loginButton.frame.origin.x = (bouns.width - self.loginButton.frame.width)/2
        self.loginButton.addTarget(self, action: #selector(CTALoginViewController.loginButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(self.loginButton)
        
        self.otherAccountView = UIView.init(frame: CGRect.init(x: 0, y: bouns.height - 175*self.getVerRate(), width: bouns.width, height: 175*self.getVerRate()))
        self.otherAccountView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        self.view.addSubview(self.otherAccountView)
        
        let spaceView = UIImageView.init(frame: CGRect.init(x: (bouns.width - 215)/2, y: 5, width: 215, height: 3))
        spaceView.image = UIImage(named: "login-spaceline")
        self.otherAccountView.addSubview(spaceView)
        
        let otherAccountLabel = UILabel.init(frame: CGRect.init(x: (bouns.width - 215)/2, y: 0, width: 50, height: 14))
        otherAccountLabel.font = UIFont.systemFontOfSize(12)
        otherAccountLabel.textColor = UIColor.init(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
        otherAccountLabel.text = NSLocalizedString("OtherAccountLoginLabel", comment: "")
        otherAccountLabel.sizeToFit()
        otherAccountLabel.frame.origin.x = (bouns.width - otherAccountLabel.frame.width)/2
        self.otherAccountView.addSubview(otherAccountLabel)
        
        self.wechatButton = UIButton.init(frame: CGRect.init(x: bouns.width/2+30, y: 45, width: 44, height: 44))
        self.wechatButton.setImage(UIImage(named: "wechat-icon"), forState: .Normal)
        self.wechatButton.addTarget(self, action: #selector(CTALoginViewController.wechatButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.otherAccountView.addSubview(self.wechatButton)
        
        self.weiboButton = UIButton.init(frame: CGRect.init(x: bouns.width/2-74, y: 45, width: 44, height: 44))
        self.weiboButton.setImage(UIImage(named: "weibo-icon"), forState: .Normal)
        self.weiboButton.addTarget(self, action: #selector(CTALoginViewController.weiboButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.otherAccountView.addSubview(self.weiboButton)
        
        let forgetButton = UIButton.init(frame: CGRect.init(x: 27, y: bouns.height - 52*self.getVerRate(), width: 20, height: 84))
        forgetButton.setTitle(NSLocalizedString("ForgetPasswordLabel", comment: ""), forState: .Normal)
        forgetButton.setTitleColor(UIColor.init(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0), forState: .Normal)
        forgetButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        forgetButton.sizeToFit()
        forgetButton.addTarget(self, action: #selector(CTALoginViewController.forgetButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(forgetButton)
        
        let registerButton = UIButton.init(frame: CGRect.init(x: 27*self.getHorRate(), y: bouns.height - 52*self.getVerRate(), width: 20, height: 84))
        registerButton.setTitle(NSLocalizedString("RegisterLabel", comment: ""), forState: .Normal)
        registerButton.setTitleColor(UIColor.init(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0), forState: .Normal)
        registerButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        registerButton.sizeToFit()
        registerButton.frame.origin.x = bouns.width - 27*self.getHorRate() - registerButton.frame.width
        registerButton.addTarget(self, action: #selector(CTALoginViewController.registerButtonClick(_:)), forControlEvents: .TouchUpInside)
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
            self.checkOtherAccount()
        }
        self.isChangeContry = false
    }
    
    func checkOtherAccount(){
        self.otherAccountView.hidden = false
        if CTASocialManager.isAppInstaller(.WeChat){
            self.wechatButton.hidden = false
        }else {
            self.wechatButton.hidden = true
        }
        if CTASocialManager.isAppInstaller(.Weibo){
            self.weiboButton.hidden = false
            if self.wechatButton.hidden {
                self.weiboButton.center = CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: 67)
            }else {
                self.weiboButton.center = CGPoint(x: UIScreen.mainScreen().bounds.width/2-42, y: 67)
                self.wechatButton.center = CGPoint(x: UIScreen.mainScreen().bounds.width/2+42, y: 67)
            }
        }else {
            self.weiboButton.hidden = true
            if self.wechatButton.hidden {
                self.otherAccountView.hidden = true
            }else {
                self.wechatButton.center = CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: 67)
            }
        }
    }
    
    func bgViewClick(sender: UIPanGestureRecognizer){
        self.resignHandler(sender)
    }
    
    func closeButtonClick(sender: UIButton){
        self.resignView()
        self.loginComplete(nil)
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
    
    func changeToLoadingView(view:UIView?){
        if view == nil {
            SVProgressHUD.show()
        }else {
            self.showLoadingViewByView(view!)
        }
    }
    
    func changeToUnloadingView(view:UIView?){
        if view == nil {
            SVProgressHUD.dismiss()
        }else {
            self.hideLoadingViewByView(view!)
        }
        
    }
    
    func loginButtonClick(sender: UIButton){
        self.loginHandler()
    }
    
    func loginHandler(){
        let phoneLabel = self.phoneTextinput.text!
        let passwordText = self.passwordTextinput.text
        if phoneLabel != "" && passwordText != ""{
            self.resignView()
            let phoneNumber = phoneLabel.stringByReplacingOccurrencesOfString("\\s", withString: "", options: .RegularExpressionSearch, range: nil)
            let zone = self.selectedModel!.zoneCode
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
        }else {
            self.loginButton.enabled = false
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
    
    func weiboButtonClick(sender: UIButton){
        CTASocialManager.OAuth(.Weibo){ (OAuthInfo, urlResponse, error) -> Void in
            if error == nil {
                if OAuthInfo != nil {
                    self.login(.Weibo, OAuthInfo: OAuthInfo, completionHandler: { (resultDic, urlResponse, error) in
                        if error == nil && resultDic != nil {
                            let weiboIDInt:Int = resultDic![key(.WeiBoID)] as! Int
                            let weiboID = String(weiboIDInt)
                            let userIconURL:String = resultDic![key(.Avatarhd)] as! String
                            let nickName:String = resultDic![key(.WeiboName)] as! String
                            let desc:String = resultDic![key(.WeiboDesc)] as! String
                            let gender:String = resultDic![key(.Gender)] as! String
                            var userSex:Int = 0
                            if gender == "m"{
                                userSex = 1
                            }else if gender == "f"{
                                userSex = 2
                            }
                            self.changeToLoadingView(self.otherAccountView)
                            CTAUserDomain.getInstance().weiboRegister(weiboID, nickName: nickName, userDesc: desc, sex: userSex, compelecationBlock: { (info) in
                                self.changeToUnloadingView(self.otherAccountView)
                                if info.result{
                                    let userModel = info.baseModel as! CTAUserModel
                                    if info.successType == 0{
                                        let setNameView = CTASetUserNameViewController.getInstance()
                                        setNameView.userNameType = .registerWeibo
                                        setNameView.userModel = userModel
                                        setNameView.userIconPath = userIconURL
                                        self.navigationController?.pushViewController(setNameView, animated: true)
                                    }else if info.successType == 2{
                                        self.loginComplete(userModel)
                                    }
                                    CTASocialManager.saveToken(userModel.userID, OAuthInfo: OAuthInfo)
                                }else {
                                    if info.errorType is CTAInternetError {
                                        self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                        })
                                    }else {
                                        let error = info.errorType as! CTAWeixinRegisterError
                                        if error == .WeixinIDIsEmpty {
                                            self.showSingleAlert(NSLocalizedString("AlertTitleWeiboNil", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
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
                            })
                        }
                    })
                }
            }else {
                if error!.code == -1{
                    
                }
                else if error!.code == -2{
                    self.showSingleAlert(NSLocalizedString("AlertTitleWeiboUninstall", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                    })
                }else {
                    self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                    })
                }
            }
        }
    }
    
    func wechatButtonClick(sender: UIButton){
        CTASocialManager.OAuth(.WeChat) { (resultDic, urlResponse, error) -> Void in
            if error == nil {
                if resultDic != nil {
                    let weixinID:String = resultDic![key(.Openid)] as! String
                    let userIconURL:String = resultDic![key(.Headimgurl)] as! String
                    let nickName:String = resultDic![key(.WechatName)] as! String
                    let sex:Int = resultDic![key(.Sex)] as! Int
                    let country:String = resultDic![key(.Country)] as! String
                    let province:String = resultDic![key(.Province)] as! String
                    let city:String = resultDic![key(.City)] as! String
                    self.changeToLoadingView(self.otherAccountView)
                    CTAUserDomain.getInstance().weixinRegister(weixinID, nickName: nickName, sex: sex, country: country, province: province, city: city, compelecationBlock: { (info) -> Void in
                        self.changeToUnloadingView(self.otherAccountView)
                        if info.result{
                            let userModel = info.baseModel as! CTAUserModel
                            if info.successType == 0{
                                let setNameView = CTASetUserNameViewController.getInstance()
                                setNameView.userNameType = .registerWechat
                                setNameView.userModel = userModel
                                setNameView.userIconPath = userIconURL
                                self.navigationController?.pushViewController(setNameView, animated: true)
                            }else if info.successType == 2{
                                self.loginComplete(userModel)
                            }
                        }else {
                            if info.errorType is CTAInternetError {
                                self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                })
                            }else {
                                let error = info.errorType as! CTAWeixinRegisterError
                                if error == .WeixinIDIsEmpty {
                                    self.showSingleAlert(NSLocalizedString("AlertTitleWechatNil", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
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
                    })
                }else {
                    //self.changeToUnloadingView(nil)
                }
            }else {
                //self.changeToUnloadingView(nil)
                if error!.code == -1{
                    
                }
                else if error!.code == -2{
                    self.showSingleAlert(NSLocalizedString("AlertTitleWeChatUninstall", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                    })
                }else {
                    self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                    })
                }
            }
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
                if newStr.length <= 1 {
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
                if newStr.length <= 6 {
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        if textField == self.passwordTextinput{
            if self.loginButton.enabled {
                self.loginHandler()
            }else {
                textField.resignFirstResponder()
            }
        }
        return true
    }
}

extension CTALoginViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
}