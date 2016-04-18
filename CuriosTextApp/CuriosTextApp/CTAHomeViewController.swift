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

    var loadMoreChangeView:Bool = false
    
    var loadingImageView:UIImageView? = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 80))
    
    var shadeView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initView()
        self.view.backgroundColor = CTAStyleKit.lightGrayBackgroundColor
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
        self.moreSpace = 6*self.getHorRate()
        self.handView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: bounds.width, height: fullSize.height + moreSpace*2 + 5))
        self.handView.center = CGPoint.init(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2)
        self.handView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(CTAHomeViewController.viewPanHandler(_:)))
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
        
        let shadeFrame = self.nextMoreCell.frame
        self.shadeView = UIView.init(frame: CGRect.init(x: shadeFrame.origin.x, y: shadeFrame.origin.y+shadeFrame.height-15, width: shadeFrame.width - 26, height: 20))
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
    }
    
    func setCellsPosition(){
        let bounds = UIScreen.mainScreen().bounds
        let fullSize = self.getCellSize()
        var rateW  = (fullSize.width  - moreSpace*2)/fullSize.width
        var rateH = (fullSize.height - moreSpace*2)/fullSize.height
        self.nextMoreCell.center = CGPoint.init(x: bounds.width/2, y: moreSpace*3+fullSize.height/2)
        self.nextMoreCell.transform = CGAffineTransformMakeScale(rateW, rateH)
        self.nextMoreCell.setViewColor(UIColor.init(red: 194/255, green: 194/255, blue: 194/255, alpha: 1))
        self.nextMoreCell.alpha = 1
        
        rateW  = (fullSize.width  - moreSpace)/fullSize.width
        rateH = (fullSize.height - moreSpace)/fullSize.height
        self.nextFullCell.center = CGPoint.init(x: bounds.width/2, y: moreSpace*1.5+fullSize.height/2)
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
        let fullWidth  = 350 * self.getHorRate()
        let fullHeight:CGFloat = fullWidth
        let fullSize = CGSize.init(width: fullWidth, height: fullHeight)
        return fullSize
    }
    
    func getLoadCellData(){
        let userID = (self.loginUser == nil) ? "" : self.loginUser!.userID
        let request = CTANewPublishListRequest.init(userID: userID, start: 0)
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
    
    func reloadViewHandler(noti: NSNotification){
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
        self.firstLoadViewMove(-100)
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
            if self.loadFirstModelArray(modelArray!){
                self.currentPublishIndex = 0
                self.setCellPublishModel()
            }else {
                self.setCellsPosition()
                self.currentFullCell!.playAnimation()
            }
        }else {
            self.setCellsPosition()
            self.currentFullCell!.playAnimation()
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
                    if !self.checkPublishModelIsHave(newmodel.publishID){
                        isChange = true
                        break
                    }
                }
            }else {
                isChange = true
            }
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
            if !self.checkPublishModelIsHave(publishModel.publishID){
                 self.publishModelArray.append(publishModel)
            }
        }
    }
    
    func checkPublishModelIsHave(publishID:String) -> Bool{
        for i in 0..<self.publishModelArray.count{
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
        UIView.animateWithDuration(0.4) { () -> Void in
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
    
    func saveArrayToLocaol(){
        let userID = (self.loginUser == nil) ? "" : self.loginUser!.userID
        let request = CTANewPublishListRequest.init(userID: userID, start: 0)
        var savePublishModel:Array<CTAPublishModel> = []
        if self.publishModelArray.count < 40 {
            savePublishModel = self.publishModelArray
        }else {
            let slice = self.publishModelArray[0...40]
            savePublishModel = Array(slice)
        }
        self.savePublishArray(request, modelArray: savePublishModel)
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
            
            let nextSizeChange = self.moreSpace*percent
            self.changeCellSizeBySpace(nextSizeChange, ischangeCurrent: false)
            self.changeViewColor(percent)
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
                self.changeViewColor(percent)
            }else {
                self.firstLoadViewMove(xChange/4)
            }
        }
    }
    
    func changeViewColor(percent:CGFloat){
        switch self.panDirection{
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
            if self.panDirection == .Next{
                if self.currentPublishIndex < self.publishModelArray.count - 1 {
                    let rChange = 0+maxR
                    let rChangePI=rChange/360*CGFloat(M_PI)
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.currentFullCell.transform = CGAffineTransformMakeRotation(rChangePI)
                        self.currentFullCell.center = CGPoint.init(x: bounds.width/2+maxX, y: fullSize.height/2+maxY)
                        let nextSizeChange = self.moreSpace
                        self.changeCellSizeBySpace(nextSizeChange, ischangeCurrent: false)
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
            if self.panDirection == .Previous{
                if self.currentPublishIndex > 0 {
                    let rChange:CGFloat = 0
                    let rChangePI=rChange/360*CGFloat(M_PI)
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.preFullCell.transform = CGAffineTransformMakeRotation(rChangePI)
                        self.preFullCell.center = CGPoint.init(x: bounds.width/2, y: fullSize.height/2)
                        let nextSizeChange = 0 - self.moreSpace
                        self.changeCellSizeBySpace(nextSizeChange, ischangeCurrent: true)
                        self.changeViewColor(0)
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
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.preFullCell.transform = CGAffineTransformMakeRotation(rChangePI)
                    self.preFullCell.center = CGPoint.init(x: bounds.width/2+xChange, y: fullSize.height/2+yChange)
                    self.changeCellSizeBySpace(0, ischangeCurrent: true)
                    self.changeViewColor(1)
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
    
    func firstLoadViewMove(xMove:CGFloat){
        let bounds = UIScreen.mainScreen().bounds
        let fullSize = self.getCellSize()

        if !self.loadingImageView!.isDescendantOfView(self.view){
            self.view.addSubview(self.loadingImageView!)
            self.loadingImageView?.image = UIImage(named: "fresh-icon-1")
            self.loadingImageView?.frame = CGRect.init(x: bounds.width, y: self.handView.frame.origin.y+self.handView.frame.height/2-20, width: 40, height: 40)
        }
        var xChange = xMove
        let maxSpace = (fullSize.width - bounds.width)/2 - 40
        if xChange < maxSpace {
            xChange = maxSpace
        }
        self.currentFullCell.center = CGPoint.init(x: bounds.width/2+xChange, y: fullSize.height/2)
        self.nextMoreCell.center = CGPoint.init(x: bounds.width/2+xChange, y: moreSpace*3+fullSize.height/2)
        self.nextFullCell.center = CGPoint.init(x: bounds.width/2+xChange, y: moreSpace*1.5+fullSize.height/2)
        self.shadeView.center = CGPoint.init(x: bounds.width/2+xChange, y: self.nextFullCell.frame.origin.y+self.nextFullCell.frame.height-5)
        self.loadingImageView?.center = CGPoint.init(x: bounds.width+xChange+20, y: self.handView.frame.origin.y+self.handView.frame.height/2)
    }
    
    func resetFirstLoadView(completion: (() -> Void)?){
        let bounds = UIScreen.mainScreen().bounds
        let fullSize = self.getCellSize()
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.currentFullCell.center = CGPoint.init(x: bounds.width/2, y: fullSize.height/2)
            self.nextMoreCell.center = CGPoint.init(x: bounds.width/2, y: self.moreSpace*3+fullSize.height/2)
            self.nextFullCell.center = CGPoint.init(x: bounds.width/2, y: self.moreSpace*1.5+fullSize.height/2)
            self.shadeView.center = CGPoint.init(x: bounds.width/2, y: self.nextFullCell.frame.origin.y+self.nextFullCell.frame.height-5)
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
            self.showLoginView()
        }else if self.currentFullCell.publishModel != nil{
            self.likeHandler()
        }
    }
    
    func moreButtonClick(sender: UIButton){
        if self.loginUser == nil {
            self.showLoginView()
        }else if self.currentFullCell.publishModel != nil{
            self.moreSelectionHandler(false)
        }
    }
    
    func rebuildButtonClick(sender: UIButton){
        if self.loginUser == nil {
            self.showLoginView()
        }else if self.currentFullCell.publishModel != nil{
            self.rebuildHandler()
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
