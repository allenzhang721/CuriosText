//
//  RecommandViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import MJRefresh

class RecommandViewController: UIViewController, CTAPublishCellProtocol, CTAPublishCacheProtocol, CTAPublishModelProtocol {

    var loginUser:CTAUserModel?
    var viewUserID:String = ""
    
    var headerView:UIView!
    var collectionView:UICollectionView!
    var collectionLayout:UICollectionViewFlowLayout!
    
    var headerFresh:MJRefreshGifHeader!
    var footerFresh:MJRefreshAutoGifFooter!
    
    var publishModelArray:Array<CTAPublishModel> = []
    var isLoadingFirstData:Bool = false
    
    var selectedPublishID:String = ""
    var isHideSelectedCell:Bool = false
    var isAddOber:Bool = false
    var isDisMis:Bool = false
    var isLoadLocal:Bool = false
    var previousScrollViewYOffset:CGFloat = 0.0
    let scrollTop:CGFloat = -20.00
    var isFreshToTop:Bool = false
    
    var isLoading:Bool = false
    var isLoadedAll:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initView()
        
        self.navigationController?.navigationBarHidden = true
        self.view.backgroundColor = CTAStyleKit.commonBackgroundColor
        if !self.isAddOber{
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(refreshView(_:)), name: "refreshSelf", object: nil)
            self.isAddOber = true
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.resetViewPosition()
        self.loadLocalUserModel()
        let userID = (self.loginUser == nil) ? "-1" : self.loginUser!.userID
        if userID != self.viewUserID {
            self.getLoadCellData()
            if !self.isLoadLocal{
                self.publishModelArray.removeAll()
            }
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.isDisMis {
            self.loadLocalUserModel()
            self.viewAppearBegin()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.loginUser = nil
        self.isDisMis = true
        self.hideLoadingView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.initCollectionView()
        self.initHeader()
    }
    
    func initHeader(){
        let bounds = UIScreen.mainScreen().bounds
        
        self.headerView = UIView(frame: CGRect(x: 0, y: 20, width: bounds.width, height: 44))
        self.headerView.backgroundColor = CTAStyleKit.commonBackgroundColor
        self.view.addSubview(self.headerView)
        
        let homeLabel = UILabel(frame: CGRect(x: 0, y: 8, width: bounds.width, height: 28))
        homeLabel.font = UIFont.boldSystemFontOfSize(18)
        homeLabel.textColor = CTAStyleKit.normalColor
        homeLabel.text = NSLocalizedString("RecommendLabel", comment: "")
        homeLabel.textAlignment = .Center
        self.headerView.addSubview(homeLabel)
        let textLine = UIImageView(frame: CGRect(x: 0, y: 43, width: bounds.width, height: 1))
        textLine.image = UIImage(named: "space-line")
        headerView.addSubview(textLine)
        self.view.addSubview(self.headerView)
    }
    
    func initCollectionView(){
        let bounds = UIScreen.mainScreen().bounds
        let rect:CGRect = CGRect(x: 0, y: 46, width: bounds.width, height: bounds.height-46)
        let space:CGFloat = self.getCellSpace()
        self.collectionLayout = UICollectionViewFlowLayout()
        
        self.collectionLayout.itemSize = self.getCellRect()
        self.collectionLayout.sectionInset = UIEdgeInsets(top: 0, left: space, bottom: 0, right: space)
        self.collectionLayout.minimumLineSpacing = space
        self.collectionLayout.minimumInteritemSpacing = space
        self.collectionView = UICollectionView(frame: rect, collectionViewLayout: self.collectionLayout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerClass(CTAPublishesCell.self, forCellWithReuseIdentifier: "ctaPublishesCell")
        self.collectionView.backgroundColor = CTAStyleKit.commonBackgroundColor
        self.view.addSubview(self.collectionView!);
        
        let freshIcon1:UIImage = UIImage(named: "fresh-icon-1")!
        
        self.headerFresh = MJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(loadFirstData))
        self.headerFresh.setImages([freshIcon1], forState: .Idle)
        self.headerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Pulling)
        self.headerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Refreshing)
        
        self.headerFresh.lastUpdatedTimeLabel?.hidden = true
        self.headerFresh.stateLabel?.hidden = true
        self.collectionView.mj_header = self.headerFresh
        
        self.footerFresh = MJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(loadLastData))
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
    
    func getLoadCellData(){
        let userID = (self.loginUser == nil) ? "" : self.loginUser!.userID
        let request = CTAHotPublishListRequest(userID: userID, start: 0)
        let data = self.getPublishArray(request)
        if data == nil {
            self.isLoadLocal = false
        }else {
            self.isLoadLocal = true
            self.publishModelArray = data!
        }
    }
    
    func saveArrayToLocal(){
        let userID = (self.loginUser == nil) ? "" : self.loginUser!.userID
        
        var savePublishModel:Array<CTAPublishModel> = []
        if self.publishModelArray.count < 100 {
            savePublishModel = self.publishModelArray
        }else {
            let slice = self.publishModelArray[0...100]
            savePublishModel = Array(slice)
        }
        let request = CTAHotPublishListRequest(userID: userID, start: 0)
        self.savePublishArray(request, modelArray: savePublishModel)
    }
    
    func loadFirstData(){
        self.isLoadingFirstData = true
        self.loadUserPublishes(0)
    }
    
    func loadLastData() {
        self.isLoadingFirstData = false
        self.loadUserPublishes(self.publishModelArray.count)
    }
    
    func resetViewPosition(){
        self.headerView.frame.origin.y = 20
        self.headerView.alpha = 1
        self.collectionView.frame.origin.y = 46
    }
    
    func refreshView(noti: NSNotification){
        if self.collectionView.contentOffset.y > self.scrollTop{
            self.isFreshToTop = true
            self.collectionView.setContentOffset(CGPoint(x: 0, y: self.scrollTop), animated: true)
        }else {
            self.headerFresh.beginRefreshing()
        }
    }
    
    func viewAppearBegin(){
        let userID = (self.loginUser == nil) ? "-1" : self.loginUser!.userID
        if userID != self.viewUserID {
            self.viewUserID = userID
            self.headerFresh.beginRefreshing()
            self.previousScrollViewYOffset = self.scrollTop
        }
    }
    
    func loadUserPublishes(start:Int, size:Int = 30){
        if self.isLoading{
            self.freshComplete();
            return
        }
        self.isLoading = true
        self.isLoadedAll = false
        let userID = (self.loginUser == nil) ? "" : self.loginUser!.userID
        CTAPublishDomain.getInstance().hotPublishList(userID, start: start, size: size) { (info) in
            self.loadPublishesComplete(info, size:size)
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
                        self.collectionView.reloadData()
                    }
                }else {
                    self.loadMoreModelArray(modelArray!)
                    self.collectionView.reloadData()
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
}

extension RecommandViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.publishModelArray.count;
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
    }
}

extension RecommandViewController: CTALoadingProtocol{
    var loadingImageView:UIImageView?{
        return nil
    }
}



