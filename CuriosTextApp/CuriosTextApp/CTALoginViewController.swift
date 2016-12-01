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
    
    var loadingImageView:UIImageView? = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
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
    
    override func viewDidDisappear(_ animated: Bool) {
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
        let bouns = UIScreen.main.bounds
        let tap = UITapGestureRecognizer(target: self, action: #selector(CTALoginViewController.bgViewClick(_:)))
        self.view.addGestureRecognizer(tap)
        
        let closeButton = UIButton(frame: CGRect(x: 0, y: 22, width: 40, height: 40))
        closeButton.setImage(UIImage(named: "close-button"), for: UIControlState())
        closeButton.setImage(UIImage(named: "close-selected-button"), for: .highlighted)
        closeButton.addTarget(self, action: #selector(CTALoginViewController.closeButtonClick(_:)), for: .touchUpInside)
        self.view.addSubview(closeButton)
        
        let iconImage = UIImageView(frame: CGRect(x: (bouns.width - 60)/2, y: 70*self.getVerRate(), width: 60, height: 62))
        iconImage.image = UIImage(named: "Launch-icon")
        self.view.addSubview(iconImage)
        
        self.initPhoneView()
        self.phoneTextinput.delegate = self
    
        self.passwordTextinput = UITextField(frame: CGRect(x:128*self.getHorRate(), y: self.phoneTextinput.frame.origin.y+50, width: 190*self.getHorRate(), height: 50))
        self.passwordTextinput.font = UIFont.systemFont(ofSize: 16)
        self.passwordTextinput.placeholder = NSLocalizedString("PasswordPlaceholder", comment: "")
        self.passwordTextinput.isSecureTextEntry = true
        self.passwordTextinput.clearsOnBeginEditing = true
        self.passwordTextinput.delegate = self
        self.passwordTextinput.returnKeyType = .go
        self.view.addSubview(self.passwordTextinput)
        let passwordLabel = UILabel(frame: CGRect(x: 27*self.getHorRate(), y: self.passwordTextinput.frame.origin.y+12, width: 50, height: 25))
        passwordLabel.font = UIFont.systemFont(ofSize: 16)
        passwordLabel.textColor = CTAStyleKit.normalColor
        passwordLabel.text = NSLocalizedString("PasswordLabel", comment: "")
        passwordLabel.sizeToFit()
        self.view.addSubview(passwordLabel)
        self.passwordVisibleButton = UIButton(frame: CGRect(x: bouns.width - 27*self.getHorRate() - 20, y: self.passwordTextinput.frame.origin.y+19, width: 20, height: 13))
        self.passwordVisibleButton.setImage(UIImage(named: "passwordhide-icon"), for: UIControlState())
        self.view.addSubview(self.passwordVisibleButton)
        self.passwordVisibleButton.addTarget(self, action: #selector(CTALoginViewController.passwordVisibleClick(_:)), for: .touchUpInside)
        let textLine = UIImageView(frame: CGRect(x: 25*self.getHorRate(), y: self.passwordTextinput.frame.origin.y+49, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "space-line")
        self.view.addSubview(textLine)
        
        self.loginButton = UIButton(frame: CGRect(x: (bouns.width - 40)/2, y: self.passwordTextinput.frame.origin.y+70, width: 40, height: 28))
        self.loginButton.setTitle(NSLocalizedString("LoginButtonLabel", comment: ""), for: UIControlState())
        self.loginButton.setTitleColor(CTAStyleKit.selectedColor, for: UIControlState())
        self.loginButton.setTitleColor(CTAStyleKit.normalColor, for: .disabled)
        self.loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.loginButton.sizeToFit()
        self.loginButton.frame.origin.x = (bouns.width - self.loginButton.frame.width)/2
        self.loginButton.addTarget(self, action: #selector(CTALoginViewController.loginButtonClick(_:)), for: .touchUpInside)
        self.view.addSubview(self.loginButton)
        
        self.otherAccountView = UIView(frame: CGRect(x: 0, y: bouns.height - 175*self.getVerRate(), width: bouns.width, height: 175*self.getVerRate()))
        self.otherAccountView.backgroundColor = UIColor.clear
        self.view.addSubview(self.otherAccountView)
        
        let spaceView = UIImageView(frame: CGRect(x: (bouns.width - 215)/2, y: 5, width: 215, height: 3))
        spaceView.image = UIImage(named: "login-spaceline")
        self.otherAccountView.addSubview(spaceView)
        
        let otherAccountLabel = UILabel(frame: CGRect(x: (bouns.width - 215)/2, y: 0, width: 50, height: 14))
        otherAccountLabel.font = UIFont.systemFont(ofSize: 12)
        otherAccountLabel.textColor = CTAStyleKit.labelShowColor
        otherAccountLabel.text = NSLocalizedString("OtherAccountLoginLabel", comment: "")
        otherAccountLabel.sizeToFit()
        otherAccountLabel.frame.origin.x = (bouns.width - otherAccountLabel.frame.width)/2
        self.otherAccountView.addSubview(otherAccountLabel)
        
        self.wechatButton = UIButton(frame: CGRect(x: bouns.width/2+30, y: 45, width: 44, height: 44))
        self.wechatButton.setImage(UIImage(named: "wechat-icon"), for: UIControlState())
        self.wechatButton.addTarget(self, action: #selector(CTALoginViewController.wechatButtonClick(_:)), for: .touchUpInside)
        self.otherAccountView.addSubview(self.wechatButton)
        
        self.weiboButton = UIButton(frame: CGRect(x: bouns.width/2-74, y: 45, width: 44, height: 44))
        self.weiboButton.setImage(UIImage(named: "weibo-icon"), for: UIControlState())
        self.weiboButton.addTarget(self, action: #selector(CTALoginViewController.weiboButtonClick(_:)), for: .touchUpInside)
        self.otherAccountView.addSubview(self.weiboButton)
        
        let forgetButton = UIButton(frame: CGRect(x: 27*self.getHorRate(), y: bouns.height - 52*self.getVerRate(), width: 20, height: 84))
        forgetButton.setTitle(NSLocalizedString("ForgetPasswordLabel", comment: ""), for: UIControlState())
        forgetButton.setTitleColor(CTAStyleKit.labelShowColor, for: UIControlState())
        forgetButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        forgetButton.sizeToFit()
        forgetButton.addTarget(self, action: #selector(CTALoginViewController.forgetButtonClick(_:)), for: .touchUpInside)
        self.view.addSubview(forgetButton)
        
        let registerButton = UIButton(frame: CGRect(x: 27*self.getHorRate(), y: bouns.height - 52*self.getVerRate(), width: 20, height: 84))
        registerButton.setTitle(NSLocalizedString("RegisterLabel", comment: ""), for: UIControlState())
        registerButton.setTitleColor(CTAStyleKit.labelShowColor, for: UIControlState())
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        registerButton.sizeToFit()
        registerButton.frame.origin.x = bouns.width - 27*self.getHorRate() - registerButton.frame.width
        registerButton.addTarget(self, action: #selector(CTALoginViewController.registerButtonClick(_:)), for: .touchUpInside)
        self.view.addSubview(registerButton)
    }
    
    func viewWillLoad(){
        if isChangeContry{
            self.phoneTextinput.text = ""
            self.passwordTextinput.text = ""
            self.passwordTextinput.isSecureTextEntry = true
            self.passwordVisibleButton.setImage(UIImage(named: "passwordhide-icon"), for: UIControlState())
            self.loginButton.isEnabled = false
            self.selectedModel = self.getCurrentContryModel()
            self.changeCountryLabelByModel(self.selectedModel)
            self.checkOtherAccount()
        }
        self.isChangeContry = false
    }
    
    func checkOtherAccount(){
        self.otherAccountView.isHidden = false
        if CTASocialManager.isAppInstaller(.weChat){
            self.wechatButton.isHidden = false
        }else {
            self.wechatButton.isHidden = true
        }
        if CTASocialManager.isAppInstaller(.weibo){
            self.weiboButton.isHidden = false
            if self.wechatButton.isHidden {
                self.weiboButton.center = CGPoint(x: UIScreen.main.bounds.width/2, y: 67)
            }else {
                self.weiboButton.center = CGPoint(x: UIScreen.main.bounds.width/2-42, y: 67)
                self.wechatButton.center = CGPoint(x: UIScreen.main.bounds.width/2+42, y: 67)
            }
        }else {
            self.weiboButton.isHidden = true
            if self.wechatButton.isHidden {
                self.otherAccountView.isHidden = true
            }else {
                self.wechatButton.center = CGPoint(x: UIScreen.main.bounds.width/2, y: 67)
            }
        }
    }
    
    func bgViewClick(_ sender: UIPanGestureRecognizer){
        self.resignHandler(sender)
    }
    
    func closeButtonClick(_ sender: UIButton){
        self.resignView()
        self.loginComplete(nil)
    }
    
    func passwordVisibleClick(_ sender: UIButton){
        self.passwordTextinput.isSecureTextEntry = !self.passwordTextinput.isSecureTextEntry
        if self.passwordTextinput.isSecureTextEntry{
            self.passwordVisibleButton.setImage(UIImage(named: "passwordhide-icon"), for: UIControlState())
        }else {
            self.passwordVisibleButton.setImage(UIImage(named: "passwordshow-icon"), for: UIControlState())
        }
    }
    
    func countryNameClick(_ sender: UIPanGestureRecognizer){
        self.resignView()
        let searchCountry = CTASearchCountryViewController.getInstance()
        searchCountry.selectedDelegate = self
        self.navigationController?.pushViewController(searchCountry, animated: true)
    }
    
    func changeToLoadingView(_ view:UIView?){
        if view == nil {
            SVProgressHUD.show()
        }else {
            self.showLoadingViewByView(view!)
        }
    }
    
    func changeToUnloadingView(_ view:UIView?){
        if view == nil {
            SVProgressHUD.dismiss()
        }else {
            self.hideLoadingViewByView(view!)
        }
        
    }
    
    func loginButtonClick(_ sender: UIButton){
        self.loginHandler()
    }
    
    func loginHandler(){
        let phoneLabel = self.phoneTextinput.text!
        let passwordText = self.passwordTextinput.text
        if phoneLabel != "" && passwordText != ""{
            self.resignView()
            let phoneNumber = phoneLabel.replacingOccurrences(of: "\\s", with: "", options: .regularExpression, range: nil)
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
                        if error == .userNameOrPasswordWrong {
                            self.showSingleAlert(NSLocalizedString("AlertTitleLoginFaile", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                            })
                        }else if error == .phoneNotExist{
                            self.showSingleAlert(NSLocalizedString("AlertTitleLoginFaile", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                            })
                        }else if error == .dataIsEmpty{
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
            self.loginButton.isEnabled = false
        }
    }
    
    func forgetButtonClick(_ sender: UIButton){
        self.resignView()
        let setMobileView = CTASetMobileNumberViewController.getInstance()
        setMobileView.isChangeContry = true
        setMobileView.setMobileNumberType = .resetPassword
        self.navigationController?.pushViewController(setMobileView, animated: true)
    }
    
    func registerButtonClick(_ sender: UIButton){
        self.resignView()
        let setMobileView = CTASetMobileNumberViewController.getInstance()
        setMobileView.isChangeContry = true
        setMobileView.setMobileNumberType = .register
        self.navigationController?.pushViewController(setMobileView, animated: true)
    }
    
    func weiboButtonClick(_ sender: UIButton){
        CTASocialManager.oauth(.weibo){ (OAuthInfo, urlResponse, error) -> Void in
            if error == nil {
                if OAuthInfo != nil {
                    self.login(.weibo, OAuthInfo: OAuthInfo, completionHandler: { (resultDic, urlResponse, error) in
                        if error == nil && resultDic != nil {
                            let weiboIDInt:Int = resultDic![key(.weiBoID)] as! Int
                            let weiboID = String(weiboIDInt)
                            let userIconURL:String = resultDic![key(.avatarhd)] as! String
                            let nickName:String = resultDic![key(.weiboName)] as! String
                            let desc:String = resultDic![key(.weiboDesc)] as! String
                            let gender:String = resultDic![key(.gender)] as! String
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
                                        if error == .weixinIDIsEmpty {
                                            self.showSingleAlert(NSLocalizedString("AlertTitleWeiboNil", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                            })
                                        }else if error == .dataIsEmpty{
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
    
    func wechatButtonClick(_ sender: UIButton){
        CTASocialManager.oauth(.weChat) { (resultDic, urlResponse, error) -> Void in
            if error == nil {
                if resultDic != nil {
                    let weixinID:String = resultDic![key(.openid)] as! String
                    let userIconURL:String = resultDic![key(.headimgurl)] as! String
                    let nickName:String = resultDic![key(.wechatName)] as! String
                    let sex:Int = resultDic![key(.sex)] as! Int
                    let country:String = resultDic![key(.country)] as! String
                    let province:String = resultDic![key(.province)] as! String
                    let city:String = resultDic![key(.city)] as! String
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
                                if error == .weixinIDIsEmpty {
                                    self.showSingleAlert(NSLocalizedString("AlertTitleWechatNil", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                    })
                                }else if error == .dataIsEmpty{
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
    func setCountryCode(_ model:CountryZone){
        self.selectedModel = model
        self.changeCountryLabelByModel(selectedModel)
    }
}

extension CTALoginViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
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
                    self.loginButton.isEnabled = true
                }
            }else {
                if newStr.length <= 1 {
                    self.loginButton.isEnabled = false
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
                    self.loginButton.isEnabled = true
                }
            }else {
                if newStr.length <= 6 {
                    self.loginButton.isEnabled = false
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == self.passwordTextinput{
            if self.loginButton.isEnabled {
                self.loginHandler()
            }else {
                textField.resignFirstResponder()
            }
        }
        return true
    }
}

extension CTALoginViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
}
