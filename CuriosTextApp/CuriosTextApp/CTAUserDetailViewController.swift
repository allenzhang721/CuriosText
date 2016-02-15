//
//  CTAUserDetailController.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/14.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit
import Kingfisher

class CTAUserDetailViewController: UIViewController, CTAImageControllerProtocol, CTALoadingProtocol, CTASystemLanguageProtocol, CTAPublishCellProtocol{
    
    var backImageView:UIView!
    var userIconImageView:UIImageView!
    var userFollowingImageView:UIImageView!
    var userNickNameLabel:UILabel!
    var userDescTextView:UITextView!
    var followButton:UIButton!
    var followButtonView:UIView!
    var followButtonBgView:UIImageView!
    
    var lineImageView:UIImageView!
    var followLabel:UILabel!
    var followCountLabel:UILabel!
    var beFollowLabel:UILabel!
    var beFollowCountLabel:UILabel!
    
    var blackColorView:UIView!
    
    var viewUser:CTAUserModel?
    var loginUserID:String = ""
    var userDetailModel:CTAViewUserModel?
    
    var loadingImageView:UIImageView? = UIImageView()
    
    static var _instance:CTAUserDetailViewController?;
    
    static func getInstance() -> CTAUserDetailViewController{
        if _instance == nil{
            _instance = CTAUserDetailViewController();
        }
        return _instance!
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initView();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.viewUser != nil {
            self.setViewByUserModel()
        } else {
            self.setDefaultView()
        }
        self.fitView()
        self.loadUserDetail()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.resetDisView()
    }
    
    func initView(){
        self.blackColorView = UIView.init(frame: self.view.bounds)
        self.view.addSubview(self.blackColorView!)
        let tap = UITapGestureRecognizer(target: self, action: "backButtonClikc:")
        self.blackColorView.addGestureRecognizer(tap)
        
        let rate       = self.getHorRate()
        let backWidth  = rate * 300
        let backHeight = rate * 440
        self.backImageView = UIView.init(frame: CGRect.init(x: (self.view.frame.width - backWidth)/2, y: (self.view.frame.height - backHeight)/2, width: backWidth, height: backHeight))
        self.view.addSubview(self.backImageView!)
        self.backImageView.backgroundColor = UIColor.whiteColor()
        self.cropImageRound(self.backImageView)

        self.userIconImageView = UIImageView.init(frame:CGRect.init(x: (self.view.frame.size.width - 60)/2, y: self.backImageView.frame.origin.y + 14*rate, width: 60, height: 60))
        self.view.addSubview(self.userIconImageView)
        self.cropImageCircle(self.userIconImageView)
        
        let imgFrame = self.userIconImageView.frame
        self.userFollowingImageView = UIImageView.init(frame: CGRect.init(x: (imgFrame.origin.x+imgFrame.size.width)-18, y: (imgFrame.origin.y+imgFrame.size.height)-18, width: 18, height: 18))
        userFollowingImageView.image = UIImage.init(named: "following-icon")
        self.view.addSubview(self.userFollowingImageView)
        self.userFollowingImageView.hidden = true
        
        self.userNickNameLabel = UILabel.init(frame: CGRect.init(x: 120, y: self.userIconImageView.frame.origin.y + 65*rate, width: 120, height: 28))
        self.view.addSubview(self.userNickNameLabel)
        self.userNickNameLabel.font = UIFont.systemFontOfSize(20)
        self.userNickNameLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        self.userNickNameLabel.text = " "
        self.userNickNameLabel.sizeToFit()
        
        self.lineImageView = UIImageView.init(frame: CGRect.init(x: self.view.frame.size.width / 2 - 1, y: self.userNickNameLabel.frame.origin.y + 85*rate, width: 2, height: 18))
        self.lineImageView.image = UIImage.init(named: "follow-line")
        self.view.addSubview(self.lineImageView)
        
        self.followLabel = UILabel.init()
        self.view.addSubview(self.followLabel)
        self.followLabel.font = UIFont.systemFontOfSize(10)
        self.followLabel.textColor = UIColor.init(red: 239/255, green: 51/255, blue: 74/255, alpha: 1.0)
        self.followLabel.text = NSLocalizedString("FollowLabel", comment: "")
        self.followLabel.sizeToFit()
        self.followLabel.frame.origin.x = self.view.frame.size.width / 2 - self.followLabel.frame.width - 20
        self.followLabel.frame.origin.y = self.lineImageView.frame.origin.y-self.followLabel.frame.height - 2
    
        self.followCountLabel = UILabel.init()
        self.view.addSubview(self.followCountLabel)
        self.followCountLabel.font = UIFont.systemFontOfSize(18)
        self.followCountLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        self.followCountLabel.text = "0"
        
        self.beFollowLabel = UILabel.init()
        self.view.addSubview(self.beFollowLabel)
        self.beFollowLabel.font = UIFont.systemFontOfSize(10)
        self.beFollowLabel.textColor = UIColor.init(red: 239/255, green: 51/255, blue: 74/255, alpha: 1.0)
        self.beFollowLabel.text = NSLocalizedString("BeFollowLabel", comment: "")
        self.beFollowLabel.sizeToFit()
        self.beFollowLabel.frame.origin.x = self.view.frame.size.width / 2  + 20
        self.beFollowLabel.frame.origin.y = self.lineImageView.frame.origin.y - self.beFollowLabel.frame.height - 2
    
        self.beFollowCountLabel = UILabel.init()
        self.view.addSubview(self.beFollowCountLabel)
        self.beFollowCountLabel.font = UIFont.systemFontOfSize(18)
        self.beFollowCountLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        self.beFollowCountLabel.text = "0"
        
        self.userDescTextView = UITextView.init(frame: CGRect.init(x: (self.view.frame.width - 260*rate)/2, y: self.lineImageView.frame.origin.y + 52*rate, width: 260*rate, height: 140*rate))
        self.userDescTextView.editable = false
        self.userDescTextView.scrollEnabled = false
        self.userDescTextView.selectable = false
        self.userDescTextView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        self.view.addSubview(self.userDescTextView)
        self.userDescTextView.font = UIFont.systemFontOfSize(14)
        self.userDescTextView.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        self.userDescTextView.textAlignment = .Center
        
        self.followButtonView = UIView.init(frame: CGRect.init(x: (self.view.frame.width - 120*rate)/2, y: (self.backImageView.frame.origin.y+self.backImageView.frame.height - 65*rate), width: 120*rate, height: 35*rate))
        self.view.addSubview(self.followButtonView)
        
        self.followButtonBgView = UIImageView.init(image: UIImage.init(named: "follow-button"))
        self.followButtonBgView.frame.size = self.followButtonView.frame.size
        self.followButtonView.addSubview(self.followButtonBgView)
        
        self.followButton = UIButton.init()
        self.followButton.frame.size = self.followButtonView.frame.size
        self.followButtonBgView.addSubview(self.followButton)
        self.followButton.setTitleColor(UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0), forState: .Normal)
        self.followButtonView.hidden = true
        
        let followTap = UITapGestureRecognizer(target: self, action: "followButtonClick:")
        self.followButtonView.addGestureRecognizer(followTap)
    }
    
    func setViewByUserModel(){
        
        let imagePath = CTAFilePath.userFilePath+(self.viewUser?.userIconURL)!
        let imageURL = NSURL(string: imagePath)!
        self.userIconImageView.kf_showIndicatorWhenLoading = true
        self.userIconImageView.kf_setImageWithURL(imageURL, placeholderImage: UIImage.init(named: "default-usericon"), optionsInfo: [.Transition(ImageTransition.Fade(1))])
        
        self.userNickNameLabel.text = self.viewUser?.nickName
        self.userDescTextView.text  = self.viewUser?.userDesc
    }
    
    func setDefaultView(){
        self.userIconImageView.image = UIImage.init(named: "default-usericon")
        self.userNickNameLabel.text = "Curios"
        self.userDescTextView.text  = "To be or not to be, That's a question!"
        self.followButtonView.hidden = true
        self.followCountLabel.text = "0"
        self.beFollowCountLabel.text = "0"
    }
    
    func resetDisView(){
        self.setDefaultView()
        self.fitView()
        self.viewUser = nil
        self.userDetailModel = nil
        self.loginUserID = ""
    }
    
    func fitView(){
        self.userNickNameLabel.sizeToFit()
        if self.userNickNameLabel.frame.width > self.view.frame.width - 80 {
            self.userNickNameLabel.frame.size.width = self.view.frame.width - 80
        }
        self.userNickNameLabel.frame.origin.x = (self.view.frame.width - self.userNickNameLabel.frame.width)/2
        
        self.followCountLabel.sizeToFit()
        self.followCountLabel.frame.origin.x = self.followLabel.frame.origin.x + (self.followLabel.frame.size.width - self.followCountLabel.frame.width)/2
        self.followCountLabel.frame.origin.y = self.followLabel.frame.origin.y + self.followLabel.frame.height
        
        self.beFollowCountLabel.sizeToFit()
        self.beFollowCountLabel.frame.origin.x = self.beFollowLabel.frame.origin.x + (self.beFollowLabel.frame.width - self.beFollowCountLabel.frame.width)/2
        self.beFollowCountLabel.frame.origin.y = self.beFollowLabel.frame.origin.y + self.beFollowLabel.frame.height
    }
    
    func loadUserDetail(){
        self.showLoadingViewByView(self.followButtonView)
        CTAUserDomain.getInstance().userDetail(self.loginUserID, beUserID: self.viewUser!.userID) { (info) -> Void in
            if info.result{
                self.userDetailModel = info.baseModel! as? CTAViewUserModel
            }else {
                self.userDetailModel = nil
            }
            self.setViewByDetailUser()
            self.hideLoadingView()
        }
    }
    
    func setViewByDetailUser(){
        if userDetailModel == nil {
            self.followButtonView!.hidden = true
            self.userFollowingImageView.hidden = true
            self.followButton.setTitle("", forState: .Normal)
            self.followCountLabel.text = "0"
            self.beFollowCountLabel.text = "0"
        }else {
            let followCount = self.userDetailModel!.followCount
            let beFollowCount = self.userDetailModel!.beFollowCount
            self.setFollowButton()
            
            self.followCountLabel.text = self.changeCountToString(followCount)
            self.beFollowCountLabel.text = self.changeCountToString(beFollowCount)
            
            let imagePath = CTAFilePath.userFilePath+self.userDetailModel!.userIconURL
            let imageURL = NSURL(string: imagePath)!
            self.userIconImageView.kf_showIndicatorWhenLoading = true
            self.userIconImageView.kf_setImageWithURL(imageURL, placeholderImage: UIImage.init(named: "default-usericon"), optionsInfo: [.Transition(ImageTransition.Fade(1))])
            
            self.userNickNameLabel.text = self.userDetailModel!.nickName
            self.userDescTextView.text  = self.userDetailModel!.userDesc
        }
        self.fitView()
    }
    
    func setFollowButton(){
        let relationType:Int = self.userDetailModel!.relationType
        self.followButtonView.hidden = false
        var buttonLabel:String = ""
        switch  relationType{
        case -1:
            self.followButtonView.hidden = true
            self.userFollowingImageView.hidden = true
        case 0, 3:
            if self.loginUserID == "" {
               self.followButtonView.hidden = true
            }else {
               buttonLabel = NSLocalizedString("FollowButtonLabel", comment: "")
            }
            self.userFollowingImageView.hidden = true
        case 1, 5:
            buttonLabel = NSLocalizedString("UnFollowButtonLabel", comment: "")
            self.userFollowingImageView.hidden = false
        case 2, 4, 6:
            self.followButtonView.hidden = true
            self.userFollowingImageView.hidden = true
        default:
            buttonLabel = ""
        }
        self.followButton.setTitle(buttonLabel, forState: .Normal)
    }
    
    func changeCountToString(count:Int) -> String{
        var countString:String = ""
        let language = self.getCurrentLanguage()
        if language == "zh-Hant-US" || language == "zh-Hans-US" || language == "zh-HK" {
            if count < 10000 {
                countString = String(count)
            }else if count < 100000000{
                if count < 1000000{
                    var countFloat = Double(count) / 10000.00
                    let countNumber = floor(countFloat*10)
                    countFloat = Double(countNumber)/10
                    if (countFloat - floor(countFloat))*10 < 1 {
                        countString = String(Int(countFloat)) + NSLocalizedString("TenThousand", comment: "")
                    }else {
                        countString =  String(format: "%.1f", countFloat) + NSLocalizedString("TenThousand", comment: "")
                    }
                }else {
                    let countInt = count / 10000
                    countString = String(countInt) + NSLocalizedString("TenThousand", comment: "")
                }
            }else {
                var countFloat = Double(count) / 100000000.00
                let countNumber = floor(countFloat*10)
                countFloat = Double(countNumber)/10
                if (countFloat - floor(countFloat))*10 < 1 {
                    countString = String(Int(countFloat)) + NSLocalizedString("HundredMillion", comment: "")
                }else {
                    countString =  String(format: "%.1f", countFloat) + NSLocalizedString("HundredMillion", comment: "")
                }
            }
        }else {
            if count < 1000 {
                countString = String(count)
            }else if count < 1000000{
                if count < 100000{
                    var countFloat = Double(count) / 1000.00
                    let countNumber = floor(countFloat*10)
                    countFloat = Double(countNumber)/10
                    if (countFloat - floor(countFloat))*10 < 1 {
                        countString = String(Int(countFloat)) + NSLocalizedString("Thousand", comment: "")
                    }else {
                        countString =  String(format: "%.1f", countFloat) + NSLocalizedString("Thousand", comment: "")
                    }
                }else {
                    let countInt = count / 1000
                    countString = String(countInt) + NSLocalizedString("Thousand", comment: "")
                }
            }else if count < 1000000000{
                if count < 100000000{
                    var countFloat = Double(count) / 1000000.00
                    let countNumber = floor(countFloat*10)
                    countFloat = Double(countNumber)/10
                    if (countFloat - floor(countFloat))*10 < 1 {
                        countString = String(Int(countFloat)) + NSLocalizedString("Million", comment: "")
                    }else {
                        countString =  String(format: "%.1f", countFloat) + NSLocalizedString("Million", comment: "")
                    }
                }else {
                    let countInt = count / 1000000
                    countString = String(countInt) + NSLocalizedString("Million", comment: "")
                }
            }else {
                var countFloat = Double(count) / 1000000000.00
                let countNumber = floor(countFloat*10)
                countFloat = Double(countNumber)/10
                if (countFloat - floor(countFloat))*10 < 1 {
                    countString = String(Int(countFloat)) + NSLocalizedString("Billion", comment: "")
                }else {
                    countString =  String(format: "%.1f", countFloat) + NSLocalizedString("Billion", comment: "")
                }
            }
        }
        return countString
    }
    
    func backButtonClikc(sender: UITapGestureRecognizer){
        let pt = sender.locationInView(self.backImageView)
        if !backImageView.pointInside(pt, withEvent: nil){
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.blackColorView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                })
                }, completion: { (_) -> Void in
                    self.dismissViewControllerAnimated(true) { () -> Void in
                        
                    }
            })
        }
    }
    
    func followButtonClick(sender: UITapGestureRecognizer){
        
        if self.userDetailModel != nil{
            let relationType:Int = self.userDetailModel!.relationType
            switch  relationType{
            case 0, 3:
                self.showLoadingViewByView(self.followButtonView)
                CTAUserRelationDomain.getInstance().followUser(self.loginUserID, relationUserID: self.userDetailModel!.userID) { (info) -> Void in
                    if info.result {
                        self.userDetailModel!.relationType = (relationType==0 ? 1 : 5)
                        self.userDetailModel!.beFollowCount += 1
                        self.setViewByDetailUser()
                    }
                    self.hideLoadingViewByView(self.followButtonView)
                }
            case 1, 5:
                self.showLoadingViewByView(self.followButtonView)
                CTAUserRelationDomain.getInstance().unFollowUser(self.loginUserID, relationUserID: self.userDetailModel!.userID) { (info) -> Void in
                    if info.result {
                        self.userDetailModel!.relationType = (relationType==1 ? 0 : 3)
                        self.userDetailModel!.beFollowCount = (self.userDetailModel!.beFollowCount - 1  > 0 ? self.userDetailModel!.beFollowCount - 1 : 0)
                        self.setViewByDetailUser()
                    }
                    self.hideLoadingViewByView(self.followButtonView)
                }
            default:
                break
            }
        }
    }
    
    func setBackgroundColor(){
        if let view = self.blackColorView{
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            })
        }
    }
    
}