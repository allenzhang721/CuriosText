//
//  CTASetUserInfoViewController.swift
//  CuriosTextApp
//
//  Created by allen on 16/2/16.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit

enum CTASetUserInfoType{
    case NickName, Desc
}

class CTASetUserInfoViewController: UIViewController, CTAPublishCellProtocol, CTALoadingProtocol, CTAAlertProtocol{
    
    static var _instance:CTASetUserInfoViewController?;
    
    static func getInstance() -> CTASetUserInfoViewController{
        if _instance == nil{
            _instance = CTASetUserInfoViewController();
        }
        return _instance!
    }
    
    var loadingImageView:UIImageView? = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
    
    var setUser:CTAUserModel?
    var setType:CTASetUserInfoType = .NickName
    
    var setInfoLabel:UILabel!
    
    var nickNameView:UIView!
    var userNickNameTextInput:UITextField!
    
    var descView:UIView!
    var userDescTextView:UITextView!
    
    var saveButton:UIButton!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadView()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.resetView()
        self.setUser = nil
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
        self.setInfoLabel = UILabel.init(frame: CGRect.init(x: 0, y: 8, width: bouns.width, height: 28))
        self.setInfoLabel.font = UIFont.systemFontOfSize(20)
        self.setInfoLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        self.setInfoLabel.text = NSLocalizedString("SettingLabel", comment: "")
        self.setInfoLabel.textAlignment = .Center
        self.view.addSubview(self.setInfoLabel)
        
        let backButton = UIButton.init(frame: CGRect.init(x: 0, y: 2, width: 40, height: 40))
        backButton.setImage(UIImage(named: "back-button"), forState: .Normal)
        backButton.addTarget(self, action: "backButtonClick:", forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton)
        
        self.nickNameView = UIView.init(frame: CGRect.init(x: 0, y: 44, width: bouns.width, height: bouns.height-44))
        self.view.addSubview(self.nickNameView)
        self.userNickNameTextInput = UITextField.init(frame: CGRect.init(x:27*self.getHorRate(), y: 12, width: 326*self.getHorRate(), height: 50))
        self.userNickNameTextInput.placeholder = NSLocalizedString("UserNamePlaceholder", comment: "")
        self.userNickNameTextInput.delegate = self
        self.userNickNameTextInput.clearButtonMode = .Always
        self.userNickNameTextInput.returnKeyType = .Done
        self.nickNameView.addSubview(self.userNickNameTextInput)
        let textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: self.userNickNameTextInput.frame.origin.y + 49, width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "textinput-line")
        self.nickNameView.addSubview(textLine)
        
        
        self.descView = UIView.init(frame: CGRect.init(x: 0, y: 44, width: bouns.width, height: bouns.height-44))
        self.view.addSubview(self.descView)
        
        self.saveButton = UIButton.init(frame: CGRect.init(x: (bouns.width - 40)/2, y: 120, width: 40, height: 28))
        self.saveButton.setTitle(NSLocalizedString("SaveButtonLabel", comment: ""), forState: .Normal)
        self.saveButton.setTitleColor(UIColor.init(red: 239/255, green: 51/255, blue: 74/255, alpha: 1.0), forState: .Normal)
        self.saveButton.setTitleColor(UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0), forState: .Disabled)
        self.saveButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        self.saveButton.sizeToFit()
        self.saveButton.frame.origin.x = (bouns.width - self.saveButton.frame.width)/2
        self.saveButton.addTarget(self, action: "saveButtonClick:", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.saveButton)
    }
    
    func reloadView(){
        self.resetView()
        switch self.setType{
        case .NickName:
            self.reloadNikeNameView()
        case .Desc:
            self.reloadDescView()
        }
    }
    
    func resetView(){
        self.setInfoLabel.text = ""
        self.nickNameView.hidden = true
        self.descView.hidden = true
        self.saveButton.enabled = false
    }
    
    func reloadNikeNameView(){
        self.setInfoLabel.text = NSLocalizedString("UserNickNameLabel", comment: "")
        self.nickNameView.hidden = false
        if self.setUser == nil {
            self.userNickNameTextInput.text = ""
        }else {
            self.userNickNameTextInput.text = self.setUser!.nickName
        }
        self.saveButton.frame.origin.y = self.userNickNameTextInput.frame.origin.y + 114
        self.userNickNameTextInput.becomeFirstResponder()
    }
    
    func reloadDescView(){
        self.setInfoLabel.text = NSLocalizedString("UserDesc", comment: "")
        self.descView.hidden = false
    }
    
    func backButtonClick(sender: UIButton){
        self.backHandler()
    }
    
    func backHandler(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func saveButtonClick(sender: UIButton){
        self.saveHandler()
    }
    
    func saveHandler(){
        switch self.setType{
        case .NickName:
            self.saveNickNameHandler()
        case .Desc:
            self.saveDescHandler()
        }
    }
    
    func saveNickNameHandler(){
        if self.setUser != nil {
            let newText = self.userNickNameTextInput.text
            let newStr = NSString(string: newText!)
            if newStr.length > 0 && newStr.length < 21{
                self.showLoadingViewByView(self.saveButton)
                CTAUserDomain.getInstance().updateNickname(self.setUser!.userID, nickName: newText!, compelecationBlock: { (info) -> Void in
                    self.hideLoadingViewByView(self.saveButton)
                    if info.result{
                        self.setUser!.nickName = newText!
                        self.changeLoginUser()
                        self.backHandler()
                    }else {
                        self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                            self.userNickNameTextInput.becomeFirstResponder()
                        })
                    }
                })
            }
        }
        
    }
    
    func saveDescHandler(){
        
    }
    
    func changeLoginUser(){
        if self.setUser != nil {
            CTAUserManager.logout()
            CTAUserManager.save(self.setUser!)
        }
    }
}

extension CTASetUserInfoViewController: UITextFieldDelegate{
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        let isDelete = string == "" ? true : false
        if textField == self.userNickNameTextInput{
            let newText = self.userNickNameTextInput.text
            let newStr = NSString(string: newText!)
            if isDelete {
                if newStr.length <= 1{
                    self.saveButton.enabled = false
                }else {
                    let delStr = newStr.substringToIndex(newStr.length-1)
                    let delText = delStr as String
                    if delText == self.setUser!.nickName {
                        self.saveButton.enabled = false
                    }else {
                        self.saveButton.enabled = true
                    }
                }
            }else{
                if (newText! + string) == self.setUser!.nickName {
                    self.saveButton.enabled = false
                }else {
                    self.saveButton.enabled = true
                }
            }
            if newStr.length < 21 || isDelete {
                return true
            }else {
                return false
            }
        }else {
            return true
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        if self.saveButton.enabled {
            self.saveHandler()
        }
        return true
    }
}