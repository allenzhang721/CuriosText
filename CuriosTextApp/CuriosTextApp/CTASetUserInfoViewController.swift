//
//  CTASetUserInfoViewController.swift
//  CuriosTextApp
//
//  Created by allen on 16/2/16.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit

enum CTASetUserInfoType{
    case NickName, Sex, Desc
}

class CTASetUserInfoViewController: UIViewController {
    
    static var _instance:CTASetUserInfoViewController?;
    
    static func getInstance() -> CTASetUserInfoViewController{
        if _instance == nil{
            _instance = CTASetUserInfoViewController();
        }
        return _instance!
    }
    
    var setUser:CTAUserModel?
    var setType:CTASetUserInfoType = .NickName
    
    var setInfoLabel:UILabel!
    
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
    }
    
    func reloadView(){
        switch self.setType{
        case .NickName:
            self.reloadNikeNameView()
        case .Sex:
            self.reloadSexView()
        case .Desc:
            self.reloadDescView()
        }
    }
    
    func reloadNikeNameView(){
        self.setInfoLabel.text = NSLocalizedString("UserNickNameLabel", comment: "")
    }
    
    func reloadSexView(){
        self.setInfoLabel.text = NSLocalizedString("UserSexLabel", comment: "")
    }
    
    func reloadDescView(){
        self.setInfoLabel.text = NSLocalizedString("UserDesc", comment: "")
    }
    
    func backButtonClick(sender: UIButton){
        self.navigationController?.popViewControllerAnimated(true)
    }
}