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
    
    var loadingImageView:UIImageView? = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
    
    var setUser:CTAUserModel?
    var setType:CTASetUserInfoType = .NickName
    
    var setInfoLabel:UILabel!
    
    var nickNameView:UIView!
    var userNickNameTextInput:UITextField!
    
    var descView:UIView!
    var userDescTextView:UITextView!
    var descTextLine:UIImageView!
    
    var saveButton:UIButton!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
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
        let bounds = UIScreen.mainScreen().bounds
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 64))
        headerView.backgroundColor = CTAStyleKit.commonBackgroundColor
        self.view.addSubview(headerView)
        
        self.setInfoLabel = UILabel.init(frame: CGRect.init(x: 0, y: 28, width: bounds.width, height: 28))
        self.setInfoLabel.font = UIFont.boldSystemFontOfSize(18)
        self.setInfoLabel.textColor = CTAStyleKit.normalColor
        self.setInfoLabel.text = NSLocalizedString("SettingLabel", comment: "")
        self.setInfoLabel.textAlignment = .Center
        headerView.addSubview(self.setInfoLabel)
        
        let backButton = UIButton.init(frame: CGRect.init(x: 0, y: 22, width: 40, height: 40))
        backButton.setImage(UIImage(named: "back-button"), forState: .Normal)
        backButton.setImage(UIImage(named: "back-selected-button"), forState: .Highlighted)
        backButton.addTarget(self, action: #selector(CTASetUserInfoViewController.backButtonClick(_:)), forControlEvents: .TouchUpInside)
        headerView.addSubview(backButton)
        
        var textLine = UIImageView.init(frame: CGRect.init(x: 0, y: 63, width: bounds.width, height: 1))
        textLine.image = UIImage(named: "space-line")
        headerView.addSubview(textLine)
        
        self.nickNameView = UIView.init(frame: CGRect.init(x: 0, y: 64, width: bounds.width, height: bounds.height-64))
        self.view.addSubview(self.nickNameView)
        self.userNickNameTextInput = UITextField.init(frame: CGRect.init(x:27*self.getHorRate(), y: 12, width: 280*self.getHorRate(), height: 50))
        self.userNickNameTextInput.center = CGPoint.init(x: bounds.width/2, y: 37)
        self.userNickNameTextInput.font = UIFont.systemFontOfSize(16)
        self.userNickNameTextInput.placeholder = NSLocalizedString("UserNamePlaceholder", comment: "")
        self.userNickNameTextInput.delegate = self
        self.userNickNameTextInput.clearButtonMode = .Always
        self.userNickNameTextInput.returnKeyType = .Done
        self.nickNameView.addSubview(self.userNickNameTextInput)
        textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: self.userNickNameTextInput.frame.origin.y + 49, width: 290*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "space-line")
        textLine.center = CGPoint.init(x: bounds.width/2, y: self.userNickNameTextInput.frame.origin.y + 49)
        self.nickNameView.addSubview(textLine)
        
        
        self.descView = UIView.init(frame: CGRect.init(x: 0, y: 64, width: bounds.width, height: bounds.height-64))
        self.view.addSubview(self.descView)
        self.userDescTextView = UITextView.init(frame: CGRect.init(x: 27*self.getHorRate(), y: 12, width: 280*self.getHorRate(), height: 50))
        self.userDescTextView.center = CGPoint.init(x: bounds.width/2, y: 37)
        self.userDescTextView.font = UIFont.systemFontOfSize(16)
        self.userDescTextView.scrollEnabled = false
        self.userDescTextView.backgroundColor = CTAStyleKit.commonBackgroundColor
        self.userDescTextView.delegate = self
        self.userDescTextView.textAlignment = .Left
        self.descView.addSubview(userDescTextView)
        self.descTextLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: self.userDescTextView.frame.origin.y + 49, width: 290*self.getHorRate(), height: 1))
        self.descTextLine.image = UIImage(named: "space-line")
        self.descTextLine.center = CGPoint.init(x: bounds.width/2, y: self.userDescTextView.frame.origin.y + 49)
        self.descView.addSubview(self.descTextLine)
        
        
        self.saveButton = UIButton.init(frame: CGRect.init(x: (bounds.width - 40)/2, y: 120, width: 40, height: 28))
        self.saveButton.setTitle(NSLocalizedString("SaveButtonLabel", comment: ""), forState: .Normal)
        self.saveButton.setTitleColor(CTAStyleKit.selectedColor, forState: .Normal)
        self.saveButton.setTitleColor(CTAStyleKit.disableColor, forState: .Disabled)
        self.saveButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        self.saveButton.sizeToFit()
        self.saveButton.frame.origin.x = (bounds.width - self.saveButton.frame.width)/2
        self.saveButton.addTarget(self, action: #selector(CTASetUserInfoViewController.saveButtonClick(_:)), forControlEvents: .TouchUpInside)
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
        switch self.setType{
        case .NickName:
            self.resetNikeNameView()
        case .Desc:
            self.resetDescView()
        }
    }
    
    func reloadNikeNameView(){
        self.setInfoLabel.text = NSLocalizedString("UserNickNameLabel", comment: "")
        self.nickNameView.hidden = false
        if self.setUser == nil {
            self.userNickNameTextInput.text = ""
        }else {
            self.userNickNameTextInput.text = self.setUser!.nickName
        }
        self.saveButton.frame.origin.y = self.userNickNameTextInput.frame.origin.y + 134
        self.userNickNameTextInput.becomeFirstResponder()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CTASetUserInfoViewController.textFieldEditChange(_:)), name: "UITextFieldTextDidChangeNotification", object: self.userNickNameTextInput)
    }
    
    func reloadDescView(){
        self.setInfoLabel.text = NSLocalizedString("UserDesc", comment: "")
        self.descView.hidden = false
        if self.setUser == nil {
            self.userDescTextView.text = ""
        }else {
            self.userDescTextView.text = self.setUser!.userDesc
        }
        
        let newText = self.userDescTextView.text
        let newStr = NSString(string: newText!)
        let len = newStr.length;
        
        if len>0{
            self.userDescTextView.selectedRange = NSMakeRange(len,0);
        }else {
            self.userDescTextView.selectedRange = NSMakeRange(0, 0)
        }
        self.setDescView()
        self.userDescTextView.becomeFirstResponder()
    }
    
    func resetNikeNameView(){
        self.userNickNameTextInput.text = ""
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "UITextFieldTextDidChangeNotification", object: self.userNickNameTextInput)
    }
    
    func resetDescView(){
        self.userDescTextView.text = ""
    }
    
    func setDescView(){
        self.userDescTextView.sizeToFit()
        self.userDescTextView.frame.size.width = 280*self.getHorRate()
        let maxHeight = self.userDescTextView.frame.height
        self.descTextLine.frame.origin.y = self.userDescTextView.frame.origin.y + (maxHeight > 50 ? maxHeight - 1 : 49)
        self.saveButton.frame.origin.y = self.descTextLine.frame.origin.y + 64
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
            if newStr.length > 0 && newStr.length < 33{
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
        if self.setUser != nil {
            let newText = self.userDescTextView.text
            let newStr = NSString(string: newText!)
            if newStr.length > 0 && newStr.length < 141{
                self.showLoadingViewByView(self.saveButton)
                CTAUserDomain.getInstance().updateUserDesc(self.setUser!.userID, userDesc: newText!, compelecationBlock: { (info) -> Void in
                    self.hideLoadingViewByView(self.saveButton)
                    if info.result{
                        self.setUser!.userDesc = newText!
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
    
    func changeLoginUser(){
        if self.setUser != nil {
            CTAUserManager.logout()
            CTAUserManager.save(self.setUser!)
        }
    }
}

extension CTASetUserInfoViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        if self.saveButton.enabled {
            self.saveHandler()
        }
        return true
    }
    
    func textFieldEditChange(noti: NSNotification) {
        let textField = noti.object as! UITextField
        self.checkTextField(textField)
        textField.sizeToFit()
        textField.frame.size.width = 280*self.getHorRate()
        textField.frame.size.height = 50
        let text = textField.text
        if text == self.setUser!.nickName {
            self.saveButton.enabled = false
        }else {
            self.saveButton.enabled = true
        }
    }
    
    func checkTextField(textField: UITextField) -> Bool{
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
            let newText = textStr.substringToIndex(textStr.length - 1)
            let newStr = NSString(string: newText)
            textField.text = newText
            let rageLength = textField.offsetFromPosition(textField.beginningOfDocument, toPosition: range!.start)
            if rageLength < newStr.length{
                textField.selectedTextRange = range
            }
            return self.checkTextField(textField)
        }else {
            return true
        }
    }
}

extension CTASetUserInfoViewController: UITextViewDelegate{
    
    func textViewDidChange(textView: UITextView){
        self.checkTextView(textView)
        self.setDescView()
        let viewText = textView.text
        if viewText == self.setUser!.userDesc {
            self.saveButton.enabled = false
        }else {
            self.saveButton.enabled = true
        }
    }
    
    func checkTextView(textView: UITextView) -> Bool{
        textView.sizeToFit()
        let viewText = textView.text
        let textStr = NSString(string: viewText!)
        let textHeight = textView.contentSize.height
        var needReset:Bool = false
        if textHeight < 200{
            if textStr.length < 141 {
                needReset = false
            }else {
                needReset = true
            }
        }else {
            needReset = true
        }
        if needReset {
            let newStr = textStr.substringToIndex(textStr.length - 1)
            let newText = newStr as String
            textView.text = newText
            return self.checkTextView(textView)
        }else {
            return true
        }
    }
}

extension CTASetUserInfoViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
