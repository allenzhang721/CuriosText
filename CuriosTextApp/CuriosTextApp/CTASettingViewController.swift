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
    
    var loadingImageView:UIImageView? = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
    
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
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.navigationController!.interactivePopGestureRecognizer!.delegate = self
        self.view.backgroundColor = CTAStyleKit.lightGrayBackgroundColor
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
        
        let bouns = UIScreen.mainScreen().bounds
        let settingLabel = UILabel.init(frame: CGRect.init(x: 0, y: 8, width: bouns.width, height: 28))
        settingLabel.font = UIFont.systemFontOfSize(18)
        settingLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        settingLabel.text = NSLocalizedString("SettingLabel", comment: "")
        settingLabel.textAlignment = .Center
        self.view.addSubview(settingLabel)
        
        let backButton = UIButton.init(frame: CGRect.init(x: 0, y: 2, width: 40, height: 40))
        backButton.setImage(UIImage(named: "back-button"), forState: .Normal)
        backButton.setImage(UIImage(named: "back-selected-button"), forState: .Highlighted)
        backButton.addTarget(self, action: #selector(CTASettingViewController.backButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton)
        
        self.scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 44, width: bouns.width, height: bouns.height-44))
        self.view.addSubview(self.scrollView)
        
        self.userIconImage = UIImageView.init(frame: CGRect.init(x: (bouns.width - 60)/2, y: 20, width: 60*self.getHorRate(), height: 60*self.getHorRate()))
        self.userIconImage.image = UIImage(named: "default-usericon")
        self.cropImageCircle(self.userIconImage)
        self.scrollView.addSubview(self.userIconImage)
        self.userIconImage.userInteractionEnabled = true
        let iconTap = UITapGestureRecognizer(target: self, action: #selector(CTASettingViewController.userIconClick(_:)))
        self.userIconImage.addGestureRecognizer(iconTap)
        
        let imgFrame = self.userIconImage.frame
        let cameraView = UIImageView.init(frame: CGRect.init(x: (imgFrame.origin.x+imgFrame.size.width)-20, y: (imgFrame.origin.y+imgFrame.size.height)-20, width: 20, height: 20))
        cameraView.image = UIImage.init(named: "usercamera-icon")
        self.scrollView.addSubview(cameraView)
        
        self.imagePicker.delegate = self
        
        self.userNickNameLabel = UILabel.init(frame: CGRect.init(x: 128*self.getHorRate(), y: 109, width: bouns.width - 153*self.getHorRate() - 15, height: 22))
        self.userNickNameLabel.font = UIFont.systemFontOfSize(16)
        self.userNickNameLabel.textColor = UIColor.init(red: 108/255, green: 108/255, blue: 108/255, alpha: 1.0)
        self.userNickNameLabel.textAlignment = .Right
        self.scrollView.addSubview(self.userNickNameLabel)
        let userNickNameTitle = UILabel.init(frame: CGRect.init(x: 27*self.getHorRate(), y: self.userNickNameLabel.frame.origin.y, width: 50, height: 22))
        userNickNameTitle.font = UIFont.systemFontOfSize(16)
        userNickNameTitle.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        userNickNameTitle.text = NSLocalizedString("UserNickNameLabel", comment: "")
        userNickNameTitle.sizeToFit()
        self.scrollView.addSubview(userNickNameTitle)
        var nextImage = UIImageView.init(frame: CGRect.init(x: bouns.width - 25*self.getHorRate() - 5, y: self.userNickNameLabel.frame.origin.y+8, width: 6, height: 10))
        nextImage.image = UIImage(named: "next-icon")
        self.scrollView.addSubview(nextImage)
        var textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: self.userNickNameLabel.frame.origin.y + 31, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "textinput-line")
        self.scrollView.addSubview(textLine)
        self.userNickNameLabel.userInteractionEnabled = true
        let nickNameTap = UITapGestureRecognizer(target: self, action: #selector(CTASettingViewController.userNickNameClick(_:)))
        self.userNickNameLabel.addGestureRecognizer(nickNameTap)
        
        self.userSexLabel = UILabel.init(frame: CGRect.init(x: 128*self.getHorRate(), y: self.userNickNameLabel.frame.origin.y+40, width: bouns.width - 153*self.getHorRate() - 15, height: 22))
        self.userSexLabel.font = UIFont.systemFontOfSize(16)
        self.userSexLabel.textColor = UIColor.init(red: 108/255, green: 108/255, blue: 108/255, alpha: 1.0)
        self.userSexLabel.textAlignment = .Right
        self.scrollView.addSubview(self.userSexLabel)
        let userSexTitle = UILabel.init(frame: CGRect.init(x: 27*self.getHorRate(), y: self.userSexLabel.frame.origin.y, width: 50, height: 22))
        userSexTitle.font = UIFont.systemFontOfSize(16)
        userSexTitle.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        userSexTitle.text = NSLocalizedString("UserSexLabel", comment: "")
        userSexTitle.sizeToFit()
        self.scrollView.addSubview(userSexTitle)
        nextImage = UIImageView.init(frame: CGRect.init(x: bouns.width - 25*self.getHorRate() - 5, y: self.userSexLabel.frame.origin.y+8, width: 6, height: 10))
        nextImage.image = UIImage(named: "next-icon")
        self.scrollView.addSubview(nextImage)
        textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: self.userSexLabel.frame.origin.y + 31, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "textinput-line")
        self.scrollView.addSubview(textLine)
        self.userSexLabel.userInteractionEnabled = true
        let userSexTap = UITapGestureRecognizer(target: self, action: #selector(CTASettingViewController.userSexClick(_:)))
        self.userSexLabel.addGestureRecognizer(userSexTap)
        
        self.userRegionLabel = UILabel.init(frame: CGRect.init(x: 128*self.getHorRate(), y: self.userSexLabel.frame.origin.y+40, width: bouns.width - 153*self.getHorRate() - 15, height: 22))
        self.userRegionLabel.font = UIFont.systemFontOfSize(16)
        self.userRegionLabel.textColor = UIColor.init(red: 108/255, green: 108/255, blue: 108/255, alpha: 1.0)
        self.userRegionLabel.textAlignment = .Right
        self.scrollView.addSubview(self.userRegionLabel)
//        let userRegionTitle = UILabel.init(frame: CGRect.init(x: 27*self.getHorRate(), y: self.userRegionLabel.frame.origin.y, width: 50, height: 25))
//        userRegionTitle.font = UIFont.systemFontOfSize(16)
//        userRegionTitle.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
//        userRegionTitle.text = NSLocalizedString("UserRegion", comment: "")
//        userRegionTitle.sizeToFit()
//        self.scrollView.addSubview(userRegionTitle)
//        nextImage = UIImageView.init(frame: CGRect.init(x: bouns.width - 25*self.getHorRate() - 11, y: self.userRegionLabel.frame.origin.y+2, width: 11, height: 20))
//        nextImage.image = UIImage(named: "next-icon")
//        self.scrollView.addSubview(nextImage)
//        textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: self.userRegionLabel.frame.origin.y + 31, width: 330*self.getHorRate(), height: 1))
//        textLine.image = UIImage(named: "textinput-line")
//        self.scrollView.addSubview(textLine)
        self.userRegionLabel.userInteractionEnabled = true
        let userRegionTap = UITapGestureRecognizer(target: self, action: #selector(CTASettingViewController.userRegionClick(_:)))
        self.userRegionLabel.addGestureRecognizer(userRegionTap)
        self.userRegionLabel.hidden = true
        
        self.userDescLabel = UILabel.init(frame: CGRect.init(x: 128*self.getHorRate(), y: self.userSexLabel.frame.origin.y+40, width: bouns.width - 153*self.getHorRate() - 15, height: 22))
        self.userDescLabel.numberOfLines = 12
        self.userDescLabel.font = UIFont.systemFontOfSize(16)
        self.userDescLabel.textColor = UIColor.init(red: 108/255, green: 108/255, blue: 108/255, alpha: 1.0)
        self.userDescLabel.textAlignment = .Right
        self.scrollView.addSubview(self.userDescLabel)
        let userDesxTitle = UILabel.init(frame: CGRect.init(x: 27*self.getHorRate(), y: self.userDescLabel.frame.origin.y, width: 50, height: 22))
        userDesxTitle.font = UIFont.systemFontOfSize(16)
        userDesxTitle.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        userDesxTitle.text = NSLocalizedString("UserDesc", comment: "")
        userDesxTitle.sizeToFit()
        self.scrollView.addSubview(userDesxTitle)
        self.descNextImg = UIImageView.init(frame: CGRect.init(x: bouns.width - 25*self.getHorRate() - 5, y: self.userDescLabel.frame.origin.y+8, width: 6, height: 10))
        self.descNextImg.image = UIImage(named: "next-icon")
        self.scrollView.addSubview(self.descNextImg)
        self.descLineImg = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: self.userDescLabel.frame.origin.y + 31, width: 330*self.getHorRate(), height: 1))
        self.descLineImg.image = UIImage(named: "textinput-line")
        self.scrollView.addSubview(self.descLineImg)
        self.userDescLabel.userInteractionEnabled = true
        let userDescTap = UITapGestureRecognizer(target: self, action: #selector(CTASettingViewController.userDescClick(_:)))
        self.userDescLabel.addGestureRecognizer(userDescTap)
        
        self.accountSettingView = UIView(frame: CGRect(x: 0, y: self.descLineImg.frame.origin.y + 40, width: bouns.width, height: 80))
        let bindingAccoutView = UIView(frame: CGRect(x: 0, y: 0, width: bouns.width, height: 40))
        self.accountSettingView.addSubview(bindingAccoutView)
        let bindingAccoutTitle = UILabel(frame: CGRect(x: 27*self.getHorRate(), y: 9, width: 50, height: 22))
        bindingAccoutTitle.font = UIFont.systemFontOfSize(16)
        bindingAccoutTitle.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        bindingAccoutTitle.text = NSLocalizedString("BindingAccountLabel", comment: "")
        bindingAccoutTitle.sizeToFit()
        bindingAccoutView.addSubview(bindingAccoutTitle)
        nextImage = UIImageView.init(frame: CGRect.init(x: bouns.width - 25*self.getHorRate() - 5, y: 17, width: 6, height: 10))
        nextImage.image = UIImage(named: "next-icon")
        bindingAccoutView.addSubview(nextImage)
        textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: 0, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "textinput-line")
        bindingAccoutView.addSubview(textLine)
        textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: 39, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "textinput-line")
        bindingAccoutView.addSubview(textLine)
        bindingAccoutView.userInteractionEnabled = true
        let bindingAccoutTap = UITapGestureRecognizer(target: self, action: #selector(CTASettingViewController.bindingAccountClick(_:)))
        bindingAccoutView.addGestureRecognizer(bindingAccoutTap)
        
        let changePasswordView = UIView(frame: CGRect(x: 0, y: bindingAccoutView.frame.origin.y + 40, width: bouns.width, height: 40))
        self.accountSettingView.addSubview(changePasswordView)
        let changePasswordTitle = UILabel(frame: CGRect(x: 27*self.getHorRate(), y: 9, width: 50, height: 22))
        changePasswordTitle.font = UIFont.systemFontOfSize(16)
        changePasswordTitle.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        changePasswordTitle.text = NSLocalizedString("ChangePasswordLabel", comment: "")
        changePasswordTitle.sizeToFit()
        changePasswordView.addSubview(changePasswordTitle)
        nextImage = UIImageView.init(frame: CGRect.init(x: bouns.width - 25*self.getHorRate() - 5, y: 17, width: 6, height: 10))
        nextImage.image = UIImage(named: "next-icon")
        changePasswordView.addSubview(nextImage)
        textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: 39, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "textinput-line")
        changePasswordView.addSubview(textLine)
        changePasswordView.userInteractionEnabled = true
        let changePasswordTap = UITapGestureRecognizer(target: self, action: #selector(CTASettingViewController.changePasswordClick(_:)))
        changePasswordView.addGestureRecognizer(changePasswordTap)
        self.scrollView.addSubview(self.accountSettingView)
        
        self.systemSettingView = UIView(frame: CGRect(x: 0, y: self.descLineImg.frame.origin.y + 160, width: bouns.width, height: 120))
        let aboutView = UIView(frame: CGRect(x: 0, y: 0, width: bouns.width, height: 40))
        self.systemSettingView.addSubview(aboutView)
        let aboutTitle = UILabel(frame: CGRect(x: 27*self.getHorRate(), y: 9, width: 50, height: 22))
        aboutTitle.font = UIFont.systemFontOfSize(16)
        aboutTitle.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        aboutTitle.text = NSLocalizedString("AboutLabel", comment: "")
        aboutTitle.sizeToFit()
        aboutView.addSubview(aboutTitle)
        nextImage = UIImageView.init(frame: CGRect.init(x: bouns.width - 25*self.getHorRate() - 5, y: 17, width: 6, height: 10))
        nextImage.image = UIImage(named: "next-icon")
        aboutView.addSubview(nextImage)
        textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: 0, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "textinput-line")
        aboutView.addSubview(textLine)
        textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: 39, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "textinput-line")
        aboutView.addSubview(textLine)
        aboutView.userInteractionEnabled = true
        let aboutTap = UITapGestureRecognizer(target: self, action: #selector(CTASettingViewController.aboutClick(_:)))
        aboutView.addGestureRecognizer(aboutTap)
        
        let shareToFriendView = UIView(frame: CGRect(x: 0, y: aboutView.frame.origin.y + 40, width: bouns.width, height: 40))
        self.systemSettingView.addSubview(shareToFriendView)
        let shareToFriendTitle = UILabel(frame: CGRect(x: 27*self.getHorRate(), y: 9, width: 50, height: 22))
        shareToFriendTitle.font = UIFont.systemFontOfSize(16)
        shareToFriendTitle.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        shareToFriendTitle.text = NSLocalizedString("InviteFriendsLabel", comment: "")
        shareToFriendTitle.sizeToFit()
        shareToFriendView.addSubview(shareToFriendTitle)
        nextImage = UIImageView.init(frame: CGRect.init(x: bouns.width - 25*self.getHorRate() - 5, y: 17, width: 6, height: 10))
        nextImage.image = UIImage(named: "next-icon")
        shareToFriendView.addSubview(nextImage)
        textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: 39, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "textinput-line")
        shareToFriendView.addSubview(textLine)
        shareToFriendView.userInteractionEnabled = true
        let shareToFriendTap = UITapGestureRecognizer(target: self, action: #selector(CTASettingViewController.shareToFriendClick(_:)))
        shareToFriendView.addGestureRecognizer(shareToFriendTap)
        
        let reviewUSView = UIView(frame: CGRect(x: 0, y: shareToFriendView.frame.origin.y + 40, width: bouns.width, height: 40))
        self.systemSettingView.addSubview(reviewUSView)
        let reviewUSTitle = UILabel(frame: CGRect(x: 27*self.getHorRate(), y: 9, width: 50, height: 22))
        reviewUSTitle.font = UIFont.systemFontOfSize(16)
        reviewUSTitle.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        reviewUSTitle.text = NSLocalizedString("ReviewUSLabel", comment: "")
        reviewUSTitle.sizeToFit()
        reviewUSView.addSubview(reviewUSTitle)
        nextImage = UIImageView.init(frame: CGRect.init(x: bouns.width - 25*self.getHorRate() - 5, y: 17, width: 6, height: 10))
        nextImage.image = UIImage(named: "next-icon")
        reviewUSView.addSubview(nextImage)
        textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: 39, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "textinput-line")
        reviewUSView.addSubview(textLine)
        reviewUSView.userInteractionEnabled = true
        let reviewUSTap = UITapGestureRecognizer(target: self, action: #selector(CTASettingViewController.reviewUSClick(_:)))
        reviewUSView.addGestureRecognizer(reviewUSTap)
        self.scrollView.addSubview(self.systemSettingView)
        
        self.logoutButton = UIButton.init(frame: CGRect.init(x: (bouns.width - 40)/2, y: self.descLineImg.frame.origin.y + 320, width: 40, height: 28))
        self.logoutButton.setTitle(NSLocalizedString("LogoutButtonLabel", comment: ""), forState: .Normal)
        self.logoutButton.setTitleColor(UIColor.init(red: 239/255, green: 51/255, blue: 74/255, alpha: 1.0), forState: .Normal)
        self.logoutButton.setTitleColor(UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0), forState: .Disabled)
        self.logoutButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        self.logoutButton.sizeToFit()
        self.logoutButton.frame.origin.x = (bouns.width - self.logoutButton.frame.width)/2
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
            defaultImg = UIImage.init(named: "default-usericon")
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
            self.descNextImg.frame.origin.y = self.userDescLabel.frame.origin.y+8
            self.descLineImg.frame.origin.y = self.userDescLabel.frame.origin.y+31
        }else {
            self.userDescLabel.textAlignment = .Right
            self.descNextImg.frame.origin.y = self.userDescLabel.frame.origin.y + texth - 8
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
            var alertArray:Array<String> = []
            
            alertArray.append(LocalStrings.TakePhoto.description)
            alertArray.append(LocalStrings.ChoosePhoto.description)
            self.showSheetAlert(nil, okAlertArray: alertArray, cancelAlertLabel: LocalStrings.Cancel.description) { (index) -> Void in
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
            let setInfo = CTASetUserInfoViewController.getInstance()
            setInfo.setUser = self.loginUser!
            setInfo.setType = .NickName
            self.navigationController?.pushViewController(setInfo, animated: true)
        }
    }
    
    func userSexClick(sender: UIPanGestureRecognizer){
        if isLogin {
            var alertArray:Array<String> = []
            alertArray.append(NSLocalizedString("UserMaleLabel", comment: ""))
            alertArray.append(NSLocalizedString("UserFemaleLabel", comment: ""))
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
            let setInfo = CTASetUserInfoViewController.getInstance()
            setInfo.setUser = self.loginUser!
            setInfo.setType = .Desc
            self.navigationController?.pushViewController(setInfo, animated: true)
        }
    }
    
    func bindingAccountClick(sender: UIPanGestureRecognizer){
        if isLogin {
            let accountSetting = CTAAccountSettingViewController.getInstance()
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
            var alertArray:Array<String> = []
            alertArray.append(NSLocalizedString("LogoutButtonLabel", comment: ""))
            let alertTile = NSLocalizedString("ConfirmLogoutLabel", comment: "")
            self.showSheetAlert(alertTile, okAlertArray: alertArray, cancelAlertLabel: LocalStrings.Cancel.description) { (index) -> Void in
                if index != -1{
                    if CTAUserManager.logout() {
                        self.showLoginView()
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
    func weChatShareHandler(){
        
        let url = NSURL(string: "https://itunes.apple.com/cn/app/curios-let-photos-lively/id1090836500?l=en&mt=8")!
        CTASocialManager.shareMessage(CTASocialManager.Message.WeChat(CTASocialManager.Message.WeChatSubtype.Session(info: (title: "奇思-让图片更有意思", description: "这个应用很好玩，可以给照片添加会动的文字，快来下载吧！", thumbnail: UIImage(named: "ShareIcon"), media: CTASocialManager.Media.URL(url))))) { (result) in
        }
        
    }
    func momentsShareHandler(){
        let url = NSURL(string: "https://itunes.apple.com/cn/app/curios-let-photos-lively/id1090836500?l=en&mt=8")!
        CTASocialManager.shareMessage(CTASocialManager.Message.WeChat(CTASocialManager.Message.WeChatSubtype.Timeline(info: (title: "奇思-让图片更有意思", description: "这个应用很好玩，可以给照片添加会动的文字，快来下载吧！", thumbnail: UIImage(named: "ShareIcon"), media: CTASocialManager.Media.URL(url))))) { (result) in
        }
    }
    func weiBoShareHandler(){
        let url = NSURL(string: "https://itunes.apple.com/cn/app/curios-let-photos-lively/id1090836500?l=en&mt=8")!
        
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
