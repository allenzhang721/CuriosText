//
//  UserListViewController.swift
//  CuriosTextApp
//
//  Created by allen on 16/7/3.
//  Copyright © 2016年 botai. All rights reserved.
//
import UIKit
import MJRefresh

enum UserListType:String{
    case Likers = "Likers"
    case Followers = "Followers"
    case Followings = "Followings"
}

let DragDownHeight:CGFloat = 44

class UserListViewController: UIViewController, CTALoginProtocol{
    
    var loginUser:CTAUserModel?
    var viewUserID:String = ""
    var publishID:String = ""
    
    var type:UserListType = .Followers
    
    var headerLabel:UILabel!
    
    var collectionView:UICollectionView!
    var collectionLayout:UICollectionViewFlowLayout!
    var headerFresh:MJRefreshGifHeader!
    var footerFresh:MJRefreshAutoGifFooter!
    
    var userModelArray:Array<CTAViewUserModel> = []
    
    var isLoading:Bool = false
    var isLoadedAll:Bool = false
    var isLoadingFirstData:Bool = false
    
    var selectedUserID:String = ""
    
    var notFresh:Bool = false
    
    var delegate:UserListViewDelegate?
    
    var previousScrollViewYOffset:CGFloat = 0.0
    
    var isTopScroll:Bool = false
    
    var isBottomScroll:Bool = false
    
    var isDragMove:Bool = false
    
    let scrollTop:CGFloat = -20.00
    
    var bgView:UIView!
    
    var beganLocation:CGPoint?
    var lastLocation:CGPoint?
    
    var isAddOber:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initView()
        if !self.isAddOber{
            NotificationCenter.default.addObserver(self, selector: #selector(reNewView(_:)), name: NSNotification.Name(rawValue: "loginComplete"), object: nil)
        }
        self.isAddOber = true
        
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CTAUserManager.isLogin {
            self.loginUser = CTAUserManager.user
        }else {
            self.loginUser = nil
        }
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.notFresh {
            self.userModelArray = []
            self.headerFresh.beginRefreshing()
            self.previousScrollViewYOffset = self.scrollTop
        }
        self.notFresh = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView(){
        self.bgView = UIView(frame: self.view.frame)
        self.bgView.backgroundColor = CTAStyleKit.commonBackgroundColor
        self.view.addSubview(self.bgView)
        //self.cropImageRound(self.bgView)
        
        self.initCollectionView()
        self.initHeader()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanHandler(_:)))
        pan.maximumNumberOfTouches = 1
        pan.minimumNumberOfTouches = 1
        self.view.addGestureRecognizer(pan)
    }
    
    func initHeader(){
        let bounds = UIScreen.main.bounds
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 64))
        headerView.backgroundColor = CTAStyleKit.commonBackgroundColor
        self.bgView.addSubview(headerView)
        
        self.headerLabel = UILabel(frame: CGRect(x: 0, y: 28, width: bounds.width, height: 28))
        self.headerLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.headerLabel.textColor = CTAStyleKit.normalColor
        self.headerLabel.textAlignment = .center
        headerView.addSubview(self.headerLabel)
        switch self.type {
        case .Followers:
            self.headerLabel.text = NSLocalizedString("BeFollowLabel", comment: "")
        case .Followings:
            self.headerLabel.text = NSLocalizedString("FollowLabel", comment: "")
        case .Likers:
            self.headerLabel.text = NSLocalizedString("LikersLabel", comment: "")
        }
        
        let closeButton = UIButton(frame: CGRect(x: 0, y: 22, width: 40, height: 40))
        closeButton.setImage(UIImage(named: "close-button"), for: UIControlState())
        closeButton.setImage(UIImage(named: "close-selected-button"), for: .highlighted)
        closeButton.addTarget(self, action: #selector(closeButtonClick(_:)), for: .touchUpInside)
        self.bgView.addSubview(closeButton)
        
        let textLine = UIImageView(frame: CGRect(x: 0, y: 63, width: bounds.width, height: 1))
        textLine.image = UIImage(named: "space-line")
        headerView.addSubview(textLine)
        
        self.bgView.layer.borderColor = CTAStyleKit.disableColor.cgColor
        self.bgView.layer.borderWidth = 1
    }
    
    func initCollectionView(){
        let bounds = UIScreen.main.bounds
        let rect:CGRect = CGRect(x: 0, y: 46, width: bounds.width, height: bounds.height-46)
        self.collectionLayout = UICollectionViewFlowLayout()
        
        self.collectionLayout.itemSize = CGSize(width: bounds.width, height: 60)
        self.collectionLayout.minimumLineSpacing = 0
        self.collectionLayout.minimumInteritemSpacing = 0
        self.collectionView = UICollectionView(frame: rect, collectionViewLayout: self.collectionLayout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(CTAUserListCell.self, forCellWithReuseIdentifier: "ctaUserListCell")
        self.collectionView.backgroundColor = CTAStyleKit.commonBackgroundColor
        self.bgView.addSubview(self.collectionView!);
        
        let freshIcon1:UIImage = UIImage(named: "fresh-icon-1")!
        
        self.headerFresh = MJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(UserListViewController.loadFirstData))
        self.headerFresh.setImages([freshIcon1], for: .idle)
        self.headerFresh.setImages(self.getLoadingImages(), duration:1.0, for: .pulling)
        self.headerFresh.setImages(self.getLoadingImages(), duration:1.0, for: .refreshing)
        
        self.headerFresh.lastUpdatedTimeLabel?.isHidden = true
        self.headerFresh.stateLabel?.isHidden = true
        self.collectionView.mj_header = self.headerFresh
        
        self.footerFresh = MJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(UserListViewController.loadLastData))
        self.footerFresh.isRefreshingTitleHidden = true
        self.footerFresh.setTitle("", for: .idle)
        self.footerFresh.setTitle("", for: .noMoreData)
        self.footerFresh.setImages(self.getLoadingImages(), duration:1.0, for: .refreshing)
        self.collectionView.mj_footer = footerFresh;
    }
    
    func closeButtonClick(_ sender: UIButton){
        self.closeHandler()
    }
    
    func closeHandler(){
        var toRect:CGRect? = nil
        if self.delegate != nil {
            toRect = self.delegate!.getUserListDismisRect(self.type)
        }
        let view = self.bgView.snapshotView(afterScreenUpdates: false)
        view?.frame.origin.y = self.bgView.frame.origin.y
        let ani = CTAScaleTransition.getInstance()
        ani.toRect = toRect
        ani.transitionAlpha = 0.4
        ani.transitionView = view
        self.dismiss(animated: true) {
            if self.delegate != nil {
                self.delegate!.disUserListMisComplete(self.type)
                self.delegate = nil
            }
        }
    }
    
    func reNewView(_ noti: Notification){
        self.notFresh = false
    }
    
    func loadFirstData(){
        self.isLoadingFirstData = true
        self.loadUserPublishes(0)
    }
    
    func loadLastData() {
        self.isLoadingFirstData = false
        self.loadUserPublishes(self.userModelArray.count)
    }
    
    func loadUserPublishes(_ start:Int, size:Int = 30){
        if self.isLoading{
            self.freshComplete();
            return
        }
        self.isLoading = true
        self.isLoadedAll = false
        let userID = (self.loginUser == nil) ? "" : self.loginUser!.userID
        switch self.type {
        case .Followers:
            CTAUserRelationDomain.getInstance().userBefollowList(userID, beUserID: self.viewUserID, start: start, size: size, compelecationBlock: { (info) in
                self.loadUsersComplete(info, size: size)
            })
        case .Followings:
            CTAUserRelationDomain.getInstance().userFollowList(userID, beUserID: self.viewUserID, start: start, size: size) { (info) in
                self.loadUsersComplete(info, size: size)
            }
        case .Likers:
            CTAPublishDomain.getInstance().publishLikeUserList(userID, publishID: self.publishID, start: start, size: size, compelecationBlock: { (info) in
                self.loadUsersComplete(info, size: size)
            })
        }
    }
    
    func loadUsersComplete(_ info: CTADomainListInfo, size:Int){
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
                        if self.userModelArray.count > 0{
                            for i in 0..<modelArray!.count{
                                let newmodel = modelArray![i] as! CTAViewUserModel
                                if !self.checkModelIsHave(newmodel, array: self.userModelArray){
                                    isChange = true
                                    break
                                }
                            }
                            if !isChange{
                                for j in 0..<modelArray!.count{
                                    if j < self.userModelArray.count{
                                        let oldModel = self.userModelArray[j]
                                        if !self.checkModelIsHave(oldModel, array: modelArray as! Array<CTAViewUserModel>){
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
                        self.footerFresh.resetNoMoreData()
                        self.userModelArray.removeAll()
                        self.loadMoreModelArray(modelArray!)
                    }
                }else {
                    self.loadMoreModelArray(modelArray!)
                }
            }
        }
        self.freshComplete()
    }
    
    func loadMoreModelArray(_ modelArray:Array<AnyObject>){
        for i in 0..<modelArray.count{
            let model = modelArray[i] as! CTAViewUserModel
            if !self.checkModelIsHave(model, array: self.userModelArray){
                self.userModelArray.append(model)
            }
        }
        self.collectionView.reloadData()
    }
    
    func checkModelIsHave(_ userModel:CTAViewUserModel, array:Array<CTAViewUserModel>) -> Bool{
        for i in 0..<array.count{
            let oldModel = array[i]
            if oldModel.userID == userModel.userID && oldModel.relationType == userModel.relationType{
                return true
            }
        }
        return false
    }
    
    func freshComplete(){
        if self.isLoadingFirstData {
            self.headerFresh.endRefreshing()
            if self.isLoadedAll {
                self.footerFresh.endRefreshingWithNoMoreData()
            }
        }else {
            if self.isLoadedAll {
                self.footerFresh.endRefreshingWithNoMoreData()
            } else {
                self.footerFresh.endRefreshing()
            }
        }
    }
    
    func viewPanHandler(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            self.beganLocation = sender.location(in: view)
        case .changed:
            let newLocation = sender.location(in: view)
            self.viewVerPanHandler(newLocation)
        case .ended, .cancelled, .failed:
            let velocity = sender.velocity(in: view)
            let newLocation = sender.location(in: view)
            if velocity.y > 500 || velocity.y < -500{
                self.closeHandler()
            }else {
                self.viewVerComplete(newLocation)
            }
        default:
            ()
        }
    }
    
    func viewVerPanHandler(_ newLocation:CGPoint){
        if self.lastLocation == nil {
            self.lastLocation = self.beganLocation
        }
        let scrollDiff = newLocation.y - self.lastLocation!.y
        self.bgView.frame.origin.y = self.bgView.frame.origin.y + scrollDiff/4
        self.lastLocation = newLocation
    }
    
    func viewVerComplete(_ newLocation:CGPoint){
        let xRate = newLocation.y - self.beganLocation!.y
        if abs(xRate) >= DragDownHeight {
            self.closeHandler()
        }else {
            UIView.animate(withDuration: 0.2, animations: {
                self.bgView.frame.origin.y = 0
                }, completion: { (_) in
            })
        }
    }
}

extension UserListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return  self.userModelArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let userCell:CTAUserListCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "ctaUserListCell", for: indexPath) as! CTAUserListCell
        let index = indexPath.row
        if index < self.userModelArray.count{
            let userModel = self.userModelArray[index]
            userCell.viewUser = userModel
        }
        userCell.delegate = self
        return userCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let index = indexPath.row
        self.selectedUserID = ""
        if index < self.userModelArray.count && index > -1{
            self.selectedUserID = self.userModelArray[index].userID
        }
        if self.selectedUserID != "" {
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offY = self.collectionView.contentOffset.y
        let scrollDiff = offY - self.previousScrollViewYOffset
        if scrollDiff < 0 {
            self.isBottomScroll = false
            if self.isTopScroll{
                self.isDragMove = true
            }
        }else {
            self.isTopScroll = false
            if self.isBottomScroll{
                self.isDragMove = true
            }
        }
        if self.isDragMove{
            self.collectionView.contentOffset.y = self.previousScrollViewYOffset
            self.bgView.frame.origin.y = self.bgView.frame.origin.y - scrollDiff/4
        }
        
        self.previousScrollViewYOffset = self.collectionView.contentOffset.y
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollEnd()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        let offY = self.collectionView.contentOffset.y
        if offY <= self.scrollTop{
            self.isTopScroll = true
        }
        
        let offSize = self.collectionView.contentSize
        let maxOffY = offSize.height - self.collectionView.frame.height + self.scrollTop
        if maxOffY > 0 {
            if offY > maxOffY && self.isLoadedAll{
                self.isBottomScroll = true
            }
        }else {
            self.isBottomScroll = true
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.scrollEnd()
    }
    
    func scrollEnd(){
        if self.isDragMove{
            self.isBottomScroll = false
            self.isTopScroll = false
            self.isDragMove = false
            let currentY = abs(self.bgView.frame.origin.y - 0)
            if currentY > DragDownHeight{
                self.closeHandler()
            }else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.bgView.frame.origin.y = 0
                    }, completion: { (_) in
                })
            }
        }
    }
}

extension UserListViewController:CTALoadingProtocol{
    var loadingImageView:UIImageView?{
        return nil
    }
}

extension UserListViewController:CTAUserListCellDelegate{
    
    func cellUserIconTap(_ cell:CTAUserListCell?){
        if cell != nil {
            if let viewUserModel = cell?.viewUser{
                let userPublish = UserViewController()
                userPublish.viewUser = viewUserModel
                self.navigationController?.pushViewController(userPublish, animated: true)
            }
        }
    }
    
    func followButtonTap(_ followView:UIView, cell:CTAUserListCell?){
        if cell != nil {
            if self.loginUser != nil {
                let userID = self.loginUser == nil ? "" : self.loginUser!.userID
                let viewUser = cell!.viewUser
                self.showLoadingViewInView(followView)
                CTAUserRelationDomain.getInstance().followUser(userID, relationUserID: viewUser!.userID) { (info) -> Void in
                    if info.result {
                        let relationType:Int = viewUser!.relationType
                        viewUser!.relationType = (relationType==0 ? 1 : 5)
                        viewUser!.beFollowCount += 1
                        cell?.viewUser = viewUser
                    }
                    self.hideLoadingViewInView(followView)
                }
            }else {
                self.showLoginView(true)
            }
        }
    }
}

protocol UserListViewDelegate: AnyObject {
    func getUserListDismisRect(_ type:UserListType) -> CGRect?
    func disUserListMisComplete(_ type:UserListType)
}

