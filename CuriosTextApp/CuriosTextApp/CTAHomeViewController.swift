//
//  CTAHomeViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAHomeViewController: UIViewController, CTAPublishCellProtocol, CTALoginProtocol, CTALoadingProtocol, CTAAlertProtocol{

    var currentPublishIndex:Int = -1
    var publishModelArray:Array<CTAPublishModel> = []

    var userIconImage:UIImageView = UIImageView()
    var userNicknameLabel:UILabel = UILabel()
    var likeButton:UIButton = UIButton()
    
    var moreSpace:CGFloat = 0.0;
    var handView:UIView!
    var currentFullCell:CTAFullPublishesCell!
    var nextFullCell:CTAFullPublishesCell!
    var nextMoreCell:CTAFullPublishesCell!
    var preFullCell:CTAFullPublishesCell!
    
    var viewUserID:String = ""
    var loginUser:CTAUserModel?
    
    var isDisMis:Bool = true
    var isLoadLocal:Bool = false
    var loadDataCompleteFuc:((CTADomainListInfo!)->Void)?
    
    var beganLocation: CGPoint! = CGPoint(x: 0, y: 0)
    var panDirection:CTAPanHorDirection = .None
    
    
    
    var loadingImageView:UIImageView? = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 80))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initView()
        self.view.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.isDisMis{
            self.reloadView()
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
        self.moreSpace = 8*self.getHorRate()
        self.handView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: bounds.width, height: fullSize.height + moreSpace*2 + 5))
        self.handView.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2+7*self.getHorRate())
        self.handView.backgroundColor = UIColor.whiteColor()
        let pan = UIPanGestureRecognizer(target: self, action: "viewPanHandler:")
        self.handView.addGestureRecognizer(pan)
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
        
        self.setCellsPosition()
        
        let userButton = UIButton.init(frame: CGRect.init(x: bounds.size.width - 45, y: 2, width: 40, height: 40))
        userButton.setImage(UIImage.init(named: "userview-button"), forState: .Normal)
        userButton.setImage(UIImage.init(named: "userview-selected-button"), forState: .Highlighted)
        userButton.addTarget(self, action: "userButtonClick:", forControlEvents: .TouchUpInside)
        self.view.addSubview(userButton)
        self.initPublishSubView(self.handView.frame, horRate: self.getHorRate())
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginCompleteHandler:", name: "loginComplete", object: nil)
    }
    
    func setCellsPosition(){
        let bounds = UIScreen.mainScreen().bounds
        let fullSize = self.getCellSize()
        var rateW  = (fullSize.width  - moreSpace*2)/fullSize.width
        var rateH = (fullSize.height - moreSpace*2)/fullSize.height
        self.nextMoreCell.center = CGPoint.init(x: bounds.width/2, y: moreSpace*3+fullSize.height/2)
        self.nextMoreCell.transform = CGAffineTransformMakeScale(rateW, rateH)
        
        rateW  = (fullSize.width  - moreSpace)/fullSize.width
        rateH = (fullSize.height - moreSpace)/fullSize.height
        self.nextFullCell.center = CGPoint.init(x: bounds.width/2, y: moreSpace*1.5+fullSize.height/2)
        self.nextFullCell.transform = CGAffineTransformMakeScale(rateW, rateH)
        
        rateW  = 1
        rateH = 1
        self.currentFullCell.center = CGPoint.init(x: bounds.width/2, y: fullSize.height/2)
        self.currentFullCell.transform = CGAffineTransformMakeScale(rateW, rateH)
        
        rateW  = 1
        rateH = 1
        self.preFullCell.center = CGPoint.init(x: bounds.width*3/2, y: fullSize.height*3/2)
        self.preFullCell.transform = CGAffineTransformMakeScale(rateW, rateH)
    }
    
    func getCellSize() -> CGSize{
        let fullWidth  = 340 * self.getHorRate()
        let fullHeight:CGFloat = fullWidth
        let fullSize = CGSize.init(width: fullWidth, height: fullHeight)
        return fullSize
    }
    
    func getLoadCellData(){
        self.isLoadLocal = false
    }
    
    func getLoginUser(){
        if CTAUserManager.isLogin {
            self.loginUser = CTAUserManager.user
        }else {
            self.loginUser = nil
        }
    }
    
    func loginCompleteHandler(noti: NSNotification){
        self.reloadView()
        self.viewAppearBegin()
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
                
            }
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
        for var i=0; i<subViews.count; i++ {
            let subView = subViews[i]
            if subView is UIButton{
                (subView as! UIButton).enabled = isEnable
            }
        }
    }
    
    func firstLoadCellData(){
        self.publishModelArray.removeAll()
        self.loadDataCompleteFuc = self.firstLoadComplete
        self.loadingImageView?.frame.size = CGSize(width: 80, height: 80)
        self.showLoadingViewByRect(self.currentFullCell.bounds)
        self.loadNewPublishes(0)
    }
    
    func firstLoadComplete(info:CTADomainListInfo!){
        self.hideLoadingView()
        self.changeViewButtonStatus(true)
        if info.result {
            let modelArray = info.modelArray
            self.loadFirstModelArray(modelArray!)
            self.currentPublishIndex = 0
            self.setCellPublishModel()
        }else{
            self.loadDataError(info.errorType)
        }
    }
    
    func loadNewCellData(){
        self.loadDataCompleteFuc = self.loadNewComplete
        self.showLoadingView()
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
        }
    }
    
    func loadMoreCellData(){
        self.loadDataCompleteFuc = self.loadMoreComplete
        self.loadNewPublishes(self.publishModelArray.count)
    }
    
    func loadMoreComplete(info:CTADomainListInfo!){
        if info.result {
            let modelArray = info.modelArray
            self.loadMoreModelArray(modelArray!)
        }
    }
    
    
    func loadFirstModelArray(modelArray:Array<AnyObject>){
        var firstDataIndex = 0
        for var i=0; i < modelArray.count; i++ {
            let publishModel = modelArray[i] as! CTAPublishModel
            if !self.checkPublishModelIsHave(publishModel.publishID){
                if firstDataIndex < self.publishModelArray.count {
                    self.publishModelArray.insert(publishModel, atIndex: firstDataIndex)
                }else{
                    self.publishModelArray.append(publishModel)
                }
                firstDataIndex++
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
            self.changeUserView(currentModel.userModel)
            self.currentFullCell.superview?.bringSubviewToFront(self.currentFullCell)
            self.currentFullCell.hidden = false
            if self.currentFullCell.publishModel != nil && self.currentFullCell.publishModel!.publishID == currentModel.publishID{
                self.currentFullCell.playAnimation()
            }else {
                self.currentFullCell.publishModel = currentModel
                self.currentFullCell.playAnimation()
            }
            
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
        CTAPublishDomain.getInstance().newPublishList(userID, start: startIndex) { (info) -> Void in
            if self.loadDataCompleteFuc != nil{
                self.loadDataCompleteFuc!(info)
            }
        }
    }
    
    func viewPanHandler(sender: UIPanGestureRecognizer) {
        switch sender.state{
        case .Began:
            self.beganLocation = sender.locationInView(view)
            self.panDirection = .None
            self.currentFullCell.pauseAnimation()
        case .Changed:
            let newLocation = sender.locationInView(view)
            self.viewHorPanHandler(newLocation)
        case .Ended, .Cancelled, .Failed:
            let velocity = sender.velocityInView(view)
            let newLocation = sender.locationInView(view)
            if velocity.x > 500 || velocity.x < -500{
                self.horPanAnimation(velocity.x)
            }else {
                self.viewHorComplete(newLocation)
            }
            self.beganLocation = CGPoint(x: 0, y: 0)
            self.panDirection = .None
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
            self.panDirection = .Next
            let percent = xChange / maxX
            let rChange = 0+maxR*percent
            var rChangePI=rChange/360*CGFloat(M_PI)
            var yChange = abs(percent*maxY)
            if self.currentPublishIndex > self.publishModelArray.count - 2 {
                xChange = xChange/4
                yChange = yChange/4
                rChangePI = rChangePI/4
            }
            self.currentFullCell.transform = CGAffineTransformMakeRotation(rChangePI)
            self.currentFullCell.center = CGPoint.init(x: bounds.width/2+xChange, y: fullSize.height/2+yChange)
            
            let nextSizeChange = self.moreSpace*percent
            self.changeCellSizeBySpace(nextSizeChange, ischangeCurrent: false)
        }else {
            self.panDirection = .Previous
            if self.currentPublishIndex > 0 {
                xChange = maxX+xChange
                let percent = xChange / maxX
                let rChange = 0+maxR*percent
                let rChangePI=rChange/360*CGFloat(M_PI)
                let yChange = abs(percent*maxY)
                self.preFullCell.transform = CGAffineTransformMakeRotation(rChangePI)
                self.preFullCell.center = CGPoint.init(x: bounds.width/2+xChange, y: fullSize.height/2+yChange)
                
                let nextSizeChange = self.moreSpace*percent - self.moreSpace
                self.changeCellSizeBySpace(nextSizeChange, ischangeCurrent: true)
            }else {
                if !self.loadingImageView!.isDescendantOfView(self.view){
                    self.view.addSubview(self.loadingImageView!)
                    self.loadingImageView?.image = UIImage(named: "fresh-icon-1")
                    self.loadingImageView?.frame = CGRect.init(x: bounds.width, y: self.handView.frame.origin.y+self.handView.frame.height/2-20, width: 40, height: 40)
                }
                xChange = xChange/4
                self.currentFullCell.center = CGPoint.init(x: bounds.width/2+xChange, y: fullSize.height/2)
                self.nextMoreCell.center = CGPoint.init(x: bounds.width/2+xChange, y: moreSpace*3+fullSize.height/2)
                self.nextFullCell.center = CGPoint.init(x: bounds.width/2+xChange, y: moreSpace*1.5+fullSize.height/2)
                self.loadingImageView?.center = CGPoint.init(x: bounds.width+xChange+20, y: self.handView.frame.origin.y+self.handView.frame.height/2)
            }
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
            if self.panDirection == .Next{
                if self.currentPublishIndex < self.publishModelArray.count - 1 {
                    let rChange = 0+maxR
                    let rChangePI=rChange/360*CGFloat(M_PI)
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.currentFullCell.transform = CGAffineTransformMakeRotation(rChangePI)
                        self.currentFullCell.center = CGPoint.init(x: bounds.width/2+maxX, y: fullSize.height/2+maxY)
                        let nextSizeChange = self.moreSpace
                        self.changeCellSizeBySpace(nextSizeChange, ischangeCurrent: false)
                        }, completion: { (_) -> Void in
                            self.horPanComplete(.Next, isChange: true)
                    })
                }else {
                    self.horPanResetAnimation(xRate)
                }
            }
        }else {
            if self.panDirection == .Previous{
                if self.currentPublishIndex > 0 {
                    let rChange:CGFloat = 0
                    let rChangePI=rChange/360*CGFloat(M_PI)
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.preFullCell.transform = CGAffineTransformMakeRotation(rChangePI)
                        self.preFullCell.center = CGPoint.init(x: bounds.width/2, y: fullSize.height/2)
                        
                        let nextSizeChange = 0 - self.moreSpace
                        self.changeCellSizeBySpace(nextSizeChange, ischangeCurrent: true)
                        }, completion: { (_) -> Void in
                            self.horPanComplete(.Previous, isChange: true)
                    })
                }else {
                    self.loadNewCellData()
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
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.currentFullCell.transform = CGAffineTransformMakeRotation(rChangePI)
                self.currentFullCell.center = CGPoint.init(x: bounds.width/2, y: fullSize.height/2)
                
                self.changeCellSizeBySpace(0, ischangeCurrent: false)
                }, completion: { (_) -> Void in
                    self.horPanComplete(.Next, isChange: false)
            })
        }else {
            if self.currentPublishIndex > 0 {
                let rChange = maxR
                let rChangePI=rChange/360*CGFloat(M_PI)
                let yChange = maxY
                let xChange = maxX
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.preFullCell.transform = CGAffineTransformMakeRotation(rChangePI)
                    self.preFullCell.center = CGPoint.init(x: bounds.width/2+xChange, y: fullSize.height/2+yChange)
                    
                    self.changeCellSizeBySpace(0, ischangeCurrent: true)
                    }, completion: { (_) -> Void in
                        self.horPanComplete(.Previous, isChange: false)
                })
            }else {
                self.resetFirstLoadView({ () -> Void in
                    self.horPanComplete(.Previous, isChange: false)
                })
            }
            
        }
    }
    
    func resetFirstLoadView(completion: (() -> Void)?){
        let bounds = UIScreen.mainScreen().bounds
        let fullSize = self.getCellSize()
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.currentFullCell.center = CGPoint.init(x: bounds.width/2, y: fullSize.height/2)
            self.nextMoreCell.center = CGPoint.init(x: bounds.width/2, y: self.moreSpace*3+fullSize.height/2)
            self.nextFullCell.center = CGPoint.init(x: bounds.width/2, y: self.moreSpace*1.5+fullSize.height/2)
            self.loadingImageView?.center = CGPoint.init(x: bounds.width+20, y: self.handView.frame.origin.y+self.handView.frame.height/2)
            }, completion: { (_) -> Void in
                if completion != nil{
                    completion!()
                }
        })
    }
    
    func changeCellSizeBySpace(space:CGFloat, ischangeCurrent:Bool){
        let bounds = UIScreen.mainScreen().bounds
        let fullSize = self.getCellSize()
        var rateW  = (fullSize.width  - self.moreSpace*2 + space)/fullSize.width
        var rateH = (fullSize.height - self.moreSpace*2 + space)/fullSize.height
        if !self.nextMoreCell.hidden {
            self.nextMoreCell.center = CGPoint.init(x: bounds.width/2, y: (self.moreSpace*6+fullSize.height-space*3)/2)
            self.nextMoreCell.transform = CGAffineTransformMakeScale(rateW, rateH)
        }
        rateW  = (fullSize.width  - self.moreSpace+space)/fullSize.width
        rateH = (fullSize.height - self.moreSpace+space)/fullSize.height
        if !self.nextFullCell.hidden {
            self.nextFullCell.center = CGPoint.init(x: bounds.width/2, y: (self.moreSpace*3+fullSize.height-space*3)/2)
            self.nextFullCell.transform = CGAffineTransformMakeScale(rateW, rateH)
        }
        if ischangeCurrent{
            rateW  = (fullSize.width + space)/fullSize.width
            rateH = (fullSize.height + space)/fullSize.height
            if !self.currentFullCell.hidden {
                self.currentFullCell.center = CGPoint.init(x: bounds.width/2, y: (fullSize.height-space*3)/2)
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
                self.nextMoreCell = currentFull
                self.currentPublishIndex++
                if self.currentPublishIndex > self.publishModelArray.count-1{
                    self.currentPublishIndex = self.publishModelArray.count-1
                }
                if self.currentPublishIndex > self.publishModelArray.count-5{
                    self.loadMoreCellData()
                }
            }else if dir == .Previous{
                let currentFull = self.currentFullCell
                self.currentFullCell = self.preFullCell
                self.preFullCell = self.nextMoreCell
                self.nextMoreCell = self.nextFullCell
                self.nextFullCell = currentFull
                self.currentPublishIndex--
                if self.currentPublishIndex < 0{
                    self.currentPublishIndex = 0
                }
            }
            self.setCellPublishModel()
        }else {
            self.setCellsPosition()
            self.currentFullCell!.playAnimation()
        }
    }
    
    func userButtonClick(sender: UIButton){
        if self.loginUser == nil {
            self.showLoginView()
        }else {
           NSNotificationCenter.defaultCenter().postNotificationName("changePageView", object: 1)
        }
    }
}

extension CTAHomeViewController: CTAPublishProtocol{
    func likeButtonClick(sender: UIButton){
        if self.loginUser == nil {
            self.showLoginView()
        }else if let publishModel = self.currentFullCell.publishModel{
            self.likeHandler(self.loginUser!.userID, publishModel: publishModel)
        }
    }
    
    func moreButtonClick(sender: UIButton){
        if self.loginUser == nil {
            self.showLoginView()
        }else if let publishModel = self.currentFullCell.publishModel{
            self.moreSelectionHandler(self.loginUser!.userID, publishModel: publishModel)
        }
    }
    
    func rebuildButtonClick(sender: UIButton){
        if self.loginUser == nil {
            self.showLoginView()
        }else if let publishModel = self.currentFullCell.publishModel{
            self.rebuildHandler(self.loginUser!.userID, publishModel: publishModel)
        }
    }
    
    func userIconClick(sender: UIPanGestureRecognizer) {
        if self.loginUser == nil {
            self.showLoginView()
        }else if let publishModel = self.currentFullCell.publishModel{
            let viewUserModel = publishModel.userModel
            let userPublish = CTAUserPublishesViewController()
            userPublish.viewUser = viewUserModel
            self.navigationController?.pushViewController(userPublish, animated: true)
        }
    }
}
