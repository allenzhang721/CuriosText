//
//  CTAAccountSettingViewController.swift
//  CuriosTextApp
//
//  Created by allen on 16/5/23.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation

class CTAAccountSettingViewController: UIViewController {

    static var _instance:CTAAccountSettingViewController?;
    
    static func getInstance() -> CTAAccountSettingViewController{
        if _instance == nil{
            _instance = CTAAccountSettingViewController();
        }
        return _instance!
    }
    
    var loginUser:CTAUserModel?
    
    
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
        
        
    }
    
    func backButtonClick(sender: UIButton){
        self.backHandler()
    }
    
    func backHandler(){
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension CTAAccountSettingViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
}