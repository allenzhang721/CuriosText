//
//  UserListCell.swift
//  CuriosTextApp
//
//  Created by allen on 16/7/4.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit
import Kingfisher


class CTAUserListCell : UICollectionViewCell, CTAImageControllerProtocol{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    var userIconImage:UIImageView!
    var userNickNameLabel:UILabel!
    var userDescLabel:UILabel!
    var followButton:UIButton!
    
    var delegate:CTAUserListCellDelegate?
    
    var viewUser:CTAViewUserModel?{
        didSet{
            self.reloadView()
        }
    }
    
    func initView(){
        let bounds = self.frame
        
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 60))
        self.contentView.addSubview(iconView)
        self.userIconImage = UIImageView(frame: CGRect(x: 10, y: 14, width: 32, height: 32));
        self.cropImageCircle(self.userIconImage)
        self.userIconImage.image = UIImage(named: "default-usericon")
        iconView.addSubview(self.userIconImage)
        self.userNickNameLabel = UILabel(frame: CGRect(x: 50, y: 14, width: bounds.width-160, height: 18))
        self.userNickNameLabel.font = UIFont.boldSystemFontOfSize(13)
        self.userNickNameLabel.textColor = CTAStyleKit.normalColor
        self.userNickNameLabel.textAlignment = .Left
        iconView.addSubview(self.userNickNameLabel)
        
        self.userDescLabel = UILabel(frame: CGRect(x: 50, y: 30, width: bounds.width-150, height: 18))
        self.userDescLabel.font = UIFont.systemFontOfSize(13)
        self.userDescLabel.textColor = CTAStyleKit.labelShowColor
        self.userDescLabel.textAlignment = .Left
        iconView.addSubview(self.userDescLabel)
        
        iconView.backgroundColor = UIColor.clearColor()
        iconView.userInteractionEnabled = true
        let iconTap = UITapGestureRecognizer(target: self, action: #selector(userIconClick(_:)))
        iconView.addGestureRecognizer(iconTap)

        self.followButton = UIButton(frame: CGRectMake(bounds.width-100, 15, 90, 30))
        self.followButton.setBackgroundImage(UIImage(named: "follow_bg"), forState: .Normal)
        self.followButton.setTitle(NSLocalizedString("FollowButtonLabel", comment: ""), forState: .Normal)
        self.followButton.setTitleColor(CTAStyleKit.selectedColor, forState: .Normal)
        self.followButton.titleLabel?.font = UIFont.systemFontOfSize(13)
        self.followButton.addTarget(self, action: #selector(followButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.contentView.addSubview(self.followButton)
        
        let textLine = UIImageView(frame: CGRect(x: 50, y: bounds.height-1, width: bounds.width - 60, height: 1))
        textLine.image = UIImage(named: "space-line")
        self.contentView.addSubview(textLine)
    }
    
    func reloadView(){
        if self.viewUser != nil{
            self.setNikeNameLabel(self.viewUser!.nickName)
            self.setDescLabel(self.viewUser!.userDesc)
            self.setUserIcon(self.viewUser!.userIconURL)
            self.setFollowButton()
        }else {
            self.resetView()
        }
    }
    
    func userIconClick(sender: UIPanGestureRecognizer) {
        if self.delegate != nil {
            self.delegate!.cellUserIconTap(self)
        }
    }
    
    func followButtonClick(sender: UIButton){
        let relationType:Int = self.viewUser!.relationType
        if relationType == 0 || relationType == 3{
            self.followUser()
        }else {
            if self.delegate != nil {
                self.delegate!.cellUserIconTap(self)
            }
        }
    }
    
    func setUserIcon(iconPath:String){
        let imagePath = CTAFilePath.userFilePath+iconPath
        let imageURL = NSURL(string: imagePath)!
        self.userIconImage.kf_showIndicatorWhenLoading = true
        self.userIconImage.kf_setImageWithURL(imageURL, placeholderImage: UIImage(named: "default-usericon"), optionsInfo: [.Transition(ImageTransition.Fade(1))]) { (image, error, cacheType, imageURL) -> () in
            if error != nil {
                self.userIconImage.image = UIImage(named: "default-usericon")
            }
            self.userIconImage.kf_showIndicatorWhenLoading = false
        }
    }
    
    func setNikeNameLabel(text:String){
        self.userNickNameLabel.text = text
    }
    
    func setDescLabel(text:String){
        self.userDescLabel.text = text
        if text == "" {
            self.userNickNameLabel.frame.origin.y = 21
        }else {
            self.userNickNameLabel.frame.origin.y = 14
        }
    }
    
    func resetView(){
        self.userIconImage.image = UIImage(named: "default-usericon")
        self.userNickNameLabel.text = ""
        self.userDescLabel.text = ""
        self.followButton.setBackgroundImage(UIImage(named: "follow_bg"), forState: .Normal)
        self.followButton.setTitle(NSLocalizedString("FollowButtonLabel", comment: ""), forState: .Normal)
        self.followButton.setTitleColor(CTAStyleKit.selectedColor, forState: .Normal)
    }
    
    func followUser(){
        self.showLoadingViewInView(self.followButton)
        let userID = CTAUserManager.user != nil ? CTAUserManager.user!.userID : ""
        CTAUserRelationDomain.getInstance().followUser(userID, relationUserID: self.viewUser!.userID) { (info) -> Void in
            if info.result {
                let relationType:Int = self.viewUser!.relationType
                self.viewUser!.relationType = (relationType==0 ? 1 : 5)
                self.viewUser!.beFollowCount += 1
                self.setFollowButton()
            }
            self.hideLoadingViewInView(self.followButton)
        }
    }
    
    func setFollowButton(){
        let relationType:Int = self.viewUser!.relationType
        var isHidden = false
        var buttonLabel:String = ""
        var buttonBg:UIImage? = UIImage(named: "follow_bg")
        var buttonLabelColor = CTAStyleKit.selectedColor
        switch  relationType{
        case -1:
            isHidden = true
            buttonLabel = ""
        case 0, 3:
            buttonLabel = NSLocalizedString("FollowButtonLabel", comment: "")
            buttonBg    = UIImage(named: "follow_bg")
            buttonLabelColor = CTAStyleKit.selectedColor
            isHidden = false
        case 1, 5:
            buttonLabel = NSLocalizedString("UnFollowButtonLabel", comment: "")
            buttonBg    = UIImage(named: "following_bg")
            buttonLabelColor = CTAStyleKit.commonBackgroundColor
            isHidden = false
        case 2, 4, 6:
            isHidden = true
            buttonLabel = ""
        default:
            isHidden = true
            buttonLabel = ""
        }
        self.followButton.hidden = isHidden
        self.followButton.setTitle(buttonLabel, forState: .Normal)
        self.followButton.setBackgroundImage(buttonBg, forState: .Normal)
        self.followButton.setTitleColor(buttonLabelColor, forState: .Normal)
    }
    
    func showLoadingViewInView(centerView:UIView){
        let viewFrame = centerView.frame
        let indicaW = viewFrame.width>viewFrame.height ? viewFrame.height : viewFrame.width
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRectMake(0, 0, indicaW, indicaW)
        activityIndicator.activityIndicatorViewStyle = .Gray
        activityIndicator.center = CGPointMake(viewFrame.width / 2, viewFrame.height / 2)
        centerView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.contentView.userInteractionEnabled = false
    }
    
    func hideLoadingViewInView(centerView:UIView){
        let subVies = centerView.subviews
        let subView = subVies[subVies.count-1]
        if subView is UIActivityIndicatorView{
            (subView as! UIActivityIndicatorView).stopAnimating()
            subView.removeFromSuperview()
        }
        self.contentView.userInteractionEnabled = true
    }
}

protocol CTAUserListCellDelegate {
    func cellUserIconTap(cell:CTAUserListCell?)
}