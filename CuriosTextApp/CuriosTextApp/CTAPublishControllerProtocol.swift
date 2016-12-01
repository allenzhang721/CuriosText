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

protocol CTAPublishControllerProtocol: CTAEditViewControllerDelegate, CTAShareViewDelegate, CTAGIFProtocol, CTAAlertProtocol, UserListViewDelegate, CommentViewDelegate{
    var publishModel:CTAPublishModel?{get}
    var userModel:CTAUserModel?{get}
    var previewView:CTAPublishPreviewView?{get}
    
    func getViewFromRect(_ smallRect:CGRect, viewRect:CGRect) -> CGRect
    func likersHandelr()
    func likersRect() -> CGRect?
    func likeHandler(_ justLike:Bool)
    func setLikeButtonStyle(_ publichModel:CTAPublishModel?)
    func moreSelectionHandler(_ isSelf:Bool, isPopup:Bool)
    func rebuildHandler(_ isPopup:Bool)
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
            let bound = UIScreen.main.bounds
            ani.fromRect = self.getViewFromRect(rect, viewRect: bound)
        }
        navi.transitioningDelegate = ani
        navi.modalPresentationStyle = .custom
        self.present(navi, animated: true, completion: {
        })
    }
    
    func getViewFromRect(_ smallRect:CGRect, viewRect:CGRect) -> CGRect{
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
    
    func likeHandler(_ justLike:Bool){
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
        let userID = self.userModel == nil ? "" : self.userModel!.userID
        let vc = Moduler.module_comment(publishID, userID: userID, delegate: self)
        let navi = UINavigationController(rootViewController: vc)
        let ani = CTAScaleTransition.getInstance()
        if let rect = self.commentRect() {
            let bound = UIScreen.main.bounds
            ani.fromRect = self.getViewFromRect(rect, viewRect: bound)
        }
        navi.transitioningDelegate = ani
        navi.modalPresentationStyle = .custom
        self.present(navi, animated: true, completion: {
        })
    }
    
    func moreSelectionHandler(_ isSelf:Bool, isPopup:Bool){
        let shareView = CTAShareView.getInstance()
        if isPopup{
            self.view.addSubview(shareView)
        }else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "addViewInRoot"), object: shareView)
        }
        shareView.delegate = self
        if isSelf{
            shareView.shareType = .loginUser
        }else {
            shareView.shareType = .normal
        }
        shareView.showViewHandler()
    }
    
    func rebuildHandler(_ isPopup:Bool) {
        if let model = self.publishModel{
            self.rebuildHandlerWith(model, isPopup: isPopup)
        }
    }
    
    func rebuildHandlerWith(_ publishModel: CTAPublishModel? = nil, isPopup:Bool? = nil){
        if let publishModel = publishModel, let isPopup = isPopup {
            
            let purl = CTAFilePath.publishFilePath
            let url = purl + publishModel.publishURL

            BlackCatManager.sharedManager.retrieveDataWithURL(URL(string: url)!, optionsInfo: nil, progressBlock: nil, completionHandler: {[weak self] (data, error, cacheType, URL) in
                
                if let slf = self {
                    if let data = data,
                        let apage = NSKeyedUnarchiver.unarchiveObject(with: data) as? CTAPage {
                        apage.removeLastImageContainer()
                        DispatchQueue.main.async(execute: {
                            
                            let page = apage
                            let documentURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                            let fileUrl = CTADocumentManager.generateDocumentURL(documentURL)
                            CTADocumentManager.createNewDocumentAt(fileUrl, page: page) { (success) -> Void in
                                
                                if success {
                                    CTADocumentManager.openDocument(fileUrl, completedBlock: { (success) -> Void in
                                        
                                        if let openDocument = CTADocumentManager.openedDocument {
                                            
                                            let editNaviVC = UIStoryboard(name: "Editor", bundle: nil).instantiateViewController(withIdentifier: "EditorNavigationController") as! UINavigationController
                                            
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
                                                NotificationCenter.default.post(name: Notification.Name(rawValue: "popupViewControllerInRoot"), object: [editNaviVC, slf])
                                            }else {
                                                NotificationCenter.default.post(name: Notification.Name(rawValue: "popupViewControllerInRoot"), object: [editNaviVC])
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
    
    func EditControllerDidPublished(_ viewController: EditViewController){
        NotificationCenter.default.post(name: Notification.Name(rawValue: "publishEditFile"), object: nil)
    }
}

extension CTAPublishControllerProtocol{
    
    func weChatShareHandler(){
        if self.previewView != nil {
            if CTASocialManager.isAppInstaller(.weChat){
                if let page = self.previewView!.getPage(){
                    let publishID = self.publishModel!.publishID
                    self.exportGIF(publishID, page: page, gifType: .Small, viewController: self as! UIViewController, completedHandler: { (fileURL, thumbImg) in
                        let message =  WXMediaMessage()
                        UIGraphicsBeginImageContext(CGSize(width: 160, height: 160))
                        thumbImg.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: 160, height: 160)))
                        let img = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                        message.setThumbImage(img)
                        
                        let ext =  WXEmoticonObject()
                        let data = try? Data(contentsOf: fileURL)
                        ext.emoticonData = data
                        message.mediaObject = ext
                        
                        let req =  SendMessageToWXReq()
                        req.bText = false
                        req.message = message
                        req.scene = 0
                        let result = WXApi.send(req)
                        if result {
                            let userID = self.userModel == nil ? "" : self.userModel!.userID
                            CTAPublishDomain.getInstance().sharePublish(userID, publishID: self.publishModel!.publishID, sharePlatform: 0, compelecationBlock: { (_) -> Void in
                                if let oldPublish = self.publishModel{
                                    oldPublish.shareCount += 1
                                }
                            })
                        }else {
                            SVProgressHUD.showError(withStatus: NSLocalizedString("ShareErrorLabel", comment: ""))
                        }
                    })
                }else {
                    self.previewView!.getPublishImg({ (img) -> () in
                        if let image = img{
                            let thumb = compressImage(image, maxWidth: image.size.width/2)
                            let message = CTASocialManager.Message
                                .weChat(
                                    .session(
                                        info: (
                                            title: "",
                                            description: "",
                                            thumbnail: thumb,
                                            media: .image(img!)
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
                                    SVProgressHUD.showError(withStatus: NSLocalizedString("ShareErrorLabel", comment: ""))
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
            if CTASocialManager.isAppInstaller(.weChat){
                self.previewView!.getPublishImg({ (img) -> () in
                    if let image = img{
                        let thumb = compressImage(image, maxWidth: image.size.width/2)
                        let message = CTASocialManager.Message
                            .weChat(
                                .timeline(
                                    info: (
                                        title: "",
                                        description: "",
                                        thumbnail: thumb,
                                        media: .image(img!)
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
                                SVProgressHUD.showError(withStatus: NSLocalizedString("ShareErrorLabel", comment: ""))
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
            if CTASocialManager.isAppInstaller(.weibo){
                if let userID = CTAUserManager.user?.userID, !userID.isEmpty, let token = CTASocialManager.needOAuthOrGetTokenByUserID(userID) {
                    self.shareWeiboWithToken(token)
                } else {
                    if let userID = CTAUserManager.user?.userID, !userID.isEmpty {
                        CTASocialManager.reOAuthWeiboGetAccessToken(userID, completed: { [weak self] (token, weiboID) in
                            guard let sf = self else { return }
                            if let token = token {
                                let time: TimeInterval = 1.0
                                let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                DispatchQueue.main.asyncAfter(deadline: delay) {
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
    
    fileprivate func shareWeiboWithToken(_ token: String) {
        if CTASocialManager.isAppInstaller(.weibo){
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
                        if let info = Bundle.main.infoDictionary {
                            let appVersion = info["CFBundleShortVersionString"] as! String
                            shareURL = shareURL+"&v="+appVersion
                        }
                        if let s = self{
                            if s.userModel != nil {
                                let userID = s.userModel!.userID
                                shareURL = shareURL+"&uid="+userID
                            }
                            shareURL = shareURL+"&pid="+publishID
                        }
                        
                        let weiboMessage = text+" "+shareURL
                        let accessToken = token
                        SVProgressHUD.setDefaultMaskType(.clear)
                        SVProgressHUD.show(withStatus: NSLocalizedString("SendProgressLabel", comment: ""))
                        WBHttpRequest(forShareAStatus: weiboMessage, contatinsAPicture: imageObject, orPictureUrl: nil, withAccessToken: accessToken, andOtherProperties: nil, queue: nil, withCompletionHandler: { [weak weiboShare] (request, object, error) in
                            guard let w = weiboShare else { return }
                            if error == nil {
                                SVProgressHUD.showSuccess(withStatus: NSLocalizedString("ShareSuccessLabel", comment: ""))
                                DispatchQueue.main.async(execute: {
                                    vc.dismiss(animated: true, completion: nil)
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
                                SVProgressHUD.showError(withStatus: NSLocalizedString("ShareErrorLabel", comment: ""))
                                DispatchQueue.main.async(execute: {
                                    w.sending = false
                                })
                            }
                            })
                    }
                    
                    
                    
                    weiboShare.dismissHandler = {
                        SVProgressHUD.dismiss()
                        DispatchQueue.main.async(execute: {
                            vc.dismiss(animated: true, completion: nil)
                        })
                    }
                    
                    vc.present(weiboShare, animated: true, completion: nil)
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
                    DispatchQueue.main.async(execute: { () -> Void in
                        photo_saveImageToLibrary(img!,finishedHandler: { (status) -> () in
                            
                            switch status {
                            case .success:
                                SVProgressHUD.showSuccess(withStatus: NSLocalizedString("SavePhotoSuccess", comment: ""))
                            case .authorized(let alert):
                                (self as! UIViewController).present(alert, animated: true, completion: nil)
                            case .failture:
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
        
        alertArray.append(["title": LocalStrings.porn.description as AnyObject])
        alertArray.append(["title": LocalStrings.scam.description as AnyObject])
        //alertArray.append(LocalStrings.Sensitive.description)
        self.showSheetAlert(nil, okAlertArray: alertArray, cancelAlertLabel: LocalStrings.cancel.description) { (index) -> Void in
            if index != -1{
                let reportType = index + 1
                let userID = self.userModel == nil ? "" : self.userModel!.userID
                CTAPublishDomain.getInstance().reportPublish(userID, publishID: self.publishModel!.publishID, reportType: reportType, reportMessage: "", compelecationBlock: { (_) -> Void in
                })
                SVProgressHUD.showSuccess(withStatus: NSLocalizedString("ReportSuccess", comment: ""))
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
                            let uploadModel = CTAUploadModel(key: publishResouceKey, token: newToken.upToken, filePath: filePath)
                            CTAUploadAction.getInstance().uploadFile(publishID, uploadModel: uploadModel, progress: { (_) -> Void in
                                }, complete: { (info) -> Void in
                                    if info.result{
                                        let filePath = CTAFilePath.resourceFilePath + publishResouceKey
                                        self.showSingleAlert(filePath, alertMessage: "", compelecationBlock: { () -> Void in
                                        })
                                    }else {
                                        SVProgressHUD.showError(withStatus: "Failed")
                                    }
                            })
                        }else {
                            SVProgressHUD.showError(withStatus: "Failed")
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
                SVProgressHUD.showSuccess(withStatus: "Success")
            }else {
                SVProgressHUD.showError(withStatus: "Failed")
            }
        }
    }
}

extension CTAPublishControllerProtocol{
    
    func getUserListDismisRect(_ type:UserListType) -> CGRect?{
        if let rect = self.likersRect(){
            let bound = UIScreen.main.bounds
            return self.getViewFromRect(rect, viewRect: bound)
        }else {
            return nil
        }
    }
    
    func disUserListMisComplete(_ type:UserListType){
        
    }
}

extension CTAPublishControllerProtocol{
    
    func getCommentDismisRect(_ publishID:String) -> CGRect?{
        if let rect = self.commentRect(){
            let bound = UIScreen.main.bounds
            return self.getViewFromRect(rect, viewRect: bound)
        }else {
            return nil
        }
    }
    
    func disCommentMisComplete(_ publishID:String){
        
    }
}
