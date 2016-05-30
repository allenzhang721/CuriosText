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
    var moreButton:UIButton{get}
    var rebuildButton:UIButton{get}
    var userIconImage:UIImageView{get}
    var userNicknameLabel:UILabel{get}
    var publishDateLabel:UILabel{get}
    var publishModel:CTAPublishModel?{get}
    var userModel:CTAUserModel?{get}
    var publishCell:CTAFullPublishesCell{get}
    func initPublishSubView(publishRect:CGRect, horRate:CGFloat)
    func changePublishView(publishModel:CTAPublishModel)
    func changeDetailUser()
    
    func likeHandler(justLike:Bool)
    func setLikeButtonStyle()
    func moreSelectionHandler(isSelf:Bool)
    func rebuildHandler()
}

extension CTAPublishProtocol where Self: UIViewController{

    func initPublishSubView(publishRect:CGRect, horRate:CGFloat){
        let bounds = UIScreen.mainScreen().bounds
        var butY   =  bounds.height - 80 //publishRect.origin.y + publishRect.height + 20 + 10*horRate
        let originy = publishRect.origin.y + publishRect.height + 55  //bounds.height - 60
        if butY < originy{
            butY = originy
        }
        self.likeButton.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        self.likeButton.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2,y: butY)
        self.likeButton.setImage(UIImage.init(named: "like-button"), forState: .Normal)
        self.likeButton.setImage(UIImage.init(named: "like-highlighted-button"), forState: .Highlighted)
        self.likeButton.setImage(UIImage.init(named: "like-disable-button"), forState: .Disabled)
        self.view.addSubview(self.likeButton)

        self.moreButton.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        self.moreButton.setImage(UIImage.init(named: "moreSelection-button"), forState: .Normal)
        self.moreButton.setImage(UIImage.init(named: "moreSelection-selected-button"), forState: .Highlighted)
        self.moreButton.setImage(UIImage.init(named: "moreSelection-disable-button"), forState: .Disabled)
        self.moreButton.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2 + 100*horRate, y: butY)
        self.view.addSubview(self.moreButton)
        
        self.rebuildButton.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        self.rebuildButton.setImage(UIImage.init(named: "rebuild-button"), forState: .Normal)
        self.rebuildButton.setImage(UIImage.init(named: "rebuild-selected-button"), forState: .Highlighted)
        self.rebuildButton.setImage(UIImage.init(named: "rebuild-disable-button"), forState: .Disabled)
        self.rebuildButton.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2 - 100*horRate, y: butY)
        self.view.addSubview(self.rebuildButton)
        
        self.userIconImage.frame = CGRect.init(x: UIScreen.mainScreen().bounds.width/2, y: 9, width: 40*horRate, height: 40*horRate)
        self.userIconImage.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2, y: 35+self.userIconImage.frame.height/2)
        self.cropImageCircle(self.userIconImage)
        self.view.addSubview(self.userIconImage)
        self.userIconImage.userInteractionEnabled = true
        self.userIconImage.image = UIImage(named: "default-usericon")
        
        self.userNicknameLabel.frame = CGRect.init(x: 0, y: self.userIconImage.frame.origin.y + 50*horRate, width: 100, height: 25)
        if (self.userNicknameLabel.frame.origin.y + self.userNicknameLabel.frame.size.height) > publishRect.origin.y{
            self.userNicknameLabel.frame.origin.y = publishRect.origin.y - self.userNicknameLabel.frame.size.height
        }
        self.userNicknameLabel.font = UIFont.systemFontOfSize(16)
        self.userNicknameLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        self.view.addSubview(self.userNicknameLabel)
        
        self.publishDateLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 25)
        self.publishDateLabel.font = UIFont.systemFontOfSize(12)
        self.publishDateLabel.textColor = UIColor.init(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
        self.publishDateLabel.text = "Yesterday"
        self.publishDateLabel.sizeToFit()
        self.publishDateLabel.frame.origin.y = publishRect.origin.y + publishRect.size.height + 10
        self.publishDateLabel.frame.origin.x = publishRect.origin.x + publishRect.size.width - self.publishDateLabel.frame.size.width-10
        self.view.addSubview(self.publishDateLabel)
    }
    
    func changePublishView(publishModel:CTAPublishModel){
        let userModel = publishModel.userModel
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
        
        let publishDate = self.getPublishDate(publishModel.publishDate)
        self.publishDateLabel.text = publishDate
        self.publishDateLabel.sizeToFit()
        self.publishDateLabel.frame.origin.x = UIScreen.mainScreen().bounds.width - self.publishDateLabel.frame.size.width-10
        UIView.transitionWithView(self.userNicknameLabel, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            self.publishDateLabel.text = publishDate
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
    
    func getPublishDate(publishDate:NSDate) ->String{
        var time = publishDate.timeIntervalSinceNow
        if time < 0{
            time = 0-time
        }
        var dateString:String = ""
        if time < 60{
            dateString = NSLocalizedString("PublishDateJustNow", comment: "")
        }else if time < 3600{
            let mins = Int(time / 60)
            dateString = String(mins)+NSLocalizedString("PublishDateMins", comment: "")
        }else if time < 3600*2{
            dateString = NSLocalizedString("PublishDateOneHour", comment: "")
        }else if time < 86400{
            let hours = Int(time / 3600)
            dateString = String(hours)+NSLocalizedString("PublishDateHours", comment: "")
        }else if time < 86400 * 2{
            dateString = NSLocalizedString("PublishDateYesterDay", comment: "")
        }else if time < 86400*30{
            let days = Int(time / 86400)
            dateString = String(days)+NSLocalizedString("PublishDateDays", comment: "")
        }else if time < 86400*30*2{
            dateString = NSLocalizedString("PublishDateOneMonth", comment: "")
        }else if time < 86400*365{
            let months = Int(time / (86400*30))
            dateString = String(months)+NSLocalizedString("PublishDateMonths", comment: "")
        }else if time < 86400*365*2{
            dateString = NSLocalizedString("PublishDateOneYear", comment: "")
        }else{
            let years = Int(time / (86400*365))
            dateString = String(years)+NSLocalizedString("PublishDateYears", comment: "")
        }
        return dateString
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
    
    func likeHandler(justLike:Bool){
        let userID = self.userModel == nil ? "" : self.userModel!.userID
        if self.publishModel != nil {
            if self.publishModel!.likeStatus == 0{
                CTAPublishDomain.getInstance().likePublish(userID, publishID: self.publishModel!.publishID, compelecationBlock: { (info) -> Void in
                    if info.result {
                        self.publishModel!.likeStatus = 1
                        self.setLikeButtonStyle()
                        
                        // play heart animation
                        dispatch_async(dispatch_get_main_queue(), { 
                            let heartView = CTAHeartAnimationView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100)))
                            heartView.center = self.view.center
                            self.view.addSubview(heartView)
                            
                            heartView.playLikeAnimation(nil)
                        })
                    }
                })
            }else if !justLike{
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
        if isSelf{
            shareView.shareType = .loginUser
        }else {
            shareView.shareType = .normal
        }
        shareView.showViewHandler()
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
                self.exportGIF(publishID, page: page, gifType: .Normal, viewController: self as! UIViewController, completedHandler: { (fileURL, thumbImg) in
                    let message =  WXMediaMessage()
                    UIGraphicsBeginImageContext(CGSize(width: 160, height: 160))
                    thumbImg.drawInRect(CGRect(origin: CGPoint.zero, size: CGSize(width: 160, height: 160)))
                    let img = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                        
                    
                    message.setThumbImage(img)
                    
                    let ext =  WXEmoticonObject()
                    let data = NSData(contentsOfURL: fileURL)
                    ext.emoticonData = data
                    message.mediaObject = ext
                    
                    let req =  SendMessageToWXReq()
                    req.bText = false
                    req.message = message
                    req.scene = 0
                    let result = WXApi.sendReq(req)
                    if result {
                        let userID = self.userModel == nil ? "" : self.userModel!.userID
                        CTAPublishDomain.getInstance().sharePublish(userID, publishID: self.publishModel!.publishID, sharePlatform: 0, compelecationBlock: { (_) -> Void in
                        })
                    }else {
                        SVProgressHUD.showErrorWithStatus(NSLocalizedString("ShareErrorLabel", comment: ""))
                    }
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
                            }else {
                                SVProgressHUD.showErrorWithStatus(NSLocalizedString("ShareErrorLabel", comment: ""))
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
                        }else {
                            SVProgressHUD.showErrorWithStatus(NSLocalizedString("ShareErrorLabel", comment: ""))
                        }
                    }
                }
            })
        }else {
            self.showSingleAlert(NSLocalizedString("AlertTitleNoInstallWechat", comment: ""), alertMessage: "", compelecationBlock: nil)
        }
    }
    
    func weiBoShareHandler() {
        
        if CTASocialManager.isAppInstaller(.Weibo){
            if let userID = CTAUserManager.user?.userID where !userID.isEmpty, let token = CTASocialManager.needOAuthOrGetTokenByUserID(userID) {
                    self.shareWeiboWithToken(token)
            } else {
                if let userID = CTAUserManager.user?.userID where !userID.isEmpty {
                CTASocialManager.reOAuthWeiboGetAccessToken(userID, completed: { [weak self] (token, weiboID) in
                    guard let sf = self else { return }
                    if let token = token {
                        let time: NSTimeInterval = 1.0
                        let delay = dispatch_time(DISPATCH_TIME_NOW,Int64(time * Double(NSEC_PER_SEC)))
                        dispatch_after(delay, dispatch_get_main_queue()) {
                            sf.shareWeiboWithToken(token)
                        }
                    }
                    
                    if let weiboID = weiboID {
                        CTAUserManager.user?.weiboID = weiboID
                    }
                })
                }
            }
        }
    }
    
    private func shareWeiboWithToken(token: String) {
        if CTASocialManager.isAppInstaller(.Weibo){
            if let page = self.publishCell.getPage(){
                let publishID = self.publishModel!.publishID
                self.exportGIF(publishID, page: page, gifType: .Normal, viewController: self as! UIViewController, completedHandler: { [weak self] (fileURL, thumbImg) in
                    
                    guard let sf = self, let vc = sf as? UIViewController else {return}
                    
                    let weiboShare = ShareViewController.viewControllerWith(fileURL, completedHandler: nil, dismissHandler: nil)
                    
                    weiboShare.completedHandler = { (imageData, text) in
                        
                        let imageObject = WBImageObject()
                        imageObject.imageData = imageData
                        
                        let accessToken = token
                        SVProgressHUD.setDefaultMaskType(.Clear)
                        SVProgressHUD.showWithStatus(NSLocalizedString("SendProgressLabel", comment: ""))
                        WBHttpRequest(forShareAStatus: text, contatinsAPicture: imageObject, orPictureUrl: nil, withAccessToken: accessToken, andOtherProperties: nil, queue: nil, withCompletionHandler: { [weak weiboShare] (request, object, error) in
                            guard let w = weiboShare else { return }
                            if error == nil {
                                SVProgressHUD.showSuccessWithStatus(NSLocalizedString("ShareSuccessLabel", comment: ""))
                                dispatch_async(dispatch_get_main_queue(), {
                                    vc.dismissViewControllerAnimated(true, completion: nil)
                                })
                                if let sl = self{
                                    let userID = sl.userModel == nil ? "" : sl.userModel!.userID
                                    CTAPublishDomain.getInstance().sharePublish(userID, publishID: sl.publishModel!.publishID, sharePlatform: 2, compelecationBlock: { (_) -> Void in
                                    })
                                }
                            } else {
                                print(error)
                                SVProgressHUD.showErrorWithStatus(NSLocalizedString("ShareErrorLabel", comment: ""))
                                dispatch_async(dispatch_get_main_queue(), {
                                    w.sending = false
                                })
                            }
                        })
                    }
                    
                    
                    
                    weiboShare.dismissHandler = {
                        SVProgressHUD.dismiss()
                        dispatch_async(dispatch_get_main_queue(), {
                            vc.dismissViewControllerAnimated(true, completion: nil)
                        })
                    }
                    
                    vc.presentViewController(weiboShare, animated: true, completion: nil)
                    
                    
//                    let message = WBMessageObject.message() as! WBMessageObject
//                    message.imageObject = imageObject
////                    message.text = ""
//                    
//                    let request = WBSendMessageToWeiboRequest.requestWithMessage(message) as! WBSendMessageToWeiboRequest
//                    WeiboSDK.sendRequest(request)
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
                let reportType = index + 1
                let userID = self.userModel == nil ? "" : self.userModel!.userID
                CTAPublishDomain.getInstance().reportPublish(userID, publishID: self.publishModel!.publishID, reportType: reportType, reportMessage: "", compelecationBlock: { (_) -> Void in
                })
                SVProgressHUD.showSuccessWithStatus(NSLocalizedString("ReportSuccess", comment: ""))
            }
        }
    }
    
    func uploadResourceHandler(){
        let publishID = self.publishModel!.publishID
        if let page = publishCell.getPage(){
            self.exportGIF(publishID, page: page, gifType: .Big, viewController: self as! UIViewController, completedHandler: { (fileURL, thumbImg) in
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
                                    SVProgressHUD.showErrorWithStatus("Failed")
                                }
                        })
                    }else {
                        SVProgressHUD.showErrorWithStatus("Failed")
                    }
                }
            })
        }
    }
    
    func addToHotHandler(){
        let publishID = self.publishModel!.publishID
        CTAPublishDomain.getInstance().setPublishHot(publishID) { (info) in
            if info.result{
                SVProgressHUD.showSuccessWithStatus("Success")
            }else {
                SVProgressHUD.showErrorWithStatus("Failed")
            }
        }
    }
}
