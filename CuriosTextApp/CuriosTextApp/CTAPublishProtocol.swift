//
//  CTAPublishProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/29.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation
import Kingfisher

protocol CTAPublishProtocol:CTAImageControllerProtocol, CTAShareViewProtocol, CTAAlertProtocol{
    var likeButton:UIButton{get}
    var userIconImage:UIImageView{get}
    var userNicknameLabel:UILabel{get}
    var publishModel:CTAPublishModel{get}
    var userModel:CTAUserModel?{get}
    func initPublishSubView(publishRect:CGRect, horRate:CGFloat)
    func changeUserView(userModel:CTAUserModel)
    func changeDetailUser()
    
    func likeHandler()
    
    func setLikeButtonStyle(publishModel:CTAPublishModel?)
    func likeButtonClick(sender: UIButton)
    
    func moreSelectionHandler(isSelf:Bool)
    func moreButtonClick(sender: UIButton)
    
    func rebuildHandler()
    func rebuildButtonClick(sender: UIButton)
    
    func userIconClick(sender: UIPanGestureRecognizer)
}

extension CTAPublishProtocol where Self: UIViewController{

    func initPublishSubView(publishRect:CGRect, horRate:CGFloat){
        let bounds = UIScreen.mainScreen().bounds
        var butY   = publishRect.origin.y + publishRect.height + 20 + 10*horRate
        let originy = bounds.height - 60
        if butY > originy{
            butY = originy
        }
        self.likeButton.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        self.likeButton.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2 - 100*horRate,y: butY)
        self.likeButton.setImage(UIImage.init(named: "like-button"), forState: .Normal)
        self.likeButton.setImage(UIImage.init(named: "like-highlighted-button"), forState: .Highlighted)
        self.likeButton.setImage(UIImage.init(named: "like-disable-button"), forState: .Disabled)
        self.view.addSubview(self.likeButton)
        self.likeButton.addTarget(self, action: "likeButtonClick:", forControlEvents: .TouchUpInside)
        
        let moreButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        moreButton.setImage(UIImage.init(named: "moreSelection-button"), forState: .Normal)
        moreButton.setImage(UIImage.init(named: "moreSelection-selected-button"), forState: .Highlighted)
        moreButton.setImage(UIImage.init(named: "moreSelection-disable-button"), forState: .Disabled)
        moreButton.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2 + 100*horRate, y: butY)
        self.view.addSubview(moreButton)
        moreButton.addTarget(self, action: "moreButtonClick:", forControlEvents: .TouchUpInside)
        
        let rebuildButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        rebuildButton.setImage(UIImage.init(named: "rebuild-button"), forState: .Normal)
        rebuildButton.setImage(UIImage.init(named: "rebuild-selected-button"), forState: .Highlighted)
        rebuildButton.setImage(UIImage.init(named: "rebuild-disable-button"), forState: .Disabled)
        rebuildButton.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2, y: butY)
        self.view.addSubview(rebuildButton)
        rebuildButton.addTarget(self, action: "rebuildButtonClick:", forControlEvents: .TouchUpInside)
        
        self.userIconImage.frame = CGRect.init(x: UIScreen.mainScreen().bounds.width/2, y: 9, width: 60, height: 60)
        self.userIconImage.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2, y: publishRect.origin.y - 30 - 65*horRate)
        if self.userIconImage.frame.origin.y < 5 {
            self.userIconImage.frame.origin.y = 5
        }
        self.cropImageCircle(self.userIconImage)
        self.view.addSubview(self.userIconImage)
        self.userIconImage.userInteractionEnabled = true
        let iconTap = UITapGestureRecognizer(target: self, action: "userIconClick:")
        self.userIconImage.addGestureRecognizer(iconTap)
        self.userIconImage.image = UIImage(named: "default-usericon")
        
        self.userNicknameLabel.frame = CGRect.init(x: 0, y: 0, width: 100, height: 25)
        self.userNicknameLabel.center = CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: self.userIconImage.center.y + 42 + 15*horRate)
        if (self.userNicknameLabel.frame.origin.y + self.userNicknameLabel.frame.size.height) > publishRect.origin.y{
            self.userNicknameLabel.frame.origin.y = publishRect.origin.y - self.userNicknameLabel.frame.size.height
            self.userNicknameLabel.font = UIFont.systemFontOfSize(16)
        }else {
            self.userNicknameLabel.font = UIFont.systemFontOfSize(18)
        }
        
        self.userNicknameLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        self.view.addSubview(self.userNicknameLabel)
    }
    
    func changeUserView(userModel:CTAUserModel){
        self.userNicknameLabel.text = userModel.nickName
        self.userNicknameLabel.sizeToFit()
        let maxWidth = UIScreen.mainScreen().bounds.width - 100
        var labelWidth = self.userNicknameLabel.frame.width
        if self.userNicknameLabel.frame.width > maxWidth {
            labelWidth = maxWidth
        }
        self.userNicknameLabel.frame.size.width = labelWidth
        self.userNicknameLabel.frame.origin.x = (UIScreen.mainScreen().bounds.width - labelWidth)/2
        let imagePath = CTAFilePath.userFilePath+userModel.userIconURL
        let imageURL = NSURL(string: imagePath)!
        self.userIconImage.kf_showIndicatorWhenLoading = true
        self.userIconImage.kf_setImageWithURL(imageURL, placeholderImage: UIImage.init(named: "default-usericon"), optionsInfo: [.Transition(ImageTransition.Fade(1))]) { (image, error, cacheType, imageURL) -> () in
            if error != nil {
                self.userIconImage.image = UIImage.init(named: "default-usericon")
            }
            self.userIconImage.kf_showIndicatorWhenLoading = false
        }
    }
    
    func changeDetailUser(){
        self.userNicknameLabel.text = NSLocalizedString("DefaultName", comment: "")
        self.userNicknameLabel.sizeToFit()
        let maxWidth = UIScreen.mainScreen().bounds.width - 100
        var labelWidth = self.userNicknameLabel.frame.width
        if self.userNicknameLabel.frame.width > maxWidth {
            labelWidth = maxWidth
        }
        self.userNicknameLabel.frame.size.width = labelWidth
        self.userNicknameLabel.frame.origin.x = (UIScreen.mainScreen().bounds.width - labelWidth)/2
        self.userIconImage.image = UIImage.init(named: "default-usericon")
    }
    
    func likeHandler(){
        let userID = self.userModel == nil ? "" : self.userModel!.userID
        if publishModel.likeStatus == 0{
            CTAPublishDomain.getInstance().likePublish(userID, publishID: publishModel.publishID, compelecationBlock: { (info) -> Void in
                if info.result {
                    self.publishModel.likeStatus = 1
                    self.setLikeButtonStyle(self.publishModel)
                }
            })
        }else {
            CTAPublishDomain.getInstance().unLikePublish(userID, publishID: publishModel.publishID, compelecationBlock: { (info) -> Void in
                if info.result {
                    self.publishModel.likeStatus = 0
                    self.setLikeButtonStyle(self.publishModel)
                }
            })
        }
    }
    
    func setLikeButtonStyle(publishModel:CTAPublishModel?){
        if let model = publishModel{
            if model.likeStatus == 0{
                self.likeButton.setImage(UIImage.init(named: "like-button"), forState: .Normal)
                self.likeButton.setImage(UIImage.init(named: "like-highlighted-button"), forState: .Highlighted)
            }else {
                self.likeButton.setImage(UIImage.init(named: "like-selected-button"), forState: .Normal)
                self.likeButton.setImage(UIImage.init(named: "like-selected-button"), forState: .Highlighted)
            }
        }
    }
    
    func moreSelectionHandler(isSelf:Bool){
        let shareView = CTAShareView.getInstance()
        shareView.delegate = self
        let mainController = CTAMainViewController.getInstance()
        if self.view.isDescendantOfView(mainController.view){
            mainController.view.addSubview(shareView)
        }else {
            self.view.superview?.addSubview(shareView)
        }
        shareView.showViewHandler(isSelf)
    }
    
    func rebuildHandler(){
        print("rebuildHandler ")
    }
}

extension CTAPublishProtocol{
    
    func weChatShareHandler(){
        if CTASocialManager.isAppInstaller(.WeChat){
            let imagePath = CTAFilePath.publishFilePath+self.publishModel.publishIconURL
            let imageURL = NSURL(string: imagePath)!
            let message = CTASocialManager.Message
                .WeChat(
                    .Session(
                        info: (
                            title: "",
                            description: "",
                            thumbnail: nil,
                            media: .URL(imageURL)
                        )
                    )
            )
            
            CTASocialManager.shareMessage(message) { (result) -> Void in
                debug_print("shareMessage result = \(result)")
            }
        }else {
            self.showSingleAlert(NSLocalizedString("AlertTitleNoInstallWechat", comment: ""), alertMessage: "", compelecationBlock: nil)
        }
    }
    
    func momentsShareHandler(){
        if CTASocialManager.isAppInstaller(.WeChat){
//            let imagePath = CTAFilePath.publishFilePath+self.publishModel.publishIconURL
//            let imageURL = NSURL(string: imagePath)!
//            let img = UIImage.init(CGImage: <#T##CGImage#>)
            let message = CTASocialManager.Message
                .WeChat(
                    .Timeline(
                        info: (
                            title: "",
                            description: "",
                            thumbnail: nil,
                            media: nil
                        )
                    )
            )
            
            CTASocialManager.shareMessage(message) { (result) -> Void in
                
                debug_print("shareMessage result = \(result)")
            }
        }else {
            self.showSingleAlert(NSLocalizedString("AlertTitleNoInstallWechat", comment: ""), alertMessage: "", compelecationBlock: nil)
        }
    }
    
    func deleteHandler(){
        
    }
    
    func copyLinkHandler(){
        print("copyLinkHandler")
    }
}
