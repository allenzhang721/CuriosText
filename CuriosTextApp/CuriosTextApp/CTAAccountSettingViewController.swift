//
//  CTAAccountSettingViewController.swift
//  CuriosTextApp
//
//  Created by allen on 16/5/23.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation
import SVProgressHUD

class CTAAccountSettingViewController: UIViewController, CTAPublishCellProtocol, CTAAlertProtocol{

    static var _instance:CTAAccountSettingViewController?;
    
    static func getInstance() -> CTAAccountSettingViewController{
        if _instance == nil{
            _instance = CTAAccountSettingViewController();
        }
        return _instance!
    }
    
    var loginUser:CTAUserModel?
    var phoneNumberLabel:UILabel!
    var wechatLabel:UILabel!
    var weiboLabel:UILabel!
    
    var isLogin:Bool = true
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.navigationController!.interactivePopGestureRecognizer!.delegate = self
        self.view.backgroundColor = CTAStyleKit.lightGrayBackgroundColor
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadView()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView(){
        
        let bouns = UIScreen.mainScreen().bounds
        let settingLabel = UILabel.init(frame: CGRect.init(x: 0, y: 8, width: bouns.width, height: 28))
        settingLabel.font = UIFont.systemFontOfSize(18)
        settingLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        settingLabel.text = NSLocalizedString("AccountLabel", comment: "")
        settingLabel.textAlignment = .Center
        self.view.addSubview(settingLabel)
        
        let backButton = UIButton.init(frame: CGRect.init(x: 0, y: 2, width: 40, height: 40))
        backButton.setImage(UIImage(named: "back-button"), forState: .Normal)
        backButton.setImage(UIImage(named: "back-selected-button"), forState: .Highlighted)
        backButton.addTarget(self, action: #selector(CTAAccountSettingViewController.backButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton)
        
        let phoneView = UIView(frame: CGRect(x: 0, y: 64, width: bouns.width, height: 40))
        let phoneTitle = UILabel(frame: CGRect(x: 27*self.getHorRate(), y: 9, width: 50, height: 22))
        phoneTitle.font = UIFont.systemFontOfSize(16)
        phoneTitle.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        phoneTitle.text = NSLocalizedString("PhoneLabel", comment: "")
        phoneTitle.sizeToFit()
        phoneView.addSubview(phoneTitle)
        var nextImage = UIImageView.init(frame: CGRect.init(x: bouns.width - 25*self.getHorRate() - 5, y: 15, width: 6, height: 10))
        nextImage.image = UIImage(named: "next-icon")
        phoneView.addSubview(nextImage)
        var textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: 0, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "textinput-line")
        phoneView.addSubview(textLine)
        textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: 39, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "textinput-line")
        phoneView.addSubview(textLine)
        self.phoneNumberLabel = UILabel.init(frame: CGRect.init(x: 128*self.getHorRate(), y: 9, width: bouns.width - 153*self.getHorRate() - 15, height: 22))
        self.phoneNumberLabel.font = UIFont.systemFontOfSize(16)
        self.phoneNumberLabel.textColor = UIColor.init(red: 108/255, green: 108/255, blue: 108/255, alpha: 1.0)
        self.phoneNumberLabel.textAlignment = .Right
        phoneView.addSubview(self.phoneNumberLabel)
        phoneView.userInteractionEnabled = true
        let phoneTap = UITapGestureRecognizer(target: self, action: #selector(CTAAccountSettingViewController.phoneViewClick(_:)))
        phoneView.addGestureRecognizer(phoneTap)
        self.view.addSubview(phoneView)
        
        let weChatView = UIView(frame: CGRect(x: 0, y: 104, width: bouns.width, height: 40))
        let weChatTitle = UILabel(frame: CGRect(x: 27*self.getHorRate(), y: 9, width: 50, height: 22))
        weChatTitle.font = UIFont.systemFontOfSize(16)
        weChatTitle.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        weChatTitle.text = NSLocalizedString("WechatLabel", comment: "")
        weChatTitle.sizeToFit()
        weChatView.addSubview(weChatTitle)
        nextImage = UIImageView.init(frame: CGRect.init(x: bouns.width - 25*self.getHorRate() - 5, y: 15, width: 6, height: 10))
        nextImage.image = UIImage(named: "next-icon")
        weChatView.addSubview(nextImage)
        textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: 39, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "textinput-line")
        weChatView.addSubview(textLine)
        self.wechatLabel = UILabel.init(frame: CGRect.init(x: 128*self.getHorRate(), y: 9, width: bouns.width - 153*self.getHorRate() - 15, height: 22))
        self.wechatLabel.font = UIFont.systemFontOfSize(16)
        self.wechatLabel.textColor = UIColor.init(red: 108/255, green: 108/255, blue: 108/255, alpha: 1.0)
        self.wechatLabel.textAlignment = .Right
        weChatView.addSubview(self.wechatLabel)
        weChatView.userInteractionEnabled = true
        let wechatTap = UITapGestureRecognizer(target: self, action: #selector(CTAAccountSettingViewController.wechatViewClick(_:)))
        weChatView.addGestureRecognizer(wechatTap)
        self.view.addSubview(weChatView)
        
        let weiboView = UIView(frame: CGRect(x: 0, y: 144, width: bouns.width, height: 40))
        let weiboTitle = UILabel(frame: CGRect(x: 27*self.getHorRate(), y: 9, width: 50, height: 22))
        weiboTitle.font = UIFont.systemFontOfSize(16)
        weiboTitle.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        weiboTitle.text = NSLocalizedString("WeiboLabel", comment: "")
        weiboTitle.sizeToFit()
        weiboView.addSubview(weiboTitle)
        nextImage = UIImageView.init(frame: CGRect.init(x: bouns.width - 25*self.getHorRate() - 5, y: 15, width: 6, height: 10))
        nextImage.image = UIImage(named: "next-icon")
        weiboView.addSubview(nextImage)
        textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: 39, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "textinput-line")
        weiboView.addSubview(textLine)
        self.weiboLabel = UILabel.init(frame: CGRect.init(x: 128*self.getHorRate(), y: 9, width: bouns.width - 153*self.getHorRate() - 15, height: 22))
        self.weiboLabel.font = UIFont.systemFontOfSize(16)
        self.weiboLabel.textColor = UIColor.init(red: 108/255, green: 108/255, blue: 108/255, alpha: 1.0)
        self.weiboLabel.textAlignment = .Right
        weiboView.addSubview(self.weiboLabel)
        weiboView.userInteractionEnabled = true
        let weiboTap = UITapGestureRecognizer(target: self, action: #selector(CTAAccountSettingViewController.weiboViewClick(_:)))
        weiboView.addGestureRecognizer(weiboTap)
        self.view.addSubview(weiboView)
    }
    
    func reloadView(){
        self.loadLocalUserModel()
        if self.isLogin{
            let phone = self.loginUser!.phone
            self.phoneNumberLabel.text = phone == "" ? NSLocalizedString("UnlinkedLabel", comment: "") : phone
            self.reloadWechat()
            self.reloadWeibo()
        }else {
            self.phoneNumberLabel.text = ""
            self.wechatLabel.text = ""
            self.weiboLabel.text = ""
        }
    }
    
    func reloadWechat(){
        let wechatID = self.loginUser!.weixinID
        let wechatMes = wechatID == "" ? NSLocalizedString("UnlinkedLabel", comment: "") : NSLocalizedString("LinkedLabel", comment: "")
        self.wechatLabel.text = wechatMes
    }
    
    func reloadWeibo(){
        let weiboID = self.loginUser!.weiboID
        let weiboMes = weiboID == "" ? NSLocalizedString("UnlinkedLabel", comment: "") : NSLocalizedString("LinkedLabel", comment: "")
        self.weiboLabel.text = weiboMes
    }
    
    func loadLocalUserModel(){
        if CTAUserManager.isLogin{
            self.loginUser = CTAUserManager.user
            self.isLogin = true
        }else {
            self.loginUser = nil
            self.isLogin = false
        }
    }
    
    func backButtonClick(sender: UIButton){
        self.backHandler()
    }
    
    func backHandler(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func phoneViewClick(sender: UIPanGestureRecognizer){
        if isLogin {
            let phone = self.loginUser!.phone
            let setMobileView = CTASetMobileNumberViewController.getInstance()
            setMobileView.isChangeContry = true
            if phone == "" {
                setMobileView.setMobileNumberType = .setMobileNumber
            }else {
                setMobileView.setMobileNumberType = .changeMobileNumber
            }
            let navigationController = UINavigationController(rootViewController: setMobileView)
            navigationController.navigationBarHidden = true
            self.presentViewController(navigationController, animated: true, completion: {
            })
        }
    }
    
    func wechatViewClick(sender: UIPanGestureRecognizer){
        if isLogin {
            let wechatID = self.loginUser!.weixinID
            let userID = self.loginUser!.userID
            if wechatID == "" {
                CTASocialManager.OAuth(.WeChat) { (resultDic, urlResponse, error) -> Void in
                    if error == nil {
                        if resultDic != nil {
                            let weixinID:String = resultDic![key(.Openid)] as! String
                            SVProgressHUD.show()
                            CTAUserDomain.getInstance().bindingUserWeixin(userID, weixinID: weixinID, compelecationBlock: { (info) in
                                SVProgressHUD.dismiss()
                                if info.result{
                                    self.loginUser!.weixinID = weixinID
                                    CTAUserManager.save(self.loginUser!)
                                    self.reloadWechat()
                                }else {
                                    if info.errorType is CTAInternetError {
                                        self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                        })
                                    }else {
                                        let error = info.errorType as! CTABindingUserWeixinError
                                        if error == .UserIDIsEmpty {
                                            self.showSingleAlert(NSLocalizedString("AlertTitleUserNotExist", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                            })
                                        }else if error == .UserIDNotExist {
                                            self.showSingleAlert(NSLocalizedString("AlertTitleUserNotExist", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                            })
                                        }else if error == .WeixinIsEmpty {
                                            self.showSingleAlert(NSLocalizedString("AlertTitleAccountNil", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                            })
                                        }else if error == .WeixinExist {
                                            self.showSingleAlert(NSLocalizedString("AlertTitleAccountRegistExist", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
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
                        }
                    }else {
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
            }else {
                if self.checkUnlinkStyle(){
                    self.showSelectedAlert(NSLocalizedString("AlertTitleUnlink", comment: ""), alertMessage: "", okAlertLabel: LocalStrings.Yes.description, cancelAlertLabel: LocalStrings.No.description, compelecationBlock: { (result) in
                        if result{
                            SVProgressHUD.show()
                            CTAUserDomain.getInstance().unBindingWeixinID(userID, compelecationBlock: { (info) in
                                SVProgressHUD.dismiss()
                                if info.result{
                                    self.loginUser!.weixinID = ""
                                    CTAUserManager.save(self.loginUser!)
                                    self.reloadWechat()
                                }else {
                                    self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                    })
                                }
                            })
                        }
                    })
                }else {
                    self.showSingleAlert(NSLocalizedString("AlertTitleUnlikeAllAccount", comment: ""), alertMessage: "", compelecationBlock: nil)
                }
            }
        }
    }
    
    func weiboViewClick(sender: UIPanGestureRecognizer){
        if isLogin {
            let weiboID = self.loginUser!.weiboID
            let userID = self.loginUser!.userID
            if weiboID == "" {
                CTASocialManager.OAuth(.Weibo){ (OAuthInfo, urlResponse, error) -> Void in
                    if error == nil {
                        if OAuthInfo != nil {
                            let weiboUID = (OAuthInfo?["uid"] ?? OAuthInfo?["userID"]) as? String
                            let weiboID = weiboUID == nil ? "" : weiboUID
                            SVProgressHUD.show()
                            CTAUserDomain.getInstance().bindingUserWeibo(userID, weibo: weiboID!, compelecationBlock: { (info) in
                                SVProgressHUD.dismiss()
                                if info.result{
                                    self.loginUser!.weiboID = weiboID!
                                    CTAUserManager.save(self.loginUser!)
                                    self.reloadWeibo()
                                }else {
                                    if info.errorType is CTAInternetError {
                                        self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                        })
                                    }else {
                                        let error = info.errorType as! CTABindingUserWeiboError
                                        if error == .UserIDIsEmpty {
                                            self.showSingleAlert(NSLocalizedString("AlertTitleUserNotExist", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                            })
                                        }else if error == .UserIDNotExist {
                                            self.showSingleAlert(NSLocalizedString("AlertTitleUserNotExist", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                            })
                                        }else if error == .WeiboIsEmpty {
                                            self.showSingleAlert(NSLocalizedString("AlertTitleAccountNil", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                            })
                                        }else if error == .WeiboExist {
                                            self.showSingleAlert(NSLocalizedString("AlertTitleAccountRegistExist", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
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
            }else {
                if self.checkUnlinkStyle(){
                    self.showSelectedAlert(NSLocalizedString("AlertTitleUnlink", comment: ""), alertMessage: "", okAlertLabel: LocalStrings.Yes.description, cancelAlertLabel: LocalStrings.No.description, compelecationBlock: { (result) in
                        if result{
                            SVProgressHUD.show()
                            CTAUserDomain.getInstance().unBindingWeiboID(userID, compelecationBlock: { (info) in
                                SVProgressHUD.dismiss()
                                if info.result{
                                    self.loginUser!.weiboID = ""
                                    CTAUserManager.save(self.loginUser!)
                                    self.reloadWeibo()
                                }else {
                                    self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                    })
                                }
                            })
                        }
                    })
                }else {
                    self.showSingleAlert(NSLocalizedString("AlertTitleUnlikeAllAccount", comment: ""), alertMessage: "", compelecationBlock: nil)
                }
            }
        }
    }
    
    func checkUnlinkStyle() -> Bool{
        if self.isLogin {
            let phone = self.loginUser!.phone
            let wechatID = self.loginUser!.weixinID
            let weiboID = self.loginUser!.weiboID
            var unLinkCount = 0
            if phone == ""{
                unLinkCount += 1
            }
            if wechatID == ""{
                unLinkCount += 1
            }
            if weiboID == "" {
                unLinkCount += 1
            }
            if unLinkCount < 2{
                return true
            }else {
                return false
            }
        }else {
            return false
        }
        
    }
}

extension CTAAccountSettingViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}