//
//  CTAPublishControllerView.swift
//  CuriosTextApp
//
//  Created by allen on 16/6/21.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit
import Kingfisher

enum PublishControllerType:String{
    case PublishCell   = "PublishCell"
    case PublishDetail = "PublishDetail"
}

class CTAPublishControllerView: UIView, CTAImageControllerProtocol, CTAPublishModelProtocol{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    var publishModel:CTAPublishModel?{
        didSet{
            self.reloadView()
        }
    }
    
    var type:PublishControllerType = .PublishCell
    
    var iconView:UIView!
    var userIconImage:UIImageView!
    var userNickNameLabel:UILabel!
    var publishTimeLabel:UILabel!
    var publishLikeCountLabel:UILabel!
    
    var likeButtonImg:UIImageView!
    var likeView:UIView!
    
    var commentButtonImg:UIImageView!
    var commentCountLabel:UILabel!
    var commentView:UIView!
    
    var rebuildButtonImg:UIImageView!
    var rebuildLabel:UILabel!
    var rebuildView:UIView!
    
    var moreButtonImg:UIImageView!
    var moreView:UIView!
    
    var likeCountView:UIView!
    var likeCountImg:UIImageView!
    
    var closeButton:UIButton!
    
    var delegate:CTAPublishControllerDelegate?
    
    func initView(){
        let bounds = self.frame
        let moreW:CGFloat = 50
        
        self.iconView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 50))
        self.addSubview(self.iconView)
        self.userIconImage = UIImageView(frame: CGRect(x: 11, y: 10, width: 32, height: 32));
        self.cropImageCircle(self.userIconImage)
        self.userIconImage.image = UIImage(named: "default-usericon")
        self.iconView.addSubview(self.userIconImage)
        self.userNickNameLabel = UILabel(frame: CGRect(x: 53, y: 17, width: bounds.width - 120, height: 18))
        self.userNickNameLabel.font = UIFont.boldSystemFont(ofSize: 13)
        self.userNickNameLabel.textColor = CTAStyleKit.normalColor
        self.userNickNameLabel.textAlignment = .left
        self.iconView.addSubview(self.userNickNameLabel)
        self.iconView.backgroundColor = UIColor.clear
        self.iconView.isUserInteractionEnabled = true
        let iconTap = UITapGestureRecognizer(target: self, action: #selector(userIconClick(_:)))
        self.iconView.addGestureRecognizer(iconTap)
        
        self.moreView = UIView(frame: CGRect(x: (bounds.width - moreW), y: 0, width: moreW, height: 50))
        self.addSubview(self.moreView)
        self.moreButtonImg = UIImageView(frame: CGRect(x: moreW-38, y: 10, width: 30, height: 30))
        self.moreButtonImg.image = UIImage(named: "moreSelection-button");
        self.moreView.addSubview(self.moreButtonImg)
        self.moreView.backgroundColor = UIColor.clear
        self.moreView.isUserInteractionEnabled = true
        let moreButtonTap = UITapGestureRecognizer(target: self, action: #selector(moreButtonClick(_:)))
        self.moreView.addGestureRecognizer(moreButtonTap)
        
        let textLine = UIImageView(frame: CGRect(x: 14, y: bounds.height-50, width: bounds.width - 28, height: 1))
        textLine.image = UIImage(named: "space-line")
        self.addSubview(textLine)
        
        self.likeView = UIView(frame: CGRect(x: 0, y: bounds.height-100, width: 50, height: 50))
        self.addSubview(self.likeView)
        self.likeButtonImg = UIImageView(frame: CGRect(x: 12, y: 10, width: 30, height: 30))
        self.likeButtonImg.image = UIImage(named: "like-button");
        self.likeView.addSubview(self.likeButtonImg)
        self.likeView.backgroundColor = UIColor.clear
        self.likeView.isUserInteractionEnabled = true
        let likeButtonTap = UITapGestureRecognizer(target: self, action: #selector(likeButtonClick(_:)))
        self.likeView.addGestureRecognizer(likeButtonTap)
        
        
        self.commentView = UIView(frame: CGRect(x: 50, y: bounds.height-100, width: 100, height: 50))
        self.addSubview(self.commentView)
        self.commentButtonImg = UIImageView(frame: CGRect(x: 0, y: 10, width: 30, height: 30))
        self.commentButtonImg.image = UIImage(named: "comment-button");
        self.commentView.addSubview(self.commentButtonImg)
        self.commentCountLabel = UILabel(frame: CGRect(x: 30, y: 16, width: 100, height: 18))
        self.commentCountLabel.font = UIFont.systemFont(ofSize: 13)
        self.commentCountLabel.textColor = CTAStyleKit.normalColor
        self.commentCountLabel.textAlignment = .left
        self.commentView.addSubview(self.commentCountLabel)
        self.commentView.backgroundColor = UIColor.clear
        self.commentCountLabel.text = NSLocalizedString("CommentsLabel", comment: "")
        self.commentView.isUserInteractionEnabled = true
        let commemtButtonTap = UITapGestureRecognizer(target: self, action: #selector(commentButtonClick(_:)))
        self.commentView.addGestureRecognizer(commemtButtonTap)
        
        self.rebuildView = UIView(frame: CGRect(x: bounds.width-60, y: bounds.height-100, width: 60, height: 50))
        self.addSubview(self.rebuildView)
        self.rebuildButtonImg = UIImageView(frame: CGRect(x: 0, y: 10, width: 30, height: 30))
        self.rebuildButtonImg.image = UIImage(named: "rebuild-button");
        self.rebuildView.addSubview(self.rebuildButtonImg)
        self.rebuildLabel = UILabel(frame: CGRect(x: 30, y: 17, width: 60, height: 18))
        self.rebuildLabel.font = UIFont.systemFont(ofSize: 13)
        self.rebuildLabel.textColor = CTAStyleKit.normalColor
        self.rebuildLabel.textAlignment = .left
        self.rebuildView.addSubview(self.rebuildLabel)
        self.rebuildView.backgroundColor = UIColor.clear
        self.rebuildLabel.text = "Ding"
        self.rebuildLabel.sizeToFit()
        self.rebuildView.frame.size.width = self.rebuildButtonImg.frame.width + self.rebuildLabel.frame.width
        self.rebuildView.frame.origin.x = bounds.width - self.rebuildView.frame.size.width - 14
        self.rebuildView.isUserInteractionEnabled = true
        let rebuildButtonTap = UITapGestureRecognizer(target: self, action: #selector(rebuildButtonClick(_:)))
        self.rebuildView.addGestureRecognizer(rebuildButtonTap)
        
        
        let lastY = bounds.height - 50
        self.publishTimeLabel = UILabel(frame: CGRect(x: 45, y: lastY + 17, width: bounds.width/2, height: 18))
        self.publishTimeLabel.font = UIFont.systemFont(ofSize: 13)
        self.publishTimeLabel.textColor = CTAStyleKit.labelShowColor
        self.publishTimeLabel.textAlignment = .left
        self.addSubview(self.publishTimeLabel)
        
        
        self.likeCountView = UIView(frame: CGRect(x: 0, y: lastY, width: bounds.width/2, height: 50))
        self.addSubview(self.likeCountView)
        self.likeCountView.backgroundColor = UIColor.clear
        self.likeCountImg = UIImageView(frame: CGRect(x: 12, y: 10, width: 30, height: 30))
        self.likeCountImg.image = UIImage(named: "like-count");
        self.likeCountView.addSubview(self.likeCountImg)
        self.publishLikeCountLabel = UILabel(frame: CGRect(x: 53, y: 16, width: bounds.width/2, height: 18))
        self.publishLikeCountLabel.font = UIFont.systemFont(ofSize: 13)
        self.publishLikeCountLabel.textColor = CTAStyleKit.normalColor
        self.publishLikeCountLabel.textAlignment = .left
        self.likeCountView.addSubview(self.publishLikeCountLabel)
        self.likeCountView.isUserInteractionEnabled = true
        let likeCountTap = UITapGestureRecognizer(target: self, action: #selector(likeCountClick(_:)))
        self.likeCountView.addGestureRecognizer(likeCountTap)
        
        self.closeButton = UIButton(frame: CGRect(x: 0, y: 2, width: 40, height: 40))
        self.closeButton.setImage(UIImage(named: "close-button"), for: UIControlState())
        self.closeButton.addTarget(self, action: #selector(closeButtonClick(_:)), for: .touchUpInside)
        self.addSubview(self.closeButton)
    }
    
    func reloadView(){
        if self.publishModel != nil{
            self.setViewByType()
            let usermodel = self.publishModel!.userModel
            self.setNikeNameLabel(usermodel.nickName)
            self.setTimeLabel(DateString(self.publishModel!.publishDate))
            self.setUserIcon(usermodel.userIconURL)
            self.changeLikeStatus()
            self.setCommentButtonCount()
            self.setCloseButtonStyle()
        }else {
            self.resetView()
        }
    }
    
    func resetView(){
        self.setNikeNameLabel("")
        self.setTimeLabel("")
        self.publishLikeCountLabel.text = NSLocalizedString("LikeDefaultLabel", comment: "")
        self.userIconImage.image = UIImage(named: "default-usericon")
        
        self.commentCountLabel.text = ""
        self.rebuildLabel.text = "Ding"
        self.closeButton.isHidden = true
        self.type = .PublishCell
        self.setViewByType()
    }
    
    func setViewByType(){
        if self.type == .PublishCell{
            self.closeButton.setImage(UIImage(named: "close-button"), for: UIControlState())
            self.userNickNameLabel.textColor = CTAStyleKit.normalColor
            self.moreButtonImg.image = UIImage(named: "moreSelection-button")
            self.likeButtonImg.image = UIImage(named: "like-button")
            self.commentButtonImg.image = UIImage(named: "comment-button")
            self.commentCountLabel.textColor = CTAStyleKit.normalColor
            self.rebuildButtonImg.image = UIImage(named: "rebuild-button");
            self.rebuildLabel.textColor = CTAStyleKit.normalColor
            self.likeCountImg.image = UIImage(named: "like-count")
            self.publishLikeCountLabel.textColor = CTAStyleKit.normalColor
        }else if self.type == .PublishDetail{
            self.closeButton.setImage(UIImage(named: "close-white-button"), for: UIControlState())
            self.userNickNameLabel.textColor = CTAStyleKit.commonBackgroundColor
            self.moreButtonImg.image = UIImage(named: "moreSelection-white-button")
            self.likeButtonImg.image = UIImage(named: "like-white-button")
            self.commentButtonImg.image = UIImage(named: "comment-white-button")
            self.commentCountLabel.textColor = CTAStyleKit.commonBackgroundColor
            self.rebuildButtonImg.image = UIImage(named: "rebuild-white-button");
            self.rebuildLabel.textColor = CTAStyleKit.commonBackgroundColor
            self.likeCountImg.image = UIImage(named: "like-white-count")
            self.publishLikeCountLabel.textColor = CTAStyleKit.commonBackgroundColor
        }
    }
    
    func setNikeNameLabel(_ text:String){
        self.userNickNameLabel.text = text
        if self.type == .PublishCell{
            self.userIconImage.frame = CGRect(x: 11, y: 10, width: 32, height: 32);
            self.userNickNameLabel.frame = CGRect(x: 53, y: 17, width: bounds.width - 120, height: 18)
        }else if self.type == .PublishDetail{
            let bounds = self.frame
            let maxWidth = bounds.width - 100
            let maxText = maxWidth - 53
            
            self.userNickNameLabel.sizeToFit()
            self.userNickNameLabel.frame.size.height = 18
            if self.userNickNameLabel.frame.width > maxText {
                self.userNickNameLabel.frame.size.width = maxText
            }
            let iconW = self.userNickNameLabel.frame.width + 64
            let iconX = (bounds.width - iconW)/2
            self.iconView.frame.origin.x = iconX
            self.iconView.frame.size.width = iconW
            self.userIconImage.frame.origin.x = 11
            self.userNickNameLabel.frame.origin.x = 53
        }
//        UIView.transitionWithView(self.userNickNameLabel, duration: 0.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
//            self.userNickNameLabel.text = text
//        }) { (_) in
//        }
    }
    
    func setTimeLabel(_ text:String){
        let bounds = self.frame
        self.publishTimeLabel.text = text
        self.publishTimeLabel.sizeToFit()
        self.publishTimeLabel.frame.origin.x = bounds.width - self.publishTimeLabel.frame.width - 14
        UIView.transition(with: self.publishTimeLabel, duration: 0.1, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            self.publishTimeLabel.text = text
        }) { (_) in
        }
    }
    
    func setUserIcon(_ iconPath:String){
        UIView.transition(with: self.userIconImage, duration: 0.1, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            let defaultImg = UIImage.init(named: "default-usericon")
            let imagePath = CTAFilePath.userFilePath+iconPath
            let imageURL = URL(string: imagePath)!
            self.userIconImage.kf.setImage(with: imageURL, placeholder: defaultImg, options: [.transition(ImageTransition.fade(1))]){ (image, error, cacheType, imageURL) -> () in
                if error != nil {
                    self.userIconImage.image = defaultImg
                }
            }
        }) { (_) in
        }
        
    }
    
    func setPublishLikeCount(){
        let likeCount = self.publishModel!.likeCount
        UIView.transition(with: self.publishLikeCountLabel, duration: 0.1, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            if likeCount != 0{
                self.publishLikeCountLabel.text = self.changeCountToAllString(likeCount)+"  "+NSLocalizedString("LikesLabel", comment: "")
            }else {
                self.publishLikeCountLabel.text = NSLocalizedString("LikeDefaultLabel", comment: "")
            }
            self.publishLikeCountLabel.sizeToFit()
            self.likeCountView.frame.size.width = self.publishLikeCountLabel.frame.origin.x + self.publishLikeCountLabel.frame.width
        }) { (_) in
        }
    }
    
    func setCommentButtonCount(){
        let commentCount = self.publishModel!.commentCount
        UIView.transition(with: self.commentCountLabel, duration: 0.1, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            if commentCount != 0{
                self.commentCountLabel.text = self.changeCountToString(commentCount)
            }else {
                self.commentCountLabel.text = ""
            }
        }) { (_) in
        }
    }
    
    func changeLikeStatus(){
        if let model = self.publishModel{
            if model.likeStatus == 0{
                if self.type == .PublishCell {
                    self.likeButtonImg.image = UIImage.init(named: "like-button")
                }else if self.type == .PublishDetail{
                    self.likeButtonImg.image = UIImage(named: "like-white-button")
                }
               
            }else {
                self.likeButtonImg.image = UIImage.init(named: "like-selected-button")
            }
            self.setPublishLikeCount()
        }
    }
    
    func playLikeAnimation(){
        self.likeButtonImg.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 0.2, animations: { 
            self.likeButtonImg.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) 
    }
    
    func setCloseButtonStyle(){
        if self.type == .PublishCell{
            self.closeButton.isHidden = true
        }else if self.type == .PublishDetail{
            self.closeButton.isHidden = false
        }
    }
    
    func userIconClick(_ sender: UIPanGestureRecognizer) {
        if self.delegate != nil{
            self.delegate?.controlUserIconTap()
        }
    }
    
    func likeCountClick(_ sender: UIPanGestureRecognizer) {
        let likeCount = self.publishModel!.likeCount
        if likeCount != 0{
            if self.delegate != nil{
                self.delegate?.controlLikeListTap()
            }
        }else {
            if self.delegate != nil{
                self.delegate?.controlLikeHandler()
            }
        }
    }
    
    func likeButtonClick(_ sender: UIPanGestureRecognizer) {
        if self.delegate != nil{
            self.delegate?.controlLikeHandler()
        }
    }
    
    func commentButtonClick(_ sender: UIPanGestureRecognizer) {
        if self.delegate != nil{
            self.delegate?.controlCommentHandler()
        }
    }
    
    func rebuildButtonClick(_ sender: UIPanGestureRecognizer) {
        if self.delegate != nil{
            self.delegate?.controlRebuildHandler()
        }
    }
    
    func moreButtonClick(_ sender: UIPanGestureRecognizer) {
        if self.delegate != nil{
            self.delegate?.controlMoreHandler()
        }
    }
    
    func closeButtonClick(_ sender: UIButton){
        if self.delegate != nil{
            self.delegate?.controlCloseHandler()
        }
    }
    
    func getControllerBottomHeight() -> CGFloat{
        if self.publishModel != nil {
            if self.publishModel?.likeCount != 0{
                return 100
            }else {
                return 50
            }
        }else {
            return 50
        }
    }
}

protocol CTAPublishControllerDelegate {
    func controlUserIconTap()
    func controlLikeListTap()
    func controlLikeHandler()
    func controlCommentHandler()
    func controlRebuildHandler()
    func controlMoreHandler()
    func controlCloseHandler()
}
