//
//  CTASettingViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import Kingfisher

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
        backButton.addTarget(self, action: "backButtonClick:", forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton)
        
        self.scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 44, width: bouns.width, height: bouns.height-44))
        self.view.addSubview(self.scrollView)
        
        self.userIconImage = UIImageView.init(frame: CGRect.init(x: (bouns.width - 60)/2, y: 30, width: 60, height: 60))
        self.userIconImage.image = UIImage(named: "default-usericon")
        self.cropImageCircle(self.userIconImage)
        self.scrollView.addSubview(self.userIconImage)
        self.userIconImage.userInteractionEnabled = true
        let iconTap = UITapGestureRecognizer(target: self, action: "userIconClick:")
        self.userIconImage.addGestureRecognizer(iconTap)
        
        let imgFrame = self.userIconImage.frame
        let cameraView = UIImageView.init(frame: CGRect.init(x: (imgFrame.origin.x+imgFrame.size.width)-20, y: (imgFrame.origin.y+imgFrame.size.height)-20, width: 20, height: 20))
        cameraView.image = UIImage.init(named: "usercamera-icon")
        self.scrollView.addSubview(cameraView)
        
        self.imagePicker.delegate = self
        
        self.userNickNameLabel = UILabel.init(frame: CGRect.init(x: 128*self.getHorRate(), y: 112, width: bouns.width - 153*self.getHorRate() - 15, height: 25))
        self.userNickNameLabel.font = UIFont.systemFontOfSize(16)
        self.userNickNameLabel.textColor = UIColor.init(red: 108/255, green: 108/255, blue: 108/255, alpha: 1.0)
        self.userNickNameLabel.textAlignment = .Right
        self.scrollView.addSubview(self.userNickNameLabel)
        let userNickNameTitle = UILabel.init(frame: CGRect.init(x: 27*self.getHorRate(), y: self.userNickNameLabel.frame.origin.y, width: 50, height: 25))
        userNickNameTitle.font = UIFont.systemFontOfSize(18)
        userNickNameTitle.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        userNickNameTitle.text = NSLocalizedString("UserNickNameLabel", comment: "")
        userNickNameTitle.sizeToFit()
        self.scrollView.addSubview(userNickNameTitle)
        var nextImage = UIImageView.init(frame: CGRect.init(x: bouns.width - 25*self.getHorRate() - 11, y: self.userNickNameLabel.frame.origin.y+2, width: 11, height: 20))
        nextImage.image = UIImage(named: "next-icon")
        self.scrollView.addSubview(nextImage)
        var textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: self.userNickNameLabel.frame.origin.y + 37, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "textinput-line")
        self.scrollView.addSubview(textLine)
        self.userNickNameLabel.userInteractionEnabled = true
        let nickNameTap = UITapGestureRecognizer(target: self, action: "userNickNameClick:")
        self.userNickNameLabel.addGestureRecognizer(nickNameTap)
        
        self.userSexLabel = UILabel.init(frame: CGRect.init(x: 128*self.getHorRate(), y: self.userNickNameLabel.frame.origin.y+50, width: bouns.width - 153*self.getHorRate() - 15, height: 25))
        self.userSexLabel.font = UIFont.systemFontOfSize(16)
        self.userSexLabel.textColor = UIColor.init(red: 108/255, green: 108/255, blue: 108/255, alpha: 1.0)
        self.userSexLabel.textAlignment = .Right
        self.scrollView.addSubview(self.userSexLabel)
        let userSexTitle = UILabel.init(frame: CGRect.init(x: 27*self.getHorRate(), y: self.userSexLabel.frame.origin.y, width: 50, height: 25))
        userSexTitle.font = UIFont.systemFontOfSize(18)
        userSexTitle.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        userSexTitle.text = NSLocalizedString("UserSexLabel", comment: "")
        userSexTitle.sizeToFit()
        self.scrollView.addSubview(userSexTitle)
        nextImage = UIImageView.init(frame: CGRect.init(x: bouns.width - 25*self.getHorRate() - 11, y: self.userSexLabel.frame.origin.y+2, width: 11, height: 20))
        nextImage.image = UIImage(named: "next-icon")
        self.scrollView.addSubview(nextImage)
        textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: self.userSexLabel.frame.origin.y + 37, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "textinput-line")
        self.scrollView.addSubview(textLine)
        self.userSexLabel.userInteractionEnabled = true
        let userSexTap = UITapGestureRecognizer(target: self, action: "userSexClick:")
        self.userSexLabel.addGestureRecognizer(userSexTap)
        
        self.userRegionLabel = UILabel.init(frame: CGRect.init(x: 128*self.getHorRate(), y: self.userSexLabel.frame.origin.y+50, width: bouns.width - 153*self.getHorRate() - 15, height: 25))
        self.userRegionLabel.font = UIFont.systemFontOfSize(16)
        self.userRegionLabel.textColor = UIColor.init(red: 108/255, green: 108/255, blue: 108/255, alpha: 1.0)
        self.userRegionLabel.textAlignment = .Right
        self.scrollView.addSubview(self.userRegionLabel)
//        let userRegionTitle = UILabel.init(frame: CGRect.init(x: 27*self.getHorRate(), y: self.userRegionLabel.frame.origin.y, width: 50, height: 25))
//        userRegionTitle.font = UIFont.systemFontOfSize(18)
//        userRegionTitle.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
//        userRegionTitle.text = NSLocalizedString("UserRegion", comment: "")
//        userRegionTitle.sizeToFit()
//        self.scrollView.addSubview(userRegionTitle)
//        nextImage = UIImageView.init(frame: CGRect.init(x: bouns.width - 25*self.getHorRate() - 11, y: self.userRegionLabel.frame.origin.y+2, width: 11, height: 20))
//        nextImage.image = UIImage(named: "next-icon")
//        self.scrollView.addSubview(nextImage)
//        textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: self.userRegionLabel.frame.origin.y + 37, width: 330*self.getHorRate(), height: 1))
//        textLine.image = UIImage(named: "textinput-line")
//        self.scrollView.addSubview(textLine)
        self.userRegionLabel.userInteractionEnabled = true
        let userRegionTap = UITapGestureRecognizer(target: self, action: "userRegionClick:")
        self.userRegionLabel.addGestureRecognizer(userRegionTap)
        self.userRegionLabel.hidden = true
        
        self.userDescLabel = UILabel.init(frame: CGRect.init(x: 128*self.getHorRate(), y: self.userSexLabel.frame.origin.y+50, width: bouns.width - 153*self.getHorRate() - 15, height: 25))
        self.userDescLabel.numberOfLines = 12
        self.userDescLabel.font = UIFont.systemFontOfSize(16)
        self.userDescLabel.textColor = UIColor.init(red: 108/255, green: 108/255, blue: 108/255, alpha: 1.0)
        self.userDescLabel.textAlignment = .Right
        self.scrollView.addSubview(self.userDescLabel)
        let userDesxTitle = UILabel.init(frame: CGRect.init(x: 27*self.getHorRate(), y: self.userDescLabel.frame.origin.y, width: 50, height: 25))
        userDesxTitle.font = UIFont.systemFontOfSize(18)
        userDesxTitle.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        userDesxTitle.text = NSLocalizedString("UserDesc", comment: "")
        userDesxTitle.sizeToFit()
        self.scrollView.addSubview(userDesxTitle)
        self.descNextImg = UIImageView.init(frame: CGRect.init(x: bouns.width - 25*self.getHorRate() - 11, y: self.userDescLabel.frame.origin.y+2, width: 11, height: 20))
        self.descNextImg.image = UIImage(named: "next-icon")
        self.scrollView.addSubview(self.descNextImg)
        self.descLineImg = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: self.userDescLabel.frame.origin.y + 37, width: 330*self.getHorRate(), height: 1))
        self.descLineImg.image = UIImage(named: "textinput-line")
        self.scrollView.addSubview(self.descLineImg)
        self.userDescLabel.userInteractionEnabled = true
        let userDescTap = UITapGestureRecognizer(target: self, action: "userDescClick:")
        self.userDescLabel.addGestureRecognizer(userDescTap)
        
        self.logoutButton = UIButton.init(frame: CGRect.init(x: (bouns.width - 40)/2, y: self.descLineImg.frame.origin.y+21, width: 40, height: 28))
        self.logoutButton.setTitle(NSLocalizedString("LogoutButtonLabel", comment: ""), forState: .Normal)
        self.logoutButton.setTitleColor(UIColor.init(red: 239/255, green: 51/255, blue: 74/255, alpha: 1.0), forState: .Normal)
        self.logoutButton.setTitleColor(UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0), forState: .Disabled)
        self.logoutButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        self.logoutButton.sizeToFit()
        self.logoutButton.frame.origin.x = (bouns.width - self.logoutButton.frame.width)/2
        self.logoutButton.addTarget(self, action: "logoutButtonClick:", forControlEvents: .TouchUpInside)
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
            self.userDescLabel.frame.size.height = 25
            self.userDescLabel.textAlignment = .Right
            self.descNextImg.frame.origin.y = self.userDescLabel.frame.origin.y+2
            self.descLineImg.frame.origin.y = self.userDescLabel.frame.origin.y+37
        }else {
            self.userDescLabel.textAlignment = .Left
            self.descNextImg.frame.origin.y = self.userDescLabel.frame.origin.y + texth - 22
            self.descLineImg.frame.origin.y = self.userDescLabel.frame.origin.y + texth + 12
        }
        
        self.logoutButton.enabled = true
        self.logoutButton.frame.origin.y = self.descLineImg.frame.origin.y + 21
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
            alertArray.append(NSLocalizedString("AlertTakePhotoLabel", comment: ""))
            alertArray.append(NSLocalizedString("AlertChoosePhoteLabel", comment: ""))
            self.showSheetAlert(nil, okAlertArray: alertArray, cancelAlertLabel: NSLocalizedString("AlertCancelLabel", comment: "")) { (index) -> Void in
                if index == 0{
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = .Camera
                    self.presentViewController(self.imagePicker, animated: true, completion: nil)
                }else if index == 1{
                    self.imagePicker.allowsEditing = false
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
            self.showSheetAlert(nil, okAlertArray: alertArray, cancelAlertLabel: NSLocalizedString("AlertCancelLabel", comment: "")) { (index) -> Void in
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
    
    func logoutButtonClick(sender: UIButton){
        if isLogin{
            var alertArray:Array<String> = []
            alertArray.append(NSLocalizedString("LogoutButtonLabel", comment: ""))
            let alertTile = NSLocalizedString("ConfirmLogoutLabel", comment: "")
            self.showSheetAlert(alertTile, okAlertArray: alertArray, cancelAlertLabel: NSLocalizedString("AlertCancelLabel", comment: "")) { (index) -> Void in
                if index != -1{
                    CTAUserManager.logout()
                    self.showLoginView()
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
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
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
        self.showLoadingViewByView(nil)
    }
    
    func uploadComplete(result:Bool, iconPath:String, icon:UIImage?){
        if result{
            CTAUserDomain.getInstance().updateUserIconURL(self.loginUser!.userID, userIconURL: iconPath, compelecationBlock: { (info) -> Void in
                self.hideLoadingViewByView(nil)
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
            self.hideLoadingViewByView(nil)
        }
    }
}

extension CTASettingViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
