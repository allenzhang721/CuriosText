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

class UserListViewController: UIViewController{
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initView()
        self.navigationController?.navigationBarHidden = true
        self.view.backgroundColor = CTAStyleKit.commonBackgroundColor
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if CTAUserManager.isLogin {
            self.loginUser = CTAUserManager.user
        }else {
            self.loginUser = nil
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !self.notFresh {
            self.userModelArray = []
            self.headerFresh.beginRefreshing()
        }
        self.notFresh = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView(){
        self.initCollectionView()
        self.initHeader()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanHandler(_:)))
        pan.maximumNumberOfTouches = 1
        pan.minimumNumberOfTouches = 1
        self.view.addGestureRecognizer(pan)
    }
    
    func initHeader(){
        let bounds = UIScreen.mainScreen().bounds
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 64))
        headerView.backgroundColor = CTAStyleKit.commonBackgroundColor
        self.view.addSubview(headerView)
        
        self.headerLabel = UILabel(frame: CGRect(x: 0, y: 28, width: bounds.width, height: 28))
        self.headerLabel.font = UIFont.boldSystemFontOfSize(18)
        self.headerLabel.textColor = CTAStyleKit.normalColor
        self.headerLabel.textAlignment = .Center
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
        closeButton.setImage(UIImage(named: "close-button"), forState: .Normal)
        closeButton.setImage(UIImage(named: "close-selected-button"), forState: .Highlighted)
        closeButton.addTarget(self, action: #selector(closeButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(closeButton)
        
        let textLine = UIImageView(frame: CGRect(x: 0, y: 63, width: bounds.width, height: 1))
        textLine.image = UIImage(named: "space-line")
        headerView.addSubview(textLine)
        
    }
    
    func initCollectionView(){
        let bounds = UIScreen.mainScreen().bounds
        let rect:CGRect = CGRect(x: 0, y: 46, width: bounds.width, height: bounds.height-46)
        self.collectionLayout = UICollectionViewFlowLayout()
        
        self.collectionLayout.itemSize = CGSize(width: bounds.width, height: 60)
        self.collectionLayout.minimumLineSpacing = 0
        self.collectionLayout.minimumInteritemSpacing = 0
        self.collectionView = UICollectionView(frame: rect, collectionViewLayout: self.collectionLayout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerClass(CTAUserListCell.self, forCellWithReuseIdentifier: "ctaUserListCell")
        self.collectionView.backgroundColor = CTAStyleKit.commonBackgroundColor
        self.view.addSubview(self.collectionView!);
        
        let freshIcon1:UIImage = UIImage(named: "fresh-icon-1")!
        
        self.headerFresh = MJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(UserListViewController.loadFirstData))
        self.headerFresh.setImages([freshIcon1], forState: .Idle)
        self.headerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Pulling)
        self.headerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Refreshing)
        
        self.headerFresh.lastUpdatedTimeLabel?.hidden = true
        self.headerFresh.stateLabel?.hidden = true
        self.collectionView.mj_header = self.headerFresh
        
        self.footerFresh = MJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(UserListViewController.loadLastData))
        self.footerFresh.refreshingTitleHidden = true
        self.footerFresh.setTitle("", forState: .Idle)
        self.footerFresh.setTitle("", forState: .NoMoreData)
        self.footerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Refreshing)
        self.collectionView.mj_footer = footerFresh;
    }
    
    func closeButtonClick(sender: UIButton){
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    
    func loadFirstData(){
        self.isLoadingFirstData = true
        self.loadUserPublishes(0)
    }
    
    func loadLastData() {
        self.isLoadingFirstData = false
        self.loadUserPublishes(self.userModelArray.count)
    }
    
    func loadUserPublishes(start:Int, size:Int = 30){
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
            CTAPublishDomain.getInstance().publishLikeUserList(userID, publishID: self.publishID, start: 0, size: size, compelecationBlock: { (info) in
                self.loadUsersComplete(info, size: size)
            })
        }
    }
    
    func loadUsersComplete(info: CTADomainListInfo, size:Int){
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
                        self.userModelArray.removeAll()
                        self.loadMoreModelArray(modelArray!)
                        self.footerFresh.resetNoMoreData()
                    }
                }else {
                    self.loadMoreModelArray(modelArray!)
                }
            }
        }
        self.freshComplete()
    }
    
    func loadMoreModelArray(modelArray:Array<AnyObject>){
        for i in 0..<modelArray.count{
            let model = modelArray[i] as! CTAViewUserModel
            if !self.checkModelIsHave(model, array: self.userModelArray){
                self.userModelArray.append(model)
            }
        }
        self.collectionView.reloadData()
    }
    
    func checkModelIsHave(userModel:CTAViewUserModel, array:Array<CTAViewUserModel>) -> Bool{
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
    
    func viewPanHandler(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began:
            print("viewPanHandler = began")
        case .Changed:
            print("viewPanHandler = Changed")
        case .Ended, .Cancelled, .Failed:
            ()
        default:
            ()
        }
    }
}

extension UserListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return  self.userModelArray.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let userCell:CTAUserListCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("ctaUserListCell", forIndexPath: indexPath) as! CTAUserListCell
        let index = indexPath.row
        if index < self.userModelArray.count{
            let userModel = self.userModelArray[index]
            userCell.viewUser = userModel
        }
        userCell.delegate = self
        return userCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let index = indexPath.row
        self.selectedUserID = ""
        if index < self.userModelArray.count && index > -1{
            self.selectedUserID = self.userModelArray[index].userID
        }
        if self.selectedUserID != "" {
            
        }
    }
}

extension UserListViewController:CTALoadingProtocol{
    var loadingImageView:UIImageView?{
        return nil
    }
}

extension UserListViewController:CTAUserListCellDelegate{
    
    func cellUserIconTap(cell:CTAUserListCell?){
        if cell != nil {
            if let viewUserModel = cell?.viewUser{
                let userPublish = UserViewController()
                userPublish.viewUser = viewUserModel
                self.navigationController?.pushViewController(userPublish, animated: true)
                self.notFresh = true
            }
        }

    }
}

