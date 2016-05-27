//
//  CTAPublishDetaiViewController.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/19.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit
import SVProgressHUD

class CTAPublishDetailViewController: UIViewController, CTAPublishCellProtocol{

    var viewUser:CTAUserModel?
    var loginUser:CTAUserModel?
    
    var publishModelArray:Array<CTAPublishModel> = []
    var selectedPublishID:String = ""
    
    var currentFullCell:CTAFullPublishesCell!
    var nextFullCell:CTAFullPublishesCell!
    var previousFullCell:CTAFullPublishesCell!
    var fullCellArray:Array<CTAFullPublishesCell> = []
    
    var userIconImage:UIImageView = UIImageView()
    var userNicknameLabel:UILabel = UILabel()
    var likeButton:UIButton = UIButton()
    var moreButton:UIButton = UIButton()
    var rebuildButton:UIButton = UIButton()
    var publishDateLabel:UILabel = UILabel()
    
    var isLoading:Bool = false
    var isLoadingFirstData = false
    var isLoadedAll:Bool = false
    
    var beganLocation: CGPoint! = CGPoint(x: 0, y: 0)
    var panDirection:CTAPanDirection = .None
    var nextCenter:CGPoint?
    var preCenter:CGPoint?
    var currentCenter:CGPoint?
    var lastLocation:CGPoint? = nil
    var verCellSpaceDic:Dictionary<String, CGPoint> = [String: CGPoint]()
    
    var delegate:CTAPublishDetailDelegate?
    
    var publishType:CTAPublishType = .Posts
    var headerView:UIView?
    var headerHeight:CGFloat = 0.0
    let cellHorCount = 3
    
    var loadingImageView:UIImageView? = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initView();
        self.view.backgroundColor = CTAStyleKit.lightGrayBackgroundColor
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    func initView(){
        let fullSize = self.getFullCellRect(nil, rate: 1.0)
        let horSpace = self.getFullHorSpace()
        self.fullCellArray.removeAll()
        let count = self.getCellCount()
        for _ in 0..<count-2{
            let fullCell:CTAFullPublishesCell = CTAFullPublishesCell.init(frame: CGRect.init(x: 0, y: 0, width: fullSize.width, height: fullSize.height))
            fullCell.transform = CGAffineTransformMakeScale(cellScale, cellScale)
            fullCell.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2, y: 0-fullSize.height)
            fullCell.addShadow()
            self.view.addSubview(fullCell)
            self.fullCellArray.append(fullCell)
        }
        self.currentFullCell = CTAFullPublishesCell.init(frame: CGRect.init(x: 0, y: 0, width: fullSize.width, height: fullSize.height))
        self.view.addSubview(self.currentFullCell!)
        self.currentFullCell!.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2)
        self.currentFullCell.animationEnable = true
        self.currentFullCell.addShadow()
        self.currentFullCell.transform = CGAffineTransformMakeScale(1, 1)
        
        self.nextFullCell = CTAFullPublishesCell.init(frame: CGRect.init(x: 0, y: 0, width: fullSize.width, height: fullSize.height))
        self.view.addSubview(self.nextFullCell!)
        self.nextFullCell!.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2 - horSpace, y: UIScreen.mainScreen().bounds.height/2)
        self.nextFullCell.animationEnable = true
        self.nextFullCell.addShadow()
        self.nextFullCell.transform = CGAffineTransformMakeScale(cellScale, cellScale)
        
        self.previousFullCell = CTAFullPublishesCell.init(frame: CGRect.init(x: 0, y: 0, width: fullSize.width, height: fullSize.height))
        self.view.addSubview(self.previousFullCell!)
        self.previousFullCell!.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2 + horSpace, y: UIScreen.mainScreen().bounds.height/2)
        self.previousFullCell.animationEnable = true
        self.previousFullCell.addShadow()
        self.previousFullCell.transform = CGAffineTransformMakeScale(cellScale, cellScale)
        
        self.initPublishSubView(self.currentFullCell.frame, horRate: self.getHorRate())
        self.likeButton.addTarget(self, action: #selector(CTAPublishDetailViewController.likeButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.moreButton.addTarget(self, action: #selector(CTAPublishDetailViewController.moreButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.rebuildButton.addTarget(self, action: #selector(CTAPublishDetailViewController.rebuildButtonClick(_:)), forControlEvents: .TouchUpInside)
        let iconTap = UITapGestureRecognizer(target: self, action: #selector(CTAPublishDetailViewController.userIconClick(_:)))
        self.userIconImage.addGestureRecognizer(iconTap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(CTAPublishDetailViewController.viewPanHandler(_:)))
        pan.maximumNumberOfTouches = 1
        pan.minimumNumberOfTouches = 1
        self.view.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CTAPublishDetailViewController.viewBackHandler(_:)))
        self.view.addGestureRecognizer(tap)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(CTAPublishDetailViewController.doubleTapHandler(_:)))
        tap2.numberOfTapsRequired=2
        tap2.numberOfTouchesRequired=1
        self.view.addGestureRecognizer(tap2)
        
    }
    
    func reloadView(){
        self.loadPublishCell()
    }
    
    func setPublishData(selectedPublishID:String, publishModelArray:Array<CTAPublishModel>, publishType:CTAPublishType, topView:UIView?){
        self.publishModelArray.removeAll()
        self.selectedPublishID = selectedPublishID
        self.publishModelArray = self.publishModelArray + publishModelArray
        self.publishType = publishType
        self.headerView = topView
        if topView != nil {
            self.headerHeight = topView!.frame.height
        }else {
            self.headerHeight = 0.0
        }
        
    }
    
    func loadPublishCell(){
        let selectedIndex = self.getPublishIndex(self.selectedPublishID)
        if !self.isLoadedAll{
            if selectedIndex > self.publishModelArray.count - 6 {
                self.isLoadingFirstData = false
                self.loadUserPublishes(self.publishModelArray.count)
            } else if selectedIndex < 6 {
                self.isLoadingFirstData = true
                self.loadUserPublishes(0)
            }
        }
        self.reloadCells()
    }
    
    func reloadCells(){
        let selectedIndex = self.getPublishIndex(self.selectedPublishID)
        let publishArray = self.getCurrentPublishArray(selectedIndex)
        let currentIndex = self.getCurrentPublishIndex(selectedIndex)
        self.resetCells(currentIndex, arrayCount: publishArray.count - 2)
        for i in 0..<publishArray.count{
            if i < currentIndex - 1{
                let previousCell = self.fullCellArray[i]
                previousCell.publishModel = publishArray[i]
                previousCell.isVisible = true
                self.setPublishCellPosition(previousCell)
            }
            if i == currentIndex - 1 {
                let preModel = publishArray[i]
                if self.previousFullCell!.publishModel == nil || self.previousFullCell!.publishModel!.publishID != preModel.publishID {
                    self.previousFullCell!.publishModel = preModel
                }
                self.previousFullCell!.isVisible = true
                self.setPublishCellPosition(previousFullCell)
            }
            if i == currentIndex{
                let currentModel = publishArray[i]
                if self.currentFullCell!.publishModel == nil || self.currentFullCell!.publishModel!.publishID != currentModel.publishID {
                    self.currentFullCell!.publishModel = currentModel
                }
                self.currentFullCell!.isVisible = true
            }
            if i == currentIndex + 1 {
                let proModel = publishArray[i]
                if self.nextFullCell!.publishModel == nil || self.nextFullCell!.publishModel!.publishID != proModel.publishID {
                    self.nextFullCell!.publishModel = proModel
                }
                self.nextFullCell!.isVisible = true
                self.setPublishCellPosition(nextFullCell)
            }
            if i > currentIndex + 1{
                var nextCell:CTAFullPublishesCell?
                if  i > self.fullCellArray.count - 1{
                    nextCell = self.getNextEnableCell()
                }else{
                    nextCell = self.fullCellArray[i]
                }
                if nextCell != nil {
                    nextCell!.publishModel = publishArray[i]
                    nextCell!.isVisible = true
                    self.setPublishCellPosition(nextCell!)
                }
            }
        }
        if !self.previousFullCell!.isVisible{
            self.setPublishCellPosition(self.previousFullCell)
        }
        if !self.nextFullCell!.isVisible{
            self.setPublishCellPosition(self.nextFullCell)
        }
        for i in 0..<self.fullCellArray.count{
            if !self.fullCellArray[i].isVisible {
                self.setPublishCellPosition(self.fullCellArray[i])
            }
        }
        self.currentFullCell!.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2)
        self.currentFullCell!.alpha = 1.0
        if let publishModel = self.currentFullCell!.publishModel {
            self.changePublishView(publishModel)
        }
        self.setLikeButtonStyle()
        self.currentFullCell!.playAnimation()
    }
    
    func getNextEnableCell() -> CTAFullPublishesCell? {
        for i in 0..<self.fullCellArray.count{
            if !self.fullCellArray[i].isVisible {
                return self.fullCellArray[i]
            }
        }
        return nil
    }
    
    func resetCells(currentIndex:Int, arrayCount:Int){
        self.previousFullCell!.isVisible = false
        self.previousFullCell!.alpha = 0.0
        self.nextFullCell!.isVisible = false
        self.nextFullCell!.alpha = 0.0
        self.currentFullCell!.isVisible = false
        self.currentFullCell!.alpha = 0.0
        for i in 0..<self.fullCellArray.count{
            self.fullCellArray[i].isVisible = false
            self.fullCellArray[i].alpha = 0.0
        }
    }
    
    func setPublishCellPosition(cell:CTAFullPublishesCell){
        if cell.publishModel == nil || !cell.isVisible {
            cell.center = CGPoint.init(x: 0 - UIScreen.mainScreen().bounds.width, y: 0 - UIScreen.mainScreen().bounds.height/2 )
            cell.hidden = true
        }else {
            cell.hidden = false
            cell.alpha = 0.2
            let selectedIndex = self.getPublishIndex(self.selectedPublishID)
            let currentHorCount = selectedIndex%self.cellHorCount
            let currentVerCount = selectedIndex/self.cellHorCount
            let cellIndex = self.getPublishIndex(cell.publishModel!.publishID)
            let cellHorCount = cellIndex%self.cellHorCount
            let cellVerCount = cellIndex/self.cellHorCount
            let horSpace = CGFloat(cellHorCount - currentHorCount) * self.getFullHorSpace()
            let verSpace:CGFloat = CGFloat(cellVerCount - currentVerCount) * self.getFullVerSpace()
            cell.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2 + horSpace, y: UIScreen.mainScreen().bounds.height/2 + verSpace)
        }
    }
    
    func getCurrentPublishIndex(selectedIndex:Int) -> Int{
        let selectedPo = selectedIndex % self.cellHorCount
        let verCount = self.getCellCount()/self.cellHorCount
        let midVerCount = verCount % 2 == 0 ? (verCount/2)-1 : (verCount/2)
        var midCount = midVerCount*self.cellHorCount+selectedPo

        let publishCount = self.publishModelArray.count - 1
        if publishCount - selectedIndex > midCount {
            
        }else {
            let allCount = publishCount % self.cellHorCount + (verCount - 1)*self.cellHorCount
            
            midCount = allCount - (publishCount - selectedIndex)
        }
        let newIndex = selectedIndex > midCount ? midCount : selectedIndex
        return newIndex
    }
    
    func getCurrentPublishArray(selectedIndex:Int) -> Array<CTAPublishModel>{
        let count = self.getCellCount()
        var selectedArray:Array<CTAPublishModel> = []
        let currentIndex = self.getCurrentPublishIndex(selectedIndex)
        let rate = selectedIndex - currentIndex
        for i in 0..<count{
            if (rate + i) < self.publishModelArray.count{
                selectedArray.append(self.publishModelArray[rate + i])
            }
        }
        return selectedArray
    }
    
    func getPublishIndex(publishID:String) -> Int{
        for i in 0..<self.publishModelArray.count{
            if self.publishModelArray[i].publishID == publishID{
                return i;
            }
        }
        return -1
    }
    
    func loadUserPublishes(start:Int, size:Int = 20){
        if self.isLoading{
            return
        }
        self.isLoading = true
        self.isLoadedAll = false
        let userID = self.loginUser == nil ? "" : self.loginUser!.userID
        if self.publishType == .Posts{
            CTAPublishDomain.getInstance().userPublishList(userID, beUserID: self.viewUser!.userID, start: start, size: size) { (info) -> Void in
                self.loadPublishesComplete(info, size: size)
            }
        }else if self.publishType == .Likes{
            CTAPublishDomain.getInstance().userLikePublishList(userID, beUserID: self.viewUser!.userID, start: start, size: size) { (info) -> Void in
                self.loadPublishesComplete(info, size: size)
            }
        }
    }
    
    func loadPublishesComplete(info: CTADomainListInfo, size:Int){
        self.isLoading = false
        if info.result{
            let modelArray = info.modelArray;
            if modelArray != nil {
                if modelArray!.count < size {
                    self.isLoadedAll = true
                }
                if self.isLoadingFirstData{
                    if modelArray!.count > 0{
                        if self.publishModelArray.count > 0{
                            var isChange:Bool = false
                            for i in 0..<modelArray!.count{
                                let newmodel = modelArray![i] as! CTAPublishModel
                                if !self.checkPublishModelIsHave(newmodel.publishID, publishArray: self.publishModelArray){
                                    isChange = true
                                    break
                                }else {
                                    let index = self.getPublishIndex(newmodel.publishID, publishArray: self.publishModelArray)
                                    if index != -1{
                                        self.publishModelArray.insert(newmodel, atIndex: index)
                                        self.publishModelArray.removeAtIndex(index+1)
                                    }
                                }
                            }
                            if !isChange{
                                for j in 0..<self.publishModelArray.count{
                                    let oldModel = self.publishModelArray[j]
                                    if !self.checkPublishModelIsHave(oldModel.publishID, publishArray: modelArray as! Array<CTAPublishModel>){
                                        isChange = true
                                        break
                                    }
                                }
                            }
                            if isChange{
                                self.publishModelArray.removeAll()
                                self.loadMoreModelArray(modelArray!)
                            }
                        }
                    }else {
                        self.publishModelArray.removeAll()
                    }
                }else {
                    self.loadMoreModelArray(modelArray!)
                }
            }
        }
    }
    
    func loadMoreModelArray(modelArray:Array<AnyObject>){
        for i in 0..<modelArray.count{
            let publishModel = modelArray[i] as! CTAPublishModel
            if !self.checkPublishModelIsHave(publishModel.publishID, publishArray: self.publishModelArray){
                self.publishModelArray.append(publishModel)
            }
        }
    }
    
    func getPublishIndex(publishID:String, publishArray:Array<CTAPublishModel>) -> Int{
        for i in 0..<publishArray.count{
            let oldPublihModel = publishArray[i]
            if oldPublihModel.publishID == publishID{
                return i
            }
        }
        return -1
    }
    
    func checkPublishModelIsHave(publishID:String, publishArray:Array<CTAPublishModel>) -> Bool{
        for i in 0..<publishArray.count{
            let oldPublihModel = publishArray[i]
            if oldPublihModel.publishID == publishID{
                return true
            }
        }
        return false
    }
    
    func removePublishModelByID(publishID:String) -> Bool{
        for i in 0..<self.publishModelArray.count{
            let oldPublihModel = self.publishModelArray[i]
            if oldPublihModel.publishID == publishID {
                self.publishModelArray.removeAtIndex(i)
                return true
            }
        }
        return false
    }
    
    // view pan
    var isPaning:Bool = false
    
    
    func viewPanHandler(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began:
            self.beganLocation = sender.locationInView(view)
            self.panDirection = .None
        case .Changed:
            let newLocation = sender.locationInView(view)
            if self.panDirection == .None {
                if abs(newLocation.x - self.beganLocation!.x)*2 > abs(newLocation.y - self.beganLocation!.y){
                    self.nextCenter = self.nextFullCell.center
                    self.preCenter = self.previousFullCell.center
                    self.currentCenter = self.currentFullCell.center
                    self.viewHorPanHandler(newLocation)
                    self.panDirection = .Hor
                }else {
                    self.currentCenter = self.currentFullCell.center
                    self.setVerCellCenter()
                    self.setVerHeaderView()
                    self.viewVerPanHandler(newLocation)
                    self.panDirection = .Ver
                }
            }else if self.panDirection == .Hor{
                self.viewHorPanHandler(newLocation)
            }else if self.panDirection == .Ver{
                self.viewVerPanHandler(newLocation)
            }
        case .Ended, .Cancelled, .Failed:
            let velocity = sender.velocityInView(view)
            let newLocation = sender.locationInView(view)
            if panDirection == .Hor{
                if velocity.x > 500 || velocity.x < -500{
                    self.horPanAnimation(velocity.x)
                }else {
                    self.viewHorComplete(newLocation)
                }
            }else if panDirection == .Ver{
                if velocity.y > 500 || velocity.y < -500{
                    self.verPanAnimation(velocity.y)
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
    
    func viewHorPanHandler(newLocation:CGPoint){
        let maxX = (UIScreen.mainScreen().bounds.width * 0.7)
        let xRate = newLocation.x - beganLocation.x
        if self.lastLocation == nil {
            self.lastLocation = self.beganLocation
        }
        if abs(xRate) > maxX{
            return
        }
        
        let percent = (newLocation.x - lastLocation!.x) / maxX
        if xRate > 0 {
            if self.previousFullCell.isVisible {
                if self.preCenter != nil && self.currentCenter != nil{
                    let xChange = (self.currentCenter!.x - self.preCenter!.x) * percent
                    let yChange = (self.currentCenter!.y - self.preCenter!.y) * percent
                    let wChange = (1 - cellScale) * xRate / maxX
                    let hChange = (1 - cellScale) * xRate / maxX
                    let alpha   = (1.0-0.2) * percent
                    self.changCellsCenter(xChange, yChange: yChange)
                    if self.previousFullCell.isVisible {
                        self.previousFullCell.transform = CGAffineTransformMakeScale(cellScale + wChange, cellScale + hChange)
                        self.previousFullCell.alpha = self.previousFullCell.alpha + alpha
                    }
                    if self.currentFullCell.isVisible {
                        self.currentFullCell.transform = CGAffineTransformMakeScale(1 - wChange, 1 - hChange)
                        self.currentFullCell.alpha = self.currentFullCell.alpha - alpha
                    }
                }
            }
        } else {
            if self.nextFullCell.isVisible {
                if self.nextCenter != nil && self.nextCenter != nil{
                    let xChange = (self.nextCenter!.x - self.currentCenter!.x) * percent
                    let yChange = (self.nextCenter!.y - self.currentCenter!.y ) * percent
                    let wChange = (cellScale - 1) * xRate / maxX
                    let hChange = (cellScale - 1) * xRate / maxX
                    let alpha   = (0.2 - 1.0) * percent
                    self.changCellsCenter(xChange, yChange: yChange)
                    if self.nextFullCell.isVisible {
                        self.nextFullCell.transform = CGAffineTransformMakeScale(cellScale + wChange, cellScale + hChange)
                        self.nextFullCell.alpha = self.nextFullCell.alpha + alpha
                    }
                    if self.currentFullCell.isVisible {
                        self.currentFullCell.transform = CGAffineTransformMakeScale(1 - wChange, 1 - hChange)
                        self.currentFullCell.alpha = self.currentFullCell.alpha - alpha
                    }
                }
            }
        }
        self.lastLocation = newLocation
    }
    
    func viewHorComplete(newLocation:CGPoint){
        let maxX = (UIScreen.mainScreen().bounds.width * 0.7)
        let xRate = newLocation.x - beganLocation.x
        if abs(xRate) >= maxX/2 {
            self.horPanAnimation(xRate)
        }else {
            self.horPanResetAnimation(xRate)
        }
    }
    
    func horPanAnimation(xRate:CGFloat){
        if xRate > 0 {
            if self.previousFullCell.isVisible {
                if self.preCenter != nil && self.currentCenter != nil{
                    let xChange = self.currentCenter!.x - self.previousFullCell.center.x
                    let yChange = self.currentCenter!.y - self.previousFullCell.center.y
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.changCellsCenter(xChange, yChange: yChange)
                        if self.previousFullCell.isVisible {
                            self.previousFullCell.transform = CGAffineTransformMakeScale(1, 1)
                            self.previousFullCell.alpha = 1
                        }
                        if self.currentFullCell.isVisible {
                            self.currentFullCell.transform = CGAffineTransformMakeScale(cellScale, cellScale)
                            self.currentFullCell.alpha = 0.2
                        }
                        }, completion: { (_) -> Void in
                            self.horPanComplete(.Previous, isChange: true)
                    })
                }
            }
        }else {
            if self.nextFullCell.isVisible {
                if self.nextCenter != nil && self.nextCenter != nil{
                    let xChange = self.currentCenter!.x - self.nextFullCell!.center.x
                    let yChange = self.currentCenter!.y - self.nextFullCell!.center.y
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.changCellsCenter(xChange, yChange: yChange)
                        if self.nextFullCell.isVisible {
                            self.nextFullCell.transform = CGAffineTransformMakeScale(1, 1)
                            self.nextFullCell.alpha = 1
                        }
                        if self.currentFullCell.isVisible {
                            self.currentFullCell.transform = CGAffineTransformMakeScale(cellScale, cellScale)
                            self.currentFullCell.alpha = 0.2
                        }
                        }, completion: { (_) -> Void in
                            self.horPanComplete(.Next, isChange: true)
                    })
                    
                }
            }
        }
    }
    
    func horPanResetAnimation(xRate:CGFloat){
        if xRate > 0 {
            if self.preCenter != nil && self.currentCenter != nil{
                let xChange = self.preCenter!.x - self.previousFullCell.center.x
                let yChange = self.preCenter!.y - self.previousFullCell.center.y
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.changCellsCenter(xChange, yChange: yChange)
                    if self.previousFullCell.isVisible {
                        self.previousFullCell.transform = CGAffineTransformMakeScale(cellScale, cellScale)
                        self.previousFullCell.alpha = 0.2
                    }
                    if self.currentFullCell.isVisible {
                        self.currentFullCell.transform = CGAffineTransformMakeScale(1, 1)
                        self.currentFullCell.alpha = 1
                    }
                    }, completion: { (_) -> Void in
                        self.horPanComplete(.Previous, isChange: false)
                })
            }
        }else {
            if self.nextCenter != nil && self.nextCenter != nil{
                let xChange = self.nextCenter!.x - self.nextFullCell!.center.x
                let yChange = self.nextCenter!.y - self.nextFullCell!.center.y
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.changCellsCenter(xChange, yChange: yChange)
                    if self.nextFullCell.isVisible {
                        self.nextFullCell.transform = CGAffineTransformMakeScale(cellScale, cellScale)
                        self.nextFullCell.alpha = 0.2
                    }
                    if self.currentFullCell.isVisible {
                        self.currentFullCell.transform = CGAffineTransformMakeScale(1, 1)
                        self.currentFullCell.alpha = 1
                    }
                    }, completion: { (_) -> Void in
                        self.horPanComplete(.Next, isChange: false)
                })
            }
        }
    }
    
    func changCellsCenter(xChange:CGFloat, yChange:CGFloat){
        if self.previousFullCell.isVisible {
            self.previousFullCell.center = CGPoint(x: self.previousFullCell.center.x + xChange, y: self.previousFullCell.center.y + yChange)
        }
        
        if self.nextFullCell.isVisible {
            self.nextFullCell.center = CGPoint(x: self.nextFullCell.center.x + xChange, y: self.nextFullCell.center.y + yChange)
        }
        
        if self.currentFullCell.isVisible {
            self.currentFullCell.center = CGPoint(x: self.currentFullCell.center.x + xChange, y: self.currentFullCell.center.y + yChange)
        }
        for i in 0..<self.fullCellArray.count{
            let cell = self.fullCellArray[i]
            if cell.isVisible{
                cell.center = CGPoint(x: cell.center.x + xChange, y: cell.center.y + yChange)
            }
        }
    }
    
    func horPanComplete(dir:CTAPanHorDirection, isChange:Bool){
        self.lastLocation = nil
        self.preCenter = nil
        self.nextCenter = nil
        self.currentCenter = nil
        if isChange {
            self.currentFullCell!.stopAnimation()
            if dir == .Next{
                let currentFull = self.currentFullCell
                self.currentFullCell = self.nextFullCell
                self.nextFullCell = self.previousFullCell
                self.previousFullCell = currentFull
                self.selectedPublishID = self.currentFullCell.publishModel!.publishID
            }else if dir == .Previous{
                let currentFull = self.currentFullCell
                self.currentFullCell = self.previousFullCell
                self.previousFullCell = self.nextFullCell
                self.nextFullCell = currentFull
                self.selectedPublishID = self.currentFullCell.publishModel!.publishID
            }
            self.loadPublishCell()
        }else {
            self.reloadCells()
        }
    }
    
    func setVerHeaderView(){
        if self.headerView != nil {
            if !self.headerView!.isDescendantOfView(self.view){
                self.view.addSubview(self.headerView!)
                self.view.sendSubviewToBack(self.headerView!)
                self.headerView!.alpha = 0
                let space = self.getTopSpace()
                self.headerView!.frame.origin.x = 0
                self.headerView!.frame.origin.y = space - self.headerView!.frame.height
            }
        }
    }
    
    func removeVerHeaderView(isClean:Bool){
        if self.headerView != nil {
            if self.headerView!.isDescendantOfView(self.view){
                self.headerView!.removeFromSuperview()
                if isClean {
                    self.headerView = nil
                }
            }
        }
    }
    
    func setVerCellCenter() {
        self.verCellSpaceDic.removeAll()
        if self.previousFullCell.isVisible {
            self.setViewCellCenter(self.previousFullCell)
        }
        
        if self.nextFullCell.isVisible {
            self.setViewCellCenter(self.nextFullCell)
        }
        for i in 0..<self.fullCellArray.count{
            let cell = self.fullCellArray[i]
            if cell.isVisible {
                self.setViewCellCenter(cell)
            }
        }
    }
    
    func setViewCellCenter(cell:CTAFullPublishesCell){
        if cell.publishModel != nil {
            self.verCellSpaceDic[cell.publishModel!.publishID] = cell.center
        }
    }
    
    func changeCellCenterPoint(cell:CTAFullPublishesCell, percent:CGFloat){
        let center = self.verCellSpaceDic[cell.publishModel!.publishID]
        if center != nil {
            let horSpace = self.getHorSpace()
            let verSpace = self.getVerSpace()
            let fullHorSpace = self.getFullHorSpace()
            let fullVerSpace = self.getFullVerSpace()
            
            
            let xMax = center!.x - self.currentCenter!.x
            let xMin = horSpace / fullHorSpace * xMax
            let xChange = xMax + (xMin - xMax) * percent
            
            
            let yMax = center!.y - self.currentCenter!.y
            let yMin = verSpace / fullVerSpace * yMax
            let yChange = yMax + (yMin - yMax) * percent
            
            cell.center = CGPoint(x: self.currentFullCell.center.x + xChange, y: self.currentFullCell.center.y + yChange)
        }
    }

    func viewVerPanHandler(newLocation:CGPoint){
        let maxY = (UIScreen.mainScreen().bounds.height * 0.7)
        let yRate = newLocation.y - beganLocation.y
        if self.lastLocation == nil {
            self.lastLocation = beganLocation
        }
        if abs(yRate) > maxY {
            return
        }
        let percent = abs(yRate) / maxY
        let currentVerCenterPoint = self.getCurrentVerCenterPoint()
        let cellRect = self.getCellRect()
        let fullRect = self.getFullCellRect(nil, rate: 1)
        if self.currentCenter != nil {
            let xChange = (currentVerCenterPoint.x - self.currentCenter!.x) * percent
            let yChange = (currentVerCenterPoint.y - self.currentCenter!.y) * percent
            let wChange = (1 - cellRect.width / fullRect.width) * percent
            let hChange = (1 - cellRect.width / fullRect.width) * percent
            if self.currentFullCell.isVisible {
                self.currentFullCell.transform = CGAffineTransformMakeScale(1 - wChange, 1 - hChange)
                self.currentFullCell.alpha = 1
                self.currentFullCell.center = CGPoint(x: self.currentCenter!.x + xChange, y: self.currentCenter!.y + yChange)
            }
            self.changeViewAlpha(1-1*percent)
            self.changeCellByCenter(percent)
            self.changeCellSize(percent)
        }
        self.lastLocation = newLocation
    }
    
    func changeViewAlpha(alpha:CGFloat) {
        let subViews = self.view.subviews
        for i in 0..<subViews.count{
            let view = subViews[i]
            if !(view is CTAFullPublishesCell){
                if self.headerView != nil && view == self.headerView{
                    view.alpha = 1 - alpha
                }else {
                    view.alpha = alpha
                }
            }
        }
    }
    
    func viewVerComplete(newLocation:CGPoint){
        let maxX = (UIScreen.mainScreen().bounds.height * 0.7)
        let xRate = newLocation.y - beganLocation.y
        if abs(xRate) >= maxX/2 {
            self.verPanAnimation(xRate)
        }else {
            self.verPanResetAnimation(xRate)
        }
    }
    
    func verPanAnimation(yRate:CGFloat, duration:NSTimeInterval = 0.3){
        let currentVerCenterPoint = self.getCurrentVerCenterPoint()
        let cellRect = self.getCellRect()
        let fullRect = self.getFullCellRect(nil, rate: 1)
        if self.currentCenter != nil {
            self.setVerHeaderView()
            UIView.animateWithDuration(duration, animations: { () -> Void in
                let xChange = (currentVerCenterPoint.x - self.currentCenter!.x)
                let yChange = (currentVerCenterPoint.y - self.currentCenter!.y)
                let wChange = (1 - cellRect.width / fullRect.width)
                let hChange = (1 - cellRect.width / fullRect.width)
                if self.currentFullCell.isVisible {
                    self.currentFullCell.transform = CGAffineTransformMakeScale(1 - wChange, 1 - hChange)
                    self.currentFullCell.alpha = 1
                    self.currentFullCell.center = CGPoint(x: self.currentCenter!.x + xChange, y: self.currentCenter!.y + yChange)
                }
                self.changeViewAlpha(0)
                self.changeCellByCenter(1.0)
                self.changeCellSize(1.0)
                }, completion: { (_) -> Void in
                    self.verPanComplete(.Change)
            })
        }
    }
    
    func verPanResetAnimation(yRate:CGFloat){
        if self.currentCenter != nil {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                if self.currentFullCell.isVisible {
                    self.currentFullCell.transform = CGAffineTransformMakeScale(1, 1)
                    self.currentFullCell.alpha = 1
                    self.currentFullCell.center = CGPoint(x: self.currentCenter!.x, y: self.currentCenter!.y)
                }
                self.changeViewAlpha(1.0)
                self.changeCellByCenter(0)
                self.changeCellSize(0.0)
                }, completion: { (_) -> Void in
                    self.verPanComplete(.Reset)
            })
        }
    }
    
    func verPanComplete(dir:CTAPanVerDirection){
        self.lastLocation = nil
        self.currentCenter = nil
        self.verCellSpaceDic.removeAll()
        if dir == .Change{
            self.currentFullCell!.stopAnimation()
            if self.delegate != nil {
                self.delegate!.setPublishData(self.selectedPublishID, publishModelArray: self.publishModelArray, selectedCellCenter: self.getCurrentVerCenterPoint())
            }
            self.delegate = nil
            self.dismissViewControllerAnimated(true) { () -> Void in
                self.changeViewAlpha(1.0)
                self.changeCellByCenter(0)
                self.changeCellSize(0.0)
                self.currentFullCell.transform = CGAffineTransformMakeScale(1, 1)
                self.currentFullCell.alpha = 1
                self.removeVerHeaderView(true)
            }
        }else {
            self.currentFullCell!.playAnimation()
            self.removeVerHeaderView(false)
        }
    }
    
    func changeCellByCenter(percent:CGFloat){
        if self.previousFullCell.isVisible {
            self.changeCellCenterPoint(self.previousFullCell, percent:percent)
        }
        if self.nextFullCell.isVisible {
            self.changeCellCenterPoint(self.nextFullCell, percent:percent)
        }
        for i in 0..<self.fullCellArray.count{
            let cell = self.fullCellArray[i]
            if cell.isVisible {
                self.changeCellCenterPoint(cell, percent:percent)
            }
        }
    }
    
    func changeCellSize(percent:CGFloat){
        let cellRect = self.getCellRect()
        let fullRect = self.getFullCellRect(nil, rate: 1)
        let wChange = (cellScale - cellRect.width / fullRect.width) * percent
        let hChange = (cellScale - cellRect.width / fullRect.width) * percent
        if self.previousFullCell.isVisible {
            self.previousFullCell.transform = CGAffineTransformMakeScale(cellScale - wChange, cellScale - hChange)
            self.previousFullCell.alpha = 0.2 + 0.8*percent
        }
        
        if self.nextFullCell.isVisible {
            self.nextFullCell.transform = CGAffineTransformMakeScale(cellScale - wChange, cellScale - hChange)
            self.nextFullCell.alpha = 0.2 + 0.8*percent
        }
        for i in 0..<self.fullCellArray.count{
            let cell = self.fullCellArray[i]
            if cell.isVisible{
                cell.transform = CGAffineTransformMakeScale(cellScale - wChange, cellScale - hChange)
                cell.alpha = 0.2 + 0.8*percent
            }
        }
    }
    
    func getCurrentVerCenterPoint() -> CGPoint{
        let selectedIndex  = self.getPublishIndex(self.selectedPublishID)
        let currentIndex = self.getCurrentPublishIndex(selectedIndex)
        let space = self.getCellSpace()
        let cellRect = self.getCellRect()
        let horCount = selectedIndex % self.cellHorCount
        let centX = space+cellRect.width/2+(cellRect.width+space)*CGFloat(horCount)
        
        let headerTop = self.getTopSpace()
        let screenH = UIScreen.mainScreen().bounds.height
        let verCount = Int(currentIndex / self.cellHorCount)
        var centY:CGFloat = 0.0
        let a = CGFloat(verCount) * (space + cellRect.height)
        let b = cellRect.height/2 + headerTop
        centY = a + b
        let maxY = screenH - cellRect.height/2 - 40
        if centY > maxY{
            centY = maxY
        }
        return CGPoint(x: centX, y: centY)
    }
    
    func getTopSpace()-> CGFloat{
        let selectedIndex  = self.getPublishIndex(self.selectedPublishID)
        let currentIndex = self.getCurrentPublishIndex(selectedIndex)
        let space = self.getCellSpace()
        let cellRect = self.getCellRect()
        
        var verCount:Int = 0
        let count = self.getCellCount()-1
        let publishCount = self.publishModelArray.count - 1
        let firstCount = selectedIndex-currentIndex
        var lastCellCount = firstCount+count
        if lastCellCount > publishCount{
            lastCellCount = publishCount
        }
        verCount = Int(lastCellCount / self.cellHorCount)
        let lastHeight = CGFloat(verCount+1) * (space + cellRect.height) + self.headerHeight
        var headerTop = self.headerHeight
        let screenH = UIScreen.mainScreen().bounds.height - 40
        if lastHeight > screenH{
            let hSpace = screenH - lastHeight + headerTop
            let topSpace = hSpace>0 ? hSpace : 0
            verCount = Int(firstCount / self.cellHorCount)
            if verCount == 0 {
                let rateCount = Int(currentIndex / self.cellHorCount)
                headerTop = self.headerHeight - CGFloat(rateCount)*(space + cellRect.height)
                if headerTop < topSpace && hSpace > 0{
                    headerTop = hSpace
                }
            }else{
                headerTop = topSpace
            }
        }
        return headerTop
    }
    
    func viewBackHandler(sender: UIPanGestureRecognizer) {
        if self.panDirection == .None{
            var isHave:Bool = false
            let subViews = self.view.subviews
            for i in 0..<subViews.count{
                let subView = subViews[i]
                let pt = sender.locationInView(subView)
                if subView.pointInside(pt, withEvent: nil){
                    isHave = true
                }
            }
            if !isHave {
                self.viewBackHandler()
            }
        }
    }
    
    func viewBackHandler(){
        self.currentCenter = self.currentFullCell.center
        self.setVerCellCenter()
        self.verPanAnimation(500.00)
    }
    
    func doubleTapHandler(sender: UIPanGestureRecognizer) {
        if self.panDirection == .None{
            let pt = sender.locationInView(self.currentFullCell)
            if self.currentFullCell.pointInside(pt, withEvent: nil){
                if self.currentFullCell.publishModel != nil{
                    self.likeHandler(true)
                }
            }
        }
    }
}

protocol CTAPublishDetailDelegate{
    func setPublishData(selectedPublishID:String, publishModelArray:Array<CTAPublishModel>, selectedCellCenter:CGPoint)
}

enum CTAPanDirection: String {
    case None, Hor, Ver
}

enum CTAPanHorDirection{
    case None, Next, Previous
}

enum CTAPanVerDirection{
    case Change, Reset
}

extension CTAPublishDetailViewController: CTAPublishProtocol{
    
    var publishModel:CTAPublishModel?{
        let publishModel = self.currentFullCell.publishModel
        return publishModel
    }
    
    var userModel:CTAUserModel?{
        return self.loginUser
    }
    
    var publishCell:CTAFullPublishesCell{
        return self.currentFullCell
    }
    
    func likeButtonClick(sender: UIButton){
        if self.currentFullCell.publishModel != nil && self.panDirection == .None{
            self.likeHandler(false)
        }
    }
    
    func moreButtonClick(sender: UIButton){
        if self.currentFullCell.publishModel != nil && self.panDirection == .None{
            let user = self.currentFullCell.publishModel!.userModel
            if user.userID != self.loginUser!.userID{
               self.moreSelectionHandler(false)
            }else {
               self.moreSelectionHandler(true)
            }
        }
    }
    
    func rebuildButtonClick(sender: UIButton){
        if self.currentFullCell.publishModel != nil && self.panDirection == .None{
            self.rebuildHandler()
        }
    }
    
    func userIconClick(sender: UIPanGestureRecognizer) {
        if self.panDirection == .None{
            if let publish = self.currentFullCell.publishModel{
                let viewUserModel = publish.userModel
                var canGo:Bool = false
                if self.viewUser == nil {
                    canGo = true
                }else if viewUserModel.userID != self.viewUser!.userID{
                    canGo = true
                }
                if canGo{
                    let userPublish = CTAUserPublishesViewController()
                    userPublish.viewUser = viewUserModel
                    self.navigationController?.pushViewController(userPublish, animated: true)
                }else {
                    self.viewBackHandler()
                }
            }
        }
    }
    
    func deleteHandler(){
        if let publish = self.currentFullCell.publishModel{LocalStrings.Delete.description
            self.showSelectedAlert(NSLocalizedString("AlertTitleDeleteFile", comment: ""), alertMessage: "", okAlertLabel: LocalStrings.DeleteFile.description, cancelAlertLabel: LocalStrings.Cancel.description, compelecationBlock: { (result) -> Void in
                if result{
                    SVProgressHUD.setDefaultMaskType(.Clear)
                    SVProgressHUD.showWithStatus(NSLocalizedString("DeleteProgressLabel", comment: ""))
                    let userID = self.viewUser == nil ? "" : self.viewUser!.userID
                    CTAPublishDomain.getInstance().deletePublishFile(publish.publishID, userID: userID, compelecationBlock: { (info) -> Void in
                        SVProgressHUD.dismiss()
                        if info.result{
                            let selectedIndex = self.getPublishIndex(self.selectedPublishID)
                            self.currentFullCell.alpha = 1
                            UIView.animateWithDuration(0.3, animations: { () -> Void in
                                self.currentFullCell.alpha = 0
                                }, completion: { (_) -> Void in
                                    self.publishModelArray.removeAtIndex(selectedIndex)
                                    if self.publishModelArray.count > 0{
                                        self.nextCenter = self.nextFullCell.center
                                        self.preCenter = self.previousFullCell.center
                                        self.currentCenter = self.currentFullCell.center
                                        if selectedIndex < self.publishModelArray.count {
                                            self.currentFullCell.hidden = true
                                            self.horPanAnimation(-1)
                                        }else {
                                            self.horPanAnimation(1)
                                        }
                                    }else {
                                        self.currentFullCell.hidden = true
                                        self.viewBackHandler()
                                    }
                            })
                        }
                    })
                }
            })
        }
    }
    
    func EditControllerDidPublished(viewController: EditViewController){
        NSNotificationCenter.defaultCenter().postNotificationName("publishEditFile", object: nil)
    }
}