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

enum CTAPublishType: String {
    case Posts, Likes
}

class CTAUserPublishesViewController: UIViewController, CTAImageControllerProtocol, CTAPublishCellProtocol, CTAPublishDetailDelegate, CTAPublishCacheProtocol{
    
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
    
    var topView:UIView!
    var collectionView:UICollectionView!
    var collectionLayout:UICollectionViewFlowLayout!
    
    var collectionControllerView:UIView!
    var userPostButton:UIButton!
    var userLikeButton:UIButton!
    
    var userInfoView:UIView!
    var userIconImage:UIImageView!
    var userNicknameLabel:UILabel!
    var userDescLabel:UILabel!
    
    var headerToolView:UIView!
    var backButton:UIButton!
    var homeViewButton:UIButton!
    var settingButton:UIButton!
    
    var previousScrollViewYOffset:CGFloat = 0.0
    var isLoading:Bool = false
    
    var headerFresh:MJRefreshGifHeader!
    var footerFresh:MJRefreshAutoGifFooter!
    
    var selectedRect:CGRect?
    var isPersent:Bool = false
    
    var publishDetail:CTAPublishDetailViewController?
    var setting:CTASettingViewController?
    
    var publishType:CTAPublishType = .Posts
    
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
        self.initTopView()
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
            if self.loginUser != nil {
                if self.isLoginUser {
                    self.viewUser = self.loginUser
                }
                self.resetView()
                if self.viewUserID != self.viewUser!.userID{
                    self.resetButton()
                    self.publishModelArray.removeAll()
                    self.loadArrayFromLocal()
                    self.collectionView.reloadData()
                    self.previousScrollViewYOffset = 0.0
                }
            }else {
                self.resetView()
                self.resetButton()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.isDisMis {
            if self.loginUser != nil && self.viewUser != nil {
                if self.viewUserID != self.viewUser!.userID{
                    self.viewUserID = self.viewUser!.userID
                    if !self.isLoginUser {
                        self.headerFresh.beginRefreshing()
                    }else {
                        self.loadFirstData()
                    }
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
    
    func saveArrayToLocal(){
        if self.isLoginUser {
            let userID = self.loginUser!.userID
            let beUserID = self.viewUser!.userID
            var savePublishModel:Array<CTAPublishModel> = []
            if self.publishModelArray.count < 100 {
                savePublishModel = self.publishModelArray
            }else {
                let slice = self.publishModelArray[0...100]
                savePublishModel = Array(slice)
            }
            var request:CTABaseRequest?
            if self.publishType == .Posts{
                request = CTAUserPublishListRequest.init(userID: userID, beUserID: beUserID, start: 0)
            }else if self.publishType == .Likes{
                request = CTAUserLikePublishListRequest.init(userID: userID, beUserID: beUserID, start: 0)
            }
            if request != nil {
                self.savePublishArray(request!, modelArray: savePublishModel)
            }
        }
    }
    
    func loadArrayFromLocal(){
        if self.isLoginUser {
            let userID = self.loginUser!.userID
            let beUserID = self.viewUser!.userID
            var request:CTABaseRequest?
            if self.publishType == .Posts{
                request = CTAUserPublishListRequest.init(userID: userID, beUserID: beUserID, start: 0)
            }else if self.publishType == .Likes{
                request = CTAUserLikePublishListRequest.init(userID: userID, beUserID: beUserID, start: 0)
            }
            if request != nil{
                let data = self.getPublishArray(request!)
                if data != nil {
                    self.publishModelArray = data!
                }
            }
        }
    }
    
    func initCollectionView(){
        let bounds = UIScreen.mainScreen().bounds
        let space:CGFloat = self.getCellSpace()
        let rect:CGRect = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.collectionLayout = UICollectionViewFlowLayout.init()
        
        self.collectionLayout.itemSize = self.getCellRect()
        self.collectionLayout.sectionInset = UIEdgeInsets(top: 0, left: space, bottom: 0, right: space)
        self.collectionLayout.minimumLineSpacing = space
        self.collectionLayout.minimumInteritemSpacing = space
        self.collectionLayout.headerReferenceSize = CGSize(width: bounds.width, height: 100)
        self.collectionView = UICollectionView.init(frame: rect, collectionViewLayout: self.collectionLayout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerClass(CTAPublishesCell.self, forCellWithReuseIdentifier: "ctaPublishesCell")
        self.collectionView.registerClass(CTAPublishHeaderView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "ctaPublishHeader")
    
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
    }
    
    func loadLocalUserModel(){
        if CTAUserManager.isLogin{
            self.loginUser = CTAUserManager.user
        }else {
            self.loginUser = nil
        }
    }
    
    func initTopView(){
        let bounds = UIScreen.mainScreen().bounds
        let maxWidth = bounds.width - 100
        
        self.topView = UIView(frame: CGRectMake(0, 0, bounds.width, 30))
        
        self.userInfoView = UIView(frame: CGRectMake(0, 0, bounds.width, 100))
        self.userIconImage = UIImageView.init(frame: CGRect.init(x: (bounds.size.width-60)/2, y: 0, width: 60*self.getHorRate(), height: 60*self.getHorRate()));
        self.cropImageCircle(self.userIconImage)
        self.userIconImage.image = UIImage(named: "default-usericon")
        
        self.userNicknameLabel = UILabel.init(frame: CGRect.init(x: (bounds.size.width-maxWidth)/2, y: 70*self.getHorRate(), width: maxWidth, height: 30))
        self.userNicknameLabel.font = UIFont.systemFontOfSize(16)
        self.userNicknameLabel.textColor = UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        self.userNicknameLabel.textAlignment = .Center
        self.userInfoView.addSubview(self.userIconImage)
        self.userInfoView.addSubview(self.userNicknameLabel)
        
        self.userDescLabel = UILabel.init(frame: CGRect.init(x: (bounds.size.width-maxWidth)/2, y: (self.userNicknameLabel.frame.origin.y+40), width: maxWidth, height: 140))
        self.userDescLabel.numberOfLines = 10
        self.userDescLabel.font = UIFont.systemFontOfSize(12)
        self.userDescLabel.textColor = UIColor.init(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
        self.userDescLabel.text = " "
        self.userDescLabel.textAlignment = .Center
        self.userInfoView.addSubview(self.userDescLabel)
        self.topView.addSubview(self.userInfoView)

        self.userPostButton = UIButton(frame: CGRectMake(0, 0, (bounds.width-20)/2, 50))
        self.userPostButton.center = CGPoint(x: bounds.width/4, y: 25)
        self.userPostButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        self.userPostButton.setTitle(NSLocalizedString("PostsButtonLabel", comment: ""), forState: .Normal)
        self.userPostButton.setTitleColor(UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0), forState: .Normal)
        self.userLikeButton = UIButton(frame: CGRectMake(0, 0, (bounds.width-20)/2, 50))
        self.userLikeButton.center = CGPoint(x: bounds.width*3/4, y: 25)
        self.userLikeButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        self.userLikeButton.setTitle(NSLocalizedString("LikesButtonLabel", comment: ""), forState: .Normal)
        self.userLikeButton.setTitleColor(UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0), forState: .Normal)
        let lineImageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 2, height: 18))
        lineImageView.image = UIImage.init(named: "follow-line")
        lineImageView.center = CGPoint(x: bounds.width/2, y: 25)
        self.collectionControllerView = UIView(frame: CGRectMake(0, 0, bounds.width, 50))
        self.collectionControllerView.addSubview(self.userPostButton)
        self.collectionControllerView.addSubview(self.userLikeButton)
        self.collectionControllerView.addSubview(lineImageView)
        self.topView.addSubview(self.collectionControllerView)
        
        self.userPostButton.addTarget(self, action: #selector(CTAUserPublishesViewController.postsButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.userLikeButton.addTarget(self, action: #selector(CTAUserPublishesViewController.likesButtonClick(_:)), forControlEvents: .TouchUpInside)
    }
    
    func initViewNavigateBar(){
        let bounds = UIScreen.mainScreen().bounds
        self.settingButton = UIButton.init(frame: CGRect.init(x: bounds.size.width - 45, y: 2, width: 40, height: 40))
        self.settingButton.setImage(UIImage.init(named: "setting-button"), forState: .Normal)
        self.settingButton.setImage(UIImage.init(named: "setting-selected-button"), forState: .Highlighted)
        self.homeViewButton = UIButton.init(frame: CGRect.init(x: 5, y: 2, width: 40, height: 40))
        self.homeViewButton.setImage(UIImage.init(named: "homeview-button"), forState: .Normal)
        self.homeViewButton.setImage(UIImage.init(named: "homeview-selected-button"), forState: .Highlighted)
        self.backButton = UIButton.init(frame: CGRect.init(x: 0, y: 2, width: 40, height: 40))
        self.backButton.setImage(UIImage.init(named: "back-button"), forState: .Normal)
        self.backButton.setImage(UIImage.init(named: "back-selected-button"), forState: .Highlighted)
        
        self.headerToolView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 44))
        self.headerToolView.addSubview(self.settingButton)
        self.headerToolView.addSubview(self.homeViewButton)
        self.headerToolView.addSubview(self.backButton)
        self.view.addSubview(self.headerToolView)
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
    
    func resetView(){
        self.setNavigateButton()
        let bounds = UIScreen.mainScreen().bounds
        let maxWidth = bounds.width - 100
        self.userNicknameLabel.text = self.viewUser?.nickName
        self.userDescLabel.text = self.viewUser?.userDesc
        self.userDescLabel.sizeToFit()
        self.userDescLabel.frame.size.width = maxWidth
        let imagePath = CTAFilePath.userFilePath+self.viewUser!.userIconURL
        let imageURL = NSURL(string: imagePath)!
        self.userIconImage.kf_showIndicatorWhenLoading = true
        self.userIconImage.kf_setImageWithURL(imageURL, placeholderImage: UIImage(named: "default-usericon"), optionsInfo: [.Transition(ImageTransition.Fade(1))]) { (image, error, cacheType, imageURL) -> () in
            if error != nil {
                self.userIconImage.image = UIImage(named: "default-usericon")
            }
            self.userIconImage.kf_showIndicatorWhenLoading = false
        }
        self.setViewsPosition()
    }
    
    func resetButton(){
        self.publishType = .Posts
        self.changeButtonStatus()
    }
    
    func setViewsPosition(){
        self.userInfoView.frame.origin.y = 35
        self.userInfoView.frame.size.height = self.userDescLabel.frame.origin.y + self.userDescLabel.frame.height
        self.collectionControllerView.frame.origin.y = self.userInfoView.frame.origin.y+self.userInfoView.frame.height+10
        self.topView.frame.size.height = self.collectionControllerView.frame.origin.y + self.collectionControllerView.frame.height
        self.topView.frame.origin.y = 0
        let frame = self.topView.frame
        self.collectionLayout.headerReferenceSize = CGSize(width: frame.width, height: frame.height)
        self.collectionView.collectionViewLayout = self.collectionLayout
    }
    
    func changeButtonStatus(){
        switch self.publishType {
        case .Posts:
            self.userPostButton.setTitleColor(UIColor.init(red: 240/255, green: 50/255, blue: 75/255, alpha: 1.0), forState: .Normal)
            self.userLikeButton.setTitleColor(UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0), forState: .Normal)
        case .Likes:
            self.userPostButton.setTitleColor(UIColor.init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0), forState: .Normal)
            self.userLikeButton.setTitleColor(UIColor.init(red: 240/255, green: 50/255, blue: 75/255, alpha: 1.0), forState: .Normal)
        }
    }
    
    func postsButtonClick(sender: UIButton){
        if self.publishType != .Posts{
            self.publishType = .Posts
            self.changeButtonStatus()
            self.publishModelArray.removeAll()
            self.loadArrayFromLocal()
            self.collectionView.reloadData()
            self.previousScrollViewYOffset = 0.0
            self.isLoading = false
            self.loadFirstData()
        }
    }
    
    func likesButtonClick(sender: UIButton){
        if self.publishType != .Likes{
            self.publishType = .Likes
            self.changeButtonStatus()
            self.publishModelArray.removeAll()
            self.loadArrayFromLocal()
            self.collectionView.reloadData()
            self.previousScrollViewYOffset = 0.0
            self.isLoading = false
            self.loadFirstData()
        }
    }
    
    func settingButtonClick(sender: UIButton){
        if self.setting == nil {
            self.setting = CTASettingViewController()
        }
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
    
    
    func loadUserPublishes(start:Int, size:Int = 30){
        if self.isLoading || self.loginUser == nil{
            self.freshComplete();
            return
        }
        self.isLoading = true
        self.isLoadedAll = false
        if self.publishType == .Posts{
            CTAPublishDomain.getInstance().userPublishList(self.loginUser!.userID, beUserID: self.viewUser!.userID, start: start, size: size) { (info) -> Void in
                self.loadPublishesComplete(info, size: size, publishType: .Posts)
            }
        }else if self.publishType == .Likes{
            CTAPublishDomain.getInstance().userLikePublishList(self.loginUser!.userID, beUserID: self.viewUser!.userID, start: start, size: size, compelecationBlock: { (info) in
                self.loadPublishesComplete(info, size: size, publishType: .Likes)
            })
        }
    }
    
    func loadPublishesComplete(info: CTADomainListInfo, size:Int, publishType:CTAPublishType){
        self.isLoading = false
        if self.publishType != publishType{
            return
        }
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
                        }else {
                            isChange = true
                        }
                    }else {
                        isChange = true
                    }
                    if isChange{
                        self.publishModelArray.removeAll()
                        self.loadMoreModelArray(modelArray!)
                        self.saveArrayToLocal()
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
            if !self.checkPublishModelIsHave(publishModel.publishID, publishArray: self.publishModelArray){
                self.publishModelArray.append(publishModel)
            }
        }
        self.collectionView.reloadData()
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
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = self.collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "ctaPublishHeader", forIndexPath: indexPath)
        headerView.addSubview(self.topView)
        return headerView
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
            self.selectCellAnimation()
        }
    }
    
    func selectCellAnimation(){
        let animationView:UIView = self.getCellAnimationView()
        let headerView:UIView = self.getCollectionHeaderView()
        self.view.addSubview(animationView)
        self.view.addSubview(headerView)
        self.collectionView.hidden = true
        headerView.alpha = 1
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.doCellTransitionAnimation(animationView, isPersent: true)
            headerView.alpha = 0
            }, completion: { (_) -> Void in
                if self.publishDetail == nil {
                    self.publishDetail = CTAPublishDetailViewController()
                }
                
                self.publishDetail!.setPublishData(self.selectedPublishID, publishModelArray: self.publishModelArray, publishType: self.publishType, topView: self.getHeaderView())
                self.publishDetail!.loginUser = self.loginUser
                self.publishDetail!.viewUser = self.viewUser
                self.publishDetail!.delegate = self
                
                let navigationController = UINavigationController(rootViewController: self.publishDetail!)
                navigationController.navigationBarHidden = true
                navigationController.transitioningDelegate = self
                navigationController.modalPresentationStyle = .Custom
                self.presentViewController(navigationController, animated: true, completion: { 
                    animationView.hidden = true
                    self.clearAnimationView(animationView)
                    headerView.hidden = true
                    headerView.removeFromSuperview()
                    self.collectionView.hidden = false
                })
        })
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
            self.saveArrayToLocal()
        }
        
        self.selectedPublishID = selectedPublishID
        var currentIndex:Int = 0
        for i in 0..<self.publishModelArray.count{
            let model = self.publishModelArray[i]
            if model.publishID == self.selectedPublishID {
                currentIndex = i
            }
        }
        let space = self.getCellSpace()
        let cellRect = self.getCellRect()
        let yIndex = Int(currentIndex / 3)
        let centY = CGFloat(yIndex) * (space + cellRect.height) + cellRect.height/2 + self.topView.frame.height
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
        if isPersent{
            return 0.3
        }else {
            return 0.3
        }
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        if isPersent{
            if let toView = transitionContext.viewForKey(UITransitionContextToViewKey){
                let view = transitionContext.containerView()!
                view.addSubview(toView)
                toView.alpha = 0
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    toView.alpha = 1
                    }, completion: { (_) -> Void in
                        toView.alpha = 1
                        transitionContext.completeTransition(true)
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
    
    func getHeaderView() -> UIView{
//        let toolView = self.headerToolView.snapshotViewAfterScreenUpdates(true)
        let topView = self.topView.snapshotViewAfterScreenUpdates(true)
        topView.frame.origin.y = 0
        topView.frame.origin.x = 0
        let animationView = UIView.init(frame: topView.frame)
        animationView.backgroundColor = UIColor.clearColor()
//        animationView.addSubview(toolView)
        animationView.addSubview(topView)
        return animationView
    }
    
    func getCollectionHeaderView() -> UIView{
        let animationView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
        animationView.backgroundColor = UIColor.clearColor()
        
        let headerView = self.headerToolView.snapshotViewAfterScreenUpdates(true)
        animationView.addSubview(headerView)
        let headers = self.collectionView.visibleSupplementaryViewsOfKind(UICollectionElementKindSectionHeader)
        for i in 0..<headers.count{
            let header = headers[i]
            let cellUIView = header.snapshotViewAfterScreenUpdates(true)
            cellUIView.frame.origin.y = header.frame.origin.y + self.collectionView.frame.origin.y - self.collectionView.contentOffset.y
            animationView.addSubview(cellUIView)
        }
        return animationView
    }
    
    func getCellAnimationView() -> UIView{
        let visibleCells = self.collectionView.visibleCells();
        let animationView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
        for i in 0..<visibleCells.count{
            let cell = visibleCells[i] as! CTAPublishesCell
            let cellImage = cell.cellImageView.snapshotViewAfterScreenUpdates(true)
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
    
    func doCellTransitionAnimation(animationView:UIView, isPersent:Bool) {
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
                        cellView.transform = CGAffineTransformMakeScale(rateW*cellScale, rateH*cellScale)
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

class CTAPublishHeaderView: UICollectionReusableView{
    
}

