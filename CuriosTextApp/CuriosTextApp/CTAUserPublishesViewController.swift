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

class CTAUserPublishesViewController: UIViewController, CTAImageControllerProtocol, CTAPublishCellProtocol, CTAPublishDetailDelegate, CTAUserDetailProtocol, CTAPublishCacheProtocol{
    
    var viewUser:CTAUserModel?
    var loginUser:CTAUserModel?
    var viewUserID:String = ""
    var isLoginUser:Bool = false
    var isLoadingFirstData = false
    var isDisMis:Bool = true
    var isLoadedAll = false
    var isCanChangeToolBar = true
    
    var isAddOber:Bool = false
    
    var publishModelArray:Array<CTAPublishModel> = []
    var selectedPublishID:String = ""
    
    var collectionView:UICollectionView!
    var viewToolBar:UIView!
    var userHeaderView:UIView!
    var userIconImage:UIImageView!
    var userNicknameLabel:UILabel!
    
    var backButton:UIButton!
    var homeViewButton:UIButton!
    var settingButton:UIButton!
    
    var noContentView:UIImageView!
    
    var previousScrollViewYOffset:CGFloat = 0.0
    var isLoading:Bool = false
    
    var headerFresh:MJRefreshGifHeader!
    var footerFresh:MJRefreshAutoGifFooter!
    
    var selectedRect:CGRect?
    var isPersent:Bool = false
    
    var publishDetail:CTAPublishDetailViewController?
    var userDetail:CTAUserDetailViewController?
    var setting:CTASettingViewController?
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
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
        self.navigationController!.interactivePopGestureRecognizer?.delegate = self
        self.view.backgroundColor = CTAStyleKit.lightGrayBackgroundColor
        if self.viewUser == nil {
            self.isLoginUser = true
        }else {
            self.isLoginUser = false
        }
        if self.isLoginUser && !self.isAddOber{
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CTAUserPublishesViewController.reloadViewHandler(_:)), name: "publishEditFile", object: nil)
            self.isAddOber = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.isDisMis {
            self.loadLocalUserModel()
            if loginUser != nil {
                if self.isLoginUser {
                    self.viewUser = self.loginUser
                }
                if self.viewUserID != self.viewUser!.userID{
                    self.publishModelArray.removeAll()
                    if self.isLoginUser {
                        let userID = self.loginUser!.userID
                        let beUserID = self.viewUser!.userID
                        let request = CTAUserPublishListRequest.init(userID: userID, beUserID: beUserID, start: 0)
                        let data = self.getPublishArray(request)
                        if data != nil {
                            self.publishModelArray = data!
                        }
                    }
                    self.collectionView.reloadData()
                    self.previousScrollViewYOffset = 0.0
                }
                self.setViewNavigateBar()
            }else {
                self.setNavigateButton()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.isDisMis {
            if loginUser != nil && self.viewUser != nil {
                if self.viewUserID != self.viewUser!.userID{
                    self.viewUserID = self.viewUser!.userID
                    self.headerFresh.beginRefreshing()
                }
            }
        }
        self.isDisMis = false
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.isDisMis = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadViewHandler(noti: NSNotification){
        if self.isLoginUser{
            self.viewUserID = ""
        }
    }
    
    func saveArrayToLocaol(){
        if self.isLoginUser {
            let userID = self.loginUser!.userID
            let beUserID = self.viewUser!.userID
            var savePublishModel:Array<CTAPublishModel> = []
            if self.publishModelArray.count < 40 {
                savePublishModel = self.publishModelArray
            }else {
                let slice = self.publishModelArray[0...40]
                savePublishModel = Array(slice)
            }
            let request = CTAUserPublishListRequest.init(userID: userID, beUserID: beUserID, start: 0)
            self.savePublishArray(request, modelArray: savePublishModel)
        }
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
        self.collectionView.backgroundColor = CTAStyleKit.lightGrayBackgroundColor
    
        let freshIcon1:UIImage = UIImage.init(named: "fresh-icon-1")!
        
        self.headerFresh = MJRefreshGifHeader.init(refreshingTarget: self, refreshingAction: #selector(CTAUserPublishesViewController.loadFirstData))
        self.headerFresh.setImages([freshIcon1], forState: .Idle)
        self.headerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Pulling)
        self.headerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Refreshing)
        
        self.headerFresh.lastUpdatedTimeLabel?.hidden = true
        self.headerFresh.stateLabel?.hidden = true
        self.collectionView.mj_header = self.headerFresh
        
        self.footerFresh = MJRefreshAutoGifFooter.init(refreshingTarget: self, refreshingAction: #selector(CTAUserPublishesViewController.loadLastData))
        self.footerFresh.refreshingTitleHidden = true
        self.footerFresh.setTitle("", forState: .Idle)
        self.footerFresh.setTitle("", forState: .NoMoreData)
        self.footerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Refreshing)
        self.collectionView.mj_footer = footerFresh;
        
        self.noContentView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 300))
        self.noContentView.center = self.collectionView.center
        self.noContentView.image = UIImage.init(named: "no-content")
        self.view.addSubview(self.noContentView)
        self.noContentView.hidden = true
    }
    
    func loadLocalUserModel(){
        if CTAUserManager.isLogin{
            self.loginUser = CTAUserManager.user
        }else {
            self.loginUser = nil
        }
    }
    
    func initViewNavigateBar(){
        let bounds = UIScreen.mainScreen().bounds
        self.userHeaderView = UIView.init(frame: CGRectMake(62,0,self.view.frame.size.width-124, 44))
        self.userIconImage = UIImageView.init(frame: CGRect.init(x: (bounds.size.width-26)/2, y: 9, width: 26, height: 26));
        self.cropImageCircle(self.userIconImage)
        self.userIconImage.image = UIImage(named: "default-usericon")
        self.userNicknameLabel = UILabel.init(frame: CGRect.init(x: (bounds.size.width-100)/2, y: 14, width: 100, height: 16))
        self.userNicknameLabel.font = UIFont.systemFontOfSize(12)
        self.userNicknameLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        self.settingButton = UIButton.init(frame: CGRect.init(x: bounds.size.width - 45, y: 2, width: 40, height: 40))
        self.settingButton.setImage(UIImage.init(named: "setting-button"), forState: .Normal)
        self.settingButton.setImage(UIImage.init(named: "setting-selected-button"), forState: .Highlighted)
        self.homeViewButton = UIButton.init(frame: CGRect.init(x: 5, y: 2, width: 40, height: 40))
        self.homeViewButton.setImage(UIImage.init(named: "homeview-button"), forState: .Normal)
        self.homeViewButton.setImage(UIImage.init(named: "homeview-selected-button"), forState: .Highlighted)
        self.backButton = UIButton.init(frame: CGRect.init(x: 0, y: 2, width: 40, height: 40))
        self.backButton.setImage(UIImage.init(named: "back-button"), forState: .Normal)
        self.backButton.setImage(UIImage.init(named: "back-selected-button"), forState: .Highlighted)
        
        self.viewToolBar = UIView()
        self.viewToolBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44)
        self.userHeaderView.addSubview(self.userIconImage)
        self.userHeaderView.addSubview(self.userNicknameLabel)
        self.viewToolBar.addSubview(self.userHeaderView)
        self.viewToolBar.addSubview(self.settingButton)
        self.viewToolBar.addSubview(self.homeViewButton)
        self.viewToolBar.addSubview(self.backButton)
        self.view.addSubview(self.viewToolBar)
        self.viewToolBar.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.0)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CTAUserPublishesViewController.userHeaderClick(_:)))
        self.userHeaderView.addGestureRecognizer(tap)
        self.settingButton.addTarget(self, action: #selector(CTAUserPublishesViewController.settingButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.homeViewButton.addTarget(self, action: #selector(CTAUserPublishesViewController.homeViewButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.backButton.addTarget(self, action: #selector(CTAUserPublishesViewController.backButtonClick(_:)), forControlEvents: .TouchUpInside)
        
    }
    
    func setNavigateButton(){
        if self.isLoginUser {
            self.settingButton.hidden = false
            self.homeViewButton.hidden = false
            self.backButton.hidden = true
        }else {
            self.settingButton.hidden = true
            self.homeViewButton.hidden = true
            self.backButton.hidden = false
        }
        self.userNicknameLabel.text = ""
        self.userIconImage.frame.origin.x = (UIScreen.mainScreen().bounds.width - self.userIconImage.frame.width)/2
    }
    
    func setViewNavigateBar(){
        self.setNavigateButton()
        self.userNicknameLabel.text = self.viewUser?.nickName
        self.userNicknameLabel.sizeToFit()
        let maxWidth = self.userHeaderView.frame.width - 30
        var labelWidth = self.userNicknameLabel.frame.width
        if self.userNicknameLabel.frame.width > maxWidth {
            labelWidth = maxWidth
        }
        let imgX = (self.userHeaderView.frame.width - labelWidth - 30)/2
        self.userNicknameLabel.frame.origin.x = imgX+30
        self.userNicknameLabel.frame.size.width = labelWidth
        self.userIconImage.frame.origin.x = imgX
        let imagePath = CTAFilePath.userFilePath+self.viewUser!.userIconURL
        let imageURL = NSURL(string: imagePath)!
        self.userIconImage.kf_showIndicatorWhenLoading = true
        self.userIconImage.kf_setImageWithURL(imageURL, placeholderImage: UIImage(named: "default-usericon"), optionsInfo: [.Transition(ImageTransition.Fade(1))]) { (image, error, cacheType, imageURL) -> () in
            if error != nil {
                self.userIconImage.image = UIImage(named: "default-usericon")
            }
            self.userIconImage.kf_showIndicatorWhenLoading = false
        }
    }
    
    func userHeaderClick(sender: UITapGestureRecognizer){
        if self.userDetail == nil {
            self.userDetail = CTAUserDetailViewController()
        }
        self.showUserDetailView(self.viewUser, loginUserID: (self.loginUser != nil ? self.loginUser!.userID : ""))
    }
    
    func settingButtonClick(sender: UIButton){
        self.setting = CTASettingViewController()
        NSNotificationCenter.defaultCenter().postNotificationName("showNavigationView", object: self.setting)
    }
    
    func backButtonClick(sender: UIButton){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func homeViewButtonClick(sender: UIButton){
        if self.isLoginUser {
            NSNotificationCenter.defaultCenter().postNotificationName("changePageView", object: 0)
        }
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
        if self.isLoading || self.loginUser == nil{
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
                if self.isLoadingFirstData{
                    var isChange:Bool = false
                    if modelArray!.count > 0{
                        if self.publishModelArray.count > 0{
                            for i in 0..<modelArray!.count{
                                let newmodel = modelArray![i] as! CTAPublishModel
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
                        self.loadMoreModelArray(modelArray!)
                        self.saveArrayToLocaol()
                    }
                }else {
                    self.loadMoreModelArray(modelArray!)
                }
            }
        }
        self.freshComplete();
    }
    
    func loadMoreModelArray(modelArray:Array<AnyObject>){
        for i in 0..<modelArray.count{
            let publishModel = modelArray[i] as! CTAPublishModel
            if !self.checkPublishModelIsHave(publishModel.publishID){
                self.publishModelArray.append(publishModel)
            }
        }
        self.collectionView.reloadData()
    }
    
    func freshComplete(){
        if self.isLoadingFirstData {
            self.headerFresh.endRefreshing()
            self.showNoContentView()
        }else {
            if self.isLoadedAll {
                self.footerFresh.endRefreshingWithNoMoreData()
            } else {
                self.footerFresh.endRefreshing()
            }
        }
    }
    
    func showNoContentView(){
        if self.isLoginUser && self.publishModelArray.count == 0{
            self.noContentView.hidden = false
        }else {
            self.noContentView.hidden = true
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
            if self.publishDetail == nil {
                self.publishDetail = CTAPublishDetailViewController()
            }
            self.publishDetail!.setPublishData(self.selectedPublishID, publishModelArray: self.publishModelArray)
            self.publishDetail!.loginUser = self.loginUser
            self.publishDetail!.viewUser = self.viewUser
            self.publishDetail!.delegate = self
            self.publishDetail!.transitioningDelegate = self
            self.publishDetail!.modalPresentationStyle = .Custom
            self.presentViewController(self.publishDetail!, animated: true, completion: nil)
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
        var isChange:Bool = false
        if publishModelArray.count == self.publishModelArray.count {
            for i in 0..<publishModelArray.count{
                let oldModel = self.publishModelArray[i]
                let newModel = publishModelArray[i]
                if oldModel.publishID != newModel.publishID {
                    isChange = true
                    break
                }
            }
        }else {
            isChange = true
        }
        if isChange{
            self.publishModelArray.removeAll()
            self.publishModelArray = publishModelArray
            self.collectionView.reloadData()
            self.saveArrayToLocaol()
            self.showNoContentView()
        }
        
        self.selectedPublishID = selectedPublishID
        self.viewToolBar.frame.origin.y = 0
        self.collectionView.frame.origin.y = self.viewToolBar.frame.height
        self.collectionView.frame.size.height = self.view.frame.height - self.viewToolBar.frame.height
        var currentIndex:Int = 0
        for i in 0..<self.publishModelArray.count{
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
        if scrollOffY > 0 && scrollOffY + scrollHeight > scrollContentSizeHeight{
            scrollOffY = scrollContentSizeHeight - scrollHeight
        }
        self.isCanChangeToolBar = false
        if self.collectionView.contentOffset.y != scrollOffY {
            self.collectionView.contentOffset.y = scrollOffY
            self.previousScrollViewYOffset = scrollOffY
            
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
                let view = transitionContext.containerView()!
                var animationView:UIView? = self.getAnimationView()
                view.addSubview(animationView!)
                
                var barView:CTAAddBarView? = CTAAddBarView(frame: CGRect.zero)
                view.addSubview(barView!)
                setAddBarView(barView!, view: view)
                
                view.addSubview(toView)
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
                                barView = nil
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
        for i in 0..<visibleCells.count{
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
                for i in 0..<subViews.count{
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
        for i in 0..<subViews.count{
            var cellView:UIView? = subViews[i]
            cellView!.removeFromSuperview()
            cellView = nil;
        }
        animationView.removeFromSuperview()
    }
}

extension CTAUserPublishesViewController:CTALoadingProtocol{
    var loadingImageView:UIImageView?{
        return nil
    }
}

extension CTAUserPublishesViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.isLoginUser{
            return false
        }
        return true
    }
    
}

class CTAPublishTransitionCell: UIView{
    var publishID:String = "";

    func addCellView(cellView:UIView, cellPublishID:String){
        self.addSubview(cellView)
        self.publishID = cellPublishID
    }
}

