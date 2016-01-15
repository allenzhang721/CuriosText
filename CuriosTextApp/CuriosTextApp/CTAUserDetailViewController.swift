//
//  CTAUserDetailController.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/14.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit
import Kingfisher

class CTAUserDetailViewController: UIViewController, CTAImageControllerProtocol, CTALoadingProtocol{
    
    var backImageView:UIImageView!
    var userIconImageView:UIImageView!
    var userNikeNameLabel:UILabel!
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
    
    var userModel:CTAUserModel?
    var loginUserID:String = ""
    var userDetailModel:CTAViewUserModel?
    
    var loadingImageView:UIImageView?
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initBackView();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.userModel != nil {
            self.setViewByUserModel()
        } else {
            self.setDefaultView()
        }
        self.fitView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.loadUserDetail();
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.resetDisView()
    }
    
    func initBackView(){
        self.blackColorView = UIView.init(frame: self.view.bounds)
        self.view.addSubview(self.blackColorView!)
        let tap = UITapGestureRecognizer(target: self, action: "backButtonClikc:")
        self.blackColorView.addGestureRecognizer(tap)
        
        let backWidth  = self.view.frame.width - 56
        let rate       = backWidth/375
        let backHeight = rate * 517
        self.backImageView = UIImageView.init(frame: CGRect.init(x: 28, y: (self.view.frame.height - backHeight)/2, width: backWidth, height: backHeight))
        self.view.addSubview(self.backImageView!)
        self.backImageView.image = UIImage.init(named: "userdetail_bakground")
        
        self.userIconImageView = UIImageView.init(frame: CGRect.init(x: (self.view.frame.size.width - 90)/2, y: self.backImageView.frame.origin.y + 20*rate, width: 90, height: 90))
        self.view.addSubview(self.userIconImageView)
        self.cropImageCircle(self.userIconImageView)
        
        self.userNikeNameLabel = UILabel.init(frame: CGRect.init(x: 120, y: self.userIconImageView.frame.origin.y + self.userIconImageView.frame.size.height + 30*rate, width: 78, height: 40))
        self.view.addSubview(self.userNikeNameLabel)
        self.userNikeNameLabel.font = UIFont.systemFontOfSize(26)
        self.userNikeNameLabel.textColor = UIColor.whiteColor()
        self.userNikeNameLabel.text = " "
        self.userNikeNameLabel.sizeToFit()
        
        self.lineImageView = UIImageView.init(frame: CGRect.init(x: self.view.frame.size.width / 2 - 1, y: self.userNikeNameLabel.frame.origin.y + self.userNikeNameLabel.frame.size.height + 30*rate, width: 2, height: 18))
        self.lineImageView.image = UIImage.init(named: "follow-line")
        self.view.addSubview(self.lineImageView)
        
        self.followLabel = UILabel.init()
        self.view.addSubview(self.followLabel)
        self.followLabel.font = UIFont.systemFontOfSize(18)
        self.followLabel.textColor = UIColor.whiteColor()
        self.followLabel.text = "关注"
        self.followLabel.sizeToFit()
        self.followLabel.frame.origin.x = self.view.frame.size.width / 2 - self.followLabel.frame.width - 20
        self.followLabel.frame.origin.y = self.lineImageView.frame.origin.y+self.lineImageView.frame.height/2-self.followLabel.frame.height/2
        
        self.followCountLabel = UILabel.init()
        self.view.addSubview(self.followCountLabel)
        self.followCountLabel.font = UIFont.systemFontOfSize(16)
        self.followCountLabel.textColor = UIColor.whiteColor()
        
        self.beFollowLabel = UILabel.init()
        self.view.addSubview(self.beFollowLabel)
        self.beFollowLabel.font = UIFont.systemFontOfSize(18)
        self.beFollowLabel.textColor = UIColor.whiteColor()
        self.beFollowLabel.text = "粉丝"
        self.beFollowLabel.sizeToFit()
        self.beFollowLabel.frame.origin.x = self.view.frame.size.width / 2  + 20
        self.beFollowLabel.frame.origin.y = self.lineImageView.frame.origin.y+self.lineImageView.frame.height/2-self.followLabel.frame.height/2
    
        self.beFollowCountLabel = UILabel.init()
        self.view.addSubview(self.beFollowCountLabel)
        self.beFollowCountLabel.font = UIFont.systemFontOfSize(16)
        self.beFollowCountLabel.textColor = UIColor.whiteColor()
        
        self.userDescTextView = UITextView.init(frame: CGRect.init(x: (self.view.frame.width - self.backImageView.frame.width + 20)/2, y: self.lineImageView.frame.origin.y + self.lineImageView.frame.size.height + 30*rate, width: self.backImageView.frame.width - 20, height: 90))
        self.userDescTextView.editable = false
        self.userDescTextView.scrollEnabled = false
        self.userDescTextView.selectable = false
        self.userDescTextView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        self.view.addSubview(self.userDescTextView)
        self.userDescTextView.font = UIFont.systemFontOfSize(18)
        self.userDescTextView.textColor = UIColor.whiteColor()
        self.userDescTextView.textAlignment = .Center

        
        self.followButtonView = UIView.init(frame: CGRect.init(x: (self.view.frame.width - 120)/2, y: (self.backImageView.frame.origin.y+self.backImageView.frame.height - 65), width: 120, height: 46))
        self.view.addSubview(self.followButtonView)
        
        self.followButtonBgView = UIImageView.init(image: UIImage.init(named: "follow-button"))
        self.followButtonBgView.frame.size = self.followButtonView.frame.size
        self.followButtonView.addSubview(self.followButtonBgView)
        
        self.followButton = UIButton.init()
        self.followButton.frame.size = self.followButtonView.frame.size
        self.followButtonBgView.addSubview(self.followButton)
        self.followButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.followButtonView.hidden = true
        
        let followTap = UITapGestureRecognizer(target: self, action: "followButtonClick:")
        self.followButtonView.addGestureRecognizer(followTap)
    }
    
    func setViewByUserModel(){
        
        let imagePath = CTAFilePath.userFilePath+(self.userModel?.userIconURL)!
        let imageURL = NSURL(string: imagePath)!
        self.userIconImageView.kf_showIndicatorWhenLoading = true
        self.userIconImageView.kf_setImageWithURL(imageURL, placeholderImage: UIImage.init(named: "default-usericon"), optionsInfo: [.Transition(ImageTransition.Fade(1))])
        
        self.userNikeNameLabel.text = self.userModel?.nikeName
        self.userDescTextView.text  = self.userModel?.userDesc
    }
    
    func setDefaultView(){
        self.userIconImageView.image = UIImage.init(named: "default-usericon")
        self.userNikeNameLabel.text = "Curios"
        self.userDescTextView.text  = "To be or not to be, That's a question!"
        self.followButtonView.hidden = true
    }
     
    func resetDisView(){
        self.setDefaultView()
        self.fitView()
        if self.loadingImageView != nil {
            self.hideLoadingView(self.loadingImageView!)
        }
        self.userModel = nil
        self.userDetailModel = nil
        self.loginUserID = ""
        self.followCountLabel.text = ""
        self.beFollowCountLabel.text = ""
    }
    
    func fitView(){
        self.userNikeNameLabel.sizeToFit()
        if self.userNikeNameLabel.frame.width > self.view.frame.width - 80 {
            self.userNikeNameLabel.frame.size.width = self.view.frame.width - 80
        }
        self.userNikeNameLabel.frame.origin.x = (self.view.frame.width - self.userNikeNameLabel.frame.width)/2
    }
    
    func loadUserDetail(){
        self.followButtonView!.hidden = true
        self.showLoadingHandle();
        CTAUserDomain.getInstance().userDetail(self.loginUserID, beUserID: self.userModel!.userID) { (info) -> Void in
            if info.result{
                self.userDetailModel = info.baseModel! as? CTAViewUserModel
            }else {
                self.userDetailModel = nil
            }
            self.setViewByDetailUser()
            self.hideLoadingHandler()
        }
    }
    
    func showLoadingHandle(){
        if self.loadingImageView == nil {
            let rect = CGRect.init(x: self.followButtonView.frame.origin.x + self.followButtonView.frame.width/2 - 20, y: self.followButtonView.frame.origin.y + self.followButtonView.frame.height/2 - 20, width: 40, height: 40)
            self.loadingImageView = UIImageView.init(frame: rect)
        }
        self.showLoadingView(self.loadingImageView!, superView: self.view)
    }
    
    func hideLoadingHandler(){
        self.hideLoadingView(self.loadingImageView!)
    }
    
    func setViewByDetailUser(){
        if userDetailModel == nil {
            self.followButtonView!.hidden = true
            self.followButton.setTitle("", forState: .Normal)
            self.followCountLabel.text = ""
            self.beFollowCountLabel.text = ""
        }else {
            let followCount = self.userDetailModel!.followCount
            let beFollowCount = self.userDetailModel!.beFollowCount
            self.setFollowButton()
            
            self.followCountLabel.text = self.changeCountToString(followCount)
            self.followCountLabel.sizeToFit()
            self.followCountLabel.frame.origin.x = self.followLabel.frame.origin.x - self.followCountLabel.frame.size.width - 5
            self.followCountLabel.frame.origin.y = self.followLabel.frame.origin.y + self.followLabel.frame.height/2 - self.followCountLabel.frame.height/2
            
            self.beFollowCountLabel.text = self.changeCountToString(beFollowCount)
            self.beFollowCountLabel.sizeToFit()
            self.beFollowCountLabel.frame.origin.x = self.beFollowLabel.frame.origin.x + self.beFollowLabel.frame.width + 5
            self.beFollowCountLabel.frame.origin.y = self.beFollowLabel.frame.origin.y + self.beFollowLabel.frame.height/2 - self.beFollowCountLabel.frame.height/2
            
            let imagePath = CTAFilePath.userFilePath+self.userDetailModel!.userIconURL
            let imageURL = NSURL(string: imagePath)!
            self.userIconImageView.kf_showIndicatorWhenLoading = true
            self.userIconImageView.kf_setImageWithURL(imageURL, placeholderImage: UIImage.init(named: "default-usericon"), optionsInfo: [.Transition(ImageTransition.Fade(1))])
            
            self.userNikeNameLabel.text = self.userDetailModel!.nikeName
            self.userDescTextView.text  = self.userDetailModel!.userDesc
            self.fitView()
        }
    }
    
    func setFollowButton(){
        let relationType:Int = self.userDetailModel!.relationType
        self.followButtonView.hidden = false
        var buttonLabel:String = ""
        switch  relationType{
        case -1:
            self.followButtonView.hidden = true;
        case 0, 3:
            buttonLabel = "关注"
        case 1, 5:
            buttonLabel = "取消关注"
        case 2, 4, 6:
            self.followButtonView.hidden = true;
        default:
            buttonLabel = ""
        }
        self.followButton.setTitle(buttonLabel, forState: .Normal)
    }
    
    func changeCountToString(count:Int) -> String{
        var countString:String = ""
        if count < 10000 {
            countString = String(count)
        }else {
            if count < 1000000{
                if count%10000 < 1000{
                    let countInt = count / 10000
                    countString = String(countInt) + "万"
                }else{
                    let countFloat = Double(count) / 10000.00
                    countString = String(format: "%.1f", countFloat) + "万"
                }
            }else {
                if count < 100000000{
                    let countInt = count / 10000
                    countString = String(countInt) + "万"
                } else {
                    if count%100000000 < 10000000{
                        let countInt = count / 100000000
                        countString = String(countInt) + "亿"
                    }else{
                        let countFloat = Double(count) / 100000000.00
                        countString = String(format: "%.1f", countFloat) + "亿"
                    }
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
                self.followButtonView!.hidden = true
                self.showLoadingHandle()
                CTAUserRelationDomain.getInstance().followUser(self.loginUserID, relationUserID: self.userDetailModel!.userID) { (info) -> Void in
                    if info.result {
                        self.userDetailModel!.relationType = (relationType==0 ? 1 : 5)
                        self.userDetailModel!.beFollowCount += 1
                        self.setViewByDetailUser()
                    }
                    self.followButtonView!.hidden = false
                    self.hideLoadingHandler()
                }
            case 1, 5:
                self.followButtonView!.hidden = true
                self.showLoadingHandle()
                CTAUserRelationDomain.getInstance().unFollowUser(self.loginUserID, relationUserID: self.userDetailModel!.userID) { (info) -> Void in
                    if info.result {
                        self.userDetailModel!.relationType = (relationType==1 ? 0 : 3)
                        self.userDetailModel!.beFollowCount = (self.userDetailModel!.beFollowCount - 1  > 0 ? self.userDetailModel!.beFollowCount - 1 : 0)
                        self.setViewByDetailUser()
                    }
                    self.followButtonView!.hidden = false
                    self.hideLoadingHandler()
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