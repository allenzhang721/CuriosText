//
//  CTAShareViewController.swift
//  CuriosTextApp
//
//  Created by allen on 16/3/2.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation

class CTAShareView: UIView{
    
    var delegate:CTAShareViewProtocol?
    
    var buttonView:UIView!
    
    var wechatShareView:UIView!
    var momentsShareView:UIView!
    var deleteView:UIView!
    //var copyLinkView:UIView!
    
    let space:CGFloat = 40.00
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
        let tap = UITapGestureRecognizer(target: self, action: "backButtonClikc:")
        self.addGestureRecognizer(tap)
        
        self.buttonView = UIView.init(frame: CGRect.init(x: 0, y: bounds.height, width: bounds.width, height: 170))
        self.buttonView.backgroundColor = UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        self.addSubview(self.buttonView)
        
        let cancelView = UIView.init(frame: CGRect.init(x: 0, y: self.buttonView.frame.height - 50, width: bounds.width, height: 50))
        cancelView.backgroundColor = UIColor.whiteColor()
        self.buttonView.addSubview(cancelView)
        let cancelButton:UIButton = UIButton.init()
        cancelButton.frame.size = cancelView.frame.size
        let cancelLabel = NSLocalizedString("AlertCancelLabel", comment: "")
        cancelButton.setTitle(cancelLabel, forState: .Normal)
        cancelButton.setTitleColor(UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0), forState: .Normal)
        cancelButton.addTarget(self, action: "cancelButtonClick:", forControlEvents: .TouchUpInside)
        cancelView.addSubview(cancelButton)
        
        self.wechatShareView = UIView.init(frame: CGRect.init(x: 0, y: 15, width: buttonW, height: buttonW))
        let wechatButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: buttonW, height: buttonW))
        wechatButton.setImage(UIImage.init(named: "wechat-share-button"), forState: .Normal)
        wechatButton.addTarget(self, action: "weChatButtonClick:", forControlEvents: .TouchUpInside)
        self.wechatShareView.addSubview(wechatButton)
        let wechatLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 20))
        wechatLabel.font = UIFont.systemFontOfSize(12)
        wechatLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        wechatLabel.text = NSLocalizedString("WechatShareLabel", comment: "")
        wechatLabel.sizeToFit()
        wechatLabel.center = CGPoint.init(x: wechatButton.center.x, y: buttonW+20)
        self.wechatShareView.addSubview(wechatLabel)
        self.wechatShareView.sizeToFit()
        self.wechatShareView.frame.origin.x = (bounds.width/2 - buttonW*3/2 - space) - (self.wechatShareView.frame.width - buttonW)/2
        self.buttonView.addSubview(self.wechatShareView)
        
        self.momentsShareView = UIView.init(frame: CGRect.init(x: 0, y: 15, width: buttonW, height: buttonW))
        let momentsButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: buttonW, height: buttonW))
        momentsButton.setImage(UIImage.init(named: "moments-share-button"), forState: .Normal)
        momentsButton.addTarget(self, action: "momentsButtonClick:", forControlEvents: .TouchUpInside)
        self.momentsShareView.addSubview(momentsButton)
        let momentsLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 20))
        momentsLabel.font = UIFont.systemFontOfSize(12)
        momentsLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        momentsLabel.text = NSLocalizedString("MomentsShareLabel", comment: "")
        momentsLabel.sizeToFit()
        momentsLabel.center = CGPoint.init(x: momentsButton.center.x, y: buttonW+20)
        self.momentsShareView.addSubview(momentsLabel)
        self.momentsShareView.sizeToFit()
        self.momentsShareView.frame.origin.x = (bounds.width/2 - buttonW/2) - (self.momentsShareView.frame.width - buttonW)/2
        self.buttonView.addSubview(self.momentsShareView)
        
        self.deleteView = UIView.init(frame: CGRect.init(x: 0, y: 15, width: buttonW, height: buttonW))
        let deleteButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: buttonW, height: buttonW))
        deleteButton.setImage(UIImage.init(named: "delete-file-button"), forState: .Normal)
        deleteButton.addTarget(self, action: "deleteButtonClick:", forControlEvents: .TouchUpInside)
        self.deleteView.addSubview(deleteButton)
        let deleteLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 20))
        deleteLabel.font = UIFont.systemFontOfSize(12)
        deleteLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        deleteLabel.text = NSLocalizedString("DeleteFileLabel", comment: "")
        deleteLabel.sizeToFit()
        deleteLabel.center = CGPoint.init(x: deleteButton.center.x, y: buttonW+20)
        self.deleteView.addSubview(deleteLabel)
        self.deleteView.sizeToFit()
        self.deleteView.frame.origin.x = (bounds.width/2 + space + buttonW/2) - (self.deleteView.frame.width - buttonW)/2
        self.buttonView.addSubview(self.deleteView)
        
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
            self.deleteView.hidden = false
            //self.copyLinkView.hidden = false
            self.wechatShareView.frame.origin.x = (bounds.width/2 - buttonW*3/2 - space) - (self.wechatShareView.frame.width - buttonW)/2
            self.momentsShareView.frame.origin.x = (bounds.width/2 - buttonW/2)  - (self.momentsShareView.frame.width - buttonW)/2
        }else {
            self.deleteView.hidden = true
            //self.copyLinkView.hidden = true
            self.wechatShareView.frame.origin.x = (bounds.width/2 - buttonW - space) - (self.wechatShareView.frame.width - buttonW)/2
            self.momentsShareView.frame.origin.x = (bounds.width/2 + space ) - (self.momentsShareView.frame.width - buttonW)/2
        }
        UIView.animateWithDuration(0.3) { () -> Void in
            self.buttonView.frame.origin.y = bounds.height - 170
            self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        }
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
    
    func copyLinkButtonClick(sender: UIButton){
        if self.delegate != nil {
            self.delegate!.copyLinkHandler()
        }
        self.cancelHandler()
    }
}

protocol CTAShareViewProtocol{
    func weChatShareHandler()
    func momentsShareHandler()
    func deleteHandler()
    func copyLinkHandler()
}