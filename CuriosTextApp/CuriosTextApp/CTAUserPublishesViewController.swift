//
//  CTADocumentsViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/4/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import Kingfisher
import MJRefresh

class CTAUserPublishesViewController: UIViewController, CTAImageControllerProtocol, CTALoadingProtocol, CTAPublishCellProtocol, CTAPublishDetailDelegate, CTAUserDetailProtocol{
    
    var viewUser:CTAUserModel?
    var loginUser:CTAUserModel?
    var isLoginUser:Bool = false
    var isLoadingFirstData = false
    var isLoadedAll = false
    var isCanChangeToolBar = true
    
    var publishModelArray:Array<CTAPublishModel> = []
    var selectedPublishID:String = ""
    
    var collectionView:UICollectionView!
    var viewToolBar:UIView!
    var userHeaderView:UIView!
    var userIconImage:UIImageView!
    var userNikenameLabel:UILabel!
    
    let backButton:UIButton = UIButton.init(frame: CGRect.init(x: 10, y: 12, width: 12, height: 20))
    let homeViewButton:UIButton = UIButton.init(frame: CGRect.init(x: 10, y: 10, width: 30, height: 24))
    var settingButton:UIButton!
    
    var previousScrollViewYOffset:CGFloat = 0.0
    var isLoading:Bool = false
    var isDisAppear:Bool = true
    
    var headerFresh:MJRefreshGifHeader!
    var footerFresh:MJRefreshAutoGifFooter!
    
    var selectedRect:CGRect?
    var isPersent:Bool = false
    var publishDetailViewController:CTAPublishDetailViewController?
    
    var userDetail:CTAUserDetailViewController?
    var userDetailTran:CTAPullUserDetailTransition?
    
    static var _instance:CTAUserPublishesViewController?;
    
    static func getInstance() -> CTAUserPublishesViewController{
        if _instance == nil{
            _instance = CTAUserPublishesViewController();
        }
        return _instance!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initCollectionView();
        self.initViewNavigateBar();
        view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if isDisAppear{
            self.loadLocalUserModel()
            if loginUser != nil {
                if viewUser == nil {
                    viewUser = loginUser
                    self.isLoginUser = true
                }
                self.setViewNavigateBar()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if loginUser != nil {
            if isDisAppear{
                super.viewDidAppear(animated)
                self.headerFresh.beginRefreshing()
            }
            isDisAppear = false
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewUser  = nil
        self.loginUser = nil
        self.isLoginUser = false
        self.publishModelArray.removeAll()
        self.collectionView.reloadData()
        self.isDisAppear = true
        self.previousScrollViewYOffset = 0.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initCollectionView(){
        let space:CGFloat = self.getCellSpace()
        let rect:CGRect = CGRect.init(x: 0, y: 44, width: self.view.frame.width, height: self.view.frame.height - 44)
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        
        layout.itemSize = self.getCellRect()
        layout.sectionInset = UIEdgeInsets(top: 0, left: space, bottom: 0, right: space)
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = space
        
        self.collectionView = UICollectionView.init(frame: rect, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerClass(CTAPublishesCell.self, forCellWithReuseIdentifier: "ctaPublishesCell")
        self.view.addSubview(self.collectionView!);
        self.collectionView.backgroundColor = UIColor.whiteColor()
    
        let freshIcon1:UIImage = UIImage.init(named: "fresh-icon-1")!
        
        
        self.headerFresh = MJRefreshGifHeader.init(refreshingTarget: self, refreshingAction: "loadFirstData")
        self.headerFresh.setImages([freshIcon1], forState: .Idle)
        self.headerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Pulling)
        self.headerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Refreshing)
        
        self.headerFresh.lastUpdatedTimeLabel?.hidden = true
        self.headerFresh.stateLabel?.hidden = true
        self.collectionView.mj_header = self.headerFresh
        
        self.footerFresh = MJRefreshAutoGifFooter.init(refreshingTarget: self, refreshingAction: "loadLastData")
        self.footerFresh.refreshingTitleHidden = true
        self.footerFresh.setTitle("", forState: .Idle)
        self.footerFresh.setTitle("", forState: .NoMoreData)
        self.footerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Refreshing)
        self.collectionView.mj_footer = footerFresh;
    }
    
    func loadLocalUserModel(){
        self.loginUser = CTAUserModel.init(userID: "ae7ca2d8590f4709ad73286920fa522f", nikeName: "喵萌君", userDesc: "美丽俏佳人231房间打开辣椒快乐附近的咖喱封疆大吏卡附近的克拉房间里放入破饿哇减肥fjdklajfkdljwofjdklafjdk打卡啦放假啦z", userIconURL: "5416b04634fb4d0daed0e9f8ce10801d/icon.jpg", sex: 1)
    }
    
    func initViewNavigateBar(){
        self.userHeaderView = UIView.init(frame: CGRectMake(62,0,self.view.frame.size.width-124, 44))
        self.userIconImage = UIImageView.init(frame: CGRect.init(x: (self.userHeaderView.frame.width-25)/2, y: 9, width: 26, height: 26));
        self.cropImageCircle(self.userIconImage)
        self.userNikenameLabel = UILabel.init(frame: CGRect.init(x: (self.userHeaderView.frame.width-100)/2, y: 14, width: 100, height: 16))
        self.userNikenameLabel.font = UIFont.systemFontOfSize(12)
        self.userNikenameLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        self.settingButton = UIButton.init(frame: CGRect.init(x: self.view.frame.width - 42, y: 10, width: 32, height: 24))
        self.settingButton.setImage(UIImage.init(named: "setting-button"), forState: .Normal)
        self.homeViewButton.setImage(UIImage.init(named: "homeview-button"), forState: .Normal)
        self.backButton.setImage(UIImage.init(named: "back-button"), forState: .Normal)
        self.viewToolBar = UIView()
        self.viewToolBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44)
        self.userHeaderView.addSubview(self.userIconImage)
        self.userHeaderView.addSubview(self.userNikenameLabel)
        self.viewToolBar.addSubview(self.userHeaderView)
        self.viewToolBar.addSubview(self.settingButton)
        self.viewToolBar.addSubview(self.homeViewButton)
        self.viewToolBar.addSubview(self.backButton)
        self.view.addSubview(self.viewToolBar)
        
        let tap = UITapGestureRecognizer(target: self, action: "userHeaderClick:")
        self.userHeaderView.addGestureRecognizer(tap)
        self.settingButton.addTarget(self, action: "settingButtonClick:", forControlEvents: .TouchUpInside)
        self.homeViewButton.addTarget(self, action: "homeViewButtonClick:", forControlEvents: .TouchUpInside)
        self.backButton.addTarget(self, action: "backButtonClick:", forControlEvents: .TouchUpInside)
    }
    
    func setViewNavigateBar(){
        if self.isLoginUser {
            self.settingButton.hidden = false
            self.homeViewButton.hidden = false
            self.backButton.hidden = true
        }else {
            self.settingButton.hidden = true
            self.homeViewButton.hidden = true
            self.backButton.hidden = false
        }
        self.userNikenameLabel.text = self.viewUser?.nikeName
        self.userNikenameLabel.sizeToFit()
        let maxWidth = self.userHeaderView.frame.width - 30
        var labelWidth = self.userNikenameLabel.frame.width
        if self.userNikenameLabel.frame.width > maxWidth {
            labelWidth = maxWidth
        }
        let imgX = (self.userHeaderView.frame.width - labelWidth - 30)/2
        self.userNikenameLabel.frame.origin.x = imgX+30
        self.userNikenameLabel.frame.size.width = labelWidth
        self.userIconImage.frame.origin.x = imgX
        let imagePath = CTAFilePath.userFilePath+self.viewUser!.userIconURL
        let imageURL = NSURL(string: imagePath)!
        self.userIconImage.kf_showIndicatorWhenLoading = true
        self.userIconImage.kf_setImageWithURL(imageURL, placeholderImage: UIImage.init(named: "default-usericon"), optionsInfo: [.Transition(ImageTransition.Fade(1))])
    }
    
    func userHeaderClick(sender: UITapGestureRecognizer){
        self.showUserDetailView(self.viewUser, loginUserID: (self.loginUser != nil ? self.loginUser!.userID : ""))
    }
    
    func settingButtonClick(sender: UIButton){
        print("setting button click")
        
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.darkGrayColor()
        presentViewController(vc, animated: true, completion: {
            vc.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    func backButtonClick(sender: UIButton){
        print("back button click")
    }
    
    func homeViewButtonClick(sender: UIButton){
        print("homeView button click")
    }
    
    func loadFirstData(){
        self.isLoadingFirstData = true
        self.loadUserPublishes(0)
    }
    
    func loadLastData(){
        self.isLoadingFirstData = false
        self.loadUserPublishes(self.publishModelArray.count)
    }
    
    
    func loadUserPublishes(start:Int, size:Int = 20){
        if self.isLoading{
            self.freshComplete();
            return
        }
        self.isLoading = true
        self.isLoadedAll = false
        CTAPublishDomain.getInstance().userPublishList(self.loginUser!.userID, beUserID: self.viewUser!.userID, start: start, size: size) { (info) -> Void in
            self.loadPublishesComplete(info, size: size)
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
                for var i=0; i < modelArray!.count; i++ {
                    let publishModel = modelArray![i] as! CTAPublishModel
                    if self.isLoadingFirstData{
                        if self.checkPublishModelIsHave(publishModel.publishID){
                            self.removePublishModelByID(publishModel.publishID)
                        }
                        if i < self.publishModelArray.count {
                            self.publishModelArray.insert(publishModel, atIndex: i)
                        }else{
                            self.publishModelArray.append(publishModel)
                        }
                    } else {
                        if !self.checkPublishModelIsHave(publishModel.publishID){
                            self.publishModelArray.append(publishModel)
                        }
                    }
                }
            }
            self.collectionView.reloadData()
        }
        self.freshComplete();
    }
    
    func freshComplete(){
        if self.isLoadingFirstData {
            self.headerFresh.endRefreshing()
        }else {
            if self.isLoadedAll {
                self.footerFresh.endRefreshingWithNoMoreData()
            } else {
                self.footerFresh.endRefreshing()
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

extension CTAUserPublishesViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    //collection view delegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.publishModelArray.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let publishesCell:CTAPublishesCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("ctaPublishesCell", forIndexPath: indexPath) as! CTAPublishesCell
        let index = indexPath.row
        if index < self.publishModelArray.count{
            let publihshModel = self.publishModelArray[index]
            publishesCell.publishModel = publihshModel
        }
        return publishesCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let index = indexPath.row
        self.selectedPublishID = ""
        if index < self.publishModelArray.count && index > -1{
            self.selectedPublishID = self.publishModelArray[index].publishID
        }
        if self.selectedPublishID != "" {
            if self.publishDetailViewController == nil {
                self.publishDetailViewController = CTAPublishDetailViewController()
            }
            self.publishDetailViewController?.setPublishData(self.selectedPublishID, publishModelArray: self.publishModelArray)
            self.publishDetailViewController?.loginUserID = (self.loginUser != nil ? self.loginUser!.userID : "")
            self.publishDetailViewController?.viewUser = self.viewUser
            self.publishDetailViewController?.delegate = self
            self.publishDetailViewController?.transitioningDelegate = self
            self.publishDetailViewController?.modalPresentationStyle = .Custom
            self.presentViewController(self.publishDetailViewController!, animated: true) { () -> Void in
                
            }
        }
    }
    
    //scroll view hide tool bar
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if !self.isCanChangeToolBar {
            return
        }
        var toolBarViewframe = self.viewToolBar.frame
        var collectViewFrame = self.collectionView.frame
        let size  = toolBarViewframe.height
        let framePercentageHidden = ( (0-toolBarViewframe.origin.y) / size)
        let scrollOffset = self.collectionView.contentOffset.y
        let scrollDiff   = scrollOffset - self.previousScrollViewYOffset
        let scrollHeight = collectViewFrame.size.height
        let scrollContentSizeHeight = self.collectionView.contentSize.height + self.collectionView.contentInset.bottom
        if scrollOffset <= -self.collectionView.contentInset.top {
            toolBarViewframe.origin.y = 0
        }else if (scrollOffset + scrollHeight) >= scrollContentSizeHeight {
            toolBarViewframe.origin.y = -size
        } else {
            toolBarViewframe.origin.y = min(0, max(-size, toolBarViewframe.origin.y - scrollDiff));
        }
        collectViewFrame.origin.y = size + toolBarViewframe.origin.y
        collectViewFrame.size.height = self.view.frame.height - collectViewFrame.origin.y
        self.viewToolBar.frame = toolBarViewframe
        self.collectionView.frame = collectViewFrame
        self.updateBarButtonsAlpha(1-framePercentageHidden)
        self.previousScrollViewYOffset = scrollOffset
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.stoppedScrolling()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.stoppedScrolling()
        }
    }
    
    func stoppedScrolling(){
        let frame = self.viewToolBar.frame
        if frame.origin.y < 0 {
            self.animationNavBarTo((0-frame.size.height))
        }
    }
    
    func updateBarButtonsAlpha(alpha:CGFloat){
        self.viewToolBar.alpha = alpha
    }
    
    func animationNavBarTo(y:CGFloat){
        UIView.animateWithDuration(0.2) { () -> Void in
            var toolBarViewframe = self.viewToolBar.frame
            var collectViewFrame = self.collectionView.frame
            let alpha:CGFloat = (toolBarViewframe.origin.y >= y ? 0.0 : 1.0)
            toolBarViewframe.origin.y = y
            collectViewFrame.origin.y = toolBarViewframe.height + toolBarViewframe.origin.y
            collectViewFrame.size.height = self.view.frame.height - collectViewFrame.origin.y
            self.viewToolBar.frame = toolBarViewframe
            self.collectionView.frame = collectViewFrame
            self.updateBarButtonsAlpha(alpha)
        }
    }
    
    func setPublishData(selectedPublishID:String, publishModelArray:Array<CTAPublishModel>, selectedCellCenter:CGPoint){
        self.publishModelArray.removeAll()
        self.selectedPublishID = selectedPublishID
        self.publishModelArray = self.publishModelArray + publishModelArray
        self.viewToolBar.frame.origin.y = 0
        self.collectionView.frame.origin.y = self.viewToolBar.frame.height
        self.collectionView.frame.size.height = self.view.frame.height - self.viewToolBar.frame.height
        var currentIndex:Int = 0
        for var i=0; i < self.publishModelArray.count; i++ {
            let model = self.publishModelArray[i]
            if model.publishID == self.selectedPublishID {
                currentIndex = i
            }
        }
        let space = self.getCellSpace()
        let cellRect = self.getCellRect()
        let yIndex = Int(currentIndex / 2)
        let centY = CGFloat(yIndex) * (space + cellRect.height) + cellRect.height/2 + 44
        var scrollOffY = centY - selectedCellCenter.y
        let scrollHeight = self.collectionView.frame.size.height
        let scrollContentSizeHeight = self.collectionView.contentSize.height + self.collectionView.contentInset.bottom
        if scrollOffY > 0 && scrollOffY + scrollHeight > scrollContentSizeHeight-5{
            scrollOffY = scrollContentSizeHeight - scrollHeight-5
        }
        self.isCanChangeToolBar = false
        if self.collectionView.contentOffset.y != scrollOffY {
            self.collectionView.contentOffset.y = scrollOffY
            self.previousScrollViewYOffset = scrollOffY
            self.collectionView.reloadData()
        }
        self.isCanChangeToolBar = true
    }
}

extension CTAUserPublishesViewController: UIViewControllerTransitioningDelegate{
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPersent = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPersent = false
        return self
    }
}

extension CTAUserPublishesViewController: UIViewControllerAnimatedTransitioning{
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        return 0.6
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        if isPersent{
            if let toView = transitionContext.viewForKey(UITransitionContextToViewKey){
                var animationView:UIView? = self.getAnimationView()
                transitionContext.containerView()!.addSubview(animationView!)
                transitionContext.containerView()!.addSubview(toView)
                toView.alpha = 0
                self.collectionView.hidden = true
                toView.frame = UIScreen.mainScreen().bounds
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.doTransitionAnimation(animationView!)
                    self.viewToolBar.alpha = 0
                    }, completion: { (_) -> Void in
                        transitionContext.completeTransition(true)
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            toView.alpha = 1
                            }, completion: { (_) -> Void in
                                animationView?.hidden = true
                                self.clearAnimationView(animationView!)
                                animationView = nil
                                toView.alpha = 1
                                self.collectionView.hidden = false
                                self.viewToolBar.alpha = 1
                                transitionContext.completeTransition(true)
                        })
                })
            }
        }
        if !isPersent{
            if let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey){
                fromView.alpha = 1
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    fromView.alpha = 0
                    }, completion: { (_) -> Void in
                        fromView.removeFromSuperview()
                        fromView.alpha = 1
                        transitionContext.completeTransition(true)
                })
            }
        }
    }
    
    func getAnimationView() -> UIView{
        let visibleCells = self.collectionView.visibleCells();
        let animationView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
        for var i=0; i < visibleCells.count; i++ {
            let cell = visibleCells[i] as! CTAPublishesCell
            let cellImage = cell.cellImageView.snapshotViewAfterScreenUpdates(false)
            let cellUIView = CTAPublishTransitionCell.init(frame: cell.frame)
            cellUIView.addCellView(cellImage, cellPublishID: cell.publishModel.publishID)
            self.addImageShadow(cellUIView)
            cellUIView.frame.origin.y = cell.frame.origin.y + self.collectionView.frame.origin.y - self.collectionView.contentOffset.y
            animationView.addSubview(cellUIView)
            if self.selectedPublishID != "" {
                if cell.publishModel.publishID == self.selectedPublishID{
                    self.selectedRect = cellUIView.frame
                }
            }
        }
        return animationView;
    }
    
    func doTransitionAnimation(animationView:UIView) {
        if isPersent{
            if self.selectedRect != nil && self.selectedPublishID != ""{
                let fullSize = self.getFullCellRect(self.selectedRect!.size, rate: 1.0)
                let fullx = UIScreen.mainScreen().bounds.width/2
                let fully = UIScreen.mainScreen().bounds.height/2
                let rateW = fullSize.width / self.selectedRect!.width
                let rateH = fullSize.height / self.selectedRect!.height
                let topRate = self.getFullVerSpace()/(self.getCellSpace()+self.selectedRect!.height)
                let subViews = animationView.subviews
                for var i = 0 ; i < subViews.count; i++ {
                    let cellView = subViews[i] as! CTAPublishTransitionCell
                    if cellView.publishID == self.selectedPublishID{
                        cellView.center = CGPoint.init(x: fullx, y: fully)
                        cellView.alpha = 1
                        cellView.transform = CGAffineTransformMakeScale(rateW, rateH)
                    }else {
                        let centerX = fullx + (cellView.frame.origin.x - selectedRect!.origin.x) * rateW
                        let centerY = fully + (cellView.frame.origin.y - selectedRect!.origin.y) * topRate
                        cellView.center = CGPoint(x: centerX, y: centerY)
                        cellView.alpha = 0.2
                        cellView.transform = CGAffineTransformMakeScale(rateW*0.9, rateH*0.9)
                    }
                    
                }
            }
        }
        
    }
    
    func clearAnimationView(animationView:UIView) {
        let subViews = animationView.subviews
        for var i = 0 ; i < subViews.count; i++ {
            var cellView:UIView? = subViews[i]
            cellView!.removeFromSuperview()
            cellView = nil;
        }
        animationView.removeFromSuperview()
    }
}

class CTAPublishTransitionCell: UIView{
    var publishID:String = "";

    func addCellView(cellView:UIView, cellPublishID:String){
        self.addSubview(cellView)
        self.publishID = cellPublishID
    }
}
