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
    case register, registerWechat, registerWeibo
}

class CTASetUserNameViewController: UIViewController, CTAPublishCellProtocol, CTATextInputProtocol, CTALoadingProtocol, CTAImageControllerProtocol, CTALoginProtocol{
    
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
    
    var loadingImageView:UIImageView? = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    var userNameType:CTASetUserNameType = .register
    var selectedImage:UIImage?
    var isChangeImage:Bool = false
    
    var userIconPath:String = ""
    var userModel:CTAUserModel?
    
    var isChange:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initView()
        self.navigationController!.interactivePopGestureRecognizer?.delegate = self
        self.view.backgroundColor = CTAStyleKit.commonBackgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.isChange {
            self.viewWillLoad()
        }
        self.isChange = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !self.isChange {
            self.resetView()
        }
    }
    
    func initView(){
        let bouns = UIScreen.main.bounds
        let tap = UITapGestureRecognizer(target: self, action: #selector(CTASetUserNameViewController.bgViewClick(_:)))
        self.view.addGestureRecognizer(tap)
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 22, width: 40, height: 40))
        backButton.setImage(UIImage(named: "back-button"), for: UIControlState())
        backButton.setImage(UIImage(named: "back-selected-button"), for: .highlighted)
        backButton.addTarget(self, action: #selector(CTASetUserNameViewController.backButtonClick(_:)), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        let userInfoLabel = UILabel(frame: CGRect(x: 0, y: 60*self.getVerRate(), width: bouns.width, height: 40))
        userInfoLabel.font = UIFont.boldSystemFont(ofSize: 28)
        userInfoLabel.textColor = CTAStyleKit.normalColor
        userInfoLabel.text = NSLocalizedString("UserInfoLabel", comment: "")
        userInfoLabel.textAlignment = .center
        self.view.addSubview(userInfoLabel)
        
        self.userIconImage = UIImageView(frame: CGRect(x: (bouns.width - 60)/2, y: 140*self.getVerRate(), width: 60, height: 60))
        self.userIconImage.image = UIImage(named: "default-usericon")
        self.cropImageCircle(self.userIconImage)
        self.view.addSubview(self.userIconImage)
        self.userIconImage.isUserInteractionEnabled = true
        let iconTap = UITapGestureRecognizer(target: self, action: #selector(CTASetUserNameViewController.userIconClick(_:)))
        self.userIconImage.addGestureRecognizer(iconTap)
    
        let imgFrame = self.userIconImage.frame
        let cameraView = UIImageView(frame: CGRect(x: (imgFrame.origin.x+imgFrame.size.width)-20, y: (imgFrame.origin.y+imgFrame.size.height)-20, width: 20, height: 20))
        cameraView.image = UIImage(named: "usercamera-icon")
        self.view.addSubview(cameraView)
        
        self.imagePicker.delegate = self
        
        self.userNickNameTextInput = UITextField(frame: CGRect(x:27*self.getHorRate(), y: self.userIconImage.frame.origin.y + 100, width: 280*self.getHorRate(), height: 50))
        self.userNickNameTextInput.center = CGPoint(x: bouns.width/2, y: 150*self.getVerRate()+75)
        self.userNickNameTextInput.placeholder = NSLocalizedString("UserNickNameLabel", comment: "") + ":  "+NSLocalizedString("UserNamePlaceholder", comment: "")
        self.userNickNameTextInput.delegate = self
        self.userNickNameTextInput.clearButtonMode = .whileEditing
        self.userNickNameTextInput.returnKeyType = .done
        self.view.addSubview(self.userNickNameTextInput)
        
        
        let textLine = UIImageView(frame: CGRect.init(x: 25*self.getHorRate(), y: self.userNickNameTextInput.frame.origin.y + 49, width: 290*self.getHorRate(), height: 1))
        textLine.center = CGPoint(x: bouns.width/2, y: self.userNickNameTextInput.frame.origin.y+49)
        textLine.image = UIImage(named: "space-line")
        self.view.addSubview(textLine)
        
        self.completeButton = UIButton(frame: CGRect(x: (bouns.width - 40)/2, y: self.userNickNameTextInput.frame.origin.y + 70, width: 40, height: 28))
        self.completeButton.setTitle(NSLocalizedString("CompleteButtonLabel", comment: ""), for: UIControlState())
        self.completeButton.setTitleColor(CTAStyleKit.selectedColor, for: UIControlState())
        self.completeButton.setTitleColor(CTAStyleKit.disableColor, for: .disabled)
        self.completeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.completeButton.sizeToFit()
        self.completeButton.frame.origin.x = (bouns.width - self.completeButton.frame.width)/2
        self.completeButton.addTarget(self, action: #selector(CTASetUserNameViewController.completeButtonClick(_:)), for: .touchUpInside)
        self.view.addSubview(self.completeButton)
    }
    
    func viewWillLoad(){
        if self.userIconPath == "" {
            if self.userModel != nil {
                if self.userModel!.userIconURL != "" {
                    let imagePath = CTAFilePath.userFilePath+self.userModel!.userIconURL
                    self.loadUserIcon(imagePath)
                }else {
                    self.userIconImage.image = UIImage(named: "default-usericon")
                }
            }else {
                self.userIconImage.image = UIImage(named: "default-usericon")
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
        NotificationCenter.default.addObserver(self, selector: #selector(CTASetUserNameViewController.textFieldEditChange(_:)), name: NSNotification.Name(rawValue: "UITextFieldTextDidChangeNotification"), object: self.userNickNameTextInput)
    }
    
    func resetView(){
        self.userNameType = .register
        self.userIconPath = ""
        self.selectedImage = nil
        self.isChangeImage = false
        self.completeButton.isEnabled = false
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UITextFieldTextDidChangeNotification"), object: self.userNickNameTextInput)
    }
    
    func loadUserIcon(_ iconPath:String){
        let imageURL = URL(string: iconPath)!
//        self.userIconImage.kf_showIndicatorWhenLoading = true
//      self.userIconImage.kf.indicator = Kingfisher.
        self.userIconImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "default-usericon"), options: nil) { (image, error, cacheType, imageURL) -> () in
            if error == nil {
                self.selectedImage = self.userIconImage.image
                self.setCompleteButtonStyle()
                if self.userIconPath != "" {
                    self.isChangeImage = true
                }
            }else {
                self.userIconImage.image = UIImage(named: "default-usericon")
            }
//            self.userIconImage.kf_showIndicatorWhenLoading = false
        }
    }
    
    func setCompleteButtonStyle(){
        let newText = self.userNickNameTextInput.text
        let newStr = NSString(string: newText!)
        if newStr.length > 0{
            self.completeButton.isEnabled = true
        }else {
            self.completeButton.isEnabled = false
        }
    }
    
    func backButtonClick(_ sender: UIButton){
        self.showSelectedAlert(NSLocalizedString("AlertTitleUserNameBack", comment: ""), alertMessage: "", okAlertLabel: LocalStrings.ok.description, cancelAlertLabel: LocalStrings.cancel.description) { (result) -> Void in
            if result {
                switch self.userNameType{
                case .register:
                    let mobile = CTASetMobileNumberViewController.getInstance()
                    self.navigationController?.popToViewController(mobile, animated: true)
                case .registerWechat, .registerWeibo:
                    let login = CTALoginViewController.getInstance()
                    self.navigationController?.popToViewController(login, animated: true)
                }
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
    
    func completeButtonClick(_ sender: UIButton){
        self.completeHandler()
    }
    
    func completeHandler(){
        self.userNickNameTextInput.resignFirstResponder()
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
            self.completeButton.isEnabled = false
        }
    }
    
    func uploadUserInfo(_ userIconURL:String = ""){
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
        self.loginComplete(self.userModel!)
    }
    
    func userIconClick(_ sender: UIPanGestureRecognizer){
        var alertArray:Array<[String : AnyObject]> = []
        alertArray.append(["title":LocalStrings.takePhoto.description as AnyObject])
        alertArray.append(["title":LocalStrings.choosePhoto.description as AnyObject])
        self.showSheetAlert(LocalStrings.photoTitle.description, okAlertArray: alertArray, cancelAlertLabel: LocalStrings.cancel.description) { (index) -> Void in
            if index == 0{
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = .camera
                self.isChange = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }else if index == 1{
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = .photoLibrary
                self.isChange = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func bgViewClick(_ sender: UIPanGestureRecognizer){
        self.resignHandler(sender)
    }
}

extension CTASetUserNameViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        if self.completeButton.isEnabled {
            self.completeHandler()
        }
        return true
    }
    
    func textFieldEditChange(_ noti: Notification) {
        let textField = noti.object as! UITextField
        self.checkTextField(textField)
        textField.sizeToFit()
        textField.frame.size.width = 280*self.getHorRate()
        textField.frame.size.height = 50
        self.setCompleteButtonStyle()
    }
    
    func checkTextField(_ textField: UITextField) -> Bool{
        textField.sizeToFit()
        let viewText = textField.text
        let textStr = NSString(string: viewText!)
        let textWidth = textField.frame.width
        var needReset:Bool = false
        let textLimit = 32
        let textWidthLimit = 280*self.getHorRate() - 30
        if textWidth < textWidthLimit{
            if textStr.length > textLimit {
                needReset = true
            }else {
                needReset = false
            }
        }else {
            needReset = true
        }
        if needReset {
            let range = textField.selectedTextRange
            let newText = textStr.substring(to: textStr.length - 1)
            let newStr = NSString(string: newText)
            textField.text = newText
            let rageLength = textField.offset(from: textField.beginningOfDocument, to: range!.start)
            if rageLength < newStr.length{
                textField.selectedTextRange = range
            }
            return self.checkTextField(textField)
        }else {
            return true
        }
    }
}

extension CTASetUserNameViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.userIconImage.image = compressIconImage(pickedImage)
            self.selectedImage = pickedImage
            self.setCompleteButtonStyle()
            self.isChangeImage = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
}

extension CTASetUserNameViewController: CTAUploadIconProtocol{
    func uploadBegin(){
        self.changeToLoadingView()
    }
    
    func uploadComplete(_ result:Bool, iconPath:String, icon:UIImage?){
        if result{
            self.uploadUserInfo(iconPath)
        }else {
            self.changeToUnloadingView()
        }
    }
}

extension CTASetUserNameViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
}
