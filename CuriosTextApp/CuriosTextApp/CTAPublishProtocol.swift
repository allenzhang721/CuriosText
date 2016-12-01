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
  func initPublishSubView(_ publishRect:CGRect, horRate:CGFloat)
  func changePublishView(_ publishModel:CTAPublishModel)
  func changeDetailUser()
  
  func likeHandler(_ justLike:Bool)
  func setLikeButtonStyle()
  func moreSelectionHandler(_ isSelf:Bool)
  func rebuildHandler()
}

extension CTAPublishProtocol where Self: UIViewController{
  
  func initPublishSubView(_ publishRect:CGRect, horRate:CGFloat){
    let bounds = UIScreen.main.bounds
    var butY   =  bounds.height - 80 //publishRect.origin.y + publishRect.height + 20 + 10*horRate
    let originy = publishRect.origin.y + publishRect.height + 55  //bounds.height - 60
    if butY < originy{
      butY = originy
    }
    self.likeButton.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
    self.likeButton.center = CGPoint.init(x: UIScreen.main.bounds.width/2,y: butY)
    self.likeButton.setImage(UIImage.init(named: "like-button"), for: UIControlState())
    self.likeButton.setImage(UIImage.init(named: "like-highlighted-button"), for: .highlighted)
    self.likeButton.setImage(UIImage.init(named: "like-disable-button"), for: .disabled)
    self.view.addSubview(self.likeButton)
    
    self.moreButton.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
    self.moreButton.setImage(UIImage.init(named: "moreSelection-button"), for: UIControlState())
    self.moreButton.setImage(UIImage.init(named: "moreSelection-selected-button"), for: .highlighted)
    self.moreButton.setImage(UIImage.init(named: "moreSelection-disable-button"), for: .disabled)
    self.moreButton.center = CGPoint.init(x: UIScreen.main.bounds.width/2 + 100*horRate, y: butY)
    self.view.addSubview(self.moreButton)
    
    self.rebuildButton.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
    self.rebuildButton.setImage(UIImage.init(named: "rebuild-button"), for: UIControlState())
    self.rebuildButton.setImage(UIImage.init(named: "rebuild-selected-button"), for: .highlighted)
    self.rebuildButton.setImage(UIImage.init(named: "rebuild-disable-button"), for: .disabled)
    self.rebuildButton.center = CGPoint.init(x: UIScreen.main.bounds.width/2 - 100*horRate, y: butY)
    self.view.addSubview(self.rebuildButton)
    
    self.userIconImage.frame = CGRect.init(x: UIScreen.main.bounds.width/2, y: 9, width: 40*horRate, height: 40*horRate)
    self.userIconImage.center = CGPoint.init(x: UIScreen.main.bounds.width/2, y: 35+self.userIconImage.frame.height/2)
    self.cropImageCircle(self.userIconImage)
    self.view.addSubview(self.userIconImage)
    self.userIconImage.isUserInteractionEnabled = true
    self.userIconImage.image = UIImage(named: "default-usericon")
    
    self.userNicknameLabel.frame = CGRect.init(x: 0, y: self.userIconImage.frame.origin.y + 50*horRate, width: 100, height: 25)
    if (self.userNicknameLabel.frame.origin.y + self.userNicknameLabel.frame.size.height) > publishRect.origin.y{
      self.userNicknameLabel.frame.origin.y = publishRect.origin.y - self.userNicknameLabel.frame.size.height
    }
    self.userNicknameLabel.font = UIFont.systemFont(ofSize: 16)
    self.userNicknameLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
    self.view.addSubview(self.userNicknameLabel)
    
    self.publishDateLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 25)
    self.publishDateLabel.font = UIFont.systemFont(ofSize: 12)
    self.publishDateLabel.textColor = UIColor.init(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
    self.publishDateLabel.text = "Yesterday"
    self.publishDateLabel.sizeToFit()
    self.publishDateLabel.frame.origin.y = publishRect.origin.y + publishRect.size.height + 10
    self.publishDateLabel.frame.origin.x = publishRect.origin.x + publishRect.size.width - self.publishDateLabel.frame.size.width-10
    self.view.addSubview(self.publishDateLabel)
  }
  
  func changePublishView(_ publishModel:CTAPublishModel){
    let userModel = publishModel.userModel
    self.userNicknameLabel.text = userModel.nickName
    self.userNicknameLabel.sizeToFit()
    let maxWidth = UIScreen.main.bounds.width - 100
    var labelWidth = self.userNicknameLabel.frame.width
    if self.userNicknameLabel.frame.width > maxWidth {
      labelWidth = maxWidth
    }
    self.userNicknameLabel.frame.size.width = labelWidth
    self.userNicknameLabel.frame.origin.x = (UIScreen.main.bounds.width - labelWidth)/2
    UIView.transition(with: self.userNicknameLabel, duration: 0.2, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
      self.userNicknameLabel.text = userModel.nickName
    }) { (_) in
    }
    
    let publishDate = self.getPublishDate(publishModel.publishDate as Date)
    self.publishDateLabel.text = publishDate
    self.publishDateLabel.sizeToFit()
    self.publishDateLabel.frame.origin.x = UIScreen.main.bounds.width - self.publishDateLabel.frame.size.width-10
    UIView.transition(with: self.userNicknameLabel, duration: 0.2, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
      self.publishDateLabel.text = publishDate
    }) { (_) in
    }
    
    UIView.transition(with: self.userIconImage, duration: 0.2, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
      let defaultImg = UIImage.init(named: "default-usericon")
      let imagePath = CTAFilePath.userFilePath+userModel.userIconURL
      let imageURL = URL(string: imagePath)!
      
      self.userIconImage.kf.setImage(with: imageURL, placeholder: defaultImg, options: nil, progressBlock: nil, completionHandler: {[weak self] (img, error, cacheType, imgURL) in
        guard let sf = self else { return }
        if error != nil {
          sf.userIconImage.image = defaultImg
        }
      })
      
      //          self.userIconImage.kf.setImage(with: imageURL, placeholder: defaultImg, options: KingfisherOptionsInfo?, progressBlock: <#T##DownloadProgressBlock?##DownloadProgressBlock?##(Int64, Int64) -> ()#>, completionHandler: <#T##CompletionHandler?##CompletionHandler?##(Image?, NSError?, CacheType, URL?) -> ()#>)
//      self.userIconImage.kf.setImage(with: imageURL, placeholder: defaultImg,options: option(.fade(1))){ (image, error, cacheType, imageURL) -> () in
//        if error != nil {
//          self.userIconImage.image = defaultImg
//        }
//      }
    }) { (_) in
    }
  }
  
  func getPublishDate(_ publishDate:Date) ->String{
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
    let maxWidth = UIScreen.main.bounds.width - 100
    var labelWidth = self.userNicknameLabel.frame.width
    if self.userNicknameLabel.frame.width > maxWidth {
      labelWidth = maxWidth
    }
    self.userNicknameLabel.frame.size.width = labelWidth
    self.userNicknameLabel.frame.origin.x = (UIScreen.main.bounds.width - labelWidth)/2
    self.userIconImage.image = UIImage.init(named: "default-usericon")
  }
  
  func likeHandler(_ justLike:Bool){
    let userID = self.userModel == nil ? "" : self.userModel!.userID
    if self.publishModel != nil {
      if self.publishModel!.likeStatus == 0{
        CTAPublishDomain.getInstance().likePublish(userID, publishID: self.publishModel!.publishID, compelecationBlock: { (info) -> Void in
          if info.result {
            self.publishModel!.likeStatus = 1
            self.setLikeButtonStyle()
            
            // play heart animation
            DispatchQueue.main.async(execute: {
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
        self.likeButton.setImage(UIImage.init(named: "like-button"), for: UIControlState())
        self.likeButton.setImage(UIImage.init(named: "like-highlighted-button"), for: .highlighted)
      }else {
        self.likeButton.setImage(UIImage.init(named: "like-selected-button"), for: UIControlState())
        self.likeButton.setImage(UIImage.init(named: "like-selected-button"), for: .highlighted)
      }
    }
  }
  
  func moreSelectionHandler(_ isSelf:Bool){
    let shareView = CTAShareView.getInstance()
    shareView.delegate = self
    let mainController = CTAMainViewController.getInstance()
    if self.view.isDescendant(of: mainController.view){
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
      if self.view.isDescendant(of: mainController.view){
        rootController = mainController
      }else {
        rootController = self
      }
      self.rebuildHandlerWith(model, rootController: rootController)
    }
  }
  
  func rebuildHandlerWith(_ publishModel: CTAPublishModel? = nil, rootController: UIViewController? = nil){
    if let publishModel = publishModel, let rootController = rootController {
      
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
                      })
                      rootController.present(editNaviVC, animated: true, completion: { () -> Void in
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
  
  func EditControllerDidPublished(_ viewController: EditViewController){
    NotificationCenter.default.post(name: Notification.Name(rawValue: "publishEditFile"), object: nil)
  }
}

extension CTAPublishProtocol{
  
  func weChatShareHandler(){
    
    if CTASocialManager.isAppInstaller(.weChat){
      if let page = publishCell.getPage(){
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
            })
          }else {
            SVProgressHUD.showError(withStatus: NSLocalizedString("ShareErrorLabel", comment: ""))
          }
        })
      }else {
        self.publishCell.getEndImg({ (img) -> () in
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
  
  func momentsShareHandler(){
    if CTASocialManager.isAppInstaller(.weChat){
      self.publishCell.getEndImg({ (img) -> () in
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
  
  func weiBoShareHandler() {
    
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
  
  fileprivate func shareWeiboWithToken(_ token: String) {
    if CTASocialManager.isAppInstaller(.weibo){
      if let page = self.publishCell.getPage(){
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
              let publishID = s.publishModel!.publishID
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
