//
//  CTAShareViewController.swift
//  CuriosTextApp
//
//  Created by allen on 16/3/2.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation

class CTAShareView: UIView{
    
    var delegate:CTAShareViewDelegate?
    
    var buttonView:UIView!
    var scrollView:UIScrollView!
    
    var wechatShareView:UIView!
    var momentsShareView:UIView!
    var deleteView:UIView!
    var saveLocolView:UIView!
    var reportView:UIView!
    var uploadResourceView:UIView!
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
            let bounds = UIScreen.mainScreen().bounds
            _instance = CTAShareView(frame: bounds)
        }
        return _instance!
    }
    
    func initView(){
        let bounds = UIScreen.mainScreen().bounds
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
        cancelView.backgroundColor = UIColor.whiteColor()
        let cancelButton:UIButton = UIButton.init()
        cancelButton.frame.size = cancelView.frame.size
        let cancelLabel = LocalStrings.Cancel.description
        cancelButton.setTitle(cancelLabel, forState: .Normal)
        cancelButton.setTitleColor(UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0), forState: .Normal)
        cancelButton.addTarget(self, action: #selector(CTAShareView.cancelButtonClick(_:)), forControlEvents: .TouchUpInside)
        cancelView.addSubview(cancelButton)
        self.buttonView.addSubview(cancelView)
        
        self.wechatShareView = UIView.init(frame: CGRect.init(x: 0, y: 15, width: buttonW, height: buttonW))
        let wechatButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: buttonW, height: buttonW))
        wechatButton.setImage(UIImage.init(named: "wechat-share-button"), forState: .Normal)
        wechatButton.addTarget(self, action: #selector(CTAShareView.weChatButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.wechatShareView.addSubview(wechatButton)
        let wechatLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 20))
        wechatLabel.font = UIFont.systemFontOfSize(8)
        wechatLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        wechatLabel.text = LocalStrings.Wechat.description
        wechatLabel.sizeToFit()
        wechatLabel.center = CGPoint.init(x: wechatButton.center.x, y: buttonW+20)
        self.wechatShareView.addSubview(wechatLabel)
        self.wechatShareView.sizeToFit()
        self.wechatShareView.frame.origin.x = 15
        self.scrollView.addSubview(self.wechatShareView)
        
        self.momentsShareView = UIView.init(frame: CGRect.init(x: 0, y: 15, width: buttonW, height: buttonW))
        let momentsButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: buttonW, height: buttonW))
        momentsButton.setImage(UIImage.init(named: "moments-share-button"), forState: .Normal)
        momentsButton.addTarget(self, action: #selector(CTAShareView.momentsButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.momentsShareView.addSubview(momentsButton)
        let momentsLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 20))
        momentsLabel.font = UIFont.systemFontOfSize(8)
        momentsLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        momentsLabel.text = LocalStrings.Moments.description
        momentsLabel.sizeToFit()
        momentsLabel.center = CGPoint.init(x: momentsButton.center.x, y: buttonW+20)
        self.momentsShareView.addSubview(momentsLabel)
        self.momentsShareView.sizeToFit()
        self.momentsShareView.frame.origin.x = 88
        self.scrollView.addSubview(self.momentsShareView)
        
        self.deleteView = UIView.init(frame: CGRect.init(x: 0, y: 15, width: buttonW, height: buttonW))
        let deleteButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: buttonW, height: buttonW))
        deleteButton.setImage(UIImage.init(named: "delete-file-button"), forState: .Normal)
        deleteButton.addTarget(self, action: #selector(CTAShareView.deleteButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.deleteView.addSubview(deleteButton)
        let deleteLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 20))
        deleteLabel.font = UIFont.systemFontOfSize(8)
        deleteLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        deleteLabel.text = LocalStrings.DeleteFile.description
        deleteLabel.sizeToFit()
        deleteLabel.center = CGPoint.init(x: deleteButton.center.x, y: buttonW+20)
        self.deleteView.addSubview(deleteLabel)
        self.deleteView.sizeToFit()
        self.deleteView.frame.origin.x = 160
        self.scrollView.addSubview(self.deleteView)
        
        self.saveLocolView = UIView.init(frame: CGRect.init(x: 0, y: 15, width: buttonW, height: buttonW))
        let saveLocalButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: buttonW, height: buttonW))
        saveLocalButton.setImage(UIImage.init(named: "save-file-button"), forState: .Normal)
        saveLocalButton.addTarget(self, action: #selector(CTAShareView.saveLocalButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.saveLocolView.addSubview(saveLocalButton)
        let saveLocalLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 20))
        saveLocalLabel.font = UIFont.systemFontOfSize(8)
        saveLocalLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        saveLocalLabel.text = LocalStrings.SaveLocal.description
        saveLocalLabel.sizeToFit()
        saveLocalLabel.center = CGPoint.init(x: deleteButton.center.x, y: buttonW+20)
        self.saveLocolView.addSubview(saveLocalLabel)
        self.saveLocolView.sizeToFit()
        self.saveLocolView.frame.origin.x = 230
        self.scrollView.addSubview(self.saveLocolView)
        
        self.reportView = UIView.init(frame: CGRect.init(x: 0, y: 15, width: buttonW, height: buttonW))
        let reportButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: buttonW, height: buttonW))
        reportButton.setImage(UIImage.init(named: "report-file-button"), forState: .Normal)
        reportButton.addTarget(self, action: #selector(CTAShareView.reportButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.reportView.addSubview(reportButton)
        let reportLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 20))
        reportLabel.font = UIFont.systemFontOfSize(8)
        reportLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        reportLabel.text = LocalStrings.Report.description
        reportLabel.sizeToFit()
        reportLabel.center = CGPoint.init(x: reportButton.center.x, y: buttonW+20)
        self.reportView.addSubview(reportLabel)
        self.reportView.sizeToFit()
        self.reportView.frame.origin.x = 230
        self.scrollView.addSubview(self.reportView)
        
        self.uploadResourceView = UIView.init(frame: CGRect.init(x: 0, y: 15, width: buttonW, height: buttonW))
        let uploadButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: buttonW, height: buttonW))
        uploadButton.setImage(UIImage.init(named: "report-file-button"), forState: .Normal)
        uploadButton.addTarget(self, action: #selector(CTAShareView.uploadResourceButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.uploadResourceView.addSubview(uploadButton)
        let uploadLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 20))
        uploadLabel.font = UIFont.systemFontOfSize(8)
        uploadLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        uploadLabel.text = LocalStrings.Report.description
        uploadLabel.sizeToFit()
        uploadLabel.center = CGPoint.init(x: uploadButton.center.x, y: buttonW+20)
        self.uploadResourceView.addSubview(uploadLabel)
        self.uploadResourceView.sizeToFit()
        self.uploadResourceView.frame.origin.x = 230
        self.scrollView.addSubview(self.uploadResourceView)
        
        #if DEBUG
            self.uploadResourceView.hidden = false
        #else
            self.uploadResourceView.hidden = true
        #endif
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
    
    func showViewHandler(isSelf:Bool){
        let bounds = UIScreen.mainScreen().bounds
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        if isSelf{
            self.selfShareView()
        }else {
            self.unSelfShareView()
        }
        self.resetScrollView()
        UIView.animateWithDuration(0.3) { () -> Void in
            self.buttonView.frame.origin.y = bounds.height - 170
            self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        }
    }
    
    func selfShareView(){
        self.deleteView.hidden = false
        let rate =  UIScreen.mainScreen().bounds.width / 375
        self.space = 15.00 * rate
        self.wechatShareView.frame.origin.x = space
        self.momentsShareView.frame.origin.x = space+(space+buttonW)*1
        self.deleteView.frame.origin.x = space+(space+buttonW)*2
        self.saveLocolView.frame.origin.x = space+(space+buttonW)*3
        self.reportView.frame.origin.x = space+(space+buttonW)*4
        self.uploadResourceView.frame.origin.x = space+(space+buttonW)*5
    }
    
    func unSelfShareView(){
        self.deleteView.hidden = true
        let rate =  UIScreen.mainScreen().bounds.width / 375
        self.space = 20.00 * rate
        self.wechatShareView.frame.origin.x = space
        self.momentsShareView.frame.origin.x = space+(space+buttonW)*1
        self.deleteView.frame.origin.x = space+(space+buttonW)*2
        self.saveLocolView.frame.origin.x = space+(space+buttonW)*2
        self.reportView.frame.origin.x = space+(space+buttonW)*3
        self.uploadResourceView.frame.origin.x = space+(space+buttonW)*4
    }
    
    func resetScrollView(){
        let maxWidth = self.reportView.frame.origin.x + self.reportView.frame.width + space
        self.scrollView.contentSize = CGSize(width: maxWidth, height: 170)
    }
    
    func cancelHandler(){
        let bounds = UIScreen.mainScreen().bounds
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.buttonView.frame.origin.y = bounds.height
            self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        }) { (_) -> Void in
            self.removeFromSuperview()
            self.delegate = nil
        }
    }
    
    func cancelButtonClick(sender: UIButton){
        self.cancelHandler()
    }
    
    func backButtonClikc(sender: UITapGestureRecognizer){
        let pt = sender.locationInView(self.buttonView)
        if !self.buttonView.pointInside(pt, withEvent: nil){
            self.cancelHandler()
        }
    }
    
    func weChatButtonClick(sender: UIButton){
        if self.delegate != nil {
            self.delegate!.weChatShareHandler()
        }
        self.cancelHandler()
    }
    
    func momentsButtonClick(sender: UIButton){
        if self.delegate != nil {
            self.delegate!.momentsShareHandler()
        }
        self.cancelHandler()
    }
    
    func deleteButtonClick(sender: UIButton){
        if self.delegate != nil {
            self.delegate!.deleteHandler()
        }
        self.cancelHandler()
    }
    
    func saveLocalButtonClick(sender: UIButton){
        if self.delegate != nil {
            self.delegate!.saveLocalHandler()
        }
        self.cancelHandler()
    }
    
    func reportButtonClick(sender: UIButton){
        if self.delegate != nil {
            self.delegate!.reportHandler()
        }
        self.cancelHandler()
    }
    
    func uploadResourceButtonClick(sender: UIButton){
        if self.delegate != nil {
            self.delegate!.uploadResourceHandler()
        }
        self.cancelHandler()
    }
    
    func copyLinkButtonClick(sender: UIButton){
        if self.delegate != nil {
            self.delegate!.copyLinkHandler()
        }
        self.cancelHandler()
    }
}

protocol CTAShareViewDelegate{
    func weChatShareHandler()
    func momentsShareHandler()
    func deleteHandler()
    func copyLinkHandler()
    func saveLocalHandler()
    func reportHandler()
    func uploadResourceHandler()
}