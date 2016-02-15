//
//  CTASettingViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTASettingViewController: UIViewController {

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
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
        settingLabel.font = UIFont.systemFontOfSize(20)
        settingLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        settingLabel.text = NSLocalizedString("SettingLabel", comment: "")
        settingLabel.textAlignment = .Center
        self.view.addSubview(settingLabel)
        
        let backButton = UIButton.init(frame: CGRect.init(x: 5, y: 2, width: 40, height: 40))
        backButton.setImage(UIImage(named: "back-button"), forState: .Normal)
        backButton.addTarget(self, action: "backButtonClick:", forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton)
    }
    
    func backButtonClick(sender: UIButton){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
