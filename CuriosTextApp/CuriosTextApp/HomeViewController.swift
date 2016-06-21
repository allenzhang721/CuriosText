//
//  HomeViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import MJRefresh

class HomeViewController: UIViewController, CTAPublishCacheProtocol, CTAPublishModelProtocol{
    
    var loginUser:CTAUserModel?
    var viewUserID:String = ""
    
    var publishModelArray:Array<CTAPublishModel> = []
    var selectedPublishID:String = ""
    
    var headerView:UIView!
    var collectionView:UICollectionView!
    var collectionLayout:UICollectionViewFlowLayout!
    
    var headerFresh:MJRefreshGifHeader!
    var footerFresh:MJRefreshAutoGifFooter!
    
    var isLoadLocal:Bool = false
    
    var isDisMis:Bool = true
    
    var isAddOber:Bool = false
    
    var isLoadingFirstData:Bool = false
    
    var isLoading:Bool = false
    
    var isLoadedAll:Bool = false
    
    var previousScrollViewYOffset:CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        self.initView()
        self.view.backgroundColor = CTAStyleKit.commonBackgroundColor
        if !self.isAddOber{
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reNewView(_:)), name: "publishEditFile", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reNewView(_:)), name: "loginComplete", object: nil)
            self.isAddOber = true
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        homeLabel.text = NSLocalizedString("DefaultName", comment: "")
        homeLabel.textAlignment = .Center
        self.headerView.addSubview(homeLabel)
        let textLine = UIImageView.init(frame: CGRect.init(x: 0, y: 43, width: bounds.width, height: 1))
        textLine.image = UIImage(named: "space-line")
        headerView.addSubview(textLine)
        self.view.addSubview(self.headerView)
        
        let timeView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 20))
        timeView.backgroundColor = CTAStyleKit.commonBackgroundColor
        self.view.addSubview(timeView)
    }
    
    func initCollectionView(){
        let bounds = UIScreen.mainScreen().bounds
        let rect:CGRect = CGRect(x: 0, y: 46, width: bounds.width, height: bounds.height-46)
        self.collectionLayout = UICollectionViewFlowLayout()

        let itemW = bounds.width
        self.collectionLayout.itemSize = CGSize(width: itemW, height: itemW+100)
        self.collectionLayout.minimumLineSpacing = 10
        self.collectionLayout.minimumInteritemSpacing = 10
        self.collectionView = UICollectionView(frame: rect, collectionViewLayout: self.collectionLayout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerClass(CTAHomePublishesCell.self, forCellWithReuseIdentifier: "ctahomepublishescell")
        self.collectionView.backgroundColor = CTAStyleKit.lightGrayBackgroundColor
        self.view.addSubview(self.collectionView!);
        
        let freshIcon1:UIImage = UIImage(named: "fresh-icon-1")!
        
        self.headerFresh = MJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadFirstData))
        self.headerFresh.setImages([freshIcon1], forState: .Idle)
        self.headerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Pulling)
        self.headerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Refreshing)
        
        self.headerFresh.lastUpdatedTimeLabel?.hidden = true
        self.headerFresh.stateLabel?.hidden = true
        self.collectionView.mj_header = self.headerFresh
        
        self.footerFresh = MJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadLastData))
        self.footerFresh.refreshingTitleHidden = true
        self.footerFresh.setTitle("", forState: .Idle)
        self.footerFresh.setTitle("", forState: .NoMoreData)
        self.footerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Refreshing)
        self.collectionView.mj_footer = footerFresh;
    }
    
    func reloadView(){
        self.resetViewPosition()
        self.getLoginUser()
        let userID = (self.loginUser == nil) ? "-1" : self.loginUser!.userID
        if userID != self.viewUserID {
            self.getLoadCellData()
            if !self.isLoadLocal{
                self.publishModelArray.removeAll()
            }
            self.collectionView.reloadData()
        }
    }
    
    func viewAppearBegin(){
        let userID = (self.loginUser == nil) ? "-1" : self.loginUser!.userID
        if userID != self.viewUserID {
            self.viewUserID = userID
            self.headerFresh.beginRefreshing()
            self.previousScrollViewYOffset = 0.0
        }
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
    
    func getLoginUser(){
        if CTAUserManager.isLogin {
            self.loginUser = CTAUserManager.user
        }else {
            self.loginUser = nil
        }
    }
    
    func getLoadCellData(){
        let userID = (self.loginUser == nil) ? "" : self.loginUser!.userID
        #if DEBUG
            let request = CTANewPublishListRequest(userID: userID, start: 0)
        #else
            let request = CTAUserFollowPublishListRequest(userID: userID, beUserID: userID, start: 0)
        #endif
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
        #if DEBUG
            let request = CTANewPublishListRequest(userID: userID, start: 0)
        #else
            let request = CTAUserFollowPublishListRequest(userID: userID, beUserID: userID, start: 0)
        #endif
        self.savePublishArray(request, modelArray: savePublishModel)
    }

    func reNewView(noti: NSNotification){
        self.viewUserID = ""
    }
    
    func loadUserPublishes(start:Int, size:Int = 30){
        if self.isLoading{
            self.freshComplete();
            return
        }
        self.isLoading = true
        self.isLoadedAll = false
        let userID = (self.loginUser == nil) ? "" : self.loginUser!.userID
        #if DEBUG
            CTAPublishDomain.getInstance().newPublishList(userID, start: start, size: size, compelecationBlock: { (info) in
                self.loadPublishesComplete(info, size:size)
            })
        #else
            if userID != "-1"{
                CTAPublishDomain.getInstance().userFollowPublishList(userID, beUserID: userID, start: start, size: size, compelecationBlock: { (info) in
                    self.loadPublishesComplete(info, size:size)
                })
            }else {
                CTAPublishDomain.getInstance().hotPublishList(userID, start: start, size: size, compelecationBlock: { (info) in
                    self.loadPublishesComplete(info, size:size)
                })
            }
        #endif
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
                                for j in 0..<modelArray!.count{
                                    if j > self.publishModelArray.count{
                                        isChange = true
                                        break
                                    }else {
                                        let oldModel = self.publishModelArray[j]
                                        if !self.checkPublishModelIsHave(oldModel.publishID, publishArray: modelArray as! Array<CTAPublishModel>){
                                            isChange = true
                                            break
                                        }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    //collection view delegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return  self.publishModelArray.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let publishCell:CTAHomePublishesCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("ctahomepublishescell", forIndexPath: indexPath) as! CTAHomePublishesCell
        let index = indexPath.row
        if index < self.publishModelArray.count{
            let publihshModel = self.publishModelArray[index]
            publishCell.publishModel = publihshModel
        }
        publishCell.delegate = self
        return publishCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let index = indexPath.row
        self.selectedPublishID = ""
        if index < self.publishModelArray.count && index > -1{
            self.selectedPublishID = self.publishModelArray[index].publishID
        }
        if self.selectedPublishID != "" {
            //self.selectCellAnimation()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath){
        let publishCell:CTAHomePublishesCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("ctahomepublishescell", forIndexPath: indexPath) as! CTAHomePublishesCell
        publishCell.releaseView()
    }
    
    //scroll view hide tool bar
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var toolBarViewframe = self.headerView.frame
        var collectViewFrame = self.collectionView.frame
        let size  = toolBarViewframe.height
        let framePercentageHidden = ( (20-toolBarViewframe.origin.y) / size)
        let scrollOffset = self.collectionView.contentOffset.y
        let scrollDiff   = scrollOffset - self.previousScrollViewYOffset
        let scrollHeight = collectViewFrame.size.height
        let scrollContentSizeHeight = self.collectionView.contentSize.height + self.collectionView.contentInset.bottom
        if scrollOffset <= -self.collectionView.contentInset.top {
            toolBarViewframe.origin.y = 20
        }else if (scrollOffset + scrollHeight) >= scrollContentSizeHeight {
            toolBarViewframe.origin.y = -size+20
        } else {
            toolBarViewframe.origin.y = min(20, max(-size+20, toolBarViewframe.origin.y - scrollDiff));
        }
        collectViewFrame.origin.y = size + toolBarViewframe.origin.y - 18
        collectViewFrame.size.height = UIScreen.mainScreen().bounds.height - collectViewFrame.origin.y
        self.headerView.frame = toolBarViewframe
        self.collectionView.frame = collectViewFrame
        self.updateBarButtonsAlpha(1-framePercentageHidden)
        self.previousScrollViewYOffset = scrollOffset
        let viewY = collectViewFrame.origin.y
        self.playCellAnimation(scrollOffset - viewY)
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
        let frame = self.headerView.frame
        if frame.origin.y < 0 {
            self.animationNavBarTo((20-frame.size.height))
        }else {
            self.animationNavBarTo(20)
        }
    }
    
    func updateBarButtonsAlpha(alpha:CGFloat){
        let subViews = self.headerView.subviews
        for i in 0..<subViews.count{
            let subView = subViews[i]
            subView.alpha = alpha
        }
    }
    
    func animationNavBarTo(y:CGFloat){
        UIView.animateWithDuration(0.2) { () -> Void in
            var toolBarViewframe = self.headerView.frame
            var collectViewFrame = self.collectionView.frame
            toolBarViewframe.origin.y = y
            collectViewFrame.origin.y = toolBarViewframe.height + toolBarViewframe.origin.y - 18
            collectViewFrame.size.height = self.view.frame.height - collectViewFrame.origin.y
            self.headerView.frame = toolBarViewframe
            self.collectionView.frame = collectViewFrame
            let alpha:CGFloat = (y == 20 ? 1.0 : 0.0)
            self.updateBarButtonsAlpha(alpha)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let bounds = UIScreen.mainScreen().bounds
        let itemW = bounds.width
        return CGSize(width: itemW, height: itemW+100)
    }
    
    func playCellAnimation(offY:CGFloat){
        let bounds = UIScreen.mainScreen().bounds
        let cells = self.collectionView.visibleCells()
        for i in 0..<cells.count{
            let cell = cells[i]
            let cellFrame = cell.frame
            let cellY = cellFrame.origin.y - offY
            let min = bounds.height/2 - bounds.width/2
            let max = bounds.height/2 + bounds.width/2
            let maxRect = CGRect(x: 0, y: min, width: bounds.width, height: (max-min))
            let cellRect = CGRect(x: 10, y: cellY, width: bounds.width-10, height: cellFrame.height)
            let publishCell = (cell as! CTAHomePublishesCell)
            if maxRect.intersects(cellRect){
                publishCell.playAnimation()
            }
        }
    }
}

extension HomeViewController:CTALoadingProtocol{
    var loadingImageView:UIImageView?{
        return nil
    }
}

extension HomeViewController:CTAHomePublishesCellDelegate{
    
}
