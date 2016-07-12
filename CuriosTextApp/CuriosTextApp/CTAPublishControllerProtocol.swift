//
//  CTAPublishControllerProtocol.swift
//  CuriosTextApp
//
//  Created by allen on 16/6/30.
//  Copyright © 2016年 botai. All rights reserved.
//

import Foundation
import Kingfisher
import SVProgressHUD

protocol CTAPublishControllerProtocol: CTAEditViewControllerDelegate, CTAShareViewDelegate, CTAGIFProtocol, CTAAlertProtocol, UserListViewDelegate{
    var publishModel:CTAPublishModel?{get}
    var userModel:CTAUserModel?{get}
    var previewView:CTAPublishPreviewView?{get}
    
    func getViewFromRect(smallRect:CGRect, viewRect:CGRect) -> CGRect
    func likersHandelr()
    func likersRect() -> CGRect?
    func likeHandler(justLike:Bool)
    func setLikeButtonStyle(publichModel:CTAPublishModel?)
    func moreSelectionHandler(isSelf:Bool, isPopup:Bool)
    func rebuildHandler(isPopup:Bool)
    func commentHandler()
    func commentRect() -> CGRect?
}

extension CTAPublishControllerProtocol where Self: UIViewController{
    
    func likersHandelr(){
        let publishID = self.publishModel == nil ? "" : self.publishModel!.publishID
        let vc = Moduler.module_likers(publishID, delegate: self)
        let navi = UINavigationController(rootViewController: vc)
        let ani = CTAScaleTransition.getInstance()
        if let rect = self.likersRect() {
            let bound = UIScreen.mainScreen().bounds
            ani.fromRect = self.getViewFromRect(rect, viewRect: bound)
        }
        navi.transitioningDelegate = ani
        navi.modalPresentationStyle = .Custom
        self.presentViewController(navi, animated: true, completion: {
        })
    }
    
    func getViewFromRect(smallRect:CGRect, viewRect:CGRect) -> CGRect{
        let smallW = smallRect.width
        let smallH = smallRect.height
        let viewW = viewRect.width
        let viewH = viewRect.height
        
        var rate:CGFloat
        let imageRate = smallW / smallH
        let maxRate = viewW / viewH
        if maxRate > imageRate{
            rate = smallW / viewW
        }else {
            rate = smallH / viewH
        }
        
        let newRect = CGRect(x: smallRect.origin.x + (smallW-rate*viewW)/2, y: smallRect.origin.y + (smallH-rate*viewH)/2, width: rate*viewW, height: rate*viewH)
        return newRect
    }
    
    func likeHandler(justLike:Bool){
        let userID = self.userModel == nil ? "" : self.userModel!.userID
        if self.publishModel != nil {
            if self.publishModel!.likeStatus == 0{
                CTAPublishDomain.getInstance().likePublish(userID, publishID: self.publishModel!.publishID, compelecationBlock: { (info) -> Void in
                    if info.result {
                        self.publishModel!.likeStatus = 1
                        self.publishModel!.likeCount += 1
                        self.setLikeButtonStyle(self.publishModel)
                    }
                })
            }else {
                if !justLike{
                    CTAPublishDomain.getInstance().unLikePublish(userID, publishID: self.publishModel!.publishID, compelecationBlock: { (info) -> Void in
                        if info.result {
                            self.publishModel!.likeStatus = 0
                            self.publishModel!.likeCount -= 1
                            self.setLikeButtonStyle(self.publishModel)
                        }
                    })
                }else {
                    self.setLikeButtonStyle(self.publishModel)
                }
            }
        }
    }
    
    func commentHandler(){
        let publishID = self.publishModel == nil ? "" : self.publishModel!.publishID
        let vc = Moduler.module_comment(publishID)
        let navi = UINavigationController(rootViewController: vc)
        self.presentViewController(navi, animated: true, completion: {
        })
    }
    
    func moreSelectionHandler(isSelf:Bool, isPopup:Bool){
        let shareView = CTAShareView.getInstance()
        if isPopup{
            self.view.addSubview(shareView)
        }else {
            NSNotificationCenter.defaultCenter().postNotificationName("addViewInRoot", object: shareView)
        }
        shareView.delegate = self
        if isSelf{
            shareView.shareType = .loginUser
        }else {
            shareView.shareType = .normal
        }
        shareView.showViewHandler()
    }
    
    func rebuildHandler(isPopup:Bool) {
        if let model = self.publishModel{
            self.rebuildHandlerWith(model, isPopup: isPopup)
        }
    }
    
    func rebuildHandlerWith(publishModel: CTAPublishModel? = nil, isPopup:Bool? = nil){
        if let publishModel = publishModel, let isPopup = isPopup {
            
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
                                                if let oldPublish = slf.publishModel{
                                                    oldPublish.rebuildCount += 1
                                                }
                                            })
                                            
                                            if isPopup{
                                                slf.presentViewController(editNaviVC, animated: true, completion: { () -> Void in
                                                })
                                            }else {
                                                NSNotificationCenter.defaultCenter().postNotificationName("popupViewControllerInRoot", object: editNaviVC)
                                            }
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

extension CTAPublishControllerProtocol{
    
    func EditControllerDidPublished(viewController: EditViewController){
        NSNotificationCenter.defaultCenter().postNotificationName("publishEditFile", object: nil)
    }
}

extension CTAPublishControllerProtocol{
    
    func weChatShareHandler(){
        if self.previewView != nil {
            if CTASocialManager.isAppInstaller(.WeChat){
                if let page = self.previewView!.getPage(){
                    let publishID = self.publishModel!.publishID
                    self.exportGIF(publishID, page: page, gifType: .Small, viewController: self as! UIViewController, completedHandler: { (fileURL, thumbImg) in
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
                                if let oldPublish = self.publishModel{
                                    oldPublish.shareCount += 1
                                }
                            })
                        }else {
                            SVProgressHUD.showErrorWithStatus(NSLocalizedString("ShareErrorLabel", comment: ""))
                        }
                    })
                }else {
                    self.previewView!.getPublishImg({ (img) -> () in
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
                                        if let oldPublish = self.publishModel{
                                            oldPublish.shareCount += 1
                                        }
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
    }
    
    func momentsShareHandler(){
        if self.previewView != nil {
            if CTASocialManager.isAppInstaller(.WeChat){
                self.previewView!.getPublishImg({ (img) -> () in
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
                                    if let oldPublish = self.publishModel{
                                        oldPublish.shareCount += 1
                                    }
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
    }
    
    func weiBoShareHandler() {
        if self.previewView != nil {
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
    }
    
    private func shareWeiboWithToken(token: String) {
        if CTASocialManager.isAppInstaller(.Weibo){
            if let page = self.previewView!.getPage(){
                let publishID = self.publishModel!.publishID
                self.exportGIF(publishID, page: page, gifType: .Big, viewController: self as! UIViewController, completedHandler: { [weak self] (fileURL, thumbImg) in
                    
                    guard let sf = self, let vc = sf as? UIViewController else {return}
                    
                    let weiboShare = ShareViewController.viewControllerWith(fileURL, completedHandler: nil, dismissHandler: nil)
                    
                    weiboShare.completedHandler = { (imageData, text) in
                        
                        let imageObject = WBImageObject()
                        imageObject.imageData = imageData
                        var shareURL = CTAShareConfig.shareURL
                        shareURL = shareURL+"?sto=weibo&sfrom=message"
                        if let info = NSBundle.mainBundle().infoDictionary {
                            let appVersion = info["CFBundleShortVersionString"] as! String
                            shareURL = shareURL+"&v="+appVersion
                        }
                        if let s = self{
                            if s.userModel != nil {
                                let userID = s.userModel!.userID
                                shareURL = shareURL+"&uid="+userID
                            }
                            let publishID = s.publishModel!.publishID
                            shareURL = shareURL+"&pid="+publishID
                        }
                        
                        let weiboMessage = text+" "+shareURL
                        let accessToken = token
                        SVProgressHUD.setDefaultMaskType(.Clear)
                        SVProgressHUD.showWithStatus(NSLocalizedString("SendProgressLabel", comment: ""))
                        WBHttpRequest(forShareAStatus: weiboMessage, contatinsAPicture: imageObject, orPictureUrl: nil, withAccessToken: accessToken, andOtherProperties: nil, queue: nil, withCompletionHandler: { [weak weiboShare] (request, object, error) in
                            guard let w = weiboShare else { return }
                            if error == nil {
                                SVProgressHUD.showSuccessWithStatus(NSLocalizedString("ShareSuccessLabel", comment: ""))
                                dispatch_async(dispatch_get_main_queue(), {
                                    vc.dismissViewControllerAnimated(true, completion: nil)
                                })
                                if let sl = self{
                                    let userID = sl.userModel == nil ? "" : sl.userModel!.userID
                                    CTAPublishDomain.getInstance().sharePublish(userID, publishID: sl.publishModel!.publishID, sharePlatform: 2, compelecationBlock: { (_) -> Void in
                                        if let oldPublish = sl.publishModel{
                                            oldPublish.shareCount += 1
                                        }
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
        if self.previewView != nil {
            self.previewView!.getPublishImg{ (img) -> () in
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
    }
    
    func reportHandler(){
        var alertArray:Array<[String: AnyObject]> = []
        
        alertArray.append(["title": LocalStrings.Porn.description])
        alertArray.append(["title": LocalStrings.Scam.description])
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
        if self.previewView != nil {
            let publishID = self.publishModel!.publishID
            if let page = self.previewView!.getPage(){
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

extension CTAPublishControllerProtocol{
    
    func getDismisRect(type:UserListType) -> CGRect?{
        if let rect = self.likersRect(){
            let bound = UIScreen.mainScreen().bounds
            return self.getViewFromRect(rect, viewRect: bound)
        }else {
            return nil
        }
    }
    
    func disMisComplete(type:UserListType){
        
    }
    
}