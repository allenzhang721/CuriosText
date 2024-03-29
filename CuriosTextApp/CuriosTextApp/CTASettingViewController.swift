//
//  CTASettingViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD

class CTASettingViewController: UIViewController, CTAImageControllerProtocol, CTAPublishCellProtocol, CTALoadingProtocol, CTALoginProtocol{
    
    var loadingImageView:UIImageView? = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    var scrollView:UIScrollView!
    var userIconImage:UIImageView!
    let imagePicker:UIImagePickerController = UIImagePickerController()
    
    var userNickNameLabel:UILabel!
    var userSexLabel:UILabel!
    var userRegionLabel:UILabel!
    var userDescLabel:UILabel!
    var descNextImg:UIImageView!
    var descLineImg:UIImageView!
    
    var accountSettingView:UIView!
    var systemSettingView:UIView!
    
    var logoutButton:UIButton!
    
    var isLogin:Bool = false
    var loginUser:CTAUserModel?
    
    var isReset:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.navigationController!.interactivePopGestureRecognizer!.delegate = self
        self.view.backgroundColor = CTAStyleKit.commonBackgroundColor
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        self.resetView()
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
        
        let bounds = UIScreen.mainScreen().bounds
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 64))
        headerView.backgroundColor = CTAStyleKit.commonBackgroundColor
        self.view.addSubview(headerView)
        
        let settingLabel = UILabel(frame: CGRect(x: 0, y: 28, width: bounds.width, height: 28))
        settingLabel.font = UIFont.boldSystemFontOfSize(18)
        settingLabel.textColor = CTAStyleKit.normalColor
        settingLabel.text = NSLocalizedString("SettingLabel", comment: "")
        settingLabel.textAlignment = .Center
        headerView.addSubview(settingLabel)
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 22, width: 40, height: 40))
        backButton.setImage(UIImage(named: "back-button"), forState: .Normal)
        backButton.setImage(UIImage(named: "back-selected-button"), forState: .Highlighted)
        backButton.addTarget(self, action: #selector(CTASettingViewController.backButtonClick(_:)), forControlEvents: .TouchUpInside)
        headerView.addSubview(backButton)
        
        var textLine = UIImageView(frame: CGRect(x: 0, y: 63, width: bounds.width, height: 1))
        textLine.image = UIImage(named: "space-line")
        headerView.addSubview(textLine)
        
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 64, width: bounds.width, height: bounds.height-64))
        self.view.addSubview(self.scrollView)
        
        self.userIconImage = UIImageView(frame: CGRect(x: (bounds.width - 60)/2, y: 20, width: 60*self.getHorRate(), height: 60*self.getHorRate()))
        self.userIconImage.image = UIImage(named: "default-usericon")
        self.cropImageCircle(self.userIconImage)
        self.scrollView.addSubview(self.userIconImage)
        self.userIconImage.userInteractionEnabled = true
        let iconTap = UITapGestureRecognizer(target: self, action: #selector(CTASettingViewController.userIconClick(_:)))
        self.userIconImage.addGestureRecognizer(iconTap)
        
        let imgFrame = self.userIconImage.frame
        let cameraView = UIImageView(frame: CGRect(x: (imgFrame.origin.x+imgFrame.size.width)-20, y: (imgFrame.origin.y+imgFrame.size.height)-20, width: 20, height: 20))
        cameraView.image = UIImage(named: "usercamera-icon")
        self.scrollView.addSubview(cameraView)
        
        self.imagePicker.delegate = self
        
        self.userNickNameLabel = UILabel(frame: CGRect(x: 128*self.getHorRate(), y: 109, width: bounds.width - 153*self.getHorRate() - 15, height: 22))
        self.userNickNameLabel.font = UIFont.systemFontOfSize(16)
        self.userNickNameLabel.textColor = CTAStyleKit.labelShowColor
        self.userNickNameLabel.textAlignment = .Right
        self.scrollView.addSubview(self.userNickNameLabel)
        let userNickNameTitle = UILabel(frame: CGRect(x: 27*self.getHorRate(), y: self.userNickNameLabel.frame.origin.y, width: 50, height: 22))
        userNickNameTitle.font = UIFont.systemFontOfSize(16)
        userNickNameTitle.textColor = CTAStyleKit.normalColor
        userNickNameTitle.text = NSLocalizedString("UserNickNameLabel", comment: "")
        userNickNameTitle.sizeToFit()
        self.scrollView.addSubview(userNickNameTitle)
        var nextImage = UIImageView(frame: CGRect(x: bounds.width - 25*self.getHorRate() - 5, y: self.userNickNameLabel.frame.origin.y+6, width: 6, height: 10))
        nextImage.image = UIImage(named: "next-icon")
        self.scrollView.addSubview(nextImage)
        textLine = UIImageView(frame: CGRect(x: 25*self.getHorRate(), y: self.userNickNameLabel.frame.origin.y + 31, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "space-line")
        self.scrollView.addSubview(textLine)
        self.userNickNameLabel.userInteractionEnabled = true
        let nickNameTap = UITapGestureRecognizer(target: self, action: #selector(CTASettingViewController.userNickNameClick(_:)))
        self.userNickNameLabel.addGestureRecognizer(nickNameTap)
        
        self.userSexLabel = UILabel(frame: CGRect(x: 128*self.getHorRate(), y: self.userNickNameLabel.frame.origin.y+40, width: bounds.width - 153*self.getHorRate() - 15, height: 22))
        self.userSexLabel.font = UIFont.systemFontOfSize(16)
        self.userSexLabel.textColor = CTAStyleKit.labelShowColor
        self.userSexLabel.textAlignment = .Right
        self.scrollView.addSubview(self.userSexLabel)
        let userSexTitle = UILabel(frame: CGRect(x: 27*self.getHorRate(), y: self.userSexLabel.frame.origin.y, width: 50, height: 22))
        userSexTitle.font = UIFont.systemFontOfSize(16)
        userSexTitle.textColor = CTAStyleKit.normalColor
        userSexTitle.text = NSLocalizedString("UserSexLabel", comment: "")
        userSexTitle.sizeToFit()
        self.scrollView.addSubview(userSexTitle)
        nextImage = UIImageView(frame: CGRect(x: bounds.width - 25*self.getHorRate() - 5, y: self.userSexLabel.frame.origin.y+6, width: 6, height: 10))
        nextImage.image = UIImage(named: "next-icon")
        self.scrollView.addSubview(nextImage)
        textLine = UIImageView(frame: CGRect(x: 25*self.getHorRate(), y: self.userSexLabel.frame.origin.y + 31, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "space-line")
        self.scrollView.addSubview(textLine)
        self.userSexLabel.userInteractionEnabled = true
        let userSexTap = UITapGestureRecognizer(target: self, action: #selector(CTASettingViewController.userSexClick(_:)))
        self.userSexLabel.addGestureRecognizer(userSexTap)
        
        self.userRegionLabel = UILabel(frame: CGRect(x: 128*self.getHorRate(), y: self.userSexLabel.frame.origin.y+40, width: bounds.width - 153*self.getHorRate() - 15, height: 22))
        self.userRegionLabel.font = UIFont.systemFontOfSize(16)
        self.userRegionLabel.textColor = CTAStyleKit.labelShowColor
        self.userRegionLabel.textAlignment = .Right
        self.scrollView.addSubview(self.userRegionLabel)
//        let userRegionTitle = UILabel.init(frame: CGRect.init(x: 27*self.getHorRate(), y: self.userRegionLabel.frame.origin.y, width: 50, height: 25))
//        userRegionTitle.font = UIFont.systemFontOfSize(16)
//        userRegionTitle.textColor = CTAStyleKit.normalColor
//        userRegionTitle.text = NSLocalizedString("UserRegion", comment: "")
//        userRegionTitle.sizeToFit()
//        self.scrollView.addSubview(userRegionTitle)
//        nextImage = UIImageView.init(frame: CGRect.init(x: bouns.width - 25*self.getHorRate() - 11, y: self.userRegionLabel.frame.origin.y+2, width: 11, height: 20))
//        nextImage.image = UIImage(named: "next-icon")
//        self.scrollView.addSubview(nextImage)
//        textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: self.userRegionLabel.frame.origin.y + 31, width: 330*self.getHorRate(), height: 1))
//        textLine.image = UIImage(named: "space-line")
//        self.scrollView.addSubview(textLine)
        self.userRegionLabel.userInteractionEnabled = true
        let userRegionTap = UITapGestureRecognizer(target: self, action: #selector(CTASettingViewController.userRegionClick(_:)))
        self.userRegionLabel.addGestureRecognizer(userRegionTap)
        self.userRegionLabel.hidden = true
        
        self.userDescLabel = UILabel(frame: CGRect(x: 128*self.getHorRate(), y: self.userSexLabel.frame.origin.y+40, width: bounds.width - 153*self.getHorRate() - 15, height: 22))
        self.userDescLabel.numberOfLines = 12
        self.userDescLabel.font = UIFont.systemFontOfSize(16)
        self.userDescLabel.textColor = CTAStyleKit.labelShowColor
        self.userDescLabel.textAlignment = .Right
        self.scrollView.addSubview(self.userDescLabel)
        let userDesxTitle = UILabel(frame: CGRect(x: 27*self.getHorRate(), y: self.userDescLabel.frame.origin.y, width: 50, height: 22))
        userDesxTitle.font = UIFont.systemFontOfSize(16)
        userDesxTitle.textColor = CTAStyleKit.normalColor
        userDesxTitle.text = NSLocalizedString("UserDesc", comment: "")
        userDesxTitle.sizeToFit()
        self.scrollView.addSubview(userDesxTitle)
        self.descNextImg = UIImageView(frame: CGRect(x: bounds.width - 25*self.getHorRate() - 5, y: self.userDescLabel.frame.origin.y+6, width: 6, height: 10))
        self.descNextImg.image = UIImage(named: "next-icon")
        self.scrollView.addSubview(self.descNextImg)
        self.descLineImg = UIImageView(frame: CGRect(x: 25*self.getHorRate(), y: self.userDescLabel.frame.origin.y + 31, width: 330*self.getHorRate(), height: 1))
        self.descLineImg.image = UIImage(named: "space-line")
        self.scrollView.addSubview(self.descLineImg)
        self.userDescLabel.userInteractionEnabled = true
        let userDescTap = UITapGestureRecognizer(target: self, action: #selector(CTASettingViewController.userDescClick(_:)))
        self.userDescLabel.addGestureRecognizer(userDescTap)
        
        self.accountSettingView = UIView(frame: CGRect(x: 0, y: self.descLineImg.frame.origin.y + 40, width: bounds.width, height: 80))
        let bindingAccoutView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 40))
        self.accountSettingView.addSubview(bindingAccoutView)
        let bindingAccoutTitle = UILabel(frame: CGRect(x: 27*self.getHorRate(), y: 9, width: 50, height: 22))
        bindingAccoutTitle.font = UIFont.systemFontOfSize(16)
        bindingAccoutTitle.textColor = CTAStyleKit.normalColor
        bindingAccoutTitle.text = NSLocalizedString("BindingAccountLabel", comment: "")
        bindingAccoutTitle.sizeToFit()
        bindingAccoutView.addSubview(bindingAccoutTitle)
        nextImage = UIImageView(frame: CGRect(x: bounds.width - 25*self.getHorRate() - 5, y: 15, width: 6, height: 10))
        nextImage.image = UIImage(named: "next-icon")
        bindingAccoutView.addSubview(nextImage)
        textLine = UIImageView(frame: CGRect(x: 25*self.getHorRate(), y: 0, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "space-line")
        bindingAccoutView.addSubview(textLine)
        textLine = UIImageView(frame: CGRect(x: 25*self.getHorRate(), y: 39, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "space-line")
        bindingAccoutView.addSubview(textLine)
        bindingAccoutView.userInteractionEnabled = true
        let bindingAccoutTap = UITapGestureRecognizer(target: self, action: #selector(CTASettingViewController.bindingAccountClick(_:)))
        bindingAccoutView.addGestureRecognizer(bindingAccoutTap)
        
        let changePasswordView = UIView(frame: CGRect(x: 0, y: bindingAccoutView.frame.origin.y + 40, width: bounds.width, height: 40))
        self.accountSettingView.addSubview(changePasswordView)
        let changePasswordTitle = UILabel(frame: CGRect(x: 27*self.getHorRate(), y: 9, width: 50, height: 22))
        changePasswordTitle.font = UIFont.systemFontOfSize(16)
        changePasswordTitle.textColor = CTAStyleKit.normalColor
        changePasswordTitle.text = NSLocalizedString("ChangePasswordLabel", comment: "")
        changePasswordTitle.sizeToFit()
        changePasswordView.addSubview(changePasswordTitle)
        nextImage = UIImageView(frame: CGRect(x: bounds.width - 25*self.getHorRate() - 5, y: 15, width: 6, height: 10))
        nextImage.image = UIImage(named: "next-icon")
        changePasswordView.addSubview(nextImage)
        textLine = UIImageView(frame: CGRect(x: 25*self.getHorRate(), y: 39, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "space-line")
        changePasswordView.addSubview(textLine)
        changePasswordView.userInteractionEnabled = true
        let changePasswordTap = UITapGestureRecognizer(target: self, action: #selector(CTASettingViewController.changePasswordClick(_:)))
        changePasswordView.addGestureRecognizer(changePasswordTap)
        self.scrollView.addSubview(self.accountSettingView)
        
        self.systemSettingView = UIView(frame: CGRect(x: 0, y: self.descLineImg.frame.origin.y + 160, width: bounds.width, height: 120))
        let aboutView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 40))
        self.systemSettingView.addSubview(aboutView)
        let aboutTitle = UILabel(frame: CGRect(x: 27*self.getHorRate(), y: 9, width: 50, height: 22))
        aboutTitle.font = UIFont.systemFontOfSize(16)
        aboutTitle.textColor = CTAStyleKit.normalColor
        aboutTitle.text = NSLocalizedString("AboutLabel", comment: "")
        aboutTitle.sizeToFit()
        aboutView.addSubview(aboutTitle)
        nextImage = UIImageView(frame: CGRect(x: bounds.width - 25*self.getHorRate() - 5, y: 15, width: 6, height: 10))
        nextImage.image = UIImage(named: "next-icon")
        aboutView.addSubview(nextImage)
        textLine = UIImageView(frame: CGRect(x: 25*self.getHorRate(), y: 0, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "space-line")
        aboutView.addSubview(textLine)
        textLine = UIImageView(frame: CGRect(x: 25*self.getHorRate(), y: 39, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "space-line")
        aboutView.addSubview(textLine)
        aboutView.userInteractionEnabled = true
        let aboutTap = UITapGestureRecognizer(target: self, action: #selector(CTASettingViewController.aboutClick(_:)))
        aboutView.addGestureRecognizer(aboutTap)
        
        let shareToFriendView = UIView(frame: CGRect(x: 0, y: aboutView.frame.origin.y + 40, width: bounds.width, height: 40))
        self.systemSettingView.addSubview(shareToFriendView)
        let shareToFriendTitle = UILabel(frame: CGRect(x: 27*self.getHorRate(), y: 9, width: 50, height: 22))
        shareToFriendTitle.font = UIFont.systemFontOfSize(16)
        shareToFriendTitle.textColor = CTAStyleKit.normalColor
        shareToFriendTitle.text = NSLocalizedString("InviteFriendsLabel", comment: "")
        shareToFriendTitle.sizeToFit()
        shareToFriendView.addSubview(shareToFriendTitle)
        nextImage = UIImageView(frame: CGRect(x: bounds.width - 25*self.getHorRate() - 5, y: 15, width: 6, height: 10))
        nextImage.image = UIImage(named: "next-icon")
        shareToFriendView.addSubview(nextImage)
        textLine = UIImageView(frame: CGRect(x: 25*self.getHorRate(), y: 39, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "space-line")
        shareToFriendView.addSubview(textLine)
        shareToFriendView.userInteractionEnabled = true
        let shareToFriendTap = UITapGestureRecognizer(target: self, action: #selector(CTASettingViewController.shareToFriendClick(_:)))
        shareToFriendView.addGestureRecognizer(shareToFriendTap)
        
        let reviewUSView = UIView(frame: CGRect(x: 0, y: shareToFriendView.frame.origin.y + 40, width: bounds.width, height: 40))
        self.systemSettingView.addSubview(reviewUSView)
        let reviewUSTitle = UILabel(frame: CGRect(x: 27*self.getHorRate(), y: 9, width: 50, height: 22))
        reviewUSTitle.font = UIFont.systemFontOfSize(16)
        reviewUSTitle.textColor = CTAStyleKit.normalColor
        reviewUSTitle.text = NSLocalizedString("ReviewUSLabel", comment: "")
        reviewUSTitle.sizeToFit()
        reviewUSView.addSubview(reviewUSTitle)
        nextImage = UIImageView(frame: CGRect(x: bounds.width - 25*self.getHorRate() - 5, y: 15, width: 6, height: 10))
        nextImage.image = UIImage(named: "next-icon")
        reviewUSView.addSubview(nextImage)
        textLine = UIImageView(frame: CGRect(x: 25*self.getHorRate(), y: 39, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "space-line")
        reviewUSView.addSubview(textLine)
        reviewUSView.userInteractionEnabled = true
        let reviewUSTap = UITapGestureRecognizer(target: self, action: #selector(CTASettingViewController.reviewUSClick(_:)))
        reviewUSView.addGestureRecognizer(reviewUSTap)
        self.scrollView.addSubview(self.systemSettingView)
        
        self.logoutButton = UIButton(frame: CGRect(x: (bounds.width - 40)/2, y: self.descLineImg.frame.origin.y + 320, width: 40, height: 28))
        self.logoutButton.setTitle(NSLocalizedString("LogoutButtonLabel", comment: ""), forState: .Normal)
        self.logoutButton.setTitleColor(CTAStyleKit.selectedColor, forState: .Normal)
        self.logoutButton.setTitleColor(CTAStyleKit.disableColor, forState: .Disabled)
        self.logoutButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        self.logoutButton.sizeToFit()
        self.logoutButton.frame.origin.x = (bounds.width - self.logoutButton.frame.width)/2
        self.logoutButton.addTarget(self, action: #selector(CTASettingViewController.logoutButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.scrollView.addSubview(self.logoutButton)
    }
    
    func reloadView(){
        self.loadLocalUserModel()
        if self.isLogin{
            self.reloadUserIcon()
            self.reloadNickName()
            self.reloadSex()
            self.reloadRegion()
            self.reloadDesc()
            self.resetScrollView()
            if self.isReset{
                self.scrollView.contentOffset.y = 0
                self.isReset = false
            }
        }else {
            self.resetView()
        }
    }
    
    func resetView(){
        self.userIconImage.image = UIImage(named: "default-usericon")
        self.userNickNameLabel.text = ""
        self.userSexLabel.text = ""
        self.userRegionLabel.text = ""
        self.userDescLabel.text = ""
        self.logoutButton.enabled = false
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
    
    func reloadUserIcon(loadImg:UIImage? = nil){
        let imagePath = CTAFilePath.userFilePath+self.loginUser!.userIconURL
        let imageURL = NSURL(string: imagePath)!
        var defaultImg:UIImage!
        if loadImg == nil{
            defaultImg = UIImage(named: "default-usericon")
        }else {
            defaultImg = loadImg
        }
        self.userIconImage.kf_setImageWithURL(imageURL, placeholderImage: defaultImg, optionsInfo: nil) { (image, error, cacheType, imageURL) -> () in
            if error != nil {
                self.userIconImage.image = defaultImg
            }
        }
    }
    
    func reloadNickName(){
        self.userNickNameLabel.text = self.loginUser!.nickName
    }
    
    func reloadSex(){
        if self.loginUser!.sex == 1{
            self.userSexLabel.text = NSLocalizedString("UserMaleLabel", comment: "")
        }else if self.loginUser!.sex == 2{
            self.userSexLabel.text = NSLocalizedString("UserFemaleLabel", comment: "")
        }else {
            self.userSexLabel.text = "  "
        }
    }
    
    func reloadRegion(){
        
    }
    
    func reloadDesc(){
        let bouns = UIScreen.mainScreen().bounds
        self.userDescLabel.text = self.loginUser!.userDesc
        self.userDescLabel.sizeToFit()
        let maxW = bouns.width - 153*self.getHorRate() - 15
        self.userDescLabel.frame.size.width = maxW
        let texth = self.userDescLabel.frame.height
        if texth < 37{
            self.userDescLabel.frame.size.height = 22
            self.userDescLabel.textAlignment = .Right
            self.descNextImg.frame.origin.y = self.userDescLabel.frame.origin.y+6
            self.descLineImg.frame.origin.y = self.userDescLabel.frame.origin.y+31
        }else {
            self.userDescLabel.textAlignment = .Right
            self.descNextImg.frame.origin.y = self.userDescLabel.frame.origin.y + texth - 14
            self.descLineImg.frame.origin.y = self.userDescLabel.frame.origin.y + texth + 6
        }
        
        self.accountSettingView.frame.origin.y = self.descLineImg.frame.origin.y + 40
        self.systemSettingView.frame.origin.y = self.descLineImg.frame.origin.y + 160
        self.logoutButton.enabled = true
        self.logoutButton.frame.origin.y = self.descLineImg.frame.origin.y + 320
    }
    
    func resetScrollView(){
        let bouns = UIScreen.mainScreen().bounds
        let maxHeight = self.logoutButton.frame.origin.y + self.logoutButton.frame.width + 5
        self.scrollView.contentSize = CGSize(width: bouns.width, height: maxHeight)
    }
    
    func backButtonClick(sender: UIButton){
        self.backHandler()
    }
    
    func backHandler(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func userIconClick(sender: UIPanGestureRecognizer){
        if self.isLogin{
            var alertArray:Array<[String : AnyObject]> = []
            
            alertArray.append(["title":LocalStrings.TakePhoto.description])
            alertArray.append(["title":LocalStrings.ChoosePhoto.description])
            self.showSheetAlert(LocalStrings.PhotoTitle.description, okAlertArray: alertArray, cancelAlertLabel: LocalStrings.Cancel.description) { (index) -> Void in
                if index == 0{
                    self.imagePicker.allowsEditing = true
                    self.imagePicker.sourceType = .Camera
                    self.presentViewController(self.imagePicker, animated: true, completion: nil)
                }else if index == 1{
                    self.imagePicker.allowsEditing = true
                    self.imagePicker.sourceType = .PhotoLibrary
                    self.presentViewController(self.imagePicker, animated: true, completion: nil)
                }
            }
        }
    }
    
    func userNickNameClick(sender: UIPanGestureRecognizer){
        if isLogin {
            let setInfo = CTASetUserInfoViewController()
            setInfo.setUser = self.loginUser!
            setInfo.setType = .NickName
            self.navigationController?.pushViewController(setInfo, animated: true)
        }
    }
    
    func userSexClick(sender: UIPanGestureRecognizer){
        if isLogin {
            var alertArray:Array<[String : AnyObject]> = []
            alertArray.append(["title":NSLocalizedString("UserMaleLabel", comment: "")])
            alertArray.append(["title":NSLocalizedString("UserFemaleLabel", comment: "")])
            self.showSheetAlert(nil, okAlertArray: alertArray, cancelAlertLabel: LocalStrings.Cancel.description) { (index) -> Void in
                if index != -1{
                    let sexIndex = index + 1
                    self.loginUser!.sex = sexIndex
                    self.reloadSex()
                    CTAUserDomain.getInstance().updateUserSex(self.loginUser!.userID, sex: sexIndex, compelecationBlock: { (info) -> Void in
                        if info.result{
                            self.changeLoginUser()
                        }
                    })
                }
            }
        }
    }
    
    func userRegionClick(sender: UIPanGestureRecognizer){
        print("userRegionClick")
    }
    
    func userDescClick(sender: UIPanGestureRecognizer){
        if isLogin {
            let setInfo = CTASetUserInfoViewController()
            setInfo.setUser = self.loginUser!
            setInfo.setType = .Desc
            self.navigationController?.pushViewController(setInfo, animated: true)
        }
    }
    
    func bindingAccountClick(sender: UIPanGestureRecognizer){
        if isLogin {
            let accountSetting = CTAAccountSettingViewController()
            self.navigationController?.pushViewController(accountSetting, animated: true)
        }
    }
    
    func changePasswordClick(sender: UIPanGestureRecognizer){
        if isLogin {
            let userPhone = self.loginUser!.phone
            if userPhone == "" {
                self.showSelectedAlert(NSLocalizedString("AlertTitleSetPhoneFirst", comment: ""), alertMessage: "", okAlertLabel: LocalStrings.Setting.description, cancelAlertLabel: LocalStrings.Cancel.description, compelecationBlock: { (result) in
                    if result {
                        let setMobileView = CTASetMobileNumberViewController.getInstance()
                        setMobileView.isChangeContry = true
                        setMobileView.setMobileNumberType = .setMobileNumber
                        let navigationController = UINavigationController(rootViewController: setMobileView)
                        navigationController.navigationBarHidden = true
                        self.presentViewController(navigationController, animated: true, completion: {
                        })
                    }
                })
            }else {
                self.showTextAlert(NSLocalizedString("ChangePasswordLabel", comment: ""), alertMessage: NSLocalizedString("AlertCurrentPassword", comment: ""), okAlertLabel: LocalStrings.OK.description, cancelAlertLabel: LocalStrings.Cancel.description, compelecationBlock: { (result, password) in
                    if result{
                        SVProgressHUD.setDefaultMaskType(.Clear)
                        SVProgressHUD.showWithStatus("")
                        let userID = self.loginUser!.userID
                        let cryptPassword = CTAEncryptManager.hash256(password)
                        CTAUserDomain.getInstance().checkPassword(userID, passwd: cryptPassword, compelecationBlock: { (info) in
                            SVProgressHUD.dismiss()
                            if info.result{
                                let setView = CTASetPasswordViewController.getInstance()
                                setView.userModel = self.loginUser!
                                setView.setPasswordType = .changePassword
                                self.presentViewController(setView, animated: true, completion: {
                                })
                            }else {
                                if info.errorType is CTAInternetError {
                                    self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                    })
                                }else {
                                    let error = info.errorType as! CTACheckPasswordError
                                    if error == .PasswordIncorrect {
                                        self.showSingleAlert(NSLocalizedString("AlertTitlePasswordIncorrect", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                        })
                                    }else if error == .UserIDNotExist || error == .UserIDIsEmpty{
                                        self.showSingleAlert(NSLocalizedString("AlertTitleUserIDNotExist", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
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
        }
    }
    
    func aboutClick(sender: UIPanGestureRecognizer){
        if let vc = Moduler.module_aboutUS() {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func shareToFriendClick(sender: UIPanGestureRecognizer){
        let shareView = CTAShareView.getInstance()
        shareView.delegate = self
        let mainController = CTAMainViewController.getInstance()
        if self.view.isDescendantOfView(mainController.view){
            mainController.view.addSubview(shareView)
        }else {
            self.view.superview?.addSubview(shareView)
        }
        shareView.shareType = .setting
        shareView.showViewHandler()
    }
    
    func reviewUSClick(sender: UIPanGestureRecognizer){
        gobal_jumpToAppStoreRation()
    }
    
    func logoutButtonClick(sender: UIButton){
        if isLogin{
            var alertArray:Array<[String: AnyObject]> = []
            alertArray.append(["title":NSLocalizedString("LogoutButtonLabel", comment: ""), "style": "Destructive"])
            let alertTile = NSLocalizedString("ConfirmLogoutLabel", comment: "")
            self.showSheetAlert(alertTile, okAlertArray: alertArray, cancelAlertLabel: LocalStrings.Cancel.description) { (index) -> Void in
                if index != -1{
                    if CTAUserManager.logout() {
                        self.showLoginView(false)
                        self.backHandler()
                    }
                }
            }
        }
    }
    
    func changeUserIcon(icon:UIImage){
        if self.isLogin{
            self.uploadUserIcon(self.loginUser!, icon: icon)
        }
    }
    
    func changeLoginUser(){
        CTAUserManager.logout()
        CTAUserManager.save(self.loginUser!)
    }
}

extension CTASettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.changeUserIcon(pickedImage)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension CTASettingViewController: CTAUploadIconProtocol{
    func uploadBegin(){
        SVProgressHUD.setDefaultMaskType(.Clear)
        SVProgressHUD.showWithStatus(NSLocalizedString("UploadProgressLabel", comment: ""))
    }
    
    func uploadComplete(result:Bool, iconPath:String, icon:UIImage?){
        if result{
            CTAUserDomain.getInstance().updateUserIconURL(self.loginUser!.userID, userIconURL: iconPath, compelecationBlock: { (info) -> Void in
                SVProgressHUD.dismiss()
                if info.result{
                    self.loginUser!.userIconURL = iconPath
                    self.changeLoginUser()
                    self.reloadUserIcon(icon)
                }else {
                    self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                    })
                }
            })
        }else {
            SVProgressHUD.dismiss()
        }
    }
}

extension CTASettingViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension CTASettingViewController: CTAShareViewDelegate{
    
    func addShareURL(shareURL:String) -> String{
        var url = shareURL
        if let info = NSBundle.mainBundle().infoDictionary {
            let appVersion = info["CFBundleShortVersionString"] as! String
            url = url+"&v="+appVersion
        }
        if CTAUserManager.isLogin{
            let userID = CTAUserManager.user?.userID
            url = url+"&uid="+userID!
        }
        return url
    }
    
    func weChatShareHandler(){
        var shareURL = CTAShareConfig.shareURL
        shareURL = shareURL+"?sto=wechat_friend&sfrom=invite"
        shareURL = self.addShareURL(shareURL)
        let url = NSURL(string: shareURL)!
        CTASocialManager.shareMessage(CTASocialManager.Message.WeChat(CTASocialManager.Message.WeChatSubtype.Session(info: (title: "奇思-让图片更有意思", description: "这个应用很好玩，可以给照片添加会动的文字，快来下载吧！", thumbnail: UIImage(named: "ShareIcon"), media: CTASocialManager.Media.URL(url))))) { (result) in
        }
        
    }
    func momentsShareHandler(){
        var shareURL = CTAShareConfig.shareURL
        shareURL = shareURL+"?sto=wechat_moment&sfrom=invite"
        shareURL = self.addShareURL(shareURL)
        let url = NSURL(string: shareURL)!
        CTASocialManager.shareMessage(CTASocialManager.Message.WeChat(CTASocialManager.Message.WeChatSubtype.Timeline(info: (title: "奇思-让图片更有意思", description: "这个应用很好玩，可以给照片添加会动的文字，快来下载吧！", thumbnail: UIImage(named: "ShareIcon"), media: CTASocialManager.Media.URL(url))))) { (result) in
        }
    }
    func weiBoShareHandler(){
        var shareURL = CTAShareConfig.shareURL
        shareURL = shareURL+"?sto=weibo&sfrom=invite"
        shareURL = self.addShareURL(shareURL)
        let url = NSURL(string: shareURL)!
        CTASocialManager.shareMessage(CTASocialManager.Message.Weibo(CTASocialManager.Message.WeiboSubtype.Default(info: (title: "奇思-让图片更有意思", description: "奇思, 让图片更有意思! 这个应用很好玩，可以给照片添加会动的文字，快来下载吧！", thumbnail: UIImage(named: "ShareIcon"), media: CTASocialManager.Media.URL(url)), accessToken: ""))) { (result) in
            
        }
        
//        CTASocialManager.shareMessage(CTASocialManager.Message.Weibo(CTASocialManager.Message.Weibo(info: (title: "奇思-让图片更有意思", description: "这个应用很好玩，可以给照片添加会动的文字，快来下载吧！", thumbnail: UIImage(named: "fresh-icon-1"), media: CTASocialManager.Media.URL(url))))) { (result) in
//        }
        
    }
    func deleteHandler(){
        
    }
    func copyLinkHandler(){
        
    }
    func saveLocalHandler(){
        
    }
    func reportHandler(){
        
    }
    func uploadResourceHandler(){
        
    }
    func addToHotHandler(){
        
    }
}
