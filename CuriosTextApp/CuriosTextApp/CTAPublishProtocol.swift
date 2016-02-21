//
//  CTAPublishProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/29.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation
import Kingfisher

protocol CTAPublishProtocol:CTAImageControllerProtocol{
    var likeButton:UIButton{get}
    var userIconImage:UIImageView{get}
    var userNicknameLabel:UILabel{get}
    func initPublishSubView(publishRect:CGRect, horRate:CGFloat)
    func changeUserView(userModel:CTAUserModel)
    
    func likeHandler(userID:String, publishModel:CTAPublishModel)
    func setLikeButtonStyle(publishModel:CTAPublishModel?)
    func likeButtonClick(sender: UIButton)
    
    func shareHandler(userID:String, publishModel:CTAPublishModel)
    func shareButtonClick(sender: UIButton)
    
    func rebuildHandler(userID:String, publishModel:CTAPublishModel)
    func rebuildButtonClick(sender: UIButton)
    
    func userIconClick(sender: UIPanGestureRecognizer)
}

extension CTAPublishProtocol where Self: UIViewController{

    func initPublishSubView(publishRect:CGRect, horRate:CGFloat){
        let bounds = UIScreen.mainScreen().bounds
        var butY  = bounds.height/2 + publishRect.height/2 + 50*horRate
        if butY > bounds.height - 65{
            butY = bounds.height - 65
        }
        self.likeButton.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        self.likeButton.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2 + 90*horRate,y: butY)
        self.likeButton.setImage(UIImage.init(named: "like-button"), forState: .Normal)
        self.likeButton.setImage(UIImage.init(named: "like-highlighted-button"), forState: .Highlighted)
        self.view.addSubview(self.likeButton)
        self.likeButton.addTarget(self, action: "likeButtonClick:", forControlEvents: .TouchUpInside)
        
        let shareButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        shareButton.setImage(UIImage.init(named: "share-button"), forState: .Normal)
        shareButton.setImage(UIImage.init(named: "share-selected-button"), forState: .Highlighted)
        shareButton.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2 - 90*horRate, y: butY)
        self.view.addSubview(shareButton)
        shareButton.addTarget(self, action: "shareButtonClick:", forControlEvents: .TouchUpInside)
        
        let rebuildButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        rebuildButton.setImage(UIImage.init(named: "rebuild-button"), forState: .Normal)
        rebuildButton.setImage(UIImage.init(named: "rebuild-selected-button"), forState: .Highlighted)
        rebuildButton.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2, y: butY)
        self.view.addSubview(rebuildButton)
        rebuildButton.addTarget(self, action: "rebuildButtonClick:", forControlEvents: .TouchUpInside)
        
        self.userIconImage.frame = CGRect.init(x: UIScreen.mainScreen().bounds.width/2, y: 9, width: 60, height: 60)
        self.userIconImage.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2 - publishRect.height/2 - 30 - 75*horRate)
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
        if (self.userNicknameLabel.frame.origin.y + self.userNicknameLabel.frame.size.height) > (UIScreen.mainScreen().bounds.height/2 - publishRect.height/2){
            self.userNicknameLabel.frame.origin.y = UIScreen.mainScreen().bounds.height/2 - publishRect.height/2 - 25
        }
        if self.userNicknameLabel.frame.origin.y < 70 {
            self.userNicknameLabel.frame.origin.y = 70
        }
        self.userNicknameLabel.font = UIFont.systemFontOfSize(18)
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
    
    func likeHandler(userID:String, publishModel:CTAPublishModel){
        if publishModel.likeStatus == 0{
            CTAPublishDomain.getInstance().likePublish(userID, publishID: publishModel.publishID, compelecationBlock: { (info) -> Void in
                if info.result {
                    publishModel.likeStatus = 1
                    self.setLikeButtonStyle(publishModel)
                }
            })
        }else {
            CTAPublishDomain.getInstance().unLikePublish(userID, publishID: publishModel.publishID, compelecationBlock: { (info) -> Void in
                if info.result {
                    publishModel.likeStatus = 0
                    self.setLikeButtonStyle(publishModel)
                }
            })
        }
    }
    
    func setLikeButtonStyle(publishModel:CTAPublishModel?){
        if let model = publishModel{
            if model.likeStatus == 0{
                self.likeButton.setImage(UIImage.init(named: "like-button"), forState: .Normal)
            }else {
                self.likeButton.setImage(UIImage.init(named: "like-selected-button"), forState: .Normal)
            }
        }
    }
    
    func shareHandler(userID:String, publishModel:CTAPublishModel){
        print("shareHandler")
    }
    
    func rebuildHandler(userID:String, publishModel:CTAPublishModel){
        print("rebuildHandler ")
    }
}