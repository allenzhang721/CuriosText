//
//  CTALoginViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTALoginViewController: UIViewController, CTAPublishCellProtocol {
    
    static var _instance:CTALoginViewController?;
    
    static func getInstance() -> CTALoginViewController{
        if _instance == nil{
            _instance = CTALoginViewController();
        }
        return _instance!
    }
    
    var userPhoneTextinput:UITextField!
    var userPasswordTextinput:UITextField!
    var countryNameLabel:UILabel!
    
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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
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
        let closeButton = UIButton.init(frame: CGRect.init(x: 10, y: 10, width: 35, height: 35))
        closeButton.setImage(UIImage(named: "close-button"), forState: .Normal)
        closeButton.addTarget(self, action: "closeButtonClick:", forControlEvents: .TouchUpInside)
        self.view.addSubview(closeButton)
        
        let iconImage = UIImageView.init(frame: CGRect.init(x: (bouns.width - 50)/2, y: 100*self.getVerRate(), width: 50, height: 52))
        iconImage.image = UIImage(named: "defaultpublish-icon")
        self.view.addSubview(iconImage)
        
        let countryLabel = UILabel.init(frame: CGRect.init(x: 27, y: 214*self.getVerRate(), width: 82, height: 25))
        countryLabel.font = UIFont.systemFontOfSize(18)
        countryLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        countryLabel.text = NSLocalizedString("CountryLabel", comment: "")
        self.view.addSubview(countryLabel)
        self.countryNameLabel = UILabel.init(frame: CGRect.init(x: 128, y: 214*self.getVerRate(), width: 36, height: 25))
        self.countryNameLabel.font = UIFont.systemFontOfSize(18)
        self.countryNameLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        self.countryNameLabel.text = "中国"
        self.view.addSubview(self.countryNameLabel)
        let nextImage = UIImageView.init(frame: CGRect.init(x: 330, y: 216*self.getVerRate(), width: 11, height: 20))
        nextImage.image = UIImage(named: "next-icon")
        self.view.addSubview(nextImage)
        
        let textLine = UIImageView.init(frame: CGRect.init(x: 27, y: 249*self.getVerRate(), width: 330, height: 1))
        textLine.image = UIImage(named: "textinput-line")
        self.view.addSubview(textLine)
        
        self.userPhoneTextinput = UITextField.init(frame: CGRect.init(x: (bouns.width - 280)/2, y: 300*self.getVerRate(), width: 280, height: 50))
        self.userPhoneTextinput.placeholder = NSLocalizedString("UserPhoneLabel", comment: "")
        self.view.addSubview(self.userPhoneTextinput)
        
        
        self.userPasswordTextinput = UITextField.init(frame: CGRect.init(x: (bouns.width - 280)/2, y: 350*self.getVerRate(), width: 280, height: 50))
        self.userPasswordTextinput.placeholder = NSLocalizedString("UserPasswordLabel", comment: "")
        self.userPasswordTextinput.secureTextEntry = true
        self.view.addSubview(self.userPasswordTextinput)
        let userPasswordLine = UIImageView.init(frame: CGRect.init(x: (bouns.width - 280)/2, y: 399*self.getVerRate(), width: 280, height: 1))
        userPasswordLine.image = UIImage(named: "textinput-line")
        self.view.addSubview(userPasswordLine)
    }
    
    func closeButtonClick(sender: UIButton){
        
        self.dismissViewControllerAnimated(false) { () -> Void in
            
        }
    }

}
