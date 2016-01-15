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

class CTAUserPublishesViewController: UIViewController, CTAImageControllerProtocol, CTALoadingProtocol{
    
    var viewUser:CTAUserModel?
    var loginUser:CTAUserModel?
    var isLoginUser:Bool = false
    var isLoadingFirstData = false
    var isLoadedAll = false
    
    var publishModelArray:Array<CTAPublishModel> = []
    
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
    
    
    var userDetailViewController:CTAUserDetailViewController?
    let userDetailTransition:CTAPullUserDetailTransition = CTAPullUserDetailTransition();
    
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
            if viewUser == nil {
                viewUser = loginUser
                self.isLoginUser = true
            }
            self.setViewNavigateBar()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if isDisAppear{
            super.viewDidAppear(animated)
            self.headerFresh.beginRefreshing()
        }
        isDisAppear = false
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewUser  = nil
        self.loginUser = nil
        self.isLoginUser = false
        self.publishModelArray.removeAll()
        self.collectionView.reloadData()
        isDisAppear = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initCollectionView(){
        let space:CGFloat = 10.00/375.00*self.view.frame.width
        let rect:CGRect = CGRect.init(x: 0, y: 44, width: self.view.frame.width, height: self.view.frame.height - 44)
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        let itemWidth = (self.view.frame.width - (space + 1)*3)/2
        
        layout.itemSize = CGSize.init(width: itemWidth, height: itemWidth)
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
        self.userNikenameLabel.frame = CGRect.init(x: imgX+30, y: 14, width: labelWidth, height: 16)
        self.userIconImage.frame = CGRect.init(x: imgX, y: 9, width: 26, height: 26)
        let imagePath = CTAFilePath.userFilePath+self.viewUser!.userIconURL
        let imageURL = NSURL(string: imagePath)!
        self.userIconImage.kf_showIndicatorWhenLoading = true
        self.userIconImage.kf_setImageWithURL(imageURL, placeholderImage: UIImage.init(named: "default-usericon"), optionsInfo: [.Transition(ImageTransition.Fade(1))])
    }
    
    func userHeaderClick(sender: UITapGestureRecognizer){
        if self.userDetailViewController == nil {
            self.userDetailViewController = CTAUserDetailViewController()
        }
        self.userDetailViewController?.userModel = self.viewUser
        self.userDetailViewController?.loginUserID = "08698b06271f442099d7943150f8eafe"
        self.userDetailViewController?.transitioningDelegate = self.userDetailTransition
        self.userDetailViewController?.modalPresentationStyle = .Custom
        self.presentViewController(self.userDetailViewController!, animated: true) { () -> Void in
            self.userDetailViewController!.setBackgroundColor()
        }
    }
    
    
    
    func settingButtonClick(sender: UIButton){
        print("setting button click")
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
    
    //scroll view hide tool bar
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
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
            var changeY = false
            if  scrollOffset < size{
                changeY = true
            } else if scrollDiff > 0{
                changeY = true
            }
            if changeY{
                toolBarViewframe.origin.y = min(0, max(-size, toolBarViewframe.origin.y - scrollDiff));
            }
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
}

class CTAPullUserDetailTransition: NSObject, UIViewControllerTransitioningDelegate{
    
    var isPersent:Bool = false
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPersent = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPersent = false
        return self
    }
    
    //
    //    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
    //
    //
    //    }
    
}

extension CTAPullUserDetailTransition: UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        return 0.6
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        if isPersent{
            if let toView = transitionContext.viewForKey(UITransitionContextToViewKey){
                transitionContext.containerView()!.addSubview(toView)
                toView.frame = CGRect.init(x: 0, y: 0-UIScreen.mainScreen().bounds.height, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
                UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 5.0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                    toView.frame = UIScreen.mainScreen().bounds
                    }, completion: { (_) -> Void in
                         transitionContext.completeTransition(true)
                })
            }
        }
        if !isPersent{
            if let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey){
                UIView.animateWithDuration(1.0, delay: 0.5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                    fromView.frame = CGRect.init(x: 0, y: 0-UIScreen.mainScreen().bounds.height, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
                    }, completion: { (_) -> Void in
                        fromView.removeFromSuperview()
                        transitionContext.completeTransition(true)
                })
            }
        }
    }
}
