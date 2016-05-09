//
//  CTAPublishProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/29.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation
import Kingfisher

import SVProgressHUD

protocol CTAPublishProtocol:CTAImageControllerProtocol, CTAAlertProtocol, CTAShareViewDelegate,CTAEditViewControllerDelegate, CTALoadingProtocol, CTAGIFProtocol{
    var likeButton:UIButton{get}
    var userIconImage:UIImageView{get}
    var userNicknameLabel:UILabel{get}
    var publishModel:CTAPublishModel?{get}
    var userModel:CTAUserModel?{get}
    var publishCell:CTAFullPublishesCell{get}
    func initPublishSubView(publishRect:CGRect, horRate:CGFloat)
    func changeUserView(userModel:CTAUserModel)
    func changeDetailUser()
    
    func likeHandler()
    
    func setLikeButtonStyle()
    func likeButtonClick(sender: UIButton)
    
    func moreSelectionHandler(isSelf:Bool)
    func moreButtonClick(sender: UIButton)
    
    func rebuildHandler()
    func rebuildButtonClick(sender: UIButton)
    
    func userIconClick(sender: UIPanGestureRecognizer)
}

extension CTAPublishProtocol where Self: UIViewController{

    func initPublishSubView(publishRect:CGRect, horRate:CGFloat){
        let bounds = UIScreen.mainScreen().bounds
        var butY   =  bounds.height - 80 //publishRect.origin.y + publishRect.height + 20 + 10*horRate
        let originy = publishRect.origin.y + publishRect.height + 20 + 10*horRate //bounds.height - 60
        if butY < originy{
            butY = originy
        }
        self.likeButton.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        self.likeButton.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2 - 100*horRate,y: butY)
        self.likeButton.setImage(UIImage.init(named: "like-button"), forState: .Normal)
        self.likeButton.setImage(UIImage.init(named: "like-highlighted-button"), forState: .Highlighted)
        self.likeButton.setImage(UIImage.init(named: "like-disable-button"), forState: .Disabled)
        self.view.addSubview(self.likeButton)
        self.likeButton.addTarget(self, action: "likeButtonClick:", forControlEvents: .TouchUpInside)
        
        let moreButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        moreButton.setImage(UIImage.init(named: "moreSelection-button"), forState: .Normal)
        moreButton.setImage(UIImage.init(named: "moreSelection-selected-button"), forState: .Highlighted)
        moreButton.setImage(UIImage.init(named: "moreSelection-disable-button"), forState: .Disabled)
        moreButton.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2 + 100*horRate, y: butY)
        self.view.addSubview(moreButton)
        moreButton.addTarget(self, action: "moreButtonClick:", forControlEvents: .TouchUpInside)
        
        let rebuildButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        rebuildButton.setImage(UIImage.init(named: "rebuild-button"), forState: .Normal)
        rebuildButton.setImage(UIImage.init(named: "rebuild-selected-button"), forState: .Highlighted)
        rebuildButton.setImage(UIImage.init(named: "rebuild-disable-button"), forState: .Disabled)
        rebuildButton.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2, y: butY)
        self.view.addSubview(rebuildButton)
        rebuildButton.addTarget(self, action: "rebuildButtonClick:", forControlEvents: .TouchUpInside)
        
        self.userIconImage.frame = CGRect.init(x: UIScreen.mainScreen().bounds.width/2, y: 9, width: 40, height: 40)
        self.userIconImage.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2, y: publishRect.origin.y - 20 - 65*horRate)
        if self.userIconImage.frame.origin.y < 5 {
            self.userIconImage.frame.origin.y = 5
        }
        self.cropImageCircle(self.userIconImage)
        self.view.addSubview(self.userIconImage)
        self.userIconImage.userInteractionEnabled = true
        let iconTap = UITapGestureRecognizer(target: self, action: Selector("userIconClick:"))
        self.userIconImage.addGestureRecognizer(iconTap)
        self.userIconImage.image = UIImage(named: "default-usericon")
        
        self.userNicknameLabel.frame = CGRect.init(x: 0, y: 0, width: 100, height: 25)
        self.userNicknameLabel.center = CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: self.userIconImage.center.y + 32 + 10*horRate)
        if (self.userNicknameLabel.frame.origin.y + self.userNicknameLabel.frame.size.height) > publishRect.origin.y{
            self.userNicknameLabel.frame.origin.y = publishRect.origin.y - self.userNicknameLabel.frame.size.height
        }
        self.userNicknameLabel.font = UIFont.systemFontOfSize(16)
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
        UIView.transitionWithView(self.userNicknameLabel, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            self.userNicknameLabel.text = userModel.nickName
            }) { (_) in
        }
        
        UIView.transitionWithView(self.userIconImage, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            let defaultImg = UIImage.init(named: "default-usericon")
            let imagePath = CTAFilePath.userFilePath+userModel.userIconURL
            let imageURL = NSURL(string: imagePath)!
            self.userIconImage.kf_setImageWithURL(imageURL, placeholderImage: defaultImg, optionsInfo: [.Transition(ImageTransition.Fade(1))]){ (image, error, cacheType, imageURL) -> () in
                if error != nil {
                    self.userIconImage.image = defaultImg
                }
            }
            }) { (_) in
        }
        
        
    }
    
    func changeDetailUser(){
        self.userNicknameLabel.text = NSLocalizedString("DefaultName", comment: "")
        self.userNicknameLabel.sizeToFit()
        let maxWidth = UIScreen.mainScreen().bounds.width - 100
        var labelWidth = self.userNicknameLabel.frame.width
        if self.userNicknameLabel.frame.width > maxWidth {
            labelWidth = maxWidth
        }
        self.userNicknameLabel.frame.size.width = labelWidth
        self.userNicknameLabel.frame.origin.x = (UIScreen.mainScreen().bounds.width - labelWidth)/2
        self.userIconImage.image = UIImage.init(named: "default-usericon")
    }
    
    func likeHandler(){
        let userID = self.userModel == nil ? "" : self.userModel!.userID
        if self.publishModel != nil {
            if self.publishModel!.likeStatus == 0{
                CTAPublishDomain.getInstance().likePublish(userID, publishID: self.publishModel!.publishID, compelecationBlock: { (info) -> Void in
                    if info.result {
                        self.publishModel!.likeStatus = 1
                        self.setLikeButtonStyle()
                    }
                })
            }else {
                CTAPublishDomain.getInstance().unLikePublish(userID, publishID: self.publishModel!.publishID, compelecationBlock: { (info) -> Void in
                    if info.result {
                        self.publishModel!.likeStatus = 0
                        self.setLikeButtonStyle()
                    }
                })
            }
        }
    }
    
    func setLikeButtonStyle(){
        if let model = self.publishModel{
            if model.likeStatus == 0{
                self.likeButton.setImage(UIImage.init(named: "like-button"), forState: .Normal)
                self.likeButton.setImage(UIImage.init(named: "like-highlighted-button"), forState: .Highlighted)
            }else {
                self.likeButton.setImage(UIImage.init(named: "like-selected-button"), forState: .Normal)
                self.likeButton.setImage(UIImage.init(named: "like-selected-button"), forState: .Highlighted)
            }
        }
    }
    
    func moreSelectionHandler(isSelf:Bool){
        let shareView = CTAShareView.getInstance()
        shareView.delegate = self
        let mainController = CTAMainViewController.getInstance()
        if self.view.isDescendantOfView(mainController.view){
            mainController.view.addSubview(shareView)
        }else {
            self.view.superview?.addSubview(shareView)
        }
        shareView.showViewHandler(isSelf)
    }
    
    func rebuildHandler() {
        if let model = self.publishModel{ 
            let mainController = CTAMainViewController.getInstance()
            var rootController:UIViewController?
            if self.view.isDescendantOfView(mainController.view){
                rootController = mainController
            }else {
                rootController = self
            }
            self.rebuildHandlerWith(model, rootController: rootController)
        }
    }
    
    func rebuildHandlerWith(publishModel: CTAPublishModel? = nil, rootController: UIViewController? = nil){
        if let publishModel = publishModel, let rootController = rootController {
            
            let purl = CTAFilePath.publishFilePath
            let url = purl + publishModel.publishURL
            
            BlackCatManager.sharedManager.retrieveDataWithURL(NSURL(string: url)!, optionsInfo: nil, progressBlock: nil, completionHandler: {[weak self] (data, error, cacheType, URL) in
                
                if let slf = self {
                    if let data = data,
                        let apage = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? CTAPage {
                        apage.removeLastImageContainer()
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            let page = apage
                            let documentURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
                            let fileUrl = CTADocumentManager.generateDocumentURL(documentURL)
                            CTADocumentManager.createNewDocumentAt(fileUrl, page: page) { (success) -> Void in
                                
                                if success {
                                    CTADocumentManager.openDocument(fileUrl, completedBlock: { (success) -> Void in
                                        
                                        if let openDocument = CTADocumentManager.openedDocument {
                                            
                                            let editNaviVC = UIStoryboard(name: "Editor", bundle: nil).instantiateViewControllerWithIdentifier("EditorNavigationController") as! UINavigationController
                                            
                                            let editVC = editNaviVC.topViewController as! EditViewController
                                            
                                            editVC.document = openDocument
                                            editVC.delegate = slf
                                            let userID = slf.userModel == nil ? "" : slf.userModel!.userID
                                            CTAPublishDomain.getInstance().rebuildPublish(userID, publishID: slf.publishModel!.publishID, compelecationBlock: { (_) -> Void in
                                            })
                                            rootController.presentViewController(editNaviVC, animated: true, completion: { () -> Void in
                                            })
                                        }
                                    })
                                }
                            }
                            
                        })
                    }
                }
                })
        }
    }
}

extension CTAPublishProtocol{
    
    func EditControllerDidPublished(viewController: EditViewController){
        NSNotificationCenter.defaultCenter().postNotificationName("publishEditFile", object: nil)
    }
}

extension CTAPublishProtocol{
    
    func weChatShareHandler(){
        
        if CTASocialManager.isAppInstaller(.WeChat){
            if let page = publishCell.getPage(){
                let publishID = self.publishModel!.publishID
                self.exportGIF(publishID, page: page, viewController: self as! UIViewController, completedHandler: { (fileURL, thumbImg) in
                    let message =  WXMediaMessage()
                    message.setThumbImage(thumbImg)
                    
                    let ext =  WXEmoticonObject()
                    let filePath = fileURL.path
                    ext.emoticonData = NSData(contentsOfFile:filePath!)
                    message.mediaObject = ext
                    
                    let req =  SendMessageToWXReq()
                    req.bText = false
                    req.message = message
                    req.scene = 0
                    WXApi.sendReq(req)
                })
            }else {
                self.publishCell.getEndImg({ (img) -> () in
                    if let image = img{
                        let thumb = compressImage(image, maxWidth: image.size.width/2)
                        let message = CTASocialManager.Message
                            .WeChat(
                                .Session(
                                    info: (
                                        title: "",
                                        description: "",
                                        thumbnail: thumb,
                                        media: .Image(img!)
                                    )
                                )
                        )
                        CTASocialManager.shareMessage(message) { (result) -> Void in
                            if result{
                                let userID = self.userModel == nil ? "" : self.userModel!.userID
                                CTAPublishDomain.getInstance().sharePublish(userID, publishID: self.publishModel!.publishID, sharePlatform: 0, compelecationBlock: { (_) -> Void in
                                })
                            }
                        }
                    }
                })
            }
        }else {
            self.showSingleAlert(NSLocalizedString("AlertTitleNoInstallWechat", comment: ""), alertMessage: "", compelecationBlock: nil)
        }
    }
    
    func momentsShareHandler(){
        if CTASocialManager.isAppInstaller(.WeChat){
            self.publishCell.getEndImg({ (img) -> () in
                if let image = img{
                    let thumb = compressImage(image, maxWidth: image.size.width/2)
                    let message = CTASocialManager.Message
                        .WeChat(
                            .Timeline(
                                info: (
                                    title: "",
                                    description: "",
                                    thumbnail: thumb,
                                    media: .Image(img!)
                                )
                            )
                    )
                    CTASocialManager.shareMessage(message) { (result) -> Void in
                        if result{
                            let userID = self.userModel == nil ? "" : self.userModel!.userID
                            CTAPublishDomain.getInstance().sharePublish(userID, publishID: self.publishModel!.publishID, sharePlatform: 1, compelecationBlock: { (_) -> Void in
                            })
                        }
                    }
                }
            })
        }else {
            self.showSingleAlert(NSLocalizedString("AlertTitleNoInstallWechat", comment: ""), alertMessage: "", compelecationBlock: nil)
        }
    }
    
    func weiBoShareHandler() {
//        let accessToken = "2.00QCIVlBCQBJcBd5c647a60bDuIS2C"
//        let userID = self.publishModel!.userModel.weiboID
        debug_print(CTAUserManager.user?.weiboID)
        
        if CTASocialManager.isAppInstaller(.Weibo){
            if let weiboID = CTAUserManager.user?.weiboID where !weiboID.isEmpty, let token = CTASocialManager.needOAuthOrGetTokenByUserID(weiboID) {
                debug_print("has token = \(token), userID = \(weiboID)")
                self.shareWeiboWithToken(token)
                
            } else {
                
                CTASocialManager.reOAuthWeiboGetAccessToken({ [weak self] (token, weiboID) in
                    guard let sf = self else { return }
                    if let token = token {
                       debug_print("re oauth token = \(token)")
                        sf.shareWeiboWithToken(token)
                    }
                    
                    if let weiboID = weiboID {
                        CTAUserManager.user?.weiboID = weiboID
                    }
                    
                    
                })
            }
        }
    }
    
    private func shareWeiboWithToken(token: String) {
        if CTASocialManager.isAppInstaller(.Weibo){
            if let page = self.publishCell.getPage(){
                let publishID = self.publishModel!.publishID
                self.exportGIF(publishID, page: page, viewController: self as! UIViewController, completedHandler: { (fileURL, thumbImg) in
                    
                    let imageObject = WBImageObject()
                    imageObject.imageData = NSData(contentsOfURL: fileURL)
                    
                    let accessToken = token
                    let _ = WBHttpRequest(forShareAStatus: "send from Curios", contatinsAPicture: imageObject, orPictureUrl: nil, withAccessToken: accessToken, andOtherProperties: nil, queue: nil, withCompletionHandler: { (request, object, error) in
                        
                        debug_print(object)
                    })
                })
            }
        }else {
            self.showSingleAlert(NSLocalizedString("AlertTitleNoInstallWeibo", comment: ""), alertMessage: "", compelecationBlock: nil)
        }
    }
    
    func deleteHandler(){
        
    }
    
    func copyLinkHandler(){
       
    }
    
    func saveLocalHandler(){
        self.publishCell.getEndImg { (img) -> () in
            if img != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    photo_saveImageToLibrary(img!,finishedHandler: { (status) -> () in
                        
                        switch status {
                        case .Success:
                            SVProgressHUD.setDefaultStyle(.Dark)
                            SVProgressHUD.showSuccessWithStatus(NSLocalizedString("SavePhotoSuccess", comment: ""))
                        case .Authorized(let alert):
                            (self as! UIViewController).presentViewController(alert, animated: true, completion: nil)
                        case .Failture:
                            ()
                        }
                        
                    })
                })
            }
        }
    }
    
    func reportHandler(){
        var alertArray:Array<String> = []
        
        alertArray.append(LocalStrings.Porn.description)
        alertArray.append(LocalStrings.Scam.description)
        //alertArray.append(LocalStrings.Sensitive.description)
        self.showSheetAlert(nil, okAlertArray: alertArray, cancelAlertLabel: LocalStrings.Cancel.description) { (index) -> Void in
            if index != -1{
                let userID = self.userModel == nil ? "" : self.userModel!.userID
                let reportType = index + 1
                CTAPublishDomain.getInstance().reportPublish(userID, publishID: self.publishModel!.publishID, reportType: reportType, reportMessage: "", compelecationBlock: { (_) -> Void in
                })
                SVProgressHUD.setDefaultStyle(.Dark)
                SVProgressHUD.showSuccessWithStatus(NSLocalizedString("ReportSuccess", comment: ""))
            }
        }
    }
    
    func uploadResourceHandler(){
        let publishID = self.publishModel!.publishID
        if let page = publishCell.getPage(){
            self.exportGIF(publishID, page: page, viewController: self as! UIViewController, completedHandler: { (fileURL, thumbImg) in
                let imageName = CTAIDGenerator.fileID()
                let publishResouceKey = publishID+"/"+imageName+".gif"
                let uptoken = CTAUpTokenModel.init(upTokenKey: publishResouceKey)
                CTAUpTokenDomain.getInstance().resourceUpToken([uptoken]) { (listInfo) in
                    if listInfo.result {
                        let newToken = listInfo.modelArray![0] as! CTAUpTokenModel
                        let filePath = fileURL.path
                        let uploadModel = CTAUploadModel(key: publishResouceKey, token: newToken.upToken, filePath: filePath!)
                        CTAUploadAction.getInstance().uploadFile(publishID, uploadModel: uploadModel, progress: { (_) -> Void in
                            }, complete: { (info) -> Void in
                                if info.result{
                                    let filePath = CTAFilePath.resourceFilePath + publishResouceKey
                                    self.showSingleAlert(filePath, alertMessage: "", compelecationBlock: { () -> Void in
                                    })
                                }else {
                                    self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                                    })
                                }
                        })
                    }else {
                        self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                        })
                    }
                }
            })
        }
    }
}
