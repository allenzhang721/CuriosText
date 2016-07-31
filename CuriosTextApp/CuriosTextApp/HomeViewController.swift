//
//  HomeViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import MJRefresh

class HomeViewController: UIViewController, CTAPublishCacheProtocol, CTAPublishModelProtocol, CTALoginProtocol{
    
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
    
    var selectedCell:CTAHomePublishesCell? = nil
    
    var isHideSelectedCell:Bool = false
    
    let collectionSpace:CGFloat = 5
    
    let scrollTop:CGFloat = -20.00
    
    let headerY:CGFloat  = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        self.initView()
        self.view.backgroundColor = CTAStyleKit.commonBackgroundColor
        if !self.isAddOber{
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(newPublishHandler(_:)), name: "publishEditFile", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reNewView(_:)), name: "loginComplete", object: nil)
            self.isAddOber = true
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadView()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(refreshView(_:)), name: "refreshSelf", object: nil)
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
        self.isDisMis = true
        self.hideLoadingView()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "refreshSelf", object: nil)
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
        
        self.headerView = UIView(frame: CGRect(x: 0, y: self.headerY, width: bounds.width, height: 64-self.headerY))
        self.headerView.backgroundColor = CTAStyleKit.commonBackgroundColor
        self.view.addSubview(self.headerView)
        
        let homeLabel = UILabel(frame: CGRect(x: 0, y: 28-self.headerY, width: bounds.width, height: 28))
        homeLabel.font = UIFont.boldSystemFontOfSize(18)
        homeLabel.textColor = CTAStyleKit.normalColor
        homeLabel.text = NSLocalizedString("DefaultName", comment: "")
        homeLabel.textAlignment = .Center
        self.headerView.addSubview(homeLabel)
        let textLine = UIImageView(frame: CGRect(x: 0, y: 63-self.headerY, width: bounds.width, height: 1))
        textLine.image = UIImage(named: "space-line")
        headerView.addSubview(textLine)
        self.view.addSubview(self.headerView)
        
        self.headerView.userInteractionEnabled = true
        let headerTap = UITapGestureRecognizer(target: self, action: #selector(headerViewClickClick(_:)))
        self.headerView.addGestureRecognizer(headerTap)
    }
    
    func initCollectionView(){
        let bounds = UIScreen.mainScreen().bounds
        let rect:CGRect = CGRect(x: 0, y: 46, width: bounds.width, height: bounds.height-46)
        self.collectionLayout = UICollectionViewFlowLayout()

        self.collectionLayout.itemSize = self.getCollectionCellSizeByPublish()
        self.collectionLayout.minimumLineSpacing = self.collectionSpace
        self.collectionLayout.minimumInteritemSpacing = self.collectionSpace
        self.collectionView = UICollectionView(frame: rect, collectionViewLayout: self.collectionLayout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerClass(CTAHomePublishesCell.self, forCellWithReuseIdentifier: "ctahomepublishescell")
        self.collectionView.backgroundColor = CTAStyleKit.commonBackgroundColor
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
            self.previousScrollViewYOffset = self.scrollTop
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
        self.headerView.frame.origin.y = self.headerY
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
    
    func headerViewClickClick(sender: UIPanGestureRecognizer){
        
    }
    
    func getLoadCellData(){
        let userID = (self.loginUser == nil) ? "" : self.loginUser!.userID
        let userType = (self.loginUser == nil) ? 1 : self.loginUser!.userType
        var request:CTABaseRequest;
        if userType == 0 {
            request = CTANewPublishListRequest(userID: userID, start: 0)
        }else {
            request = CTAUserFollowPublishListRequest(userID: userID, beUserID: userID, start: 0)
        }
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
        let userType = (self.loginUser == nil) ? 1 : self.loginUser!.userType
        
        var savePublishModel:Array<CTAPublishModel> = []
        if self.publishModelArray.count < 100 {
            savePublishModel = self.publishModelArray
        }else {
            let slice = self.publishModelArray[0...100]
            savePublishModel = Array(slice)
        }
        var request:CTABaseRequest;
        if userType == 0 {
            request = CTANewPublishListRequest(userID: userID, start: 0)
        }else {
            request = CTAUserFollowPublishListRequest(userID: userID, beUserID: userID, start: 0)
        }
        self.savePublishArray(request, modelArray: savePublishModel)
    }

    func reNewView(noti: NSNotification){
        self.viewUserID = ""
    }
    
    func newPublishHandler(noti: NSNotification){
        if self.isDisMis{
            self.viewUserID = ""
        }else {
            self.loadFirstData()
        }
    }
    
    func refreshView(noti: NSNotification){
        if self.collectionView.contentOffset.y > self.scrollTop{
            self.collectionView.setContentOffset(CGPoint(x: 0, y: self.scrollTop), animated: true)
        }else {
            self.headerFresh.beginRefreshing()
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
        let userType = (self.loginUser == nil) ? 1 : self.loginUser!.userType
        if userType == 0 {
            CTAPublishDomain.getInstance().newPublishList(userID, start: start, size: size, compelecationBlock: { (info) in
                self.loadPublishesComplete(info, size:size)
            })
        }else {
            CTAPublishDomain.getInstance().userFollowPublishList(userID, beUserID: userID, start: start, size: size, compelecationBlock: { (info) in
                self.loadPublishesComplete(info, size:size)
            })
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
                    }else {
                        self.updateCollectionCell()
                    }
                }else {
                    self.loadMoreModelArray(modelArray!)
                    self.collectionView.reloadData()
                }
            }
        }
        self.freshComplete();
    }
    
    func updateCollectionCell(){
        let cells = self.collectionView.visibleCells()
        for i in 0..<cells.count{
            let cell = cells[i] as! CTAHomePublishesCell
            if cell.publishModel != nil {
                for j in 0..<self.publishModelArray.count{
                    let newpublish = self.publishModelArray[j]
                    if newpublish.publishID == cell.publishModel!.publishID{
                        cell.publishModel = newpublish
                    }
                }
            }
        }
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
            if publihshModel.publishID == self.selectedPublishID{
                if self.isHideSelectedCell {
                    publishCell.previewView.alpha = 0
                }
                self.isHideSelectedCell = false
            }
        }
        publishCell.delegate = self
        return publishCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let publishesCell = self.collectionView.cellForItemAtIndexPath(indexPath) as? CTAHomePublishesCell
        let index = indexPath.row
        self.selectedPublishID = ""
        if index < self.publishModelArray.count && index > -1{
            self.selectedPublishID = self.publishModelArray[index].publishID
        }
        self.selectedCell = publishesCell
        if self.selectedPublishID != "" {
            self.showDetailView();
        }
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath){
        let publishCell:CTAHomePublishesCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("ctahomepublishescell", forIndexPath: indexPath) as! CTAHomePublishesCell
        publishCell.releaseView()
    }
    
    //scroll view hide tool bar
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let toolBarViewframe = self.headerView.frame
        let collectViewFrame = self.collectionView.frame
        let size  = toolBarViewframe.height - 20
        let scrollOffset = self.collectionView.contentOffset.y
        let scrollDiff   = scrollOffset - self.previousScrollViewYOffset
        let scrollHeight = collectViewFrame.size.height
        let scrollContentSizeHeight = self.collectionView.contentSize.height + self.collectionView.contentInset.bottom
        var frameY:CGFloat = 0.0
        if scrollOffset <= -self.collectionView.contentInset.top {
            frameY = self.headerY
        }else if (scrollOffset + scrollHeight) >= scrollContentSizeHeight {
            frameY = -size+self.headerY
        } else {
            frameY = min(self.headerY, max(-size+self.headerY, toolBarViewframe.origin.y - scrollDiff));
        }
        self.changeColloetionNavBar(frameY)
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
            let size  = frame.height - 20
            self.animationNavBarTo((self.headerY-size))
        }else {
            self.animationNavBarTo(self.headerY)
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
        UIView.animateWithDuration(0.1) { () -> Void in
            self.changeColloetionNavBar(y)
        }
    }
    
    func changeColloetionNavBar(y:CGFloat){
        var toolBarViewframe = self.headerView.frame
        var collectViewFrame = self.collectionView.frame
        toolBarViewframe.origin.y = y
        collectViewFrame.origin.y = toolBarViewframe.height + toolBarViewframe.origin.y - 18
        collectViewFrame.size.height = self.view.frame.height - collectViewFrame.origin.y
        self.headerView.frame = toolBarViewframe
        self.collectionView.frame = collectViewFrame
        let size  = toolBarViewframe.height - 20
        let alpha:CGFloat = 1 - ((self.headerY-y) / size)
        self.updateBarButtonsAlpha(alpha)
    }

//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
//        let index = indexPath.row
//        if index < self.publishModelArray.count{
//            let publish = self.publishModelArray[index]
//            return self.getCollectionCellSizeByPublish(publish)
//        }else {
//            return CGSize(width: 0, height: 0)
//        }
//    }
    
    func getCollectionCellSizeByPublish(publish:CTAPublishModel? = nil) -> CGSize{
        let top:CGFloat = 50
        var buttom:CGFloat = 100
        let bounds = UIScreen.mainScreen().bounds
        if publish != nil {
            if publish!.likeCount > 0{
                buttom = 100
            }else {
                buttom = 100
            }
            return CGSize(width: bounds.width, height: bounds.width + top+buttom)
        }else {
            buttom = 100
            return CGSize(width: bounds.width, height: bounds.width + top+buttom)
        }
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
            let cellRect = CGRect(x: 10, y: cellY + 25, width: bounds.width-10, height: cellFrame.height - 100)
            let publishCell = (cell as! CTAHomePublishesCell)
            if maxRect.intersects(cellRect){
                publishCell.playAnimation()
            }else {
                publishCell.stopAnimation()
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
    
    func cellUserIconTap(cell:CTAHomePublishesCell?){
        if cell != nil {
            if let publishModel = cell?.publishModel{
                let viewUserModel = publishModel.userModel
                let userPublish = UserViewController()
                userPublish.viewUser = viewUserModel
                self.navigationController?.pushViewController(userPublish, animated: true)
            }
        }
    }
    
    func cellLikeListTap(cell:CTAHomePublishesCell?){
        if self.loginUser != nil {
            if cell != nil {
                self.selectedCell = cell
                self.likersHandelr()
            }
        }else {
            self.showLoginView(false)
        }
    }
    
    func cellLikeHandler(cell:CTAHomePublishesCell?, justLike:Bool){
        if self.loginUser != nil {
            if cell != nil {
                self.selectedCell = cell
                self.likeHandler(justLike)
            }
        }else {
            self.showLoginView(false)
        }
    }
    
    func cellCommentHandler(cell:CTAHomePublishesCell?){
        if self.loginUser != nil {
            if cell != nil {
                self.selectedCell = cell
                self.commentHandler()
            }
        }else {
            self.showLoginView(false)
        }
    }
    
    func cellRebuildHandler(cell:CTAHomePublishesCell?){
        if self.loginUser != nil {
            if cell != nil {
                self.selectedCell = cell
                self.rebuildHandler(false)
            }
        }else {
            self.showLoginView(false)
        }
    }
    
    func cellMoreHandler(cell:CTAHomePublishesCell?){
        if cell != nil {
            self.selectedCell = cell
            self.moreSelectionHandler(false, isPopup: false)
        }
    }
    
    func cellDoubleTap(cell:CTAHomePublishesCell?){
        if self.loginUser != nil {
            if cell != nil {
                self.selectedCell = cell
                self.likeHandler(true)
            }
        }
    }
    
    func cellSingleTap(cell:CTAHomePublishesCell?){
        if cell != nil {
            self.selectedCell = cell
            self.selectedPublishID = self.selectedCell!.publishModel!.publishID
            self.showDetailView();
        }
    }
    
    func showDetailView(){
        let bounds = UIScreen.mainScreen().bounds
        var cellFrame:CGRect!
        var transitionView:UIView
        var preview:CTAPublishPreviewView?
        if self.selectedCell != nil {
            preview = self.selectedCell!.previewView
            cellFrame = preview!.frame
            let zorePt = preview!.convertPoint(CGPoint(x: 0, y: 0), toView: self.view)
            cellFrame.origin.y = zorePt.y
            cellFrame.origin.x = zorePt.x
            transitionView = preview!.snapshotViewAfterScreenUpdates(false)
        }else {
            cellFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
            transitionView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            transitionView.backgroundColor = CTAStyleKit.commonBackgroundColor
        }
        let ani = CTAScaleTransition.getInstance()
        ani.alphaView = preview
        ani.transitionView = transitionView
        ani.transitionAlpha = 1
        ani.fromRect = cellFrame
        ani.toRect = CGRect(x: 0, y: (bounds.height - bounds.width )/2 - Detail_Space, width: bounds.width, height: bounds.width)
        
        var detailType:PublishDetailType = .UserFollow
        let userID = (self.loginUser == nil) ? "" : self.loginUser!.userID
        let userType = (self.loginUser == nil) ? 1 : self.loginUser!.userType
        if userType == 0{
            detailType = .NewPublish
        }else {
            if userID == ""{
                detailType = .HotPublish
            }else{
                detailType = .UserFollow
            }
        }
        
        let vc = Moduler.module_publishDetail(self.selectedPublishID, publishArray: self.publishModelArray, delegate: self, type: detailType)
        
        let navi = UINavigationController(rootViewController: vc)
        navi.transitioningDelegate = ani
        navi.modalPresentationStyle = .Custom
        
        self.presentViewController(navi, animated: true, completion: {
        })
    }
}

extension HomeViewController: CTAPublishControllerProtocol{
    
    var publishModel:CTAPublishModel?{
        if self.selectedCell != nil {
            let publishModel = self.selectedCell!.publishModel
            return publishModel
        }else {
            return nil
        }
    }
    
    var userModel:CTAUserModel?{
        return self.loginUser
    }
    
    var previewView:CTAPublishPreviewView?{
        if self.selectedCell != nil {
            let previewView = self.selectedCell!.previewView
            return previewView
        }else {
            return nil
        }
    }
    
    func setLikeButtonStyle(publichModel:CTAPublishModel?){
        if self.selectedCell != nil {
            self.selectedCell?.changeLikeStatus(publichModel)
        }
    }
    
    func likersRect() -> CGRect? {
        if self.selectedCell != nil {
            let cellFrame = self.selectedCell!.controllerView.likeCountView.frame
            let pt = self.selectedCell!.controllerView.likeCountView.convertPoint(CGPoint(x: 0, y: 0), toView: self.view)
            let rect:CGRect = CGRect(x: pt.x, y: pt.y, width: cellFrame.width, height: cellFrame.height)
            return rect
        }
        return nil
    }
    
    func commentRect() -> CGRect? {
        if self.selectedCell != nil {
            let cellFrame = self.selectedCell!.controllerView.commentView.frame
            let pt = self.selectedCell!.controllerView.commentView.convertPoint(CGPoint(x: 0, y: 0), toView: self.view)
            let rect:CGRect = CGRect(x: pt.x, y: pt.y, width: cellFrame.width, height: cellFrame.height)
            return rect
        }
        return nil
    }
    
    func disCommentMisComplete(publishID: String) {
        self.updatePublishByID(publishID)
    }
    
    func updatePublishByID(publishID:String){
        let userID = self.loginUser == nil ? "" : self.loginUser!.userID
        CTAPublishDomain.getInstance().publishDetai(userID, publishID: publishID) { (info) in
            if info.result {
                if let publishModel = info.baseModel as? CTAPublishModel {
                    let index = self.getPublishIndex(publishModel.publishID, publishArray: self.publishModelArray)
                    if index != -1{
                        self.publishModelArray.insert(publishModel, atIndex: index)
                        self.publishModelArray.removeAtIndex(index+1)
                        self.updateCollectionCell()
                    }
                }
            }
        }
    }
}

extension HomeViewController: PublishDetailViewDelegate{
    
    func transitionComplete() {
//        let frame = self.view.frame
//        self.view.frame.origin.y = frame.origin.y + 20
        let cells = self.collectionView.visibleCells()
        for i in 0..<cells.count{
            let cell = cells[i] as! CTAHomePublishesCell
            if cell.publishModel?.publishID == self.selectedPublishID{
                cell.previewView.alpha = 1
                cell.playAnimation()
            }
        }
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
        self.changeColloetionNavBar(self.headerY)
        let boundsHeight = self.collectionView.frame.size.height
        let totalIndex = self.publishModelArray.count - 1
        let cellRect = self.getCollectionCellSizeByPublish()
        let space = self.collectionSpace
        let currentLineIndex = Int(currentIndex / 1)
        let totalLineIndex   = Int(totalIndex / 1)
        let currentY = CGFloat(currentLineIndex) * (space + cellRect.height) - 20
        let totalY = CGFloat(totalLineIndex+1) * (space + cellRect.height) + 44
        
        var scrollOffY:CGFloat = 0
        if (totalY - currentY) > boundsHeight{
            scrollOffY = currentY
        }else {
            scrollOffY = totalY - boundsHeight
        }
        if scrollOffY < self.scrollTop{
            scrollOffY = self.scrollTop
        }
        self.isHideSelectedCell = true
        self.collectionView.reloadData()
        self.collectionView.contentOffset.y = scrollOffY
        self.changeColloetionNavBar(self.headerY)
        
        let cellY = CGFloat(currentLineIndex) * (space + cellRect.height) - scrollOffY + self.collectionView.frame.origin.y
        let currentRect = CGRect(x: 0, y: cellY+50, width: cellRect.width, height: cellRect.height - 150)
        return currentRect
    }
}
