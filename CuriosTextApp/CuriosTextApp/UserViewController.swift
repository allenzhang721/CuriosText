//
//  UserViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import Kingfisher
import MJRefresh

enum CTAPublishType: String {
    case Posts, Likes
}

class UserViewController: UIViewController, CTAImageControllerProtocol, CTAPublishCellProtocol, CTAPublishCacheProtocol, CTAPublishModelProtocol, CTALoadingProtocol, CTAAlertProtocol, CTALoginProtocol{

    var viewUser:CTAViewUserModel?
    var loginUser:CTAUserModel?
    var viewUserID:String = ""
    var isLoginUser:Bool = false
    var isLoadingFirstData = false
    var isDisMis:Bool = true
    var isLoadedAll = false
    
    var isAddOber:Bool = false
    
    var publishModelArray:Array<CTAPublishModel> = []
    var selectedPublishID:String = ""
    
    var topView:UIView!
    var collectionView:UICollectionView!
    var collectionLayout:CTACollectionViewStickyFlowLayout!
    
    var collectionControllerView:UIView!
    var userPostButton:UIButton!
    var userLikeButton:UIButton!
    
    var userInfoView:UIView!
    var userIconImage:UIImageView!
    var userNicknameLabel:UILabel!
    var userDescLabel:UILabel!
    
    var userFollowView:UIView!
    var followLabel:UILabel!
    var followCountLabel:UILabel!
    var beFollowLabel:UILabel!
    var beFollowCountLabel:UILabel!
    
    var followButton:UIButton!
    
    var backButton:UIButton!
    var settingButton:UIButton!

    var isLoading:Bool = false
    
    var headerFresh:MJRefreshGifHeader!
    var footerFresh:MJRefreshAutoGifFooter!
    
    var selectedRect:CGRect?
    var isPersent:Bool = false
    
    var publishDetail:CTAPublishDetailViewController?
    var setting:CTASettingViewController?
    
    var publishType:CTAPublishType = .Posts
    
    var loadingImageView:UIImageView? = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    var topNikeNameY:CGFloat = 0.0
    let cellHorCount = 3
    
    var isHideSelectedCell:Bool = false
    let scrollTop:CGFloat = 00.00
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.viewUser == nil {
            self.isLoginUser = true
        }else {
            self.isLoginUser = false
            self.loadLocalUserModel()
        }
        self.initTopView()
        self.initCollectionView();
        self.initViewNavigateBar();
        self.navigationController?.navigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        self.view.backgroundColor = CTAStyleKit.commonBackgroundColor
        if !self.isAddOber{
            if self.isLoginUser {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadViewHandler(_:)), name: "publishEditFile", object: nil)
            }
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reNewView(_:)), name: "loginComplete", object: nil)
            self.isAddOber = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.isDisMis {
            self.loadLocalUserModel()
            if self.loginUser != nil {
                if self.isLoginUser {
                    self.viewUser = GetViewUserModel(self.loginUser!)
                }
            }
            self.setUIView()
            if self.viewUserID != self.viewUser!.userID{
                self.resetButton()
                self.publishModelArray.removeAll()
                self.loadArrayFromLocal()
                self.collectionView.reloadData()
                self.loadUserDetailFromLocal()
                self.setViewByDetailUser()
            }
        }
        if self.isLoginUser {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(refreshView(_:)), name: "refreshSelf", object: nil)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.isDisMis {
            if self.viewUser != nil {
                if self.viewUserID != self.viewUser!.userID{
                    self.viewUserID = self.viewUser!.userID
                    if !self.isLoginUser {
                        self.headerFresh.beginRefreshing()
                    }else {
                        self.beginFresh()
                    }
                }else {
                    self.loadUserDetail()
                }
            }
        }
        self.isDisMis = false
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isLoginUser {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: "refreshSelf", object: nil)
        }
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
    
    func reNewView(noti: NSNotification){
        self.viewUserID = ""
    }
    
    func refreshView(noti: NSNotification){
        if self.collectionView.contentOffset.y > self.scrollTop{
            self.collectionView.setContentOffset(CGPoint(x: 0, y: self.scrollTop), animated: true)
        }else {
            self.headerFresh.beginRefreshing()
        }
    }
    
    func saveArrayToLocal(){
        let userID = self.loginUser == nil ? "" : self.loginUser!.userID
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
            request = CTAUserPublishListRequest(userID: userID, beUserID: beUserID, start: 0)
        }else if self.publishType == .Likes{
            request = CTAUserLikePublishListRequest(userID: userID, beUserID: beUserID, start: 0)
        }
        if request != nil {
            self.savePublishArray(request!, modelArray: savePublishModel)
        }
    }
    
    func loadArrayFromLocal(){
        let userID = self.loginUser == nil ? "" : self.loginUser!.userID
        let beUserID = self.viewUser!.userID
        var request:CTABaseRequest?
        if self.publishType == .Posts{
            request = CTAUserPublishListRequest(userID: userID, beUserID: beUserID, start: 0)
        }else if self.publishType == .Likes{
            request = CTAUserLikePublishListRequest(userID: userID, beUserID: beUserID, start: 0)
        }
        if request != nil{
            let data = self.getPublishArray(request!)
            if data != nil {
                self.publishModelArray = data!
            }
        }
    }
    
    func saveUserDetailToLocal(){
        if self.viewUser != nil {
            let userID = self.loginUser == nil ? "" : self.loginUser!.userID
            let beUserID = self.viewUser!.userID
            let request:CTABaseRequest = CTAUserDetailRequest(userID: userID, beUserID: beUserID)
            self.saveUserDetail(request, userDetail: self.viewUser!)
        }
    }
    
    func loadUserDetailFromLocal(){
        let userID = self.loginUser == nil ? "" : self.loginUser!.userID
        let beUserID = self.viewUser!.userID
        let request:CTABaseRequest = CTAUserDetailRequest(userID: userID, beUserID: beUserID)
        let data = self.getUserDetail(request)
        if data != nil {
            self.viewUser = data
        }
    }
    
    func initCollectionView(){
        let bounds = UIScreen.mainScreen().bounds
        let space:CGFloat = self.getCellSpace()
        let rect:CGRect = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        self.collectionLayout = CTACollectionViewStickyFlowLayout()
        
        self.collectionLayout.itemSize = self.getCellRect()
        self.collectionLayout.sectionInset = UIEdgeInsets(top: 0, left: space, bottom: 0, right: space)
        self.collectionLayout.minimumLineSpacing = space
        self.collectionLayout.minimumInteritemSpacing = space
        self.collectionLayout.headerReferenceSize = CGSize(width: bounds.width, height: 100)
        self.collectionView = UICollectionView(frame: rect, collectionViewLayout: self.collectionLayout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerClass(CTAPublishesCell.self, forCellWithReuseIdentifier: "ctaPublishesCell")
        self.collectionView.registerClass(CTAPublishHeaderView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "ctaPublishHeader")
        self.collectionView.backgroundColor = CTAStyleKit.commonBackgroundColor
        self.view.addSubview(self.collectionView!);
        
        let freshIcon1:UIImage = UIImage(named: "fresh-icon-1")!
        
        self.headerFresh = MJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(UserViewController.beginFresh))
        self.headerFresh.setImages([freshIcon1], forState: .Idle)
        self.headerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Pulling)
        self.headerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Refreshing)
        
        self.headerFresh.lastUpdatedTimeLabel?.hidden = true
        self.headerFresh.stateLabel?.hidden = true
        self.collectionView.mj_header = self.headerFresh
        
        self.footerFresh = MJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(UserViewController.loadLastData))
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
        let maxWidth = bounds.width - 80
        
        self.topView = UIView(frame: CGRectMake(0, 0, bounds.width, 30))
        self.topView.backgroundColor = CTAStyleKit.commonBackgroundColor
        self.userInfoView = UIView(frame: CGRectMake(0, 0, bounds.width, 100))
        self.userIconImage = UIImageView(frame: CGRect(x: (bounds.size.width-60)/2, y: 0, width: 60*self.getHorRate(), height: 60*self.getHorRate()));
        self.cropImageCircle(self.userIconImage)
        self.userIconImage.image = UIImage(named: "default-usericon")
        self.userInfoView.addSubview(self.userIconImage)
        
        self.topNikeNameY = self.userIconImage.frame.origin.y + self.userIconImage.frame.height+10
        self.userNicknameLabel = UILabel(frame: CGRect(x: (bounds.size.width-maxWidth)/2, y: self.topNikeNameY, width: maxWidth, height: 28))
        self.userNicknameLabel.font = UIFont.boldSystemFontOfSize(18)
        self.userNicknameLabel.textColor = CTAStyleKit.normalColor
        self.userNicknameLabel.textAlignment = .Center
        self.topView.addSubview(self.userNicknameLabel)
        
        self.userDescLabel = UILabel(frame: CGRect(x: (bounds.size.width-maxWidth)/2, y: self.userIconImage.frame.origin.y + self.userIconImage.frame.height+45, width: maxWidth, height: 140))
        self.userDescLabel.numberOfLines = 10
        self.userDescLabel.font = UIFont.systemFontOfSize(13)
        
        self.userDescLabel.textColor = CTAStyleKit.labelShowColor
        self.userDescLabel.text = " "
        self.userDescLabel.textAlignment = .Center
        self.userInfoView.addSubview(self.userDescLabel)
        self.topView.addSubview(self.userInfoView)
        
        self.userFollowView = UIView(frame: CGRectMake(0, 0, bounds.width, 80))
        let lineImageView = UIImageView.init(frame: CGRect.init(x: bounds.width/2, y: 5, width: 1, height: 14))
        lineImageView.image = UIImage.init(named: "follow-line")
        self.userFollowView.addSubview(lineImageView)
        let followView = UIView(frame: CGRectMake(0, 0, bounds.width/2, 25))
        followView.backgroundColor = UIColor.clearColor()
        self.followLabel = UILabel()
        self.followLabel.font = UIFont.systemFontOfSize(13)
        self.followLabel.textColor = CTAStyleKit.labelShowColor
        self.followLabel.text = NSLocalizedString("FollowLabel", comment: "")
        followView.addSubview(followLabel)
        self.followCountLabel = UILabel()
        self.followCountLabel.font = UIFont.systemFontOfSize(13)
        self.followCountLabel.textColor = CTAStyleKit.labelShowColor
        self.followCountLabel.text = "0"
        followView.addSubview(self.followCountLabel)
        self.userFollowView.addSubview(followView)
        followView.userInteractionEnabled = true
        let followTap = UITapGestureRecognizer(target: self, action: #selector(followViewClickClick(_:)))
        followView.addGestureRecognizer(followTap)
        
        let beFollowView = UIView(frame: CGRectMake(bounds.width/2, 0, bounds.width/2, 25))
        beFollowView.backgroundColor = UIColor.clearColor()
        self.beFollowLabel = UILabel()
        self.beFollowLabel.font = UIFont.systemFontOfSize(13)
        self.beFollowLabel.textColor = CTAStyleKit.labelShowColor
        self.beFollowLabel.text = NSLocalizedString("BeFollowLabel", comment: "")
        beFollowView.addSubview(beFollowLabel)
        let beFollowTap = UITapGestureRecognizer(target: self, action: #selector(beFollowViewClick(_:)))
        beFollowView.addGestureRecognizer(beFollowTap)
        
        self.beFollowCountLabel = UILabel()
        self.beFollowCountLabel.font = UIFont.systemFontOfSize(13)
        self.beFollowCountLabel.textColor = CTAStyleKit.labelShowColor
        self.beFollowCountLabel.text = "0"
        beFollowView.addSubview(self.beFollowCountLabel)
        self.userFollowView.addSubview(beFollowView)
        self.followButton = UIButton(frame: CGRectMake((bounds.width-90)/2, 35, 90, 30))
        self.followButton.setBackgroundImage(UIImage(named: "follow_bg"), forState: .Normal)
        self.followButton.setTitle(NSLocalizedString("FollowButtonLabel", comment: ""), forState: .Normal)
        self.followButton.setTitleColor(CTAStyleKit.selectedColor, forState: .Normal)
        self.followButton.titleLabel?.font = UIFont.systemFontOfSize(13)
        if self.isLoginUser {
            self.userFollowView.frame = CGRectMake(0, 0, bounds.width, 35)
        }else if self.loginUser != nil && self.loginUser?.userID == self.viewUser?.userID {
            self.userFollowView.frame = CGRectMake(0, 0, bounds.width, 35)
        }else {
            self.userFollowView.addSubview(self.followButton)
            self.followButton.addTarget(self, action: #selector(followButtonClick(_:)), forControlEvents: .TouchUpInside)
        }
        self.topView.addSubview(self.userFollowView)
    
        
        self.userPostButton = UIButton(frame: CGRectMake(0, 0, (bounds.width-20)/2, 40))
        self.userPostButton.center = CGPoint(x: bounds.width/4, y: 20)
        self.userPostButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        self.userPostButton.setTitle(NSLocalizedString("PostsButtonLabel", comment: ""), forState: .Normal)
        self.userPostButton.setTitleColor(CTAStyleKit.normalColor, forState: .Normal)
        self.userLikeButton = UIButton(frame: CGRectMake(0, 0, (bounds.width-20)/2, 40))
        self.userLikeButton.center = CGPoint(x: bounds.width*3/4, y: 20)
        self.userLikeButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        self.userLikeButton.setTitle(NSLocalizedString("LikesButtonLabel", comment: ""), forState: .Normal)
        self.userLikeButton.setTitleColor(CTAStyleKit.normalColor, forState: .Normal)
        self.collectionControllerView = UIView(frame: CGRectMake(0, 0, bounds.width, 40))
        self.collectionControllerView.addSubview(self.userPostButton)
        self.collectionControllerView.addSubview(self.userLikeButton)
        
        var textLine = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: bounds.width, height: 1))
        textLine.image = UIImage(named: "space-line")
        self.collectionControllerView.addSubview(textLine)
        
        textLine = UIImageView.init(frame: CGRect.init(x: 0, y: 39, width: bounds.width, height: 1))
        textLine.image = UIImage(named: "space-line")
        self.collectionControllerView.addSubview(textLine)
        self.topView.addSubview(self.collectionControllerView)
        
        self.userPostButton.addTarget(self, action: #selector(postsButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.userLikeButton.addTarget(self, action: #selector(likesButtonClick(_:)), forControlEvents: .TouchUpInside)
    }
    
    func initViewNavigateBar(){
        let bounds = UIScreen.mainScreen().bounds
        self.settingButton = UIButton(frame: CGRect(x: bounds.width - 40, y: 22, width: 40, height: 40))
        self.settingButton.setImage(UIImage(named: "setting-button"), forState: .Normal)
        self.settingButton.setImage(UIImage(named: "setting-selected-button"), forState: .Highlighted)
        self.backButton = UIButton(frame: CGRect(x: 0, y: 22, width: 40, height: 40))
        self.backButton.setImage(UIImage(named: "back-button"), forState: .Normal)
        self.backButton.setImage(UIImage(named: "back-selected-button"), forState: .Highlighted)
        
        self.view.addSubview(self.settingButton)
        self.view.addSubview(self.backButton)
        self.settingButton.addTarget(self, action: #selector(UserViewController.settingButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.backButton.addTarget(self, action: #selector(UserViewController.backButtonClick(_:)), forControlEvents: .TouchUpInside)
        
        let timeView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 20))
        timeView.backgroundColor = CTAStyleKit.commonBackgroundColor
        self.view.addSubview(timeView)
    }
    
    func setNavigateButton(){
        if self.isLoginUser {
            self.settingButton.hidden = false
            self.backButton.hidden = true
        }else {
            self.settingButton.hidden = true
            self.backButton.hidden = false
        }
        self.userNicknameLabel.text = ""
        self.userIconImage.frame.origin.x = (UIScreen.mainScreen().bounds.width - self.userIconImage.frame.width)/2
    }
    
    func setUIView(){
        self.setNavigateButton()
        let bounds = UIScreen.mainScreen().bounds
        let maxWidth = bounds.width - 80
        self.userNicknameLabel.text = self.viewUser?.nickName
        self.userDescLabel.text = self.viewUser?.userDesc
        self.userDescLabel.sizeToFit()
        self.userDescLabel.frame.size.width = maxWidth
        self.setUserIcon(self.viewUser!.userIconURL)
        self.setViewsPosition()
        self.setFollowLabelPosition()
    }
    
    func setUserIcon(iconPath:String){
        var defaultImg = UIImage(named: "default-usericon")
        if self.userIconImage.image != nil {
            defaultImg = self.userIconImage.image
        }
        let imagePath = CTAFilePath.userFilePath+iconPath
        let imageURL = NSURL(string: imagePath)!
        self.userIconImage.kf_showIndicatorWhenLoading = true
        self.userIconImage.kf_setImageWithURL(imageURL, placeholderImage: defaultImg, optionsInfo: [.Transition(ImageTransition.Fade(1))]) { (image, error, cacheType, imageURL) -> () in
            if error != nil {
                self.userIconImage.image = UIImage(named: "default-usericon")
            }
            self.userIconImage.kf_showIndicatorWhenLoading = false
        }
    }
    
    func resetView() {
        let bounds = UIScreen.mainScreen().bounds
        let maxWidth = bounds.width - 80
        self.userNicknameLabel.text = ""
        self.userDescLabel.text = ""
        self.userDescLabel.sizeToFit()
        self.userDescLabel.frame.size.width = maxWidth
        self.followCountLabel.text = "0"
        self.beFollowCountLabel.text = "0"
        self.userIconImage.image = UIImage(named: "default-usericon")
        self.setViewsPosition()
        self.setFollowLabelPosition()
    }
    
    func resetButton(){
        self.publishType = .Posts
        self.changeButtonStatus()
    }
    
    func setViewsPosition(){
        self.userInfoView.frame.origin.y = 20
        self.userInfoView.frame.size.height = self.userDescLabel.frame.origin.y + self.userDescLabel.frame.height+5
        self.userFollowView.frame.origin.y = self.userInfoView.frame.origin.y+self.userInfoView.frame.height
        self.collectionControllerView.frame.origin.y = self.userFollowView.frame.origin.y+self.userFollowView.frame.height
        self.topView.frame.size.height = self.collectionControllerView.frame.origin.y + self.collectionControllerView.frame.height
        self.topView.frame.origin.y = 0
        let frame = self.topView.frame
        self.collectionLayout.headerReferenceSize = CGSize(width: frame.width, height: frame.height)
        
        self.collectionView.collectionViewLayout = self.collectionLayout
        let headerHMin = self.collectionControllerView.frame.origin.y-64
        self.collectionLayout.stickyHeight = headerHMin
        
        let offY = self.collectionView.contentOffset.y
        if offY > headerHMin{
            self.collectionLayout.isSticky = true
            self.collectionLayout.isHold = true
            self.changeHeaderAlpha(headerHMin, totalH: headerHMin)
        }else {
            self.collectionLayout.isSticky = false
            self.changeHeaderAlpha(offY, totalH: headerHMin)
        }
    }
    
    func setFollowLabelPosition(){
        let bounds = UIScreen.mainScreen().bounds
        
        self.followCountLabel.sizeToFit()
        self.followCountLabel.frame.origin.x = bounds.width/2 - 14 - self.followCountLabel.frame.width
        self.followCountLabel.frame.origin.y = 5
        
        self.followLabel.sizeToFit()
        self.followLabel.frame.origin.x = self.followCountLabel.frame.origin.x - self.followLabel.frame.width - 5
        self.followLabel.frame.origin.y = 5
        
        self.beFollowLabel.sizeToFit()
        self.beFollowLabel.frame.origin.x = 14
        self.beFollowLabel.frame.origin.y = 5
        
        self.beFollowCountLabel.sizeToFit()
        self.beFollowCountLabel.frame.origin.x = self.beFollowLabel.frame.width+self.beFollowLabel.frame.origin.x+5
        self.beFollowCountLabel.frame.origin.y = 5
    }
    
    func changeButtonStatus(){
        switch self.publishType {
        case .Posts:
            self.userPostButton.setTitleColor(CTAStyleKit.selectedColor, forState: .Normal)
            self.userLikeButton.setTitleColor(CTAStyleKit.normalColor, forState: .Normal)
        case .Likes:
            self.userPostButton.setTitleColor(CTAStyleKit.normalColor, forState: .Normal)
            self.userLikeButton.setTitleColor(CTAStyleKit.selectedColor, forState: .Normal)
        }
    }
    
    func postsButtonClick(sender: UIButton){
        if self.publishType != .Posts{
            self.publishType = .Posts
            self.changeButtonStatus()
            self.changeCollectionViewOffY()
            self.publishModelArray.removeAll()
            self.loadArrayFromLocal()
            self.collectionView.reloadData()
            self.isLoading = false
            self.loadFirstData()
        }
    }
    
    func likesButtonClick(sender: UIButton){
        if self.publishType != .Likes{
            self.publishType = .Likes
            self.changeButtonStatus()
            self.changeCollectionViewOffY()
            self.publishModelArray.removeAll()
            self.loadArrayFromLocal()
            self.collectionView.reloadData()
            self.isLoading = false
            self.loadFirstData()
        }
    }
    
    func changeCollectionViewOffY(){
        var offY = self.collectionView.contentOffset.y
        if offY > self.collectionLayout.stickyHeight{
            offY = self.collectionLayout.stickyHeight
        }
        self.collectionView.contentOffset.y = offY
    }
    
    func settingButtonClick(sender: UIButton){
        if self.setting == nil {
            self.setting = CTASettingViewController()
        }
        self.setting!.isReset = true
        self.setting!.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(self.setting!, animated: true)
    }
    
    func backButtonClick(sender: UIButton){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func followViewClickClick(sender: UIPanGestureRecognizer){
        self.loadUserDetail()
        let userID = self.viewUserID
        let vc = Moduler.module_userList(userID, type: .Followings, delegate: self)
        let navi = UINavigationController(rootViewController: vc)
        let ani = CTAScaleTransition.getInstance()
        let bound = UIScreen.mainScreen().bounds
        
        let rectPoint = self.followLabel.convertPoint(CGPoint(x: 0, y: 0), toView: self.view)
        let labelW = self.followCountLabel.frame.width + self.followLabel.frame.width
        let rect = CGRect(x: rectPoint.x, y: rectPoint.y, width: labelW, height: self.followCountLabel.frame.height)
        ani.fromRect = self.getViewFromRect(rect, viewRect: bound)
        navi.transitioningDelegate = ani
        navi.modalPresentationStyle = .Custom
        self.presentViewController(navi, animated: true, completion: {
        })
    }
    
    func beFollowViewClick(ender: UIPanGestureRecognizer){
        self.loadUserDetail()
        let userID = self.viewUserID
        let vc = Moduler.module_userList(userID, type: .Followers, delegate: self)
        let navi = UINavigationController(rootViewController: vc)
        let ani = CTAScaleTransition.getInstance()
        let bound = UIScreen.mainScreen().bounds
        let rectPoint = self.beFollowLabel.convertPoint(CGPoint(x: 0, y: 0), toView: self.view)
        let labelW = self.beFollowCountLabel.frame.width + self.beFollowLabel.frame.width
        let rect = CGRect(x: rectPoint.x, y: rectPoint.y, width: labelW, height: self.beFollowCountLabel.frame.height)
        ani.fromRect = self.getViewFromRect(rect, viewRect: bound)
        navi.transitioningDelegate = ani
        navi.modalPresentationStyle = .Custom
        self.presentViewController(navi, animated: true, completion: {
            
        })
    }
    
    func getViewFromRect(smallRect:CGRect, viewRect:CGRect) -> CGRect{
        let smallW = smallRect.width
        let smallH = smallRect.height
        let viewW = viewRect.width
        let viewH = viewRect.height
        
        var rate:CGFloat
        let imageRate = smallW / smallH
        let maxRate = viewW / viewH
        if maxRate > imageRate{
            rate = smallW / viewW
        }else {
            rate = smallH / viewH
        }
        
        let newRect = CGRect(x: smallRect.origin.x + (smallW-rate*viewW)/2, y: smallRect.origin.y + (smallH-rate*viewH)/2, width: rate*viewW, height: rate*viewH)
        return newRect
    }
    
    func followButtonClick(sender: UIButton){
        if self.loginUser != nil{
            if self.viewUser != nil{
                let relationType:Int = self.viewUser!.relationType
                switch  relationType{
                case 0, 3:
                    self.followUser()
                case 1, 5:
                    var alertArray:Array<[String: AnyObject]> = []
                    alertArray.append(["title":NSLocalizedString("UnFollowLabel", comment: ""), "style": "Destructive"])
                    let alertTile = NSLocalizedString("ConfirmUnFollowLabel", comment: "")+self.viewUser!.nickName+"?"
                    self.showSheetAlert(alertTile, okAlertArray: alertArray, cancelAlertLabel: LocalStrings.Cancel.description) { (index) -> Void in
                        if index != -1{
                            self.unfollowUser()
                        }
                    }
                default:
                    break
                }
            }
        }else {
            self.showLoginView(true)
        }
    }
    
    func followUser(){
        if self.loginUser != nil {
            self.showLoadingViewInView(self.followButton)
            CTAUserRelationDomain.getInstance().followUser(self.loginUser!.userID, relationUserID: self.viewUser!.userID) { (info) -> Void in
                if info.result {
                    let relationType:Int = self.viewUser!.relationType
                    self.viewUser!.relationType = (relationType==0 ? 1 : 5)
                    self.viewUser!.beFollowCount += 1
                    self.setViewByDetailUser()
                    self.saveUserDetailToLocal()
                }
                self.hideLoadingViewInView(self.followButton)
            }
        }
    }
    
    func unfollowUser(){
        if self.loginUser != nil {
            self.showLoadingViewInView(self.followButton)
            CTAUserRelationDomain.getInstance().unFollowUser(self.loginUser!.userID, relationUserID: self.viewUser!.userID) { (info) -> Void in
                if info.result {
                    let relationType:Int = self.viewUser!.relationType
                    self.viewUser!.relationType = (relationType==1 ? 0 : 3)
                    self.viewUser!.beFollowCount = (self.viewUser!.beFollowCount - 1  > 0 ? self.viewUser!.beFollowCount - 1 : 0)
                    self.setViewByDetailUser()
                    self.saveUserDetailToLocal()
                }
                self.hideLoadingViewInView(self.followButton)
            }
        }
    }
    
    func beginFresh(){
        self.loadFirstData()
        self.loadUserDetail()
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
        if self.isLoading{
            self.freshComplete();
            return
        }
        self.isLoading = true
        self.isLoadedAll = false
        let userID = self.loginUser == nil ? "" : self.loginUser!.userID
        if self.publishType == .Posts{
            CTAPublishDomain.getInstance().userPublishList(userID, beUserID: self.viewUser!.userID, start: start, size: size) { (info) -> Void in
                self.loadPublishesComplete(info, size: size, publishType: .Posts)
            }
        }else if self.publishType == .Likes{
            CTAPublishDomain.getInstance().userLikePublishList(userID, beUserID: self.viewUser!.userID, start: start, size: size, compelecationBlock: { (info) in
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
                                if !self.checkPublishModelIsHave(newmodel, publishArray: self.publishModelArray){
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
                                for j in 0..<modelArray!.count{
                                    if j < self.publishModelArray.count{
                                        let oldModel = self.publishModelArray[j]
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
                        self.publishModelArray.removeAll()
                        self.loadMoreModelArray(modelArray!)
                        self.footerFresh.resetNoMoreData()
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
            if !self.checkPublishModelIsHave(publishModel, publishArray: self.publishModelArray){
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
    
    func loadUserDetail(){
        let userID = self.loginUser == nil ? "" : self.loginUser!.userID
        CTAUserDomain.getInstance().userDetail(userID, beUserID: self.viewUser!.userID) { (info) -> Void in
            if info.result{
                self.viewUser = info.baseModel! as? CTAViewUserModel
                self.saveUserDetailToLocal()
            }else {
                self.loadUserDetailFromLocal()
            }
            self.setViewByDetailUser()
        }
    }
    
    func setViewByDetailUser(){
        if self.viewUser == nil {
            self.followCountLabel.text = "0"
            self.beFollowCountLabel.text = "0"
            self.setFollowLabelPosition()
            self.followButton.setBackgroundImage(UIImage(named: "follow_bg"), forState: .Normal)
            self.followButton.setTitle(NSLocalizedString("FollowButtonLabel", comment: ""), forState: .Normal)
            self.followButton.setTitleColor(CTAStyleKit.selectedColor, forState: .Normal)
        }else {
            let followCount = self.viewUser!.followCount
            let beFollowCount = self.viewUser!.beFollowCount
            self.setFollowButton()
            
            self.followCountLabel.text = self.changeCountToString(followCount)
            self.beFollowCountLabel.text = self.changeCountToString(beFollowCount)
            
            self.setUserIcon(self.viewUser!.userIconURL)
            self.userNicknameLabel.text = self.viewUser!.nickName
            self.userDescLabel.text  = self.viewUser!.userDesc
            self.setViewsPosition()
            self.setFollowLabelPosition()
        }
    }
    
    func setFollowButton(){
        let relationType:Int = self.viewUser!.relationType
        var isHidden = false
        var buttonLabel:String = ""
        var buttonBg:UIImage? = UIImage(named: "follow_bg")
        var buttonLabelColor = CTAStyleKit.selectedColor
        switch  relationType{
        case -1:
            isHidden = true
            buttonLabel = ""
        case 0, 3:
            buttonLabel = NSLocalizedString("FollowButtonLabel", comment: "")
            buttonBg    = UIImage(named: "follow_bg")
            buttonLabelColor = CTAStyleKit.selectedColor
            isHidden = false
        case 1, 5:
            buttonLabel = NSLocalizedString("UnFollowButtonLabel", comment: "")
            buttonBg    = UIImage(named: "following_bg")
            buttonLabelColor = CTAStyleKit.commonBackgroundColor
            isHidden = false
        case 2, 4, 6:
            isHidden = true
            buttonLabel = ""
        default:
            isHidden = true
            buttonLabel = ""
        }
        self.followButton.hidden = isHidden
        self.followButton.setTitle(buttonLabel, forState: .Normal)
        self.followButton.setBackgroundImage(buttonBg, forState: .Normal)
        self.followButton.setTitleColor(buttonLabelColor, forState: .Normal)
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

extension UserViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
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
            if publihshModel.publishID == self.selectedPublishID{
                if self.isHideSelectedCell {
                    publishesCell.alpha = 0
                }
                self.isHideSelectedCell = false
            }
        }
        return publishesCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let publishesCell = self.collectionView.cellForItemAtIndexPath(indexPath)
        let index = indexPath.row
        self.selectedPublishID = ""
        if index < self.publishModelArray.count && index > -1{
            self.selectedPublishID = self.publishModelArray[index].publishID
        }
        if self.selectedPublishID != "" {
            let bounds = UIScreen.mainScreen().bounds
            var cellFrame:CGRect!
            var transitionView:UIView!
            if publishesCell != nil {
                cellFrame = publishesCell!.frame
                let zorePt = publishesCell!.convertPoint(CGPoint(x: 0, y: 0), toView: self.view)
                cellFrame.origin.y = zorePt.y
                cellFrame.origin.x = zorePt.x
                transitionView = publishesCell!.snapshotViewAfterScreenUpdates(false)
            }else {
                cellFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
                transitionView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
                transitionView.backgroundColor = CTAStyleKit.commonBackgroundColor
            }
            
            let ani = CTAScaleTransition.getInstance()
            ani.alphaView = publishesCell
            ani.transitionView = transitionView
            ani.transitionAlpha = 1
            ani.fromRect = cellFrame
            ani.toRect = CGRect(x: 0, y: (bounds.height - bounds.width )/2 - Detail_Space, width: bounds.width, height: bounds.width)
            
            var detailType:PublishDetailType = .Posts
            if self.publishType == .Posts{
                detailType = .Posts
            }else if self.publishType == .Likes{
                detailType = .Likes
            }
            let vc = Moduler.module_publishDetail(self.selectedPublishID, publishArray: self.publishModelArray, delegate: self, type: detailType, viewUserID: self.viewUser!.userID)
            let navi = UINavigationController(rootViewController: vc)
            navi.transitioningDelegate = ani
            navi.modalPresentationStyle = .Custom
            self.presentViewController(navi, animated: true, completion: {
            })
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offY = self.collectionView.contentOffset.y
        if offY > self.collectionLayout.stickyHeight{
            self.collectionLayout.isSticky = true
            self.collectionLayout.isHold = true
            self.changeHeaderAlpha(self.collectionLayout.stickyHeight, totalH: self.collectionLayout.stickyHeight)
        }else {
            self.collectionLayout.isSticky = false
            self.changeHeaderAlpha(offY, totalH: self.collectionLayout.stickyHeight)
        }
    }
    
    func changeHeaderAlpha(offY:CGFloat, totalH:CGFloat){
        let nikeNameYB = self.topNikeNameY + self.userInfoView.frame.origin.y
        let nikeNameYE = totalH + 28
        if offY < 0{
            self.userInfoView.alpha = 1
            self.userFollowView.alpha = 1
            self.userNicknameLabel.frame.origin.y = nikeNameYB
        }else {
            let viewAlpha = (totalH - offY)/totalH
            self.userInfoView.alpha = viewAlpha
            self.userFollowView.alpha = viewAlpha
            self.userNicknameLabel.frame.origin.y = (1-viewAlpha) * (nikeNameYE - nikeNameYB) + nikeNameYB
        }
    }
}

extension UserViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension UserViewController: UserListViewDelegate{
    
    func getUserListDismisRect(type:UserListType) -> CGRect?{
        let bound = UIScreen.mainScreen().bounds
        var rect:CGRect?
        if type == .Followers{
            let rectPoint = self.beFollowLabel.convertPoint(CGPoint(x: 0, y: 0), toView: self.view)
            let labelW = self.beFollowCountLabel.frame.width + self.beFollowLabel.frame.width
            rect = CGRect(x: rectPoint.x, y: rectPoint.y, width: labelW, height: self.beFollowCountLabel.frame.height)
        }else if type == .Followings{
            let rectPoint = self.followLabel.convertPoint(CGPoint(x: 0, y: 0), toView: self.view)
            let labelW = self.followCountLabel.frame.width + self.followLabel.frame.width
            rect = CGRect(x: rectPoint.x, y: rectPoint.y, width: labelW, height: self.followCountLabel.frame.height)
        }
        if rect != nil {
            return self.getViewFromRect(rect!, viewRect: bound)
        }else {
            return nil
        }
    }
    
    func disUserListMisComplete(type:UserListType){
        self.isDisMis = true
        self.viewWillAppear(true)
        self.viewDidAppear(true)
    }
}

extension UserViewController: PublishDetailViewDelegate{

    func transitionComplete() {
        let cells = self.collectionView.visibleCells()
        for i in 0..<cells.count{
            let cell = cells[i]
            cell.alpha = 1
        }
        self.isDisMis = true
        self.viewWillAppear(true)
        self.viewDidAppear(true)
    }
    
    func getPublishCell(selectedID:String, publishArray:Array<CTAPublishModel>) -> CGRect?{
        let cellFrame:CGRect = self.saveNewPublishArray(selectedID, publishArray: publishArray)
        return cellFrame;
    }
    
    func saveNewPublishArray(selectedID:String, publishArray:Array<CTAPublishModel>) -> CGRect{
        var isChange:Bool = false
        if publishArray.count == self.publishModelArray.count {
            for i in 0..<publishArray.count{
                let oldModel = self.publishModelArray[i]
                let newModel = publishArray[i]
                if oldModel.publishID != newModel.publishID {
                    isChange = true
                    break
                }else {
                    let index = self.getPublishIndex(newModel.publishID, publishArray: self.publishModelArray)
                    if index != -1{
                        self.publishModelArray.insert(newModel, atIndex: index)
                        self.publishModelArray.removeAtIndex(index+1)
                    }
                }
            }
        }else {
            isChange = true
        }
        if isChange{
            self.publishModelArray.removeAll()
            self.publishModelArray = publishArray
            self.footerFresh.resetNoMoreData()
            self.saveArrayToLocal()
        }
        self.selectedPublishID = selectedID
        
        var currentIndex:Int = 0
        for i in 0..<self.publishModelArray.count{
            let model = self.publishModelArray[i]
            if model.publishID == self.selectedPublishID {
                currentIndex = i
            }
        }
        let boundsHeight = self.collectionView.frame.size.height
        let totalIndex = self.publishModelArray.count - 1
        let cellRect = self.getCellRect()
        let space = self.getCellSpace()
        let currentLineIndex = Int(currentIndex / self.cellHorCount)
        let currentColumnIndex = Int(currentIndex % self.cellHorCount)
        let totalLineIndex   = Int(totalIndex / self.cellHorCount)
        let currentY = CGFloat(currentLineIndex+1) * (space + cellRect.height) - cellRect.height/2 + self.topView.frame.height
        let totalY = CGFloat(totalLineIndex+1) * (space + cellRect.height) + self.topView.frame.height + 44
        
        var scrollOffY:CGFloat = 0
        if (totalY - currentY) > boundsHeight/2{
            scrollOffY = currentY - boundsHeight/2
        }else {
            scrollOffY = totalY - boundsHeight
        }
        if scrollOffY < -20{
            scrollOffY = -20
        }
        self.isHideSelectedCell = true
        self.collectionView.reloadData()
        self.collectionView.contentOffset.y = scrollOffY
        
        let cellY = CGFloat(currentLineIndex) * (space + cellRect.height) + self.topView.frame.height - scrollOffY + self.collectionView.frame.origin.y
        let currentRect = CGRect(x: CGFloat(currentColumnIndex)*(space + cellRect.width) + space, y: cellY, width: cellRect.width, height: cellRect.height)
        return currentRect
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


class CTACollectionViewStickyFlowLayout: UICollectionViewFlowLayout {
    
    var isSticky:Bool = false
    
    var stickyHeight:CGFloat = 0.0
    
    var isHold:Bool = false
    
    override func collectionViewContentSize() -> CGSize{
        let superSize = super.collectionViewContentSize()
        if self.isHold {
            let offY = self.collectionView?.contentOffset.y
            if offY > 0{
                let viewFrame = self.collectionView!.frame
                let maxHeight = viewFrame.height + stickyHeight
                if superSize.height < maxHeight {
                    let newSize = CGSizeMake(superSize.width, maxHeight)
                    return newSize
                }else {
                    return superSize
                }
            }else {
                self.isHold = false
                return superSize
            }
        }else {
            return superSize
        }
        
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool{
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]?{
        
        var answer = super.layoutAttributesForElementsInRect(rect)
        if self.isSticky{
            let missingSections:NSMutableIndexSet = NSMutableIndexSet()
            for var i in 0..<answer!.count{
                let layoutAttributes = answer![i]
                if layoutAttributes.representedElementCategory == .Cell {
                    missingSections.addIndex(layoutAttributes.indexPath.section)
                }
                if layoutAttributes.representedElementKind == UICollectionElementKindSectionHeader{
                    answer?.removeAtIndex(i)
                    i=i-1
                }
            }
            
            if missingSections.count == 0 {
                missingSections.addIndex(0)
            }
            missingSections.enumerateIndexesUsingBlock { (idx, stop) in
                let indexPath = NSIndexPath(forItem: 0, inSection: idx)
                let layoutAttributes = self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: indexPath)
                answer?.append(layoutAttributes!)
            }
        }
        return answer;
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes?{
        let attributes = super.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath: indexPath)
        if self.isSticky{
            if elementKind == UICollectionElementKindSectionHeader {
                let cv = self.collectionView!;
                let contentOffset = cv.contentOffset;
                var nextHeaderOrigin = CGPointMake(CGFloat(Float.infinity), CGFloat(Float.infinity))
                
                if (indexPath.section+1 < cv.numberOfSections()) {
                    let nextHeaderAttributes =  super.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath: NSIndexPath(forItem: 0, inSection: indexPath.section+1))
                    nextHeaderOrigin = nextHeaderAttributes!.frame.origin;
                }
                
                var frame = attributes!.frame;
                if (self.scrollDirection == .Vertical) {
                    frame.origin.y = min(max(contentOffset.y, frame.origin.y), nextHeaderOrigin.y - CGRectGetHeight(frame)) - stickyHeight;
                }
                else { // UICollectionViewScrollDirectionHorizontal
                    frame.origin.x = min(max(contentOffset.x, frame.origin.x), nextHeaderOrigin.x - CGRectGetWidth(frame));
                }
                attributes!.zIndex = 1024;
                attributes!.frame = frame;
            }
        }
        return attributes;
    }
    
    override func initialLayoutAttributesForAppearingSupplementaryElementOfKind(elementKind: String, atIndexPath elementIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes?{
        let attributes = self.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath: elementIndexPath)
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingSupplementaryElementOfKind(elementKind: String, atIndexPath elementIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes?{
        let attributes = self.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath: elementIndexPath)
        return attributes
    }
}




