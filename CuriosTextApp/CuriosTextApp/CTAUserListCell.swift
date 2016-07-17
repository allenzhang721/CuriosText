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
    var followImg:UIImageView!
    
    var delegate:CTAUserListCellDelegate?
    
    var viewUser:CTAViewUserModel?{
        didSet{
            self.reloadView()
        }
    }
    
    func initView(){
        let bounds = self.frame
        
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width-60, height: 60))
        self.contentView.addSubview(iconView)
        self.userIconImage = UIImageView(frame: CGRect(x: 10, y: 14, width: 32, height: 32));
        self.cropImageCircle(self.userIconImage)
        self.userIconImage.image = UIImage(named: "default-usericon")
        iconView.addSubview(self.userIconImage)
        self.userNickNameLabel = UILabel(frame: CGRect(x: 50, y: 14, width: bounds.width-100, height: 18))
        self.userNickNameLabel.font = UIFont.boldSystemFontOfSize(13)
        self.userNickNameLabel.textColor = CTAStyleKit.normalColor
        self.userNickNameLabel.textAlignment = .Left
        iconView.addSubview(self.userNickNameLabel)
        
        self.userDescLabel = UILabel(frame: CGRect(x: 50, y: 30, width: bounds.width-100, height: 18))
        self.userDescLabel.font = UIFont.systemFontOfSize(13)
        self.userDescLabel.textColor = CTAStyleKit.labelShowColor
        self.userDescLabel.textAlignment = .Left
        iconView.addSubview(self.userDescLabel)
        
        iconView.backgroundColor = UIColor.clearColor()
        iconView.userInteractionEnabled = true
        let iconTap = UITapGestureRecognizer(target: self, action: #selector(userIconClick(_:)))
        iconView.addGestureRecognizer(iconTap)
        
        
        let followView = UIView(frame: CGRectMake(bounds.width - 60, 0, 60, 60))
        self.contentView.addSubview(followView)
        self.followImg = UIImageView(frame: CGRectMake(20,17,30,30))
        self.followImg.image = UIImage(named: "liker_follow_btn")
        followView.addSubview(self.followImg)
        
        followView.backgroundColor = UIColor.clearColor()
        followView.userInteractionEnabled = true
        let imgTap = UITapGestureRecognizer(target: self, action: #selector(followButtonClick(_:)))
        followView.addGestureRecognizer(imgTap)
        
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
    
    func followButtonClick(sender: UIPanGestureRecognizer){
        let relationType:Int = self.viewUser!.relationType
        if relationType == 0 || relationType == 3{
            if self.delegate != nil {
                self.delegate!.followButtonTap(self.followImg, cell: self)
            }
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
        self.followImg.image = UIImage(named: "liker_follow_btn")
    }
    
    func setFollowButton(){
        let relationType:Int = self.viewUser!.relationType
        var isHidden = false
        var buttonBg:UIImage? = UIImage(named: "liker_follow_btn")
        switch  relationType{
        case -1:
            isHidden = true
        case 0, 3:
            buttonBg    = UIImage(named: "liker_follow_btn")
            isHidden = false
        case 1, 5:
            buttonBg    = UIImage(named: "liker_following_btn")
            isHidden = false
        case 2, 4, 6:
            isHidden = true
        default:
            isHidden = true
        }
        self.followImg.hidden = isHidden
        self.followImg.image = buttonBg
    }
}

protocol CTAUserListCellDelegate {
    func cellUserIconTap(cell:CTAUserListCell?)
    func followButtonTap(followView:UIView, cell:CTAUserListCell?)
}