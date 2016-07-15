//
//  CTAHomeViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAHomeViewController: UIViewController, CTAPublishCellProtocol, CTALoginProtocol, CTAPublishCacheProtocol{

    var currentPublishIndex:Int = -1
    var publishModelArray:Array<CTAPublishModel> = []

    var userIconImage:UIImageView = UIImageView()
    var userNicknameLabel:UILabel = UILabel()
    var likeButton:UIButton = UIButton()
    var moreButton:UIButton = UIButton()
    var rebuildButton:UIButton = UIButton()
    var publishDateLabel:UILabel = UILabel()
    
    var horSpace:CGFloat = 0.0;
    var verSpace:CGFloat = 0.0
    var handView:UIView!
    var currentFullCell:CTAFullPublishesCell!
    var nextFullCell:CTAFullPublishesCell!
    var nextMoreCell:CTAFullPublishesCell!
    var preFullCell:CTAFullPublishesCell!
    
    var viewUserID:String = ""
    var loginUser:CTAUserModel?
    var isAddNew:Bool = false
    
    var isDisMis:Bool = true
    var isLoadLocal:Bool = false
    var loadDataCompleteFuc:((CTADomainListInfo!)->Void)?
    
    var beganLocation: CGPoint! = CGPoint(x: 0, y: 0)
    var panDirection:CTAPanDirection = .None
    var panHorDirection:CTAPanHorDirection = .None
    
    var loadMoreChangeView:Bool = false
    
    var loadingImageView:UIImageView? = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 80))
    
    var shadeView:UIView!
    
    var isAddOber:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initView()
        self.view.backgroundColor = CTAStyleKit.lightGrayBackgroundColor
        if !self.isAddOber{
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CTAHomeViewController.addNewPublish(_:)), name: "publishEditFile", object: nil)
            self.isAddOber = true
        }
    }
    
    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.isDisMis{
            self.reloadView()
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CTAHomeViewController.reloadViewHandler(_:)), name: "loginComplete", object: nil)

        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.isDisMis{
            self.viewAppearBegin()
        }
        self.isDisMis = false
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.loginUser = nil
        self.isDisMis = true
        self.hideLoadingView()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "loginComplete", object: nil)
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
        let bounds = UIScreen.mainScreen().bounds
        let fullSize = self.getCellSize()
        self.horSpace = 10*self.getHorRate()
        self.verSpace = 5*self.getHorRate()
        self.handView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: bounds.width, height: fullSize.height+(self.verSpace*3 + 6)))
        self.handView.center = CGPoint.init(x: bounds.width/2, y: bounds.height/2)
        self.handView.backgroundColor = UIColor.clearColor()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(CTAHomeViewController.viewPanHandler(_:)))
        pan.minimumNumberOfTouches = 1
        pan.maximumNumberOfTouches = 1
        self.handView.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(CTAHomeViewController.viewTapHandler(_:)))
        tap.numberOfTapsRequired=2
        tap.numberOfTouchesRequired=1
        self.handView.addGestureRecognizer(tap)
        self.view.addSubview(self.handView)
        
        self.nextMoreCell = CTAFullPublishesCell.init(frame: CGRect.init(x: (bounds.width - fullSize.width*2)/2, y: 0, width: fullSize.width, height: fullSize.height))
        self.handView.addSubview(self.nextMoreCell!)
        self.nextMoreCell.animationEnable = true
        self.nextMoreCell.publishModel = nil
        
        self.nextFullCell = CTAFullPublishesCell.init(frame: CGRect.init(x: (bounds.width - fullSize.width)/2, y: 0, width: fullSize.width, height: fullSize.height))
        self.handView.addSubview(self.nextFullCell!)
        self.nextFullCell.animationEnable = true
        self.nextFullCell.publishModel = nil
        
        self.currentFullCell = CTAFullPublishesCell.init(frame: CGRect.init(x: (bounds.width - fullSize.width)/2, y: 0, width: fullSize.width, height: fullSize.height))
        self.handView.addSubview(self.currentFullCell!)
        self.currentFullCell.animationEnable = true
        self.currentFullCell.publishModel = nil
        
        self.preFullCell = CTAFullPublishesCell.init(frame: CGRect.init(x: bounds.width, y: bounds.height, width: fullSize.width, height: fullSize.height))
        self.handView.addSubview(self.preFullCell!)
        self.preFullCell.animationEnable = true
        self.preFullCell.publishModel = nil
        
        let shadeFrame = self.nextMoreCell.frame
        self.shadeView = UIView.init(frame: CGRect.init(x: shadeFrame.origin.x, y: shadeFrame.origin.y+shadeFrame.height-15, width: shadeFrame.width - 26, height: 20))
        self.shadeView.frame.size.width = fullSize.width  - self.horSpace*6
        self.handView.addSubview(self.shadeView)
        addCellShadow(self.shadeView)
        self.shadeView.superview?.sendSubviewToBack(self.shadeView)
        self.setCellsPosition()
        
        let userButton = UIButton.init(frame: CGRect.init(x: bounds.size.width - 45, y: 2, width: 40, height: 40))
        userButton.setImage(UIImage.init(named: "userview-button"), forState: .Normal)
        userButton.setImage(UIImage.init(named: "userview-selected-button"), forState: .Highlighted)
        userButton.addTarget(self, action: #selector(CTAHomeViewController.userButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(userButton)
        self.initPublishSubView(self.handView.frame, horRate: self.getHorRate())
        self.likeButton.addTarget(self, action: #selector(CTAHomeViewController.likeButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.moreButton.addTarget(self, action: #selector(CTAHomeViewController.moreButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.rebuildButton.addTarget(self, action: #selector(CTAHomeViewController.rebuildButtonClick(_:)), forControlEvents: .TouchUpInside)
        let iconTap = UITapGestureRecognizer(target: self, action: #selector(CTAHomeViewController.userIconClick(_:)))
        self.userIconImage.addGestureRecognizer(iconTap)
        self.publishDateLabel.hidden = true
    }
    
    func setCellsPosition(){
        let bounds = UIScreen.mainScreen().bounds
        let fullSize = self.getCellSize()
        var rateW  = (fullSize.width  - self.horSpace*4)/fullSize.width
        var rateH = (fullSize.height - self.horSpace*4)/fullSize.height
        self.nextMoreCell.center = CGPoint.init(x: bounds.width/2, y: (self.horSpace+self.verSpace)*2+fullSize.height/2)
        self.nextMoreCell.transform = CGAffineTransformMakeScale(rateW, rateH)
        self.nextMoreCell.setViewColor(UIColor.init(red: 194/255, green: 194/255, blue: 194/255, alpha: 1))
        self.nextMoreCell.alpha = 1
        
        rateW  = (fullSize.width  - self.horSpace*2)/fullSize.width
        rateH = (fullSize.height - self.horSpace*2)/fullSize.height
        self.nextFullCell.center = CGPoint.init(x: bounds.width/2, y: self.horSpace+self.verSpace+fullSize.height/2)
        self.nextFullCell.transform = CGAffineTransformMakeScale(rateW, rateH)
        self.nextFullCell.setViewColor(UIColor.init(red: 180/255, green: 180/255, blue: 180/255, alpha: 1))
        self.nextFullCell.alpha = 1
        
        rateW  = 1
        rateH = 1
        self.currentFullCell.center = CGPoint.init(x: bounds.width/2, y: fullSize.height/2)
        self.currentFullCell.transform = CGAffineTransformMakeScale(rateW, rateH)
        self.currentFullCell.removeViewColor()
        self.currentFullCell.alpha = 1
        
        rateW  = 1
        rateH = 1
        self.preFullCell.center = CGPoint.init(x: bounds.width*3/2, y: fullSize.height*3/2)
        self.preFullCell.transform = CGAffineTransformMakeScale(rateW, rateH)
        self.preFullCell.removeViewColor()
        self.preFullCell.alpha = 1
        
        self.shadeView.center = CGPoint.init(x: bounds.width/2, y: self.nextFullCell.frame.origin.y+self.nextFullCell.frame.height-5)
    }
    
    func getCellSize() -> CGSize{
        let fullWidth  = 367 * self.getHorRate()
        let fullHeight:CGFloat = fullWidth
        let fullSize = CGSize.init(width: fullWidth, height: fullHeight)
        return fullSize
    }
    
    func getLoadCellData(){
        let userID = (self.loginUser == nil) ? "" : self.loginUser!.userID
        #if DEBUG
            let request = CTANewPublishListRequest.init(userID: userID, start: 0)
        #else
            let request = CTAHotPublishListRequest.init(userID: userID, start: 0)
        #endif
        let data = self.getPublishArray(request)
        if data == nil {
            self.isLoadLocal = false
        }else {
            self.isLoadLocal = true
            self.publishModelArray = data!
        }
    }
    
    func getLoginUser(){
        if CTAUserManager.isLogin {
            self.loginUser = CTAUserManager.user
        }else {
            self.loginUser = nil
        }
    }
    
    func addNewPublish(noti: NSNotification){
        self.isAddNew = true
    }
    
    func reloadViewHandler(noti: NSNotification){
        self.getLoginUser()
        self.viewUserID = (self.loginUser == nil) ? "-1" : self.loginUser!.userID
        self.loadNewCellData()
    }
    
    func reloadView(){
        self.setCellsPosition()
        self.getLoginUser()
        let userID = (self.loginUser == nil) ? "-1" : self.loginUser!.userID
        if userID != self.viewUserID {
            self.getLoadCellData()
            if !self.isLoadLocal{
                self.resetView()
                self.publishModelArray.removeAll()
            }else {
                self.currentPublishIndex = 0
                self.setCellPublishModel()
            }
        }
    }
    
    func viewAppearBegin(){
        let userID = (self.loginUser == nil) ? "-1" : self.loginUser!.userID
        if userID != self.viewUserID {
            self.viewUserID = userID
            if !self.isLoadLocal{
                self.firstLoadCellData()
            }else {
                self.loadNewCellData()
            }
        }else if self.isAddNew{
            self.loadNewCellData()
            self.isAddNew = false
        }
    }
    
    func resetView(){
        self.changeDetailUser()
        self.nextFullCell.hidden = true
        self.nextFullCell.publishModel = nil
        self.nextMoreCell.hidden = true
        self.nextMoreCell.publishModel = nil
        self.currentFullCell.publishModel = nil
        self.preFullCell.publishModel = nil
        self.changeViewButtonStatus(false)
    }
    
    func changeViewButtonStatus(isEnable:Bool){
        let subViews = self.view.subviews
        for i in 0..<subViews.count{
            let subView = subViews[i]
            if subView is UIButton{
                (subView as! UIButton).enabled = isEnable
            }
        }
    }
    
    func firstLoadCellData(){
        self.loadDataCompleteFuc = self.firstLoadComplete
        self.loadingImageView?.frame.size = CGSize(width: 80, height: 80)
        self.showLoadingViewByRect(self.handView.frame)
        self.loadNewPublishes(0)
    }
    
    func firstLoadComplete(info:CTADomainListInfo!){
        self.hideLoadingView()
        self.changeViewButtonStatus(true)
        if info.result {
            let modelArray = info.modelArray
            if self.loadFirstModelArray(modelArray!){
                self.currentPublishIndex = 0
                self.setCellPublishModel()
            }
        }else{
            self.loadDataError(info.errorType)
        }
    }
    
    func loadNewCellData(){
        self.firstLoadViewMove(40)
        self.showLoadingView()
        self.loadDataCompleteFuc = self.loadNewComplete
        self.loadNewPublishes(0)
    }
    
    func loadNewComplete(info:CTADomainListInfo!){
        self.resetFirstLoadView({ () -> Void in
            self.hideLoadingView()
        })
        if info.result {
            let modelArray = info.modelArray
            self.loadFirstModelArray(modelArray!)
            self.currentPublishIndex = 0
            self.setCellPublishModel()
//            if self.loadFirstModelArray(modelArray!){
//                self.currentPublishIndex = 0
//                self.setCellPublishModel()
//            }else {
//                self.setCellsPosition()
//            }
        }else {
            self.setCellsPosition()
        }
    }

    func loadMoreCellData(isChangeView:Bool){
        self.loadMoreChangeView = isChangeView
        self.loadDataCompleteFuc = self.loadMoreComplete
        self.loadNewPublishes(self.publishModelArray.count)
    }
    
    func loadMoreComplete(info:CTADomainListInfo!){
        if info.result {
            let modelArray = info.modelArray
            self.loadMoreModelArray(modelArray!)
            if self.loadMoreChangeView{
                self.setCellPublishModel()
            }
        }
    }
    
    
    func loadFirstModelArray(modelArray:Array<AnyObject>) -> Bool{
        var isChange = false
        if modelArray.count > 0{
            if self.publishModelArray.count > 0{
                for i in 0..<modelArray.count{
                    let newmodel = modelArray[i] as! CTAPublishModel
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
                    for j in 0..<modelArray.count{
                        if j > self.publishModelArray.count{
                            isChange = true
                            break
                        }else {
                            let oldModel = self.publishModelArray[j]
                            if !self.checkPublishModelIsHave(oldModel.publishID, publishArray: modelArray as! Array<CTAPublishModel>){
                                isChange = true
                                break
                            }
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
            self.publishModelArray.removeAll()
            self.loadMoreModelArray(modelArray)
            self.saveArrayToLocaol()
            return true
        }else {
            return false
        }
    }
    
    func loadMoreModelArray(modelArray:Array<AnyObject>){
        for i in 0..<modelArray.count{
            let publishModel = modelArray[i] as! CTAPublishModel
            if !self.checkPublishModelIsHave(publishModel.publishID, publishArray: self.publishModelArray){
                 self.publishModelArray.append(publishModel)
            }else {
                let index = self.getPublishIndex(publishModel.publishID, publishArray: self.publishModelArray)
                if index != -1 {
                    self.publishModelArray.removeAtIndex(index)
                    self.publishModelArray.append(publishModel)
                }
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
    
    func loadDataError(error:ErrorType?){
        if error != nil {
            if error is CTAInternetError {
                self.showSingleAlert(NSLocalizedString("AlertTitleInternetError", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                })
            }else {
                let error = error as! CTAPublishListError
                if error == .DataIsEmpty{
                    self.showSingleAlert(NSLocalizedString("AlertTitleDataNil", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                    })
                }else {
                    self.showSingleAlert(NSLocalizedString("AlertTitleConnectUs", comment: ""), alertMessage: "", compelecationBlock: { () -> Void in
                    })
                }
            }
        }
    }
    
    func setCellPublishModel(){
        self.setCellsPosition()
        if self.currentPublishIndex < self.publishModelArray.count && self.currentPublishIndex > -1{
            let currentModel = self.publishModelArray[self.currentPublishIndex]
            self.changePublishView(currentModel)
            self.currentFullCell.superview?.bringSubviewToFront(self.currentFullCell)
            self.currentFullCell.hidden = false
            if self.currentFullCell.publishModel != nil && self.currentFullCell.publishModel!.publishID == currentModel.publishID{
                self.currentFullCell.playAnimation()
            }else {
                self.currentFullCell.publishModel = currentModel
                self.currentFullCell.playAnimation()
            }
            self.setLikeButtonStyle()
            
            self.preFullCell.superview?.bringSubviewToFront(self.preFullCell)
            self.preFullCell.hidden = false
            if self.currentPublishIndex > 0 {
                let preModel = self.publishModelArray[self.currentPublishIndex-1]
                if self.preFullCell.publishModel != nil && self.preFullCell.publishModel!.publishID == preModel.publishID{
                    self.preFullCell.stopAnimation()
                }else {
                    self.preFullCell.publishModel = preModel
                }
            }else {
                self.preFullCell.publishModel = nil
            }
            
            self.nextFullCell.superview?.sendSubviewToBack(self.nextFullCell)
            if self.currentPublishIndex < self.publishModelArray.count - 1{
                let nextModel = self.publishModelArray[self.currentPublishIndex+1]
                if self.nextFullCell.publishModel != nil && self.nextFullCell.publishModel!.publishID == nextModel.publishID{
                    self.nextFullCell.stopAnimation()
                }else {
                    self.nextFullCell.publishModel = nextModel
                }
                if self.nextFullCell.hidden {
                    self.showCellAnimation(self.nextFullCell)
                }
            }else {
                self.nextFullCell.hidden = true
                self.nextFullCell.publishModel = nil
            }
            
            self.nextMoreCell.superview?.sendSubviewToBack(self.nextMoreCell)
            if self.currentPublishIndex < self.publishModelArray.count - 2{
                let nextMoreModel = self.publishModelArray[self.currentPublishIndex+2]
                if self.nextMoreCell.publishModel != nil && self.nextMoreCell.publishModel!.publishID == nextMoreModel.publishID{
                    self.nextMoreCell.stopAnimation()
                }else {
                    self.nextMoreCell.publishModel = nextMoreModel
                }
                if self.nextMoreCell.hidden == true {
                    self.showCellAnimation(self.nextMoreCell)
                }
            }else {
                self.nextMoreCell.hidden = true
                self.nextMoreCell.publishModel = nil
            }
            self.shadeView.superview?.sendSubviewToBack(self.shadeView)
        }else {
            self.resetView()
        }
    }
    
    func showCellAnimation(cell:UIView){
        cell.alpha = 0
        cell.hidden = false
        UIView.animateWithDuration(0.2) { () -> Void in
            cell.alpha = 1
        }
    }
    
    
    func loadNewPublishes(startIndex:Int){
        let userID = (self.loginUser == nil) ? "" : self.loginUser!.userID
        
        #if DEBUG
            CTAPublishDomain.getInstance().newPublishList(userID, start: startIndex) { (info) -> Void in
                if self.loadDataCompleteFuc != nil{
                    self.loadDataCompleteFuc!(info)
                }
            }
        #else
            CTAPublishDomain.getInstance().hotPublishList(userID, start: startIndex) { (info) in
                if self.loadDataCompleteFuc != nil{
                    self.loadDataCompleteFuc!(info)
                }
            }
        #endif
        
    }
    
    func saveArrayToLocaol(){
        let userID = (self.loginUser == nil) ? "" : self.loginUser!.userID
        
        #if DEBUG
            let request = CTANewPublishListRequest.init(userID: userID, start: 0)
        #else
            let request = CTAHotPublishListRequest.init(userID: userID, start: 0)
        #endif
        
        var savePublishModel:Array<CTAPublishModel> = []
        if self.publishModelArray.count < 40 {
            savePublishModel = self.publishModelArray
        }else {
            let slice = self.publishModelArray[0...40]
            savePublishModel = Array(slice)
        }
        self.savePublishArray(request, modelArray: savePublishModel)
    }
    
    func viewTapHandler(sender: UITapGestureRecognizer) {
        if self.loginUser != nil && self.currentFullCell.publishModel != nil{
            self.likeHandler(true)
        }
    }
    
    func viewPanHandler(sender: UIPanGestureRecognizer) {
        switch sender.state{
        case .Began:
            self.beganLocation = sender.locationInView(view)
            self.panDirection = .None
        case .Changed:
            let newLocation = sender.locationInView(view)
            if self.panDirection == .None {
                if abs(newLocation.x - self.beganLocation!.x)*5 > abs(newLocation.y - self.beganLocation!.y){
                    self.panDirection = .Hor
                    self.panHorDirection = .None
                    self.viewHorPanHandler(newLocation)
                }else {
                    self.panDirection = .Ver
                    self.viewVerPanHandler(newLocation)
                }
            }else if self.panDirection == .Hor{
                self.viewHorPanHandler(newLocation)
            }else if self.panDirection == .Ver{
                self.viewVerPanHandler(newLocation)
            }
        case .Ended, .Cancelled, .Failed:
            let velocity = sender.velocityInView(view)
            let newLocation = sender.locationInView(view)
            if self.panDirection == .Hor {
                if velocity.x > 500 || velocity.x < -500{
                    self.horPanAnimation(velocity.x)
                }else {
                    self.viewHorComplete(newLocation)
                }
                self.beganLocation = CGPoint(x: 0, y: 0)
                self.panHorDirection = .None
            }else if self.panDirection == .Ver {
                if velocity.y > 500 || velocity.y < -500{
                    self.verPanAnimation(velocity.y)
                }else {
                   self.viewVerComplete(newLocation)
                }
                
            }
        default:
            ()
        }
    }
    
    func viewHorPanHandler(location:CGPoint){
        let bounds = UIScreen.mainScreen().bounds
        let fullSize = self.getCellSize()
        let maxX = bounds.width/2 + fullSize.width*2/3
        let maxY = (bounds.width-fullSize.width)
        let maxR:CGFloat = 30.00
        var xChange = location.x - self.beganLocation.x
        if xChange > 0{
            self.panHorDirection = .Next
            var percent = xChange / maxX
            if self.currentPublishIndex > self.publishModelArray.count - 2 {
                xChange = 0
                percent = 0
            }
            let rChange = 0+maxR*percent
            let rChangePI=rChange/360*CGFloat(M_PI)
            let yChange = abs(percent*maxY)
            self.currentFullCell.transform = CGAffineTransformMakeRotation(rChangePI)
            self.currentFullCell.center = CGPoint.init(x: bounds.width/2+xChange, y: fullSize.height/2+yChange)
            
            let nextHor = self.horSpace*percent
            let nextVer = self.verSpace*percent
            self.changeCellSizeBySpace(nextHor, verSpace: nextVer, ischangeCurrent: false)
            self.changeViewColor(percent)
        }else {
            self.panHorDirection = .Previous
            if self.currentPublishIndex > 0 {
                xChange = maxX+xChange
                let percent = xChange / maxX
                let rChange = 0+maxR*percent
                let rChangePI=rChange/360*CGFloat(M_PI)
                let yChange = abs(percent*maxY)
                self.preFullCell.transform = CGAffineTransformMakeRotation(rChangePI)
                self.preFullCell.center = CGPoint.init(x: bounds.width/2+xChange, y: fullSize.height/2+yChange)
                
                let nextHor = self.horSpace*percent - self.horSpace
                let nextVer = self.verSpace*percent - self.verSpace
                self.changeCellSizeBySpace(nextHor, verSpace: nextVer, ischangeCurrent: true)
                self.changeViewColor(percent)
            }else {
                //self.firstLoadViewMove(0-xChange/4)
            }
        }
    }
    
    func viewVerPanHandler(location:CGPoint){
        let yChange = location.y - self.beganLocation.y
        if yChange > 0{
            self.firstLoadViewMove(yChange/4)
        }
    }
    
    func viewVerComplete(newLocation:CGPoint){
        let yRate = newLocation.y - beganLocation.y
        if yRate >= 20{
            self.loadNewCellData()
        }else {
            self.resetFirstLoadView({ () -> Void in
                self.horPanComplete(.Previous, isChange: false)
            })
        }
    }
    
    func verPanAnimation(yRate:CGFloat){
        if yRate > 0{
            self.loadNewCellData()
        }
    }
    
    func changeViewColor(percent:CGFloat){
        switch self.panHorDirection{
        case .Next:
            self.changeNextViewColor(percent)
        case .Previous:
            self.changePreViewColor(percent)
        default:
            ()
        }
    }

    func changeNextViewColor(percent:CGFloat){
        if !self.nextFullCell.hidden {
            self.nextFullCell.setViewColor(UIColor.init(red: 180/255, green: 180/255, blue: 180/255, alpha: 1*(1-percent)))
        }
        if !self.nextMoreCell.hidden {
            let rate = 194 - (194 - 180) * percent
            self.nextMoreCell.setViewColor(UIColor.init(red: rate/255, green: rate/255, blue: rate/255, alpha: 1))
        }
    }

    func changePreViewColor(percent:CGFloat){
        if !self.currentFullCell.hidden {
            self.currentFullCell.setViewColor(UIColor.init(red: 180/255, green: 180/255, blue: 180/255, alpha: 1*(1-percent)))
        }
        if !self.nextFullCell.hidden {
            let rate = 194 - (194 - 180) * percent
            self.nextFullCell.setViewColor(UIColor.init(red: rate/255, green: rate/255, blue: rate/255, alpha: 1))
        }
        if !self.nextMoreCell.hidden {
            self.nextMoreCell.alpha = 1*percent
        }
    }

    func viewHorComplete(newLocation:CGPoint){
        let maxDir = (UIScreen.mainScreen().bounds.width * 0.7)
        let xRate = newLocation.x - beganLocation.x
        if abs(xRate) >= maxDir/2 {
            self.horPanAnimation(xRate)
        }else {
            self.horPanResetAnimation(xRate)
        }
    }
    
    func horPanAnimation(xRate:CGFloat){
        let bounds = UIScreen.mainScreen().bounds
        let fullSize = self.getCellSize()
        let maxX = bounds.width/2 + fullSize.width*2/3
        let maxY = (bounds.width-fullSize.width)
        let maxR:CGFloat = 30.00
        if xRate > 0{
            if self.panHorDirection == .Next{
                if self.currentPublishIndex < self.publishModelArray.count - 1 {
                    let rChange = 0+maxR
                    let rChangePI=rChange/360*CGFloat(M_PI)
                    
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.currentFullCell.transform = CGAffineTransformMakeRotation(rChangePI)
                        self.currentFullCell.center = CGPoint.init(x: bounds.width/2+maxX, y: fullSize.height/2+maxY)
                        let nextHor = self.horSpace
                        let nextVer = self.verSpace
                        self.changeCellSizeBySpace(nextHor, verSpace: nextVer, ischangeCurrent: false)
                        self.changeViewColor(1)
                        }, completion: { (_) -> Void in
                            self.horPanComplete(.Next, isChange: true)
                    })
                }else {
                    self.horPanResetAnimation(xRate)
                    self.loadMoreCellData(true)
                }
            }
        }else {
            if self.panHorDirection == .Previous{
                if self.currentPublishIndex > 0 {
                    let rChange:CGFloat = 0
                    let rChangePI=rChange/360*CGFloat(M_PI)
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.preFullCell.transform = CGAffineTransformMakeRotation(rChangePI)
                        self.preFullCell.center = CGPoint.init(x: bounds.width/2, y: fullSize.height/2)
                        let nextHor = 0 - self.horSpace
                        let nextVer = 0 - self.verSpace
                        self.changeCellSizeBySpace(nextHor, verSpace: nextVer, ischangeCurrent: true)
                        self.changeViewColor(0)
                        }, completion: { (_) -> Void in
                            self.horPanComplete(.Previous, isChange: true)
                    })
                }else {
                    //self.loadNewCellData()
                }
            }
        }
    }
    
    func horPanResetAnimation(xRate:CGFloat){
        let bounds = UIScreen.mainScreen().bounds
        let fullSize = self.getCellSize()
        let maxX = bounds.width/2 + fullSize.width*2/3
        let maxY = (bounds.width-fullSize.width)
        let maxR:CGFloat = 30.00
        if xRate > 0{
            let rChange:CGFloat = 0.0
            let rChangePI=rChange/360*CGFloat(M_PI)
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.currentFullCell.transform = CGAffineTransformMakeRotation(rChangePI)
                self.currentFullCell.center = CGPoint.init(x: bounds.width/2, y: fullSize.height/2)
                self.changeCellSizeBySpace(0, verSpace: 0, ischangeCurrent: false)
                self.changeViewColor(0)
                }, completion: { (_) -> Void in
                    self.horPanComplete(.Next, isChange: false)
            })
        }else {
            if self.currentPublishIndex > 0 {
                let rChange = maxR
                let rChangePI=rChange/360*CGFloat(M_PI)
                let yChange = maxY
                let xChange = maxX
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.preFullCell.transform = CGAffineTransformMakeRotation(rChangePI)
                    self.preFullCell.center = CGPoint.init(x: bounds.width/2+xChange, y: fullSize.height/2+yChange)
                    self.changeCellSizeBySpace(0, verSpace: 0, ischangeCurrent: true)
                    self.changeViewColor(1)
                    }, completion: { (_) -> Void in
                        self.horPanComplete(.Previous, isChange: false)
                })
            }else {
//                self.resetFirstLoadView({ () -> Void in
//                    self.horPanComplete(.Previous, isChange: false)
//                })
            }
            
        }
    }
    
    func firstLoadViewMove(yMove:CGFloat){
        let bounds = UIScreen.mainScreen().bounds
        if !self.loadingImageView!.isDescendantOfView(self.view){
            self.view.addSubview(self.loadingImageView!)
            self.loadingImageView!.image = UIImage(named: "fresh-icon-1")
            self.loadingImageView!.frame = CGRect.init(x: bounds.width/2-20, y: self.handView.frame.origin.y, width: 40, height: 40)
            self.view.sendSubviewToBack(self.loadingImageView!)
        }
        var yChange = yMove
        let maxSpace:CGFloat = 40
        if yChange > maxSpace {
            yChange = maxSpace
        }
        self.handView.center = CGPoint.init(x: bounds.width/2, y: bounds.height/2+yChange)
    }
    
    func resetFirstLoadView(completion: (() -> Void)?){
        let bounds = UIScreen.mainScreen().bounds
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.handView.center = CGPoint.init(x: bounds.width/2, y: bounds.height/2)
            }, completion: { (_) -> Void in
                completion?()
        })
    }
    
    func changeCellSizeBySpace(horSpace:CGFloat, verSpace:CGFloat, ischangeCurrent:Bool){
        let bounds = UIScreen.mainScreen().bounds
        let fullSize = self.getCellSize()
        var rateW  = (fullSize.width  - self.horSpace*4 + horSpace*2)/fullSize.width
        var rateH = (fullSize.height - self.horSpace*4 + horSpace*2)/fullSize.height
        if !self.nextMoreCell.hidden {
            let point = self.nextMoreCell.center
            self.nextMoreCell.center = CGPoint.init(x: point.y, y: (point.y - verSpace))
            self.nextMoreCell.center = CGPoint(x: bounds.width/2, y: (self.horSpace+self.verSpace)*2+fullSize.height/2-(horSpace+verSpace))
            self.nextMoreCell.transform = CGAffineTransformMakeScale(rateW, rateH)
        }
        rateW  = (fullSize.width  - (self.horSpace-horSpace)*2)/fullSize.width
        rateH = (fullSize.height - (self.horSpace-horSpace)*2)/fullSize.height
        if !self.nextFullCell.hidden {
            self.nextFullCell.center = CGPoint(x: bounds.width/2, y: (self.horSpace+self.verSpace)+fullSize.height/2-(horSpace+verSpace))
            self.nextFullCell.transform = CGAffineTransformMakeScale(rateW, rateH)
        }
        if ischangeCurrent{
            rateW  = (fullSize.width + horSpace*2)/fullSize.width
            rateH = (fullSize.height + horSpace*2)/fullSize.height
            if !self.currentFullCell.hidden {
                self.currentFullCell.center = CGPoint.init(x: bounds.width/2, y: fullSize.height/2-(horSpace+verSpace))
                self.currentFullCell.transform = CGAffineTransformMakeScale(rateW, rateH)
            }
        }
    }
    
    func horPanComplete(dir:CTAPanHorDirection, isChange:Bool){
        if isChange {
            self.currentFullCell!.stopAnimation()
            if dir == .Next{
                let currentFull = self.currentFullCell
                self.currentFullCell = self.nextFullCell
                self.nextFullCell = self.nextMoreCell
                self.nextMoreCell = self.preFullCell
                self.preFullCell = currentFull
                self.currentPublishIndex+=1
                if self.currentPublishIndex > self.publishModelArray.count-1{
                    self.currentPublishIndex = self.publishModelArray.count-1
                }
                if self.currentPublishIndex > self.publishModelArray.count-5{
                    self.loadMoreCellData(false)
                }
            }else if dir == .Previous{
                let currentFull = self.currentFullCell
                self.currentFullCell = self.preFullCell
                self.preFullCell = self.nextMoreCell
                self.nextMoreCell = self.nextFullCell
                self.nextFullCell = currentFull
                self.currentPublishIndex-=1
                if self.currentPublishIndex < 0{
                    self.currentPublishIndex = 0
                }
            }
            self.setCellPublishModel()
        }else {
            self.setCellsPosition()
            //self.currentFullCell!.playAnimation()
        }
    }
    
    func userButtonClick(sender: UIButton){
        if self.loginUser == nil {
            self.showLoginView(false)
        }else {
           NSNotificationCenter.defaultCenter().postNotificationName("changePageView", object: 1)
        }
    }
}

extension CTAHomeViewController: CTAPublishProtocol{
    
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
        if self.loginUser == nil {
            self.showLoginView(false)
        }else if self.currentFullCell.publishModel != nil{
            self.likeHandler(false)
        }
    }
    
    func moreButtonClick(sender: UIButton){
        self.moreSelectionHandler(false)
    }
    
    func rebuildButtonClick(sender: UIButton){
        if self.loginUser == nil {
            self.showLoginView(false)
        }else if self.currentFullCell.publishModel != nil{
            self.rebuildHandler()
        }
    }
    
    func userIconClick(sender: UIPanGestureRecognizer) {
        if self.loginUser == nil {
            self.showLoginView(false)
        }else if let publishModel = self.currentFullCell.publishModel{
//            let viewUserModel = publishModel.userModel
//            let userPublish = CTAUserPublishesViewController()
//            userPublish.viewUser = viewUserModel
//            self.navigationController?.pushViewController(userPublish, animated: true)
        }
    }
}
