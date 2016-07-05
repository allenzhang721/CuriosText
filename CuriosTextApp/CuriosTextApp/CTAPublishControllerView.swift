//
//  CTAPublishControllerView.swift
//  CuriosTextApp
//
//  Created by allen on 16/6/21.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit
import Kingfisher
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
    
    var delegate:CTAPublishControllerDelegate?
    
    func initView(){
        let bounds = self.frame
        let moreW:CGFloat = 50
        
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 50))
        self.addSubview(iconView)
        self.userIconImage = UIImageView(frame: CGRect(x: 11, y: 10, width: 32, height: 32));
        self.cropImageCircle(self.userIconImage)
        self.userIconImage.image = UIImage(named: "default-usericon")
        iconView.addSubview(self.userIconImage)
        self.userNickNameLabel = UILabel(frame: CGRect(x: 53, y: 17, width: bounds.width - 120, height: 18))
        self.userNickNameLabel.font = UIFont.boldSystemFontOfSize(13)
        self.userNickNameLabel.textColor = CTAStyleKit.normalColor
        self.userNickNameLabel.textAlignment = .Left
        iconView.addSubview(self.userNickNameLabel)
        iconView.backgroundColor = UIColor.clearColor()
        iconView.userInteractionEnabled = true
        let iconTap = UITapGestureRecognizer(target: self, action: #selector(userIconClick(_:)))
        iconView.addGestureRecognizer(iconTap)
        
        self.moreView = UIView(frame: CGRect(x: (bounds.width - moreW), y: 0, width: moreW, height: 50))
        self.addSubview(self.moreView)
        self.moreButtonImg = UIImageView(frame: CGRect(x: moreW-38, y: 10, width: 30, height: 30))
        self.moreButtonImg.image = UIImage(named: "moreSelection-button");
        self.moreView.addSubview(self.moreButtonImg)
        self.moreView.backgroundColor = UIColor.clearColor()
        self.moreView.userInteractionEnabled = true
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
        self.likeView.backgroundColor = UIColor.clearColor()
        self.likeView.userInteractionEnabled = true
        let likeButtonTap = UITapGestureRecognizer(target: self, action: #selector(likeButtonClick(_:)))
        self.likeView.addGestureRecognizer(likeButtonTap)
        
        
        self.commentView = UIView(frame: CGRect(x: 50, y: bounds.height-100, width: 100, height: 50))
        self.addSubview(self.commentView)
        self.commentButtonImg = UIImageView(frame: CGRect(x: 0, y: 10, width: 30, height: 30))
        self.commentButtonImg.image = UIImage(named: "comment-button");
        self.commentView.addSubview(self.commentButtonImg)
        self.commentCountLabel = UILabel(frame: CGRect(x: 30, y: 16, width: 100, height: 18))
        self.commentCountLabel.font = UIFont.systemFontOfSize(13)
        self.commentCountLabel.textColor = CTAStyleKit.normalColor
        self.commentCountLabel.textAlignment = .Left
        self.commentView.addSubview(self.commentCountLabel)
        self.commentView.backgroundColor = UIColor.clearColor()
        self.commentCountLabel.text = NSLocalizedString("CommentsLabel", comment: "")
        self.commentView.userInteractionEnabled = true
        let commemtButtonTap = UITapGestureRecognizer(target: self, action: #selector(commentButtonClick(_:)))
        self.commentView.addGestureRecognizer(commemtButtonTap)
        
        self.rebuildView = UIView(frame: CGRect(x: bounds.width-60, y: bounds.height-100, width: 60, height: 50))
        self.addSubview(self.rebuildView)
        self.rebuildButtonImg = UIImageView(frame: CGRect(x: 0, y: 10, width: 30, height: 30))
        self.rebuildButtonImg.image = UIImage(named: "rebuild-button");
        self.rebuildView.addSubview(self.rebuildButtonImg)
        self.rebuildLabel = UILabel(frame: CGRect(x: 30, y: 17, width: 60, height: 18))
        self.rebuildLabel.font = UIFont.systemFontOfSize(13)
        self.rebuildLabel.textColor = CTAStyleKit.normalColor
        self.rebuildLabel.textAlignment = .Left
        self.rebuildView.addSubview(self.rebuildLabel)
        self.rebuildView.backgroundColor = UIColor.clearColor()
        self.rebuildLabel.text = "Ding"
        self.rebuildLabel.sizeToFit()
        self.rebuildView.frame.size.width = self.rebuildButtonImg.frame.width + self.rebuildLabel.frame.width
        self.rebuildView.frame.origin.x = bounds.width - self.rebuildView.frame.size.width - 14
        self.rebuildView.userInteractionEnabled = true
        let rebuildButtonTap = UITapGestureRecognizer(target: self, action: #selector(rebuildButtonClick(_:)))
        self.rebuildView.addGestureRecognizer(rebuildButtonTap)
        
        
        let lastY = bounds.height - 50
        self.publishTimeLabel = UILabel(frame: CGRect(x: 45, y: lastY + 17, width: bounds.width/2, height: 18))
        self.publishTimeLabel.font = UIFont.systemFontOfSize(13)
        self.publishTimeLabel.textColor = CTAStyleKit.labelShowColor
        self.publishTimeLabel.textAlignment = .Left
        iconView.addSubview(self.publishTimeLabel)
        
        
        let likeCountView = UIView(frame: CGRect(x: 0, y: lastY, width: bounds.width/2, height: 50))
        self.addSubview(likeCountView)
        likeCountView.backgroundColor = UIColor.clearColor()
        let likeCountImg = UIImageView(frame: CGRect(x: 12, y: 10, width: 30, height: 30))
        likeCountImg.image = UIImage(named: "like-count");
        likeCountView.addSubview(likeCountImg)
        self.publishLikeCountLabel = UILabel(frame: CGRect(x: 53, y: 16, width: bounds.width/2, height: 18))
        self.publishLikeCountLabel.font = UIFont.systemFontOfSize(13)
        self.publishLikeCountLabel.textColor = CTAStyleKit.normalColor
        self.publishLikeCountLabel.textAlignment = .Left
        likeCountView.addSubview(self.publishLikeCountLabel)
        likeCountView.userInteractionEnabled = true
        let likeCountTap = UITapGestureRecognizer(target: self, action: #selector(likeCountClick(_:)))
        likeCountView.addGestureRecognizer(likeCountTap)
    }
    
    func reloadView(){
        if self.publishModel != nil{
            let usermodel = self.publishModel!.userModel
            self.setNikeNameLabel(usermodel.nickName)
            self.setTimeLabel(self.getPublishDate(self.publishModel!.publishDate))
            self.setUserIcon(usermodel.userIconURL)
            self.changeLikeStatus()
            self.setCommentButtonCount()
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
    }
    
    func setNikeNameLabel(text:String){
        self.userNickNameLabel.text = text
    }
    
    func setTimeLabel(text:String){
        let bounds = self.frame
        self.publishTimeLabel.text = text
        self.publishTimeLabel.sizeToFit()
        self.publishTimeLabel.frame.origin.x = bounds.width - self.publishTimeLabel.frame.width - 14
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
    
    func setPublishLikeCount(){
        let likeCount = self.publishModel!.likeCount
        if likeCount != 0{
            self.publishLikeCountLabel.text = self.changeCountToAllString(likeCount)+"  "+NSLocalizedString("LikesLabel", comment: "")
        }else {
            self.publishLikeCountLabel.text = NSLocalizedString("LikeDefaultLabel", comment: "")
        }
    }
    
    func setCommentButtonCount(){
        let commentCount = self.publishModel!.commentCount
        if commentCount != 0{
            self.commentCountLabel.text = self.changeCountToString(commentCount)
        }else {
            self.commentCountLabel.text = ""
        }
    }
    
    func changeLikeStatus(){
        if let model = self.publishModel{
            if model.likeStatus == 0{
                self.likeButtonImg.image = UIImage.init(named: "like-button")
            }else {
                self.likeButtonImg.image = UIImage.init(named: "like-selected-button")
            }
            self.setPublishLikeCount()
        }
    }
    
    func userIconClick(sender: UIPanGestureRecognizer) {
        if self.delegate != nil{
            self.delegate?.userIconTap()
        }
    }
    
    func likeCountClick(sender: UIPanGestureRecognizer) {
        let likeCount = self.publishModel!.likeCount
        if likeCount != 0{
            if self.delegate != nil{
                self.delegate?.likeListTap()
            }
        }else {
            if self.delegate != nil{
                self.delegate?.likeHandler()
            }
        }
    }
    
    func likeButtonClick(sender: UIPanGestureRecognizer) {
        if self.delegate != nil{
            self.delegate?.likeHandler()
        }
    }
    
    func commentButtonClick(sender: UIPanGestureRecognizer) {
        if self.delegate != nil{
            self.delegate?.commentHandler()
        }
    }
    
    func rebuildButtonClick(sender: UIPanGestureRecognizer) {
        if self.delegate != nil{
            self.delegate?.rebuildHandler()
        }
    }
    
    func moreButtonClick(sender: UIPanGestureRecognizer) {
        if self.delegate != nil{
            self.delegate?.moreHandler()
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
    func userIconTap()
    func likeListTap()
    func likeHandler()
    func commentHandler()
    func rebuildHandler()
    func moreHandler()
}