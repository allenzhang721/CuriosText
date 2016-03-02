//
//  CTAPublishDetaiViewController.swift
//  CuriosTextApp
//
//  Created by allen on 16/1/19.
//  Copyright © 2016年 botai. All rights reserved.
//

import UIKit

class CTAPublishDetailViewController: UIViewController, CTAPublishCellProtocol, CTAUserDetailProtocol, CTALoadingProtocol, CTAAlertProtocol{

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
    var userDetail:CTAUserDetailViewController?
    
    var loadingImageView:UIImageView? = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
//    
//    static var _instance:CTAPublishDetailViewController?;
//    
//    static func getInstance() -> CTAPublishDetailViewController{
//        if _instance == nil{
//            _instance = CTAPublishDetailViewController();
//        }
//        return _instance!
//    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initView();
        self.view.backgroundColor = UIColor.whiteColor()
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
        for var i = 0; i < count - 2; i++ {
            let fullCell:CTAFullPublishesCell = CTAFullPublishesCell.init(frame: CGRect.init(x: 0, y: 0, width: fullSize.width, height: fullSize.height))
            fullCell.transform = CGAffineTransformMakeScale(0.9, 0.9)
            fullCell.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2, y: 0-fullSize.height)
            self.view.addSubview(fullCell)
            self.fullCellArray.append(fullCell)
        }
        self.currentFullCell = CTAFullPublishesCell.init(frame: CGRect.init(x: 0, y: 0, width: fullSize.width, height: fullSize.height))
        self.view.addSubview(self.currentFullCell!)
        self.currentFullCell!.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2)
        self.currentFullCell.animationEnable = true
        self.currentFullCell.transform = CGAffineTransformMakeScale(1, 1)
        
        self.nextFullCell = CTAFullPublishesCell.init(frame: CGRect.init(x: 0, y: 0, width: fullSize.width, height: fullSize.height))
        self.view.addSubview(self.nextFullCell!)
        self.nextFullCell!.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2 - horSpace, y: UIScreen.mainScreen().bounds.height/2)
        self.nextFullCell.animationEnable = true
        self.nextFullCell.transform = CGAffineTransformMakeScale(0.9, 0.9)
        
        self.previousFullCell = CTAFullPublishesCell.init(frame: CGRect.init(x: 0, y: 0, width: fullSize.width, height: fullSize.height))
        self.view.addSubview(self.previousFullCell!)
        self.previousFullCell!.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2 + horSpace, y: UIScreen.mainScreen().bounds.height/2)
        self.previousFullCell.animationEnable = true
        self.previousFullCell.transform = CGAffineTransformMakeScale(0.9, 0.9)
        
        self.initPublishSubView(self.currentFullCell.frame, horRate: self.getHorRate())
        self.initAddBarView(nil)
        let pan = UIPanGestureRecognizer(target: self, action: "viewPanHandler:")
        self.view.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: "viewBackHandler:")
        self.view.addGestureRecognizer(tap)
    }
    
    func reloadView(){
        if self.viewUser != nil {
            self.changeUserView(self.viewUser!)
        }
        self.loadPublishCell()
    }
    
    func setPublishData(selectedPublishID:String, publishModelArray:Array<CTAPublishModel>){
        self.publishModelArray.removeAll()
        self.selectedPublishID = selectedPublishID
        self.publishModelArray = self.publishModelArray + publishModelArray
    }
    
    func loadPublishCell(){
        let selectedIndex = self.getPublishIndex(self.selectedPublishID)
        if !self.isLoadedAll{
            if selectedIndex > self.publishModelArray.count - 4 {
                self.isLoadingFirstData = false
                self.loadUserPublishes(self.publishModelArray.count)
            } else if selectedIndex < 4 {
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
        for var i=0; i<publishArray.count; i++ {
            if i < currentIndex - 1{
                let previousCell = self.fullCellArray[i]
                previousCell.publishModel = publishArray[i]
                previousCell.isVisible = true
                self.setPublishCellRect(previousCell)
            }
            if i == currentIndex - 1 {
                self.previousFullCell!.publishModel = publishArray[i]
                self.previousFullCell!.isVisible = true
                self.setPublishCellRect(previousFullCell)
            }
            if i == currentIndex{
                self.currentFullCell!.publishModel = publishArray[i]
                self.currentFullCell!.isVisible = true
            }
            if i == currentIndex + 1 {
                self.nextFullCell!.publishModel = publishArray[i]
                self.nextFullCell!.isVisible = true
                self.setPublishCellRect(nextFullCell)
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
                    self.setPublishCellRect(nextCell!)
                }
            }
        }
        if !self.previousFullCell!.isVisible{
            self.setPublishCellRect(self.previousFullCell)
        }
        if !self.nextFullCell!.isVisible{
            self.setPublishCellRect(self.nextFullCell)
        }
        for var i=0; i < self.fullCellArray.count; i++ {
            if !self.fullCellArray[i].isVisible {
                self.setPublishCellRect(self.fullCellArray[i])
            }
        }
        self.currentFullCell!.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2)
        self.currentFullCell!.alpha = 1.0
        self.currentFullCell!.playAnimation()
        self.setLikeButtonStyle(self.currentFullCell.publishModel)
    }
    
    func getNextEnableCell() -> CTAFullPublishesCell? {
        for var i = 0 ; i<self.fullCellArray.count; i++ {
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
        for var i=0; i < self.fullCellArray.count; i++ {
            self.fullCellArray[i].isVisible = false
            self.fullCellArray[i].alpha = 0.0
        }
    }
    
    func setPublishCellRect(cell:CTAFullPublishesCell){
        if cell.publishModel == nil || !cell.isVisible {
            cell.center = CGPoint.init(x: 0 - UIScreen.mainScreen().bounds.width, y: 0 - UIScreen.mainScreen().bounds.height/2 )
            cell.hidden = true
        }else {
            cell.hidden = false
            cell.alpha = 0.2
            let selectedIndex = self.getPublishIndex(self.selectedPublishID)
            let cellIndex = self.getPublishIndex(cell.publishModel!.publishID)
            let isLeft = (selectedIndex % 2 == 0 ? true : false )
            let rate = cellIndex - selectedIndex
            let isDouble = (rate % 2 == 0 ? true : false)
            let rateIndex = Int(rate / 2)
            if isDouble {
                cell.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2 + CGFloat(rateIndex) * self.getFullVerSpace())
            }else {
                let horSpace = isLeft ? self.getFullHorSpace() : 0-self.getFullHorSpace()
                var verSpace:CGFloat = 0.0
                if isLeft{
                    if rate > 0{
                        verSpace = CGFloat(rateIndex ) * self.getFullVerSpace()
                    }else {
                        verSpace = CGFloat(rateIndex - 1) * self.getFullVerSpace()
                    }
                }else {
                    if rate > 0{
                        verSpace = CGFloat(rateIndex + 1) * self.getFullVerSpace()
                    }else {
                        verSpace = CGFloat(rateIndex) * self.getFullVerSpace()
                    }
                }
                cell.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2 + horSpace, y: UIScreen.mainScreen().bounds.height/2 + verSpace)
            }
        }
    }
    
    func getCurrentPublishIndex(selectedIndex:Int) -> Int{
        let count = self.getCellCount()-1
        let isLeft = (selectedIndex % 2 == 0 ? true : false )
        let publishCount = self.publishModelArray.count - 1
        let isLastLeft = publishCount % 2 == 0 ? true : false
        var midCount = count/2
        if publishCount - selectedIndex > midCount {
            if isLeft {
                midCount = midCount % 2 == 0 ?  midCount : midCount-1
            }else {
                midCount = midCount % 2 == 0 ?  midCount + 1 : midCount
            }
        }else {
            if isLastLeft {
                midCount = count - (publishCount - selectedIndex) - 1
            }else {
                midCount = count - (publishCount - selectedIndex)
            }
        }
        let newIndex = selectedIndex > midCount ? midCount : selectedIndex
        return newIndex
    }
    
    func getCurrentPublishArray(selectedIndex:Int) -> Array<CTAPublishModel>{
        let count = self.getCellCount()
        var selectedArray:Array<CTAPublishModel> = []
        let currentIndex = self.getCurrentPublishIndex(selectedIndex)
        let rate = selectedIndex - currentIndex
        for var i=0; i < count; i++ {
            if (rate + i < self.publishModelArray.count){
                selectedArray.append(self.publishModelArray[rate + i])
            }
        }
        return selectedArray
    }
    
    func getPublishIndex(publishID:String) -> Int{
        for var i=0; i<self.publishModelArray.count; i++ {
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
        CTAPublishDomain.getInstance().userPublishList(userID, beUserID: self.viewUser!.userID, start: start, size: size) { (info) -> Void in
            self.isLoading = false
            self.loadPublishesComplete(info, size: size)
        }
    }
    
    func loadPublishesComplete(info: CTADomainListInfo, size:Int){
        if info.result{
            let modelArray = info.modelArray;
            if modelArray != nil {
                if modelArray!.count < size {
                    self.isLoadedAll = true
                }
                if self.isLoadingFirstData{
                    if modelArray!.count > 0{
                        if self.publishModelArray.count > 0{
                            let newmodel = modelArray![0] as! CTAPublishModel
                            let oldModel = self.publishModelArray[0]
                            if newmodel.publishID != oldModel.publishID{
                                self.publishModelArray.removeAll()
                                self.loadMoreModelArray(modelArray!)
                            }
                        }else {
                            self.loadMoreModelArray(modelArray!)
                        }
                    }
                }else {
                    self.loadMoreModelArray(modelArray!)
                }
            }
        }
    }
    
    func loadMoreModelArray(modelArray:Array<AnyObject>){
        for var i=0; i < modelArray.count; i++ {
            let publishModel = modelArray[i] as! CTAPublishModel
            if !self.checkPublishModelIsHave(publishModel.publishID){
                self.publishModelArray.append(publishModel)
            }
        }
    }
    
    func checkPublishModelIsHave(publishID:String) -> Bool{
        for var i=0; i<self.publishModelArray.count; i++ {
            let oldPublihModel = self.publishModelArray[i]
            if oldPublihModel.publishID == publishID{
                return true
            }
        }
        return false
    }
    
    func removePublishModelByID(publishID:String) -> Bool{
        for var i=0; i<self.publishModelArray.count; i++ {
            let oldPublihModel = self.publishModelArray[i]
            if oldPublihModel.publishID == publishID {
                self.publishModelArray.removeAtIndex(i)
                return true
            }
        }
        return false
    }
    
    // view pan
    
    func viewPanHandler(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began:
            self.beganLocation = sender.locationInView(view)
            self.panDirection = .None
            self.currentFullCell!.pauseAnimation()
        case .Changed:
            let newLocation = sender.locationInView(view)
            if self.panDirection == .None {
                if abs(newLocation.x - self.beganLocation!.x) > abs(newLocation.y - self.beganLocation!.y){
                    self.nextCenter = self.nextFullCell.center
                    self.preCenter = self.previousFullCell.center
                    self.currentCenter = self.currentFullCell.center
                    self.viewHorPanHandler(newLocation)
                    self.panDirection = .Hor
                }else {
                    self.currentCenter = self.currentFullCell.center
                    self.setVerCellCenter()
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
                    let wChange = (1 - 0.9) * xRate / maxX
                    let hChange = (1 - 0.9) * xRate / maxX
                    let alpha   = (1.0-0.2) * percent
                    self.changCellsCenter(xChange, yChange: yChange)
                    if self.previousFullCell.isVisible {
                        self.previousFullCell.transform = CGAffineTransformMakeScale(0.9 + wChange, 0.9 + hChange)
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
                    let wChange = (0.9 - 1) * xRate / maxX
                    let hChange = (0.9 - 1) * xRate / maxX
                    let alpha   = (0.2 - 1.0) * percent
                    self.changCellsCenter(xChange, yChange: yChange)
                    if self.nextFullCell.isVisible {
                        self.nextFullCell.transform = CGAffineTransformMakeScale(0.9 + wChange, 0.9 + hChange)
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
                            self.currentFullCell.transform = CGAffineTransformMakeScale(0.9, 0.9)
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
                            self.currentFullCell.transform = CGAffineTransformMakeScale(0.9, 0.9)
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
            if self.previousFullCell.isVisible {
                if self.preCenter != nil && self.currentCenter != nil{
                    let xChange = self.preCenter!.x - self.previousFullCell.center.x
                    let yChange = self.preCenter!.y - self.previousFullCell.center.y
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.changCellsCenter(xChange, yChange: yChange)
                        if self.previousFullCell.isVisible {
                            self.previousFullCell.transform = CGAffineTransformMakeScale(0.9, 0.9)
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
            }
        }else {
            if self.nextFullCell.isVisible {
                if self.nextCenter != nil && self.nextCenter != nil{
                    let xChange = self.nextCenter!.x - self.nextFullCell!.center.x
                    let yChange = self.nextCenter!.y - self.nextFullCell!.center.y
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.changCellsCenter(xChange, yChange: yChange)
                        if self.nextFullCell.isVisible {
                            self.nextFullCell.transform = CGAffineTransformMakeScale(0.9, 0.9)
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
        for var i=0; i < self.fullCellArray.count; i++ {
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
            self.currentFullCell!.playAnimation()
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
        
        for var i=0; i<self.fullCellArray.count; i++ {
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
        for var i=0; i<subViews.count; i++ {
            let view = subViews[i]
            if !(view is CTAFullPublishesCell) && !(view is CTAAddBarView) {
                view.alpha = alpha
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
            }
        }else {
            self.currentFullCell!.playAnimation()
        }
    }
    
    func changeCellByCenter(percent:CGFloat){
        if self.previousFullCell.isVisible {
            self.changeCellCenterPoint(self.previousFullCell, percent:percent)
        }
        if self.nextFullCell.isVisible {
            self.changeCellCenterPoint(self.nextFullCell, percent:percent)
        }
        for var i=0; i<self.fullCellArray.count; i++ {
            let cell = self.fullCellArray[i]
            if cell.isVisible {
                self.changeCellCenterPoint(cell, percent:percent)
            }
        }
    }
    
    func changeCellSize(percent:CGFloat){
        let cellRect = self.getCellRect()
        let fullRect = self.getFullCellRect(nil, rate: 1)
        let wChange = (0.9 - cellRect.width / fullRect.width) * percent
        let hChange = (0.9 - cellRect.width / fullRect.width) * percent
        if self.previousFullCell.isVisible {
            self.previousFullCell.transform = CGAffineTransformMakeScale(0.9 - wChange, 0.9 - hChange)
            self.previousFullCell.alpha = 0.2 + 0.8*percent
        }
        
        if self.nextFullCell.isVisible {
            self.nextFullCell.transform = CGAffineTransformMakeScale(0.9 - wChange, 0.9 - hChange)
            self.nextFullCell.alpha = 0.2 + 0.8*percent
        }
        
        for var i=0; i < self.fullCellArray.count; i++ {
            let cell = self.fullCellArray[i]
            if cell.isVisible{
                cell.transform = CGAffineTransformMakeScale(0.9 - wChange, 0.9 - hChange)
                cell.alpha = 0.2 + 0.8*percent
            }
        }
    }
    
    func getCurrentVerCenterPoint() -> CGPoint{
        let selectedIndex  = self.getPublishIndex(self.selectedPublishID)
        let currentIndex = self.getCurrentPublishIndex(selectedIndex)
        let space = self.getCellSpace()
        let cellRect = self.getCellRect()
        let centX = currentIndex % 2 == 0 ? (space + cellRect.width / 2) : (UIScreen.mainScreen().bounds.width - (space + cellRect.width / 2))
    
        var centY:CGFloat = 0.0
        let yIndex = Int(currentIndex / 2)
        centY = CGFloat(yIndex) * (space + cellRect.height) + cellRect.height/2 + 44
        let maxY = UIScreen.mainScreen().bounds.height - 44 - cellRect.height/2
        if centY > maxY{
            centY = maxY
        }
        return CGPoint(x: centX, y: centY)
    }
    
    func viewBackHandler(sender: UIPanGestureRecognizer) {
        var isHave:Bool = false
        let subViews = self.view.subviews
        for var i=0; i<subViews.count; i++ {
            let view = subViews[i]
            let pt = sender.locationInView(view)
            if view.pointInside(pt, withEvent: nil){
                isHave = true
            }
        }
        if !isHave {
            self.currentCenter = self.currentFullCell.center
            self.setVerCellCenter()
            self.verPanAnimation(500.00)
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
    
    var publishModel:CTAPublishModel{
        let publishModel = self.currentFullCell.publishModel
        return publishModel!
    }
    
    var userModel:CTAUserModel?{
        return self.loginUser
    }
    
    func likeButtonClick(sender: UIButton){
        if self.currentFullCell.publishModel != nil{
            self.likeHandler()
        }
    }
    
    func moreButtonClick(sender: UIButton){
        if self.currentFullCell.publishModel != nil{
            if self.viewUser?.userID != self.loginUser!.userID{
               self.moreSelectionHandler(false)
            }else {
               self.moreSelectionHandler(true)
            }
        }
    }
    
    func rebuildButtonClick(sender: UIButton){
        if self.currentFullCell.publishModel != nil{
            self.rebuildHandler()
        }
    }
    
    func userIconClick(sender: UIPanGestureRecognizer) {
        if self.userDetail == nil {
            self.userDetail = CTAUserDetailViewController()
        }
        let userID = self.loginUser == nil ? "" : self.loginUser!.userID
        self.showUserDetailView(self.viewUser, loginUserID: userID)
    }
    
    func deleteHandler(){
        if let publish = self.currentFullCell.publishModel{
            self.showSelectedAlert(NSLocalizedString("AlertTitleDeleteFile", comment: ""), alertMessage: "", okAlertLabel: NSLocalizedString("DeleteFileLabel", comment: ""), cancelAlertLabel: NSLocalizedString("AlertCancelLabel", comment: ""), compelecationBlock: { (result) -> Void in
                if result{
                    self.showLoadingViewByView(nil)
                    let userID = self.loginUser == nil ? "" : self.viewUser!.userID
                    CTAPublishDomain.getInstance().deletePublishFile(publish.publishID, userID: userID, compelecationBlock: { (info) -> Void in
                        self.hideLoadingViewByView(nil)
                        if info.result{
                            let selectedIndex = self.getPublishIndex(self.selectedPublishID)
                            UIView.animateWithDuration(0.3, animations: { () -> Void in
                                self.currentFullCell.alpha = 0
                                }, completion: { (_) -> Void in
                                    self.nextCenter = self.nextFullCell.center
                                    self.preCenter = self.previousFullCell.center
                                    self.currentCenter = self.currentFullCell.center
                                    if selectedIndex < self.publishModelArray.count - 1 {
                                        self.currentFullCell.hidden = true
                                        self.horPanAnimation(-1)
                                    }else {
                                        self.horPanAnimation(1)
                                    }
                                    self.publishModelArray.removeAtIndex(selectedIndex)
                            })
                        }
                    })
                }
            })
        }
    }
}

extension CTAPublishDetailViewController: CTAAddBarProtocol{
    func addBarViewClick(sender: UIPanGestureRecognizer) {
        self.showEditView()
    }
}