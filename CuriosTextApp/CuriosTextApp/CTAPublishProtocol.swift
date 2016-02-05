//
//  CTAPublishProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/29.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation
import Kingfisher

protocol CTAPublishProtocol:CTAImageControllerProtocol, CTAUserDetailProtocol{
    var likeButton:UIButton{get}
    var userIconImage:UIImageView{get}
    var userNikenameLabel:UILabel{get}
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
    func showUserDetailHandler(viewUser:CTAUserModel?, loginUserID:String)
}

extension CTAPublishProtocol where Self: UIViewController{

    func initPublishSubView(publishRect:CGRect, horRate:CGFloat){
        self.likeButton.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        self.likeButton.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2 + 90*horRate,y: UIScreen.mainScreen().bounds.height/2 + publishRect.height/2 + 40*horRate)
        self.likeButton.setImage(UIImage.init(named: "like-button"), forState: .Normal)
        self.view.addSubview(self.likeButton)
        self.likeButton.addTarget(self, action: "likeButtonClick:", forControlEvents: .TouchUpInside)
        
        let shareButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        shareButton.setImage(UIImage.init(named: "share-button"), forState: .Normal)
        shareButton.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2 - 90*horRate, y: UIScreen.mainScreen().bounds.height/2 + publishRect.height/2 + 40*horRate)
        self.view.addSubview(shareButton)
        shareButton.addTarget(self, action: "shareButtonClick:", forControlEvents: .TouchUpInside)
        
        let rebuildButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        rebuildButton.setImage(UIImage.init(named: "rebuild-button"), forState: .Normal)
        rebuildButton.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2 + publishRect.height/2 + 40*horRate)
        self.view.addSubview(rebuildButton)
        rebuildButton.addTarget(self, action: "rebuildButtonClick:", forControlEvents: .TouchUpInside)
        
        self.userIconImage.frame = CGRect.init(x: UIScreen.mainScreen().bounds.width/2, y: 9, width: 60 * horRate, height: 60 * horRate)
        self.userIconImage.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2 - publishRect.height/2 - 75 * horRate)
        self.cropImageCircle(self.userIconImage)
        self.view.addSubview(self.userIconImage)
        self.userIconImage.userInteractionEnabled = true
        let iconTap = UITapGestureRecognizer(target: self, action: "userIconClick:")
        self.userIconImage.addGestureRecognizer(iconTap)
        self.userIconImage.image = UIImage(named: "default-usericon")
        
        self.userNikenameLabel.frame = CGRect.init(x: 0, y: 0, width: 100, height: 25)
        self.userNikenameLabel.center = CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2 - publishRect.height/2 - 25 * horRate)
        self.userNikenameLabel.font = UIFont.systemFontOfSize(18)
        self.userNikenameLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        self.view.addSubview(self.userNikenameLabel)
    }
    
    func changeUserView(userModel:CTAUserModel){
        self.userNikenameLabel.text = userModel.nikeName
        self.userNikenameLabel.sizeToFit()
        let maxWidth = UIScreen.mainScreen().bounds.width - 100
        var labelWidth = self.userNikenameLabel.frame.width
        if self.userNikenameLabel.frame.width > maxWidth {
            labelWidth = maxWidth
        }
        self.userNikenameLabel.frame.size.width = labelWidth
        self.userNikenameLabel.frame.origin.x = (UIScreen.mainScreen().bounds.width - labelWidth)/2
        let imagePath = CTAFilePath.userFilePath+userModel.userIconURL
        let imageURL = NSURL(string: imagePath)!
        self.userIconImage.kf_showIndicatorWhenLoading = true
        self.userIconImage.kf_setImageWithURL(imageURL, placeholderImage: UIImage.init(named: "default-usericon"), optionsInfo: [.Transition(ImageTransition.Fade(1))])
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
    
    func showUserDetailHandler(viewUser:CTAUserModel?, loginUserID:String){
        self.showUserDetailView(viewUser, loginUserID: loginUserID)
    }
    
    func shareHandler(userID:String, publishModel:CTAPublishModel){
        print("shareHandler")
    }
    
    func rebuildHandler(userID:String, publishModel:CTAPublishModel){
        print("rebuildHandler ")
    }
}