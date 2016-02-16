//
//  CTASetUserNameViewController.swift
//  CuriosTextApp
//
//  Created by allen on 16/2/2.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation
import Kingfisher

enum CTASetUserNameType{
    case register, registerWechat
}

class CTASetUserNameViewController: UIViewController, CTAPublishCellProtocol, CTATextInputProtocol, CTALoadingProtocol, CTAImageControllerProtocol{
    
    static var _instance:CTASetUserNameViewController?;
    
    static func getInstance() -> CTASetUserNameViewController{
        if _instance == nil{
            _instance = CTASetUserNameViewController();
        }
        return _instance!
    }
    
    var userNickNameTextInput:UITextField!
    var completeButton:UIButton!
    var userIconImage:UIImageView!
    let imagePicker:UIImagePickerController = UIImagePickerController()
    
    var loadingImageView:UIImageView? = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
    
    var userNameType:CTASetUserNameType = .register
    var selectedImage:UIImage?
    var isChangeImage:Bool = false
    var isResetView:Bool = false
    
    var userIconPath:String = ""
    var userModel:CTAUserModel?
    
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
    
    func initView(){
        let bouns = UIScreen.mainScreen().bounds
        let tap = UITapGestureRecognizer(target: self, action: "bgViewClick:")
        self.view.addGestureRecognizer(tap)
        
        let backButton = UIButton.init(frame: CGRect.init(x: 0, y: 2, width: 40, height: 40))
        backButton.setImage(UIImage(named: "back-button"), forState: .Normal)
        backButton.addTarget(self, action: "backButtonClick:", forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton)
        
        let userInfoLabel = UILabel.init(frame: CGRect.init(x: (bouns.width - 50)/2, y: 100*self.getVerRate(), width: 100, height: 40))
        userInfoLabel.font = UIFont.systemFontOfSize(28)
        userInfoLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        userInfoLabel.text = NSLocalizedString("UserInfoLabel", comment: "")
        userInfoLabel.sizeToFit()
        userInfoLabel.frame.origin.x = (bouns.width - userInfoLabel.frame.width)/2
        self.view.addSubview(userInfoLabel)
        
        self.userIconImage = UIImageView.init(frame: CGRect.init(x: (bouns.width - 60)/2, y: 170*self.getVerRate(), width: 60, height: 60))
        self.userIconImage.image = UIImage(named: "setimage-icon")
        self.cropImageCircle(self.userIconImage)
        self.view.addSubview(self.userIconImage)
        self.userIconImage.userInteractionEnabled = true
        let iconTap = UITapGestureRecognizer(target: self, action: "userIconClick:")
        self.userIconImage.addGestureRecognizer(iconTap)
    
        self.imagePicker.delegate = self
        
        self.userNickNameTextInput = UITextField.init(frame: CGRect.init(x:128*self.getHorRate(), y: 250*self.getVerRate(), width: 190*self.getHorRate(), height: 50))
        self.userNickNameTextInput.placeholder = NSLocalizedString("UserNamePlaceholder", comment: "")
        self.userNickNameTextInput.delegate = self
        self.userNickNameTextInput.clearButtonMode = .WhileEditing
        self.userNickNameTextInput.returnKeyType = .Done
        self.view.addSubview(self.userNickNameTextInput)
        
        let userNickNameLabel = UILabel.init(frame: CGRect.init(x: 27*self.getHorRate(), y: self.userNickNameTextInput.frame.origin.y + 12, width: 50, height: 25))
        userNickNameLabel.font = UIFont.systemFontOfSize(18)
        userNickNameLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        userNickNameLabel.text = NSLocalizedString("UserNickNameLabel", comment: "")
        userNickNameLabel.sizeToFit()
        self.view.addSubview(userNickNameLabel)
        
        let textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: self.userNickNameTextInput.frame.origin.y + 49, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "textinput-line")
        self.view.addSubview(textLine)
        
        self.completeButton = UIButton.init(frame: CGRect.init(x: (bouns.width - 40)/2, y: self.userNickNameTextInput.frame.origin.y + 70, width: 40, height: 28))
        self.completeButton.setTitle(NSLocalizedString("CompleteButtonLabel", comment: ""), forState: .Normal)
        self.completeButton.setTitleColor(UIColor.init(red: 239/255, green: 51/255, blue: 74/255, alpha: 1.0), forState: .Normal)
        self.completeButton.setTitleColor(UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0), forState: .Disabled)
        self.completeButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        self.completeButton.sizeToFit()
        self.completeButton.frame.origin.x = (bouns.width - self.completeButton.frame.width)/2
        self.completeButton.addTarget(self, action: "completeButtonClick:", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.completeButton)
    }
    
    func viewWillLoad(){
        if self.isResetView {
            self.selectedImage = nil
            self.isChangeImage = false
            if self.userIconPath == "" {
                if self.userModel != nil {
                    if self.userModel!.userIconURL != "" {
                        let imagePath = CTAFilePath.userFilePath+self.userModel!.userIconURL
                        self.loadUserIcon(imagePath)
                    }else {
                        self.userIconImage.image = UIImage(named: "setimage-icon")
                    }
                }else {
                    self.userIconImage.image = UIImage(named: "setimage-icon")
                }
            }else {
                self.loadUserIcon(self.userIconPath)
            }
            if self.userModel != nil {
                self.userNickNameTextInput.text = self.userModel!.nickName
            }else {
                self.userNickNameTextInput.text = ""
            }
            self.setCompleteButtonStyle()
        }
        self.isResetView = false
    }
    
    func loadUserIcon(iconPath:String){
        let imageURL = NSURL(string: iconPath)!
        self.userIconImage.kf_showIndicatorWhenLoading = true
        self.userIconImage.kf_setImageWithURL(imageURL, placeholderImage: UIImage(named: "setimage-icon"), optionsInfo: [.Transition(ImageTransition.Fade(1))]) { (image, error, cacheType, imageURL) -> () in
            if error == nil {
                self.selectedImage = self.userIconImage.image
                self.setCompleteButtonStyle()
            }else {
                self.userIconImage.image = UIImage(named: "setimage-icon")
            }
            self.userIconImage.kf_showIndicatorWhenLoading = false
        }
    }
    
    func setCompleteButtonStyle(){
        let newText = self.userNickNameTextInput.text
        let newStr = NSString(string: newText!)
        if self.selectedImage != nil && newStr.length > 0{
            self.completeButton.enabled = true
        }else {
            self.completeButton.enabled = false
        }
    }
    
    func backButtonClick(sender: UIButton){
        self.showSelectedAlert(NSLocalizedString("AlertTitleUserNameBack", comment: ""), alertMessage: "", okAlertLabel: NSLocalizedString("AlertOkLabel", comment: ""), cancelAlertLabel: NSLocalizedString("AlertCancelLabel", comment: "")) { (result) -> Void in
            if result {
                let mobile = CTASetMobileNumberViewController.getInstance()
                self.navigationController?.popToViewController(mobile, animated: true)
            }
        }
    }
    
    func changeToLoadingView() {
        self.resignView()
        self.showLoadingViewByView(self.completeButton)
    }
    
    func changeToUnloadingView(){
        self.hideLoadingViewByView(self.completeButton)
    }
    
    func completeButtonClick(sender: UIButton){
        self.completeHandler()
    }
    
    func completeHandler(){
        if self.userNickNameTextInput.text != "" {
            if self.userModel != nil {
                if self.isChangeImage {
                    self.uploadUserIcon(self.userModel!, icon: self.selectedImage!)
                }else {
                    if self.userModel != nil {
                        if self.userModel!.nickName == self.userNickNameTextInput.text{
                            self.updateComplete()
                        }else {
                            self.uploadUserInfo()
                        }
                    }
                }
            }else {
                self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                })
            }
        }else {
            self.completeButton.enabled = false
        }
    }
    
    func uploadUserInfo(userIconURL:String = ""){
        if self.userModel != nil {
            if userIconURL != "" {
                self.userModel!.userIconURL = userIconURL
            }
            self.userModel!.nickName = self.userNickNameTextInput.text!
            self.changeToLoadingView()
            CTAUserDomain.getInstance().updateUserInfo(self.userModel!, compelecationBlock: { (info) -> Void in
                self.changeToUnloadingView()
                if info.result {
                    self.updateComplete()
                }else {
                    if info.errorType is CTAInternetError {
                        self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                        })
                    }else {
                        //let error = info.errorType as! CTARequestUserError
                        self.showSingleAlert(NSLocalizedString("AlertTitleConnectUs", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                        })
                    }
                }
            })
        }
    }
    
    func updateComplete(){
        CTAUserManager.save(self.userModel!)
        self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
    
    func userIconClick(sender: UIPanGestureRecognizer){
        var alertArray:Array<String> = []
        alertArray.append(NSLocalizedString("AlertTakePhotoLabel", comment: ""))
        alertArray.append(NSLocalizedString("AlertChoosePhoteLabel", comment: ""))
        self.showSheetAlert(alertArray, cancelAlertLabel: NSLocalizedString("AlertCancelLabel", comment: "")) { (index) -> Void in
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
    
    func bgViewClick(sender: UIPanGestureRecognizer){
        self.resignHandler(sender)
    }
}

extension CTASetUserNameViewController: UITextFieldDelegate{
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        let newText = self.userNickNameTextInput.text
        let newStr = NSString(string: newText!)
        let isDelete = string == "" ? true : false
        if isDelete {
            if newStr.length <= 1{
                self.completeButton.enabled = false
            }
        }else{
            if self.selectedImage != nil{
                self.completeButton.enabled = true
            }
        }
        if newStr.length < 21 || isDelete {
            return true
        }else {
            return false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        if self.completeButton.enabled {
            self.completeHandler()
        }
        return true
    }
}

extension CTASetUserNameViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.userIconImage.image = pickedImage
            self.selectedImage = pickedImage
            self.setCompleteButtonStyle()
            self.isChangeImage = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension CTASetUserNameViewController: CTAUploadIconProtocol{
    func uploadBegin(){
        self.changeToLoadingView()
    }
    
    func uploadComplete(result:Bool, iconPath:String, icon:UIImage?){
        if result{
            self.uploadUserInfo(iconPath)
        }else {
            self.changeToUnloadingView()
        }
    }
}