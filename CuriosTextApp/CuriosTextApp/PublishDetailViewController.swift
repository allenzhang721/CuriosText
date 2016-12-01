//
//  DetailViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import SVProgressHUD

enum PublishDetailType: String {
    case Posts = "Posts"
    case Likes = "Likes"
    case UserFollow = "UserFollow"
    case HotPublish = "HotPublish"
    case NewPublish = "NewPublish"
    case Single = "Single"
}

let Detail_Space:CGFloat = 25

class PublishDetailViewController: UIViewController, CTAPublishModelProtocol, CTALoginProtocol{
    
    var selectedPublishID:String = ""
    var publishArray:Array<CTAPublishModel> = []
    var viewUserID:String = ""
    var loginUser:CTAUserModel?
    
    var backgroundView:UIView!
    var controllerView:CTAPublishControllerView!
    
    var currentPreviewCell:CTAPublishPreviewView!
    var previousPreviewCell:CTAPublishPreviewView?
    var nextPreviewCell:CTAPublishPreviewView?
    
    var delegate:PublishDetailViewDelegate?
    
    var type:PublishDetailType = .Posts
    
    var beganLocation: CGPoint! = CGPoint(x: 0, y: 0)
    var panDirection:CTAPanDirection = .None
    var currentCenter:CGPoint?
    var cellRect:CGRect?
    var currentRect:CGRect?
    var lastLocation:CGPoint? = nil
    
    var isLoadedAll:Bool = false
    var isLoadingFirstData:Bool = false
    var isLoading:Bool = false
    
    var isHideBar:Bool = false
    
    var isDoubleClick:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initView()
        
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.clear
        self.loadLocalUserModel()
    }
    
    override var prefersStatusBarHidden : Bool {
        return self.isHideBar
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadPublishCell(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isHideBar = true
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func initView(){
        let bounds = self.view.bounds
        self.backgroundView = UIView(frame: bounds)
        self.backgroundView.backgroundColor = CTAStyleKit.detailBackgroundColor
        self.view.addSubview(self.backgroundView)
        
        self.currentPreviewCell = CTAPublishPreviewView(frame: CGRect(x: 0, y: (bounds.height - bounds.width)/2 - Detail_Space, width: bounds.width, height: bounds.height))
        self.view.addSubview(self.currentPreviewCell)
        self.currentPreviewCell.animationEnable = true
        
        self.controllerView = CTAPublishControllerView(frame: CGRect(x: 0, y: 10, width: bounds.width, height: bounds.height))
        self.controllerView.type = .PublishDetail
        self.controllerView.delegate = self
        self.view.addSubview(self.controllerView)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanHandler(_:)))
        pan.maximumNumberOfTouches = 1
        pan.minimumNumberOfTouches = 1
        self.view.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewBackHandler(_:)))
        self.view.addGestureRecognizer(tap)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(doubleTapHandler(_:)))
        tap2.numberOfTapsRequired=2
        tap2.numberOfTouchesRequired=1
        self.view.addGestureRecognizer(tap2)
        
        self.resetViewCells(true)
    }
    
    func loadPublishCell(_ isReload:Bool){
        if !self.isLoadedAll && self.type != .Single{
            let selectedIndex = self.getPublishIndexByID(self.selectedPublishID)
            if selectedIndex > self.publishArray.count - 3 {
                self.isLoadingFirstData = false
                self.loadPublishes(self.publishArray.count)
            } else if selectedIndex < 3 {
                self.isLoadingFirstData = true
                self.loadPublishes(0)
            }
        }
        self.resetViewCells(isReload)
    }
    
    func resetViewCells(_ isReload:Bool){
        let bounds = self.view.bounds
        let selectedPublish = self.getPublishModelByID(self.selectedPublishID)
        let seletedIndex = self.getPublishIndexByID(self.selectedPublishID)
        if selectedPublish != nil {
            let currentSize = self.getViewRect(selectedPublish)
            self.currentPreviewCell.frame = CGRect(x: 0, y: (bounds.height - currentSize.height )/2 - Detail_Space, width: currentSize.width, height: currentSize.height)
            if self.currentPreviewCell.publishModel == nil || self.currentPreviewCell.publishModel!.publishID != selectedPublish!.publishID{
                self.currentPreviewCell.publishModel = selectedPublish
                self.currentPreviewCell.loadImg()
            }
            self.currentPreviewCell.alpha = 1
            if seletedIndex < self.publishArray.count - 1{
                let nextPublish = self.publishArray[seletedIndex + 1]
                let nextSize = self.getViewRect(nextPublish)
                if self.nextPreviewCell == nil {
                    self.nextPreviewCell = CTAPublishPreviewView(frame: CGRect(x: bounds.width + 5, y: (bounds.height - nextSize.height )/2 - Detail_Space, width: nextSize.width, height: nextSize.height))
                    self.view.addSubview(self.nextPreviewCell!)
                    self.nextPreviewCell?.animationEnable = true
                }else {
                    self.nextPreviewCell?.frame = CGRect(x: bounds.width + 5, y: (bounds.height - nextSize.height )/2 - Detail_Space, width: nextSize.width, height: nextSize.height)
                }
                if self.nextPreviewCell!.publishModel == nil || self.nextPreviewCell!.publishModel!.publishID != nextPublish.publishID{
                    self.nextPreviewCell!.publishModel = nextPublish
                    self.nextPreviewCell!.loadImg()
                }else {
                    self.nextPreviewCell!.stopAnimation()
                }
                self.nextPreviewCell!.alpha = 1
            }else {
                if self.nextPreviewCell != nil {
                    self.nextPreviewCell?.removeFromSuperview()
                    self.nextPreviewCell?.releasePreviewView()
                    self.nextPreviewCell?.releaseImg()
                    self.nextPreviewCell = nil
                }
            }
            if seletedIndex > 0{
                let previousPublish = self.publishArray[seletedIndex - 1]
                let previousSize = self.getViewRect(previousPublish)
                if self.previousPreviewCell == nil {
                    self.previousPreviewCell = CTAPublishPreviewView(frame: CGRect(x: 0-previousSize.width - 5, y: (bounds.height - previousSize.height )/2 - Detail_Space, width: previousSize.width, height: previousSize.height))
                    self.view.addSubview(self.previousPreviewCell!)
                    self.previousPreviewCell?.animationEnable = true
                }else {
                    self.previousPreviewCell?.frame = CGRect(x: 0-previousSize.width - 5, y: (bounds.height - previousSize.height )/2 - Detail_Space, width: previousSize.width, height: previousSize.height)
                }
                if self.previousPreviewCell?.publishModel == nil || self.previousPreviewCell!.publishModel?.publishID != previousPublish.publishID{
                    self.previousPreviewCell?.publishModel = previousPublish
                    self.previousPreviewCell?.loadImg()
                }else {
                    self.previousPreviewCell!.stopAnimation()
                }
                self.previousPreviewCell!.alpha = 1
            }else {
                if self.previousPreviewCell != nil {
                    self.previousPreviewCell?.removeFromSuperview()
                    self.previousPreviewCell?.releasePreviewView()
                    self.previousPreviewCell?.releaseImg()
                    self.previousPreviewCell = nil
                }
            }
            self.controllerView.publishModel = selectedPublish
            if isReload{
                self.currentPreviewCell.loadPreviewView()
                self.currentPreviewCell.playAnimation()
            }
        }
    }
    
    func loadLocalUserModel(){
        if CTAUserManager.isLogin{
            self.loginUser = CTAUserManager.user
        }else {
            self.loginUser = nil
        }
    }
    
    func closeHandler(){
        var toRect:CGRect!
        let alphaView:UIView? = nil
        if self.delegate != nil {
            self.isHideBar = false
            self.setNeedsStatusBarAppearanceUpdate()
            if let paremt = self.delegate?.getPublishCell(self.selectedPublishID, publishArray: self.publishArray){
                toRect = paremt
            }else {
                toRect = CGRect(x: 0, y: 0, width: 0, height: 0)
            }
        }else {
            toRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
        let bgView  = self.backgroundView.snapshotView(afterScreenUpdates: false)
        let colView = self.controllerView.snapshotView(afterScreenUpdates: false)
        colView?.frame.origin.y = self.controllerView.frame.origin.y
        colView?.frame.origin.x = self.controllerView.frame.origin.x
        bgView?.addSubview(colView!)
        
        let fromRect = self.currentPreviewCell.frame
        let ani = CTAScaleTransition.getInstance()
        ani.transitionView = self.currentPreviewCell.snapshotView(afterScreenUpdates: false)
        ani.transitionAlpha = self.backgroundView.alpha
        ani.transitionBackView = bgView
        ani.fromRect = fromRect
        ani.toRect = toRect
        ani.alphaView = alphaView
        self.dismiss(animated: true) {
            if self.delegate != nil{
                self.delegate!.transitionComplete()
                self.delegate = nil
            }
        }
    }
    
    func getPublishModelByID(_ publishID:String) -> CTAPublishModel?{
        for i in 0..<self.publishArray.count {
            let publishModel = self.publishArray[i]
            if publishModel.publishID == publishID{
                return publishModel
            }
        }
        return nil
    }
    
    func getPublishIndexByID(_ publishID:String) -> Int{
        for i in 0..<self.publishArray.count {
            let publishModel = self.publishArray[i]
            if publishModel.publishID == publishID{
                return i
            }
        }
        return -1
    }
    
    func getViewRect(_ publish:CTAPublishModel?) -> CGSize{
        let rect = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.width)
        return rect;
    }
    
    func viewBackHandler(_ sender: UIPanGestureRecognizer) {
        if self.panDirection == .None{
            delay(0.2, task: {
                if !self.isDoubleClick {
                    self.closeHandler()
                }
                self.isDoubleClick = false
            })
        }
    }
    
    func doubleTapHandler(_ sender: UIPanGestureRecognizer) {
        if self.panDirection == .None{
            self.isDoubleClick = true
            if self.loginUser != nil {
                self.likeHandler(true)
            }
        }
    }
    
    func viewPanHandler(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            self.beganLocation = sender.location(in: view)
            self.panDirection = .None
        case .changed:
            let newLocation = sender.location(in: view)
            if self.panDirection == .None {
                if abs(newLocation.x - self.beganLocation!.x)*5 > abs(newLocation.y - self.beganLocation!.y){
                    self.currentRect = self.currentPreviewCell.frame
                    self.currentCenter = self.currentPreviewCell.center
                    self.viewHorPanHandler(newLocation)
                    self.panDirection = .Hor
                }else {
                    self.isHideBar = false
                    self.setNeedsStatusBarAppearanceUpdate()
                    if self.delegate != nil {
                        self.cellRect = self.delegate!.getPublishCell(self.selectedPublishID, publishArray: self.publishArray)
                    }else {
                        self.cellRect = CGRect(x: 0, y: 0, width: 0, height: 0)
                    }
                    self.currentRect = self.currentPreviewCell.frame
                    self.currentCenter = self.currentPreviewCell.center
                    self.hideControllerView()
                    self.viewVerPanHandler(newLocation)
                    self.panDirection = .Ver
                }
            }else if self.panDirection == .Hor{
                self.viewHorPanHandler(newLocation)
            }else if self.panDirection == .Ver{
                self.viewVerPanHandler(newLocation)
            }
        case .ended, .cancelled, .failed:
            let velocity = sender.velocity(in: view)
            let newLocation = sender.location(in: view)
            if self.panDirection == .Hor{
                if velocity.x > 500 || velocity.x < -500{
                    self.horPanAnimation(velocity.x)
                }else {
                    self.viewHorComplete(newLocation)
                }
            }else if panDirection == .Ver{
                if velocity.y > 500 || velocity.y < -500{
                    self.verPanAnimation()
                }else {
                    self.viewVerComplete(newLocation)
                }
            }
            self.beganLocation = CGPoint(x: 0, y: 0)
            self.panDirection = .None
        default:
            ()
        }
    }
    
    func viewHorPanHandler(_ newLocation:CGPoint){
        let publishIndex = self.getPublishIndexByID(self.selectedPublishID)
        let xRate = newLocation.x - beganLocation.x
        if self.lastLocation == nil {
            self.lastLocation = self.beganLocation
        }
        let xChange = newLocation.x - self.lastLocation!.x
        if  xRate > 0 {
            if publishIndex > 0{
                self.changCellsCenter(xChange, yChange: 0)
            }else {
                self.changCellsCenter(xChange/4, yChange: 0)
            }
        }else {
            if publishIndex < self.publishArray.count-1{
                self.changCellsCenter(xChange, yChange: 0)
            }else {
                self.changCellsCenter(xChange/4, yChange: 0)
            }
        }
        self.lastLocation = newLocation
    }
    
    func changCellsCenter(_ xChange:CGFloat, yChange:CGFloat){
        if self.previousPreviewCell != nil {
            self.previousPreviewCell!.center = CGPoint(x: self.previousPreviewCell!.center.x + xChange, y: self.previousPreviewCell!.center.y + yChange)
        }
        
        if self.nextPreviewCell != nil {
            self.nextPreviewCell!.center = CGPoint(x: self.nextPreviewCell!.center.x + xChange, y: self.nextPreviewCell!.center.y + yChange)
        }
        
        self.currentPreviewCell.center = CGPoint(x: self.currentPreviewCell.center.x + xChange, y: self.currentPreviewCell.center.y + yChange)
    }
    
    func horPanAnimation(_ xRate:CGFloat){
        let maxW = UIScreen.main.bounds.width
        let maxX = maxW + self.currentRect!.width/2 + 5
        let minX = 0 - self.currentRect!.width/2 - 5
        let publishIndex = self.getPublishIndexByID(self.selectedPublishID)
        if  xRate > 0 {
            if publishIndex > 0{
                let xChange = maxX - self.currentPreviewCell.center.x
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.changCellsCenter(xChange, yChange: 0)
                    }, completion: { (_) -> Void in
                        self.horPanComplete(.previous, isChange: true)
                })
            }else {
                self.horPanResetAnimation(xRate)
            }
        }else {
            if publishIndex < self.publishArray.count-1{
                let xChange = minX - self.currentPreviewCell.center.x
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.changCellsCenter(xChange, yChange: 0)
                    }, completion: { (_) -> Void in
                        self.horPanComplete(.next, isChange: true)
                })
            }else {
                self.horPanResetAnimation(xRate)
            }
        }
    }
    
    func viewHorComplete(_ newLocation:CGPoint){
        let maxX = UIScreen.main.bounds.width
        let xRate = newLocation.x - beganLocation.x
        if abs(xRate) >= maxX/2 {
            self.horPanAnimation(xRate)
        }else {
            self.horPanResetAnimation(xRate)
        }
    }
    
    func horPanResetAnimation(_ xRate:CGFloat){
        if self.currentCenter != nil {
            let xChange = self.currentCenter!.x - self.currentPreviewCell.center.x
            let yChange = self.currentCenter!.y - self.currentPreviewCell.center.y
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.changCellsCenter(xChange, yChange: yChange)
                }, completion: { (_) -> Void in
                    if xRate > 0 {
                        self.horPanComplete(.previous, isChange: false)
                    }else {
                        self.horPanComplete(.next, isChange: false)
                    }
            })
        }
    }
    
    func horPanComplete(_ dir:CTAPanHorDirection, isChange:Bool){
        self.lastLocation = nil
        self.currentCenter = nil
        if isChange {
            self.currentPreviewCell.stopAnimation()
            if dir == .next{
                let currentFull = self.currentPreviewCell
                self.currentPreviewCell = self.nextPreviewCell
                self.nextPreviewCell = self.previousPreviewCell
                self.previousPreviewCell = currentFull
                self.selectedPublishID = self.currentPreviewCell.publishModel!.publishID
            }else if dir == .previous{
                let currentFull = self.currentPreviewCell
                self.currentPreviewCell = self.previousPreviewCell
                self.previousPreviewCell = self.nextPreviewCell
                self.nextPreviewCell = currentFull
                self.selectedPublishID = self.currentPreviewCell.publishModel!.publishID
            }
            self.loadPublishCell(true)
        }else {
            self.resetViewCells(false)
        }
    }
    
    func viewVerPanHandler(_ newLocation:CGPoint){
        let maxY = UIScreen.main.bounds.height/2
        let yRate = newLocation.y - self.beganLocation.y
        if self.lastLocation == nil {
            self.lastLocation = self.beganLocation
        }
        let yChange = newLocation.y - self.lastLocation!.y
        //let xChange = newLocation.x - self.lastLocation!.x
        var center = self.currentPreviewCell.center
        //center.x = center.x + xChange
        center.y = center.y + yChange
        var percent:CGFloat = 1
        if abs(yRate) > maxY {
            percent = 1
        }else {
            percent = abs(yRate) / maxY
        }
        let wChange = (1 - self.cellRect!.width / self.currentRect!.width) * percent
        let hChange = (1 - self.cellRect!.height / self.currentRect!.height) * percent
        self.currentPreviewCell.transform = CGAffineTransform(scaleX: 1 - wChange, y: 1 - hChange)
        self.currentPreviewCell.center = center
        self.backgroundView.alpha =  1 - percent
        self.lastLocation = newLocation
    }
    
    func hideControllerView(){
        UIView.animate(withDuration: 0.1, animations: { 
            self.controllerView.alpha = 0
        }) 
    }
    
    func verPanAnimation(){
        self.closeHandler()
        self.verPanComlete()
    }
    
    func viewVerComplete(_ newLocation:CGPoint){
        let xRate = newLocation.y - beganLocation.y
        if abs(xRate) >= 10 {
            self.verPanAnimation()
        }else {
            self.verPanResetAnimation(xRate)
        }
    }
    
    func verPanResetAnimation(_ yRate:CGFloat){
        self.isHideBar = true
        self.setNeedsStatusBarAppearanceUpdate()
        if self.currentCenter != nil {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.currentPreviewCell.transform = CGAffineTransform(scaleX: 1, y: 1)
                if self.currentCenter != nil {
                    self.currentPreviewCell.center = self.currentCenter!
                }else {
                    let bounds = self.view.bounds
                    let selectedPublish = self.getPublishModelByID(self.selectedPublishID)
                    let currentSize = self.getViewRect(selectedPublish)
                    self.currentPreviewCell.center = CGPoint(x: currentSize.width, y: bounds.height/2 - Detail_Space)
                }
                self.backgroundView.alpha = 1
                self.controllerView.alpha = 1
                }, completion: { (_) -> Void in
                    self.verPanComlete()
            })
        }
    }
    
    func verPanComlete(){
        self.lastLocation = nil
        self.currentCenter = nil
        self.currentRect = nil
        self.cellRect = nil
    }
    
    
    func loadPublishes(_ start:Int, size:Int = 20){
        if self.isLoading{
            return
        }
        self.isLoading = true
        self.isLoadedAll = false
        let userID = self.loginUser == nil ? "" : self.loginUser!.userID
        switch self.type {
        case .Posts:
            CTAPublishDomain.getInstance().userPublishList(userID, beUserID: self.viewUserID, start: start, size: size) { (info) -> Void in
                self.loadPublishesComplete(info, size: size)
            }
        case .Likes:
            CTAPublishDomain.getInstance().userLikePublishList(userID, beUserID: self.viewUserID, start: start, size: size) { (info) -> Void in
                self.loadPublishesComplete(info, size: size)
            }
        case .UserFollow:
            CTAPublishDomain.getInstance().userFollowPublishList(userID, beUserID: userID, start: start, size: size, compelecationBlock: { (info) in
                self.loadPublishesComplete(info, size:size)
            })
        case .HotPublish:
            CTAPublishDomain.getInstance().hotPublishList(userID, start: start, size: size, compelecationBlock: { (info) in
                self.loadPublishesComplete(info, size:size)
            })
        case .NewPublish:
            CTAPublishDomain.getInstance().newPublishList(userID, start: start, size: size, compelecationBlock: { (info) in
                self.loadPublishesComplete(info, size:size)
            })
        default:
            ()
        }
    }
    
    func loadPublishesComplete(_ info: CTADomainListInfo, size:Int){
        self.isLoading = false
        if info.result{
            let modelArray = info.modelArray;
            if modelArray != nil {
                if modelArray!.count < size {
                    self.isLoadedAll = true
                }
                if self.isLoadingFirstData{
                    var isChange:Bool = false
                    if modelArray!.count > 0{
                        if self.publishArray.count > 0{
                            for i in 0..<modelArray!.count{
                                let newmodel = modelArray![i] as! CTAPublishModel
                                if !self.checkPublishModelIsHave(newmodel, publishArray: self.publishArray){
                                    isChange = true
                                    break
                                }else {
                                    let index = self.getPublishIndex(newmodel.publishID, publishArray: self.publishArray)
                                    if index != -1{
                                        self.publishArray.insert(newmodel, at: index)
                                        self.publishArray.remove(at: index+1)
                                    }
                                }
                            }
                            if !isChange{
                                for j in 0..<modelArray!.count{
                                    if j < self.publishArray.count{
                                        let oldModel = self.publishArray[j]
                                        if !self.checkPublishModelIsHave(oldModel, publishArray: modelArray as! Array<CTAPublishModel>){
                                            isChange = true
                                            break
                                        }
                                    }else {
                                        isChange = true
                                        break
                                    }
                                }
                            }
                        }else {
                            isChange = true
                        }
                    }else {
                        isChange = true
                    }
                    if isChange{
                        self.publishArray.removeAll()
                        self.loadMoreModelArray(modelArray!)
                    }
                }else {
                    self.loadMoreModelArray(modelArray!)
                }
            }
        }
    }
    
    func loadMoreModelArray(_ modelArray:Array<AnyObject>){
        for i in 0..<modelArray.count{
            let publishModel = modelArray[i] as! CTAPublishModel
            if !self.checkPublishModelIsHave(publishModel, publishArray: self.publishArray){
                self.publishArray.append(publishModel)
            }
        }
    }
}

extension PublishDetailViewController: CTAPublishControllerProtocol{
    var publishModel:CTAPublishModel?{
        let selectedPublish = self.getPublishModelByID(self.selectedPublishID)
        return selectedPublish
    }
    
    var userModel:CTAUserModel?{
        return self.loginUser
    }
    
    var previewView:CTAPublishPreviewView?{
        return self.currentPreviewCell
    }
    
    func setLikeButtonStyle(_ publichModel:CTAPublishModel?){
        self.changeLikeStatus(publichModel)
    }
    
    func changeLikeStatus(_ publichModel:CTAPublishModel?){
        self.controllerView.publishModel = publichModel
        self.controllerView.changeLikeStatus()
        if let model = publichModel{
            if model.likeStatus == 1{
                DispatchQueue.main.async(execute: {
                    let heartView = CTAHeartAnimationView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100)))
                    heartView.center = self.currentPreviewCell.center
                    self.view.addSubview(heartView)
                    heartView.playLikeAnimation(nil)
                    self.controllerView.playLikeAnimation()
                })
            }
        }
    }
    
    func likersRect() -> CGRect? {
        let point = self.controllerView.likeCountView.convert(CGPoint(x: 0, y: 0), to: self.view)
        let frame = self.controllerView.likeCountView.frame
        let rect:CGRect = CGRect(x: point.x, y: point.y, width: frame.width, height: frame.height)
        return rect
    }
    
    func commentRect() -> CGRect? {
        let point = self.controllerView.commentView.convert(CGPoint(x: 0, y: 0), to: self.view)
        let frame = self.controllerView.commentView.frame
        let rect:CGRect = CGRect(x: point.x, y: point.y, width: frame.width, height: frame.height)
        return rect
    }
    
    func disCommentMisComplete(_ publishID: String) {
        self.updatePublishByID(publishID)
    }
    
    func updatePublishByID(_ publishID:String){
        let userID = self.loginUser == nil ? "" : self.loginUser!.userID
        CTAPublishDomain.getInstance().publishDetai(userID, publishID: publishID) { (info) in
            if info.result {
                if let publishModel = info.baseModel as? CTAPublishModel {
                    let index = self.getPublishIndex(publishModel.publishID, publishArray: self.publishArray)
                    if index != -1{
                        self.publishArray.insert(publishModel, at: index)
                        self.publishArray.remove(at: index+1)
                        if let currentPublishID = self.currentPreviewCell.publishModel?.publishID{
                            if publishModel.publishID == currentPublishID{
                                self.controllerView.publishModel = publishModel
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    func deleteHandler(){
        if let publish = self.currentPreviewCell.publishModel{
            self.showSelectedAlert(NSLocalizedString("AlertTitleDeleteFile", comment: ""), alertMessage: "", okAlertLabel: LocalStrings.deleteFile.description, cancelAlertLabel: LocalStrings.cancel.description, compelecationBlock: { (result) -> Void in
                if result{
                    SVProgressHUD.setDefaultMaskType(.clear)
                    SVProgressHUD.show(withStatus: NSLocalizedString("DeleteProgressLabel", comment: ""))
                    let userID = self.loginUser == nil ? "" : self.loginUser!.userID
                    CTAPublishDomain.getInstance().deletePublishFile(publish.publishID, userID: userID, compelecationBlock: { (info) -> Void in
                        SVProgressHUD.dismiss()
                        if info.result{
                            let selectedIndex = self.getPublishIndexByID(self.selectedPublishID)
                            self.currentPreviewCell.alpha = 1
                            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                                self.currentPreviewCell.alpha = 0
                                }, completion: { (_) -> Void in
                                    if self.publishArray.count > 1{
                                        self.currentRect = self.currentPreviewCell.frame
                                        self.currentCenter = self.currentPreviewCell.center
                                        if selectedIndex < self.publishArray.count-1 {
                                            self.horPanAnimation(-1)
                                        }else {
                                            self.horPanAnimation(1)
                                        }
                                        self.publishArray.remove(at: selectedIndex)
                                    }else {
                                        self.publishArray.remove(at: selectedIndex)
                                        self.closeHandler()
                                    }
                            })
                        }
                    })
                }
            })
        }
    }
}

extension PublishDetailViewController: CTAPublishControllerDelegate{
    
    func controlUserIconTap(){
        let publish = self.getPublishModelByID(self.selectedPublishID)
        if self.viewUserID != "" {
            if publish != nil {
                if publish!.userModel.userID == self.viewUserID {
                    self.closeHandler()
                }else {
                    self.pushUserPublish(publish)
                }
            }
        }else {
            self.pushUserPublish(publish)
        }
    }
    
    func controlLikeListTap(){
        if self.loginUser != nil {
            self.likersHandelr()
        }else {
            self.showLoginView(true)
        }
    }
    
    func controlLikeHandler(){
        if self.loginUser != nil {
            self.likeHandler(false)
        }else {
            self.showLoginView(true)
        }
    }
    
    func controlCommentHandler(){
        if self.loginUser != nil {
            self.commentHandler()
        }else {
            self.showLoginView(true)
        }
    }
    
    func controlRebuildHandler(){
        if self.loginUser != nil {
            self.rebuildHandler(true)
        }else {
            self.showLoginView(true)
        }
    }
    
    func controlMoreHandler(){
        if self.type == .Posts{
            if self.loginUser != nil && self.viewUserID == self.loginUser?.userID {
                self.moreSelectionHandler(true, isPopup: true)
            }else {
                self.moreSelectionHandler(false, isPopup: true)
            }
        }else {
            self.moreSelectionHandler(false, isPopup: true)
        }
    }
    
    func controlCloseHandler(){
        self.closeHandler()
    }
    
    func pushUserPublish(_ publish:CTAPublishModel?){
        let viewUserModel = publish?.userModel
        let userPublish = UserViewController()
        userPublish.viewUser = viewUserModel
        self.navigationController?.pushViewController(userPublish, animated: true)
    }
}

protocol PublishDetailViewDelegate: AnyObject{
    
    func getPublishCell(_ selectedID:String, publishArray:Array<CTAPublishModel>) -> CGRect?;
    
    func transitionComplete()
}
