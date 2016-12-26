//
//  CTAShareViewController.swift
//  CuriosTextApp
//
//  Created by allen on 16/3/2.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation

enum CTAShareViewType{
    case normal, loginUser, setting
}

class CTAShareView: UIView{
    
    var delegate:CTAShareViewDelegate?
    
    var buttonView:UIView!
    var scrollView:UIScrollView!
    
    var wechatShareView:UIView!
    var momentsShareView:UIView!
    var weiboShareView:UIView!
    var deleteView:UIView!
    var saveLocolView:UIView!
    var reportView:UIView!
    var uploadResourceView:UIView!
    var addToHotView:UIView!
    
    var shareType:CTAShareViewType = .normal
    //var copyLinkView:UIView!
    
    var space:CGFloat = 15.00
    let buttonW:CGFloat = 60.00
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var _instance:CTAShareView?;
    
    static func getInstance() -> CTAShareView{
        if _instance == nil{
            let bounds = UIScreen.main.bounds
            _instance = CTAShareView(frame: bounds)
        }
        return _instance!
    }
    
    func initView(){
        let bounds = UIScreen.main.bounds
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        let tap = UITapGestureRecognizer(target: self, action: #selector(CTAShareView.backButtonClikc(_:)))
        self.addGestureRecognizer(tap)
        
        self.buttonView = UIView.init(frame: CGRect.init(x: 0, y: bounds.height, width: bounds.width, height: 170))
        self.buttonView.backgroundColor = UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        self.addSubview(self.buttonView)
        
        self.scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: bounds.width, height: 170))
        self.scrollView.backgroundColor = UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        self.buttonView.addSubview(self.scrollView)
        
        let cancelView = UIView.init(frame: CGRect.init(x: 0, y: self.buttonView.frame.height - 50, width: bounds.width, height: 50))
        cancelView.backgroundColor = UIColor.white
        let cancelButton:UIButton = UIButton.init()
        cancelButton.frame.size = cancelView.frame.size
        let cancelLabel = LocalStrings.cancel.description
        cancelButton.setTitle(cancelLabel, for: UIControlState())
        cancelButton.setTitleColor(UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(CTAShareView.cancelButtonClick(_:)), for: .touchUpInside)
        cancelView.addSubview(cancelButton)
        self.buttonView.addSubview(cancelView)
        
        self.wechatShareView = UIView.init(frame: CGRect.init(x: 0, y: 15, width: buttonW, height: buttonW))
        let wechatButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: buttonW, height: buttonW))
        wechatButton.setImage(UIImage.init(named: "wechat-share-button"), for: UIControlState())
        wechatButton.addTarget(self, action: #selector(CTAShareView.weChatButtonClick(_:)), for: .touchUpInside)
        self.wechatShareView.addSubview(wechatButton)
        let wechatLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 20))
        wechatLabel.font = UIFont.systemFont(ofSize: 8)
        wechatLabel.textColor = CTAStyleKit.normalColor//UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        wechatLabel.text = LocalStrings.wechat.description
        wechatLabel.sizeToFit()
        wechatLabel.center = CGPoint.init(x: wechatButton.center.x, y: buttonW+20)
        self.wechatShareView.addSubview(wechatLabel)
        self.wechatShareView.sizeToFit()
        self.wechatShareView.frame.origin.x = 15
        self.scrollView.addSubview(self.wechatShareView)
        
        self.momentsShareView = UIView.init(frame: CGRect.init(x: 0, y: 15, width: buttonW, height: buttonW))
        let momentsButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: buttonW, height: buttonW))
        momentsButton.setImage(UIImage.init(named: "moments-share-button"), for: UIControlState())
        momentsButton.addTarget(self, action: #selector(CTAShareView.momentsButtonClick(_:)), for: .touchUpInside)
        self.momentsShareView.addSubview(momentsButton)
        let momentsLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 20))
        momentsLabel.font = UIFont.systemFont(ofSize: 8)
        momentsLabel.textColor = CTAStyleKit.normalColor//UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        momentsLabel.text = LocalStrings.moments.description
        momentsLabel.sizeToFit()
        momentsLabel.center = CGPoint.init(x: momentsButton.center.x, y: buttonW+20)
        self.momentsShareView.addSubview(momentsLabel)
        self.momentsShareView.sizeToFit()
        self.momentsShareView.frame.origin.x = 88
        self.scrollView.addSubview(self.momentsShareView)
        

        
        self.weiboShareView = UIView.init(frame: CGRect.init(x: 0, y: 15, width: buttonW, height: buttonW))
        let weiboButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: buttonW, height: buttonW))
        weiboButton.setImage(UIImage.init(named: "weibo-share-button"), for: UIControlState())
        weiboButton.addTarget(self, action: #selector(CTAShareView.weiboButtonClick(_:)), for: .touchUpInside)
        self.weiboShareView.addSubview(weiboButton)
        let weiboLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 20))
        weiboLabel.font = UIFont.systemFont(ofSize: 8)
        weiboLabel.textColor = CTAStyleKit.normalColor//UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        weiboLabel.text = LocalStrings.weibo.description
        weiboLabel.sizeToFit()
        weiboLabel.center = CGPoint.init(x: weiboButton.center.x, y: buttonW+20)
        self.weiboShareView.addSubview(weiboLabel)
        self.weiboShareView.sizeToFit()
        self.weiboShareView.frame.origin.x = 88
        self.scrollView.addSubview(self.weiboShareView)
 
        
        
        self.deleteView = UIView.init(frame: CGRect.init(x: 0, y: 15, width: buttonW, height: buttonW))
        let deleteButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: buttonW, height: buttonW))
        deleteButton.setImage(UIImage.init(named: "delete-file-button"), for: UIControlState())
        deleteButton.addTarget(self, action: #selector(CTAShareView.deleteButtonClick(_:)), for: .touchUpInside)
        self.deleteView.addSubview(deleteButton)
        let deleteLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 20))
        deleteLabel.font = UIFont.systemFont(ofSize: 8)
        deleteLabel.textColor = CTAStyleKit.normalColor//UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        deleteLabel.text = LocalStrings.deleteFile.description
        deleteLabel.sizeToFit()
        deleteLabel.center = CGPoint.init(x: deleteButton.center.x, y: buttonW+20)
        self.deleteView.addSubview(deleteLabel)
        self.deleteView.sizeToFit()
        self.deleteView.frame.origin.x = 160
        self.scrollView.addSubview(self.deleteView)
        
        self.saveLocolView = UIView.init(frame: CGRect.init(x: 0, y: 15, width: buttonW, height: buttonW))
        let saveLocalButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: buttonW, height: buttonW))
        saveLocalButton.setImage(UIImage.init(named: "save-file-button"), for: UIControlState())
        saveLocalButton.addTarget(self, action: #selector(CTAShareView.saveLocalButtonClick(_:)), for: .touchUpInside)
        self.saveLocolView.addSubview(saveLocalButton)
        let saveLocalLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 20))
        saveLocalLabel.font = UIFont.systemFont(ofSize: 8)
        saveLocalLabel.textColor = CTAStyleKit.normalColor//UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        saveLocalLabel.text = LocalStrings.saveLocal.description
        saveLocalLabel.sizeToFit()
        saveLocalLabel.center = CGPoint.init(x: deleteButton.center.x, y: buttonW+20)
        self.saveLocolView.addSubview(saveLocalLabel)
        self.saveLocolView.sizeToFit()
        self.saveLocolView.frame.origin.x = 230
        self.scrollView.addSubview(self.saveLocolView)
        
        self.reportView = UIView.init(frame: CGRect.init(x: 0, y: 15, width: buttonW, height: buttonW))
        let reportButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: buttonW, height: buttonW))
        reportButton.setImage(UIImage.init(named: "report-file-button"), for: UIControlState())
        reportButton.addTarget(self, action: #selector(CTAShareView.reportButtonClick(_:)), for: .touchUpInside)
        self.reportView.addSubview(reportButton)
        let reportLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 20))
        reportLabel.font = UIFont.systemFont(ofSize: 8)
        reportLabel.textColor = CTAStyleKit.normalColor//UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        reportLabel.text = LocalStrings.report.description
        reportLabel.sizeToFit()
        reportLabel.center = CGPoint.init(x: reportButton.center.x, y: buttonW+20)
        self.reportView.addSubview(reportLabel)
        self.reportView.sizeToFit()
        self.reportView.frame.origin.x = 230
        self.scrollView.addSubview(self.reportView)
        
        self.uploadResourceView = UIView.init(frame: CGRect.init(x: 0, y: 15, width: buttonW, height: buttonW))
        let uploadButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: buttonW, height: buttonW))
        uploadButton.setImage(UIImage.init(named: "copy-link-button"), for: UIControlState())
        uploadButton.addTarget(self, action: #selector(CTAShareView.uploadResourceButtonClick(_:)), for: .touchUpInside)
        self.uploadResourceView.addSubview(uploadButton)
        let uploadLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 20))
        uploadLabel.font = UIFont.systemFont(ofSize: 8)
        uploadLabel.textColor = CTAStyleKit.normalColor//UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        uploadLabel.text = LocalStrings.uploadFile.description
        uploadLabel.sizeToFit()
        uploadLabel.center = CGPoint.init(x: uploadButton.center.x, y: buttonW+20)
        self.uploadResourceView.addSubview(uploadLabel)
        self.uploadResourceView.sizeToFit()
        self.uploadResourceView.frame.origin.x = 230
        self.scrollView.addSubview(self.uploadResourceView)
        
        self.addToHotView = UIView.init(frame: CGRect.init(x: 0, y: 15, width: buttonW, height: buttonW))
        let addToHotButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: buttonW, height: buttonW))
        addToHotButton.setImage(UIImage.init(named: "copy-link-button"), for: UIControlState())
        addToHotButton.addTarget(self, action: #selector(CTAShareView.addToHotButtonClick(_:)), for: .touchUpInside)
        self.addToHotView.addSubview(addToHotButton)
        let addToHotLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 20))
        addToHotLabel.font = UIFont.systemFont(ofSize: 8)
        addToHotLabel.textColor = CTAStyleKit.normalColor//UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        addToHotLabel.text = LocalStrings.addToHot.description
        addToHotLabel.sizeToFit()
        addToHotLabel.center = CGPoint.init(x: uploadButton.center.x, y: buttonW+20)
        self.addToHotView.addSubview(addToHotLabel)
        self.addToHotView.sizeToFit()
        self.addToHotView.frame.origin.x = 230
        self.scrollView.addSubview(self.addToHotView)
        
//        self.copyLinkView = UIView.init(frame: CGRect.init(x: 0, y: 15, width: buttonW, height: buttonW))
//        let copyLinkButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: buttonW, height: buttonW))
//        copyLinkButton.setImage(UIImage.init(named: "copy-link-button"), forState: .Normal)
//        copyLinkButton.addTarget(self, action: "copyLinkButtonClick:", forControlEvents: .TouchUpInside)
//        self.copyLinkView.addSubview(copyLinkButton)
//        let copyLinkLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 20))
//        copyLinkLabel.font = UIFont.systemFontOfSize(14)
//        copyLinkLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
//        copyLinkLabel.text = NSLocalizedString("CopyLinkLabel", comment: "")
//        copyLinkLabel.sizeToFit()
//        copyLinkLabel.center = CGPoint.init(x: copyLinkButton.center.x, y: buttonW+25)
//        self.copyLinkView.addSubview(copyLinkLabel)
//        self.copyLinkView.sizeToFit()
//        self.copyLinkView.frame.origin.x = (bounds.width/2 + 60 + space*3/2) - (self.copyLinkView.frame.width - buttonW)/2
//        self.buttonView.addSubview(self.copyLinkView)
    }
    
    func showViewHandler(){
        let bounds = UIScreen.main.bounds
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        switch self.shareType {
        case .normal:
            self.unSelfShareView()
        case .loginUser:
            self.selfShareView()
        case .setting:
            self.settingShareView()
        }
        self.resetScrollView()
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.buttonView.frame.origin.y = bounds.height - 170
            self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        }) 
    }
    
    func selfShareView(){
        self.deleteView.isHidden = false
        self.saveLocolView.isHidden = false
        self.reportView.isHidden = false
        if self.isAdminUser() {
            self.uploadResourceView.isHidden = false
            self.addToHotView.isHidden = false
        }else {
            self.uploadResourceView.isHidden = true
            self.addToHotView.isHidden = true
        }
        let rate =  UIScreen.main.bounds.width / 375
        self.space = 15.00 * rate
        self.wechatShareView.frame.origin.x = space
        self.momentsShareView.frame.origin.x = space+(space+buttonW)*1
        self.weiboShareView.frame.origin.x = space+(space+buttonW)*2
        self.deleteView.frame.origin.x = space+(space+buttonW)*3
        self.saveLocolView.frame.origin.x = space+(space+buttonW)*4
        self.reportView.frame.origin.x = space+(space+buttonW)*5
        self.addToHotView.frame.origin.x = space+(space+buttonW)*6
        self.uploadResourceView.frame.origin.x = space+(space+buttonW)*7
    }
    
    func unSelfShareView(){
        self.deleteView.isHidden = true
        self.saveLocolView.isHidden = false
        self.reportView.isHidden = false
        if self.isAdminUser() {
            self.uploadResourceView.isHidden = false
            self.addToHotView.isHidden = false
        }else {
            self.uploadResourceView.isHidden = true
            self.addToHotView.isHidden = true
        }
        let rate =  UIScreen.main.bounds.width / 375
        self.space = 15.00 * rate
        self.wechatShareView.frame.origin.x = space
        self.momentsShareView.frame.origin.x = space+(space+buttonW)*1
        self.weiboShareView.frame.origin.x = space+(space+buttonW)*2
        self.deleteView.frame.origin.x = space+(space+buttonW)*3
        self.saveLocolView.frame.origin.x = space+(space+buttonW)*3
        self.reportView.frame.origin.x = space+(space+buttonW)*4
        self.addToHotView.frame.origin.x = space+(space+buttonW)*5
        self.uploadResourceView.frame.origin.x = space+(space+buttonW)*6
    }
    
    func settingShareView(){
        self.deleteView.isHidden = true
        self.saveLocolView.isHidden = true
        self.reportView.isHidden = true
        self.uploadResourceView.isHidden = true
        self.addToHotView.isHidden = true
        let maxWidth =  UIScreen.main.bounds.width
        let space = (maxWidth - 3*buttonW)/4
        self.wechatShareView.frame.origin.x = space
        self.momentsShareView.frame.origin.x = space+(space+buttonW)*1
        self.weiboShareView.frame.origin.x = space+(space+buttonW)*2
        self.deleteView.frame.origin.x = space+(space+buttonW)*3
        self.saveLocolView.frame.origin.x = space+(space+buttonW)*3
        self.reportView.frame.origin.x = space+(space+buttonW)*3
        self.uploadResourceView.frame.origin.x = space+(space+buttonW)*3
        self.addToHotView.frame.origin.x = space+(space+buttonW)*3
    }
    
    func resetScrollView(){
        var maxWidth:CGFloat = 0.0
        if self.isAdminUser() {
            maxWidth = self.uploadResourceView.frame.origin.x + self.uploadResourceView.frame.width + space
        }else {
            maxWidth = self.reportView.frame.origin.x + self.reportView.frame.width + space
        }
        self.scrollView.contentSize = CGSize(width: maxWidth, height: 170)
        self.scrollView.contentOffset.x = 0
    }
    
    func isAdminUser() -> Bool {
        if let loginUser = CTAUserManager.user{
            if loginUser.userType == 0 {
                return true
            }else {
                return false
            }
        }else {
            return false
        }
    }
    
    func cancelHandler(_ complete: (() -> ())?){
        let bounds = UIScreen.main.bounds
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.buttonView.frame.origin.y = bounds.height
            self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        }, completion: { (_) -> Void in
            self.removeFromSuperview()
            complete?()
            self.delegate = nil
        }) 
    }
    
    func cancelButtonClick(_ sender: UIButton){
        self.cancelHandler({
        })
    }
    
    func backButtonClikc(_ sender: UITapGestureRecognizer){
        let pt = sender.location(in: self.buttonView)
        if !self.buttonView.point(inside: pt, with: nil){
            self.cancelHandler({
            })
        }
    }
    
    func weChatButtonClick(_ sender: UIButton){
        self.cancelHandler({
            if self.delegate != nil {
                self.delegate!.weChatShareHandler()
            }
        })
    }
    
    func momentsButtonClick(_ sender: UIButton){
        self.cancelHandler({
            if self.delegate != nil {
                self.delegate!.momentsShareHandler()
            }
        })
    }
    
    func weiboButtonClick(_ sender: UIButton){
        self.cancelHandler({
            if self.delegate != nil {
                self.delegate!.weiBoShareHandler()
            }
        })
    }
    
    func deleteButtonClick(_ sender: UIButton){
        self.cancelHandler({
            if self.delegate != nil {
                self.delegate!.deleteHandler()
            }
        })
    }
    
    func saveLocalButtonClick(_ sender: UIButton){
        self.cancelHandler({
            if self.delegate != nil {
                self.delegate!.saveLocalHandler()
            }
        })
    }
    
    func reportButtonClick(_ sender: UIButton){
        self.cancelHandler({
            if self.delegate != nil {
                self.delegate!.reportHandler()
            }
        })
    }
    
    func uploadResourceButtonClick(_ sender: UIButton){
        self.cancelHandler({
            if self.delegate != nil {
                self.delegate!.uploadResourceHandler()
            }
        })
    }
    
    func addToHotButtonClick(_ sender: UIButton){
        self.cancelHandler({
            if self.delegate != nil {
                self.delegate!.addToHotHandler()
            }
        })
    }
    
    func copyLinkButtonClick(_ sender: UIButton){
        self.cancelHandler({
            if self.delegate != nil {
                self.delegate!.copyLinkHandler()
            }
        })
    }
}

protocol CTAShareViewDelegate{
    func weChatShareHandler()
    func momentsShareHandler()
    func weiBoShareHandler()
    func deleteHandler()
    func copyLinkHandler()
    func saveLocalHandler()
    func reportHandler()
    func addToHotHandler()
    func uploadResourceHandler()
}
