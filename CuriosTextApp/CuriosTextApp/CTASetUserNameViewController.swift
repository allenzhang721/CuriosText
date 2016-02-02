//
//  CTASetUserNameViewController.swift
//  CuriosTextApp
//
//  Created by allen on 16/2/2.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation

class CTASetUserNameViewController: UIViewController, CTAPublishCellProtocol, CTAAlertProtocol, CTATextInputProtocol{
    
    static var _instance:CTASetUserNameViewController?;
    
    static func getInstance() -> CTASetUserNameViewController{
        if _instance == nil{
            _instance = CTASetUserNameViewController();
        }
        return _instance!
    }
    
    var userNameTextInput:UITextField!
    var completeButton:UIButton!
    var iconImageButton:UIButton!
    
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
        
        let backButton = UIButton.init(frame: CGRect.init(x: 20, y: 12, width: 11, height: 20))
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
        
        self.iconImageButton = UIButton.init(frame: CGRect.init(x: (bouns.width - 60)/2, y: 170*self.getVerRate(), width: 60, height: 62))
        self.iconImageButton.setImage(UIImage(named: "setimage-icon"), forState: .Normal)
        self.iconImageButton.addTarget(self, action: "iconImageButtonClick:", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.iconImageButton)
        
        let userNameLabel = UILabel.init(frame: CGRect.init(x: 27*self.getHorRate(), y: 262*self.getVerRate(), width: 50, height: 25))
        userNameLabel.font = UIFont.systemFontOfSize(18)
        userNameLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        userNameLabel.text = NSLocalizedString("UserNameLabel", comment: "")
        userNameLabel.sizeToFit()
        self.view.addSubview(userNameLabel)
        
        self.userNameTextInput = UITextField.init(frame: CGRect.init(x:128*self.getHorRate(), y: 250*self.getVerRate(), width: 190*self.getHorRate(), height: 50))
        self.userNameTextInput.placeholder = NSLocalizedString("UserNamePlaceholder", comment: "")
        self.userNameTextInput.clearsOnBeginEditing = true
        self.userNameTextInput.delegate = self
        self.view.addSubview(self.userNameTextInput)
        let textLine = UIImageView.init(frame: CGRect.init(x: 25*self.getHorRate(), y: 299*self.getVerRate(), width: 330*self.getHorRate(), height: 1))
        textLine.image = UIImage(named: "textinput-line")
        self.view.addSubview(textLine)
        
        self.completeButton = UIButton.init(frame: CGRect.init(x: (bouns.width - 40)/2, y: 320*self.getVerRate(), width: 40, height: 28))
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
        self.iconImageButton.setImage(UIImage(named: "setimage-icon"), forState: .Normal)
        self.userNameTextInput.text = ""
        self.completeButton.enabled = false
    }
    
    func backButtonClick(sender: UIButton){
        self.showSelectedAlert(NSLocalizedString("AlertTitleUserNameBack", comment: ""), alertMessage: "", okAlertLabel: NSLocalizedString("AlertOkLabel", comment: ""), cancelAlertLabel: NSLocalizedString("AlertCancelLabel", comment: "")) { (result) -> Void in
            if result {
                let mobile = CTASetMobileNumberViewController.getInstance()
                self.navigationController?.popToViewController(mobile, animated: true)
            }
        }
       
    }
    
    func completeButtonClick(sender: UIButton){
    
    }
    
    func iconImageButtonClick(sender: UIButton){
        
    }
    
    func bgViewClick(sender: UIPanGestureRecognizer){
        self.resignHandler(sender)
    }
}

extension CTASetUserNameViewController: UITextFieldDelegate{
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        let newText = self.userNameTextInput.text
        let newStr = NSString(string: newText!)
        let isDelete = string == "" ? true : false
        if isDelete {
            if newStr.length == 1{
                self.completeButton.enabled = false
            }
        }else{
            self.completeButton.enabled = true
        }
        return true
    }
}