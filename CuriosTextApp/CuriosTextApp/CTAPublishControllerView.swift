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
    var likeCountLabel:UILabel!
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
        var textLine = UIImageView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 1))
        textLine.image = UIImage(named: "space-line")
        self.addSubview(textLine)
        
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 50))
        self.addSubview(iconView)
        self.userIconImage = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30));
        self.cropImageCircle(self.userIconImage)
        self.userIconImage.image = UIImage(named: "default-usericon")
        iconView.addSubview(self.userIconImage)
        self.userNickNameLabel = UILabel(frame: CGRect(x: 50, y: 8, width: bounds.width/2, height: 18))
        self.userNickNameLabel.font = UIFont.boldSystemFontOfSize(13)
        self.userNickNameLabel.textColor = CTAStyleKit.normalColor
        self.userNickNameLabel.textAlignment = .Left
        iconView.addSubview(self.userNickNameLabel)
        self.publishTimeLabel = UILabel(frame: CGRect(x: 50, y: 24, width: bounds.width/2, height: 18))
        self.publishTimeLabel.font = UIFont.systemFontOfSize(13)
        self.publishTimeLabel.textColor = CTAStyleKit.disableColor
        self.publishTimeLabel.textAlignment = .Left
        iconView.addSubview(self.publishTimeLabel)
        iconView.backgroundColor = UIColor.clearColor()
        iconView.userInteractionEnabled = true
        let iconTap = UITapGestureRecognizer(target: self, action: #selector(userIconClick(_:)))
        iconView.addGestureRecognizer(iconTap)
        
        self.publishLikeCountLabel = UILabel(frame: CGRect(x: 240, y: 0, width: bounds.width/2, height: 50))
        self.publishLikeCountLabel.font = UIFont.systemFontOfSize(13)
        self.publishLikeCountLabel.textColor = CTAStyleKit.normalColor
        self.publishLikeCountLabel.textAlignment = .Right
        self.addSubview(self.publishLikeCountLabel)
        self.publishLikeCountLabel.userInteractionEnabled = true
        let likeCountTap = UITapGestureRecognizer(target: self, action: #selector(likeCountClick(_:)))
        self.publishLikeCountLabel.addGestureRecognizer(likeCountTap)
        
        textLine = UIImageView(frame: CGRect(x: 0, y: 50, width: bounds.width, height: 1))
        textLine.image = UIImage(named: "space-line")
        self.addSubview(textLine)
        
        let moreW = bounds.width*0.25
        let buttonW = (bounds.width - moreW)/3
        self.likeView = UIView(frame: CGRect(x: 0, y: 50, width: buttonW, height: 50))
        self.addSubview(self.likeView)
        self.likeButtonImg = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        self.likeButtonImg.image = UIImage(named: "like-button");
        self.likeView.addSubview(self.likeButtonImg)
        self.likeCountLabel = UILabel(frame: CGRect(x: 50, y: 18, width: buttonW, height: 18))
        self.likeCountLabel.font = UIFont.systemFontOfSize(13)
        self.likeCountLabel.textColor = CTAStyleKit.normalColor
        self.likeCountLabel.textAlignment = .Left
        self.likeView.addSubview(self.likeCountLabel)
        self.likeView.backgroundColor = UIColor.clearColor()
        self.likeCountLabel.text = NSLocalizedString("LikesLabel", comment: "")
        self.adjustButtonView(self.likeButtonImg, label: self.likeCountLabel, buttonView: self.likeView)
        self.likeView.userInteractionEnabled = true
        let likeButtonTap = UITapGestureRecognizer(target: self, action: #selector(likeButtonClick(_:)))
        self.likeView.addGestureRecognizer(likeButtonTap)
        
        self.commentView = UIView(frame: CGRect(x: buttonW, y: 50, width: buttonW, height: 50))
        self.addSubview(self.commentView)
        self.commentButtonImg = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        self.commentButtonImg.image = UIImage(named: "comment-button");
        self.commentView.addSubview(self.commentButtonImg)
        self.commentCountLabel = UILabel(frame: CGRect(x: 50, y: 18, width: buttonW, height: 18))
        self.commentCountLabel.font = UIFont.systemFontOfSize(13)
        self.commentCountLabel.textColor = CTAStyleKit.normalColor
        self.commentCountLabel.textAlignment = .Left
        self.commentView.addSubview(self.commentCountLabel)
        self.commentView.backgroundColor = UIColor.clearColor()
        self.commentCountLabel.text = NSLocalizedString("CommentsLabel", comment: "")
        self.adjustButtonView(self.commentButtonImg, label: self.commentCountLabel, buttonView: self.commentView)
        self.commentView.userInteractionEnabled = true
        let commemtButtonTap = UITapGestureRecognizer(target: self, action: #selector(commentButtonClick(_:)))
        self.commentView.addGestureRecognizer(commemtButtonTap)
        
        self.rebuildView = UIView(frame: CGRect(x: buttonW*2, y: 50, width: buttonW, height: 50))
        self.addSubview(self.rebuildView)
        self.rebuildButtonImg = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        self.rebuildButtonImg.image = UIImage(named: "rebuild-button");
        self.rebuildView.addSubview(self.rebuildButtonImg)
        self.rebuildLabel = UILabel(frame: CGRect(x: 50, y: 18, width: buttonW, height: 18))
        self.rebuildLabel.font = UIFont.systemFontOfSize(13)
        self.rebuildLabel.textColor = CTAStyleKit.normalColor
        self.rebuildLabel.textAlignment = .Left
        self.rebuildView.addSubview(self.rebuildLabel)
        self.rebuildView.backgroundColor = UIColor.clearColor()
        self.rebuildLabel.text = "Ding"
        self.adjustButtonView(self.rebuildButtonImg, label: self.rebuildLabel, buttonView: self.rebuildView)
        self.rebuildView.userInteractionEnabled = true
        let rebuildButtonTap = UITapGestureRecognizer(target: self, action: #selector(rebuildButtonClick(_:)))
        self.rebuildView.addGestureRecognizer(rebuildButtonTap)
        
        self.moreView = UIView(frame: CGRect(x: buttonW*3, y: 50, width: moreW, height: 50))
        self.addSubview(self.moreView)
        self.moreButtonImg = UIImageView(frame: CGRect(x: moreW-40, y: 10, width: 30, height: 30))
        self.moreButtonImg.image = UIImage(named: "moreSelection-button");
        self.moreView.addSubview(self.moreButtonImg)
        self.moreView.backgroundColor = UIColor.clearColor()
        self.moreView.userInteractionEnabled = true
        let moreButtonTap = UITapGestureRecognizer(target: self, action: #selector(moreButtonClick(_:)))
        self.moreView.addGestureRecognizer(moreButtonTap)
    }
    
    func reloadView(){
        if self.publishModel != nil{
            let usermodel = self.publishModel!.userModel
            self.userNickNameLabel.text = usermodel.nickName
            self.publishTimeLabel.text = self.getPublishDate(self.publishModel!.publishDate)
            self.setUserIcon(usermodel.userIconURL)
            self.setPublishLikeCount()
            self.setLikeButtonCount()
            self.setCommentButtonCount()
        }else {
            self.resetView()
        }
    }
    
    func resetView(){
        self.userNickNameLabel.text = ""
        self.publishTimeLabel.text = ""
        self.publishLikeCountLabel.text = ""
        self.userIconImage.image = UIImage(named: "default-usericon")
        
        self.likeCountLabel.text = NSLocalizedString("LikesLabel", comment: "")
        self.adjustButtonView(self.likeButtonImg, label: self.likeCountLabel, buttonView: self.likeView)
        self.commentCountLabel.text = NSLocalizedString("CommentsLabel", comment: "")
        self.adjustButtonView(self.commentButtonImg, label: self.commentCountLabel, buttonView: self.commentView)
        self.rebuildLabel.text = "Ding"
        self.adjustButtonView(self.rebuildButtonImg, label: self.rebuildLabel, buttonView: self.rebuildView)
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
        let bounds = self.frame
        let likeCount = self.publishModel!.likeCount
        if likeCount != 0{
             self.publishLikeCountLabel.text = self.changeCountToAllString(likeCount)+"  "+NSLocalizedString("LikesLabel", comment: "")
        }else {
            self.publishLikeCountLabel.text = ""
        }
        self.publishLikeCountLabel.sizeToFit()
        self.publishLikeCountLabel.frame.origin.x = bounds.width - 10 - self.publishLikeCountLabel.frame.width
        self.publishLikeCountLabel.frame.size.height = 50
    }
    
    func setLikeButtonCount(){
        let likeCount = self.publishModel!.likeCount
        if likeCount != 0{
            self.likeCountLabel.text = self.changeCountToString(likeCount)
        }else {
            self.likeCountLabel.text = NSLocalizedString("LikesLabel", comment: "")
        }
        self.adjustButtonView(self.likeButtonImg, label: self.likeCountLabel, buttonView: self.likeView)
    }
    
    func setCommentButtonCount(){
        self.commentCountLabel.text = NSLocalizedString("CommentsLabel", comment: "")
        self.adjustButtonView(self.commentButtonImg, label: self.commentCountLabel, buttonView: self.commentView)
    }
    
    func adjustButtonView(img:UIImageView, label:UILabel, buttonView:UIView){
        label.sizeToFit()
        let itemW = label.frame.width + 50
        let viewW = buttonView.frame.width
        if itemW > viewW{
            let itemX = (buttonView.frame.width - img.frame.width - label.frame.width)/2
            img.frame.origin.x = itemX
            label.frame.origin.x = img.frame.width + itemX
        }else {
            img.frame.origin.x = 10
            label.frame.origin.x = 50
        }
    }
    
    func userIconClick(sender: UIPanGestureRecognizer) {
        if self.delegate != nil{
            self.delegate?.userIconTap()
        }
    }
    
    func likeCountClick(sender: UIPanGestureRecognizer) {
        if self.delegate != nil{
            self.delegate?.likeListTap()
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
}

protocol CTAPublishControllerDelegate {
    func userIconTap()
    func likeListTap()
    func likeHandler()
    func commentHandler()
    func rebuildHandler()
    func moreHandler()
}