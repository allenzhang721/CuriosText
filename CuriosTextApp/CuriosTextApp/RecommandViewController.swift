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

    var headerView:UIView!
    var collectionView:UICollectionView!
    var collectionLayout:UICollectionViewFlowLayout!
    
    var headerFresh:MJRefreshGifHeader!
    var footerFresh:MJRefreshAutoGifFooter!
    
    var publishModelArray:Array<CTAPublishModel> = []
    var isLoadingFirstData:Bool = false
    
    var selectedPublishID:String = ""
    var isHideSelectedCell:Bool = false
    var isDisMis:Bool = true
    var isLoadLocal:Bool = false
    var previousScrollViewYOffset:CGFloat = 0.0
    let scrollTop:CGFloat = -20.00
    var isFreshToTop:Bool = false
    
    var isLoading:Bool = false
    var isLoadedAll:Bool = false
    let cellHorCount = 3
    
    var isNoFresh:Bool = false
    
    let headerY:CGFloat  = 20.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initView()
        
        self.navigationController?.navigationBarHidden = true
        self.view.backgroundColor = CTAStyleKit.commonBackgroundColor
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if !self.isNoFresh{
            if self.isDisMis {
                self.resetViewPosition()
                self.getLoadCellData()
                if !self.isLoadLocal{
                    self.publishModelArray.removeAll()
                }
                self.collectionView.reloadData()
            }
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(refreshView(_:)), name: "refreshSelf", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !self.isNoFresh{
            if self.isDisMis {
                self.viewAppearBegin()
            }
            self.isDisMis = false
        }
        self.isNoFresh = true
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
        
        self.headerView = UIView(frame: CGRect(x: 0, y: self.headerY, width: bounds.width, height: 64-self.headerY))
        self.headerView.backgroundColor = CTAStyleKit.commonBackgroundColor
        self.view.addSubview(self.headerView)
        
        let homeLabel = UILabel(frame: CGRect(x: 0, y: 28-self.headerY, width: bounds.width, height: 28))
        homeLabel.font = UIFont.boldSystemFontOfSize(18)
        homeLabel.textColor = CTAStyleKit.normalColor
        homeLabel.text = NSLocalizedString("RecommendLabel", comment: "")
        homeLabel.textAlignment = .Center
        self.headerView.addSubview(homeLabel)
        let textLine = UIImageView(frame: CGRect(x: 0, y: 63-self.headerY, width: bounds.width, height: 1))
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
    
    func getLoadCellData(){
        let userID = ""
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
        let userID = ""
        
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
        self.headerView.frame.origin.y = self.headerY
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
        self.headerFresh.beginRefreshing()
        self.previousScrollViewYOffset = self.scrollTop
    }
    
    func loadUserPublishes(start:Int, size:Int = 30){
        if self.isLoading{
            self.freshComplete();
            return
        }
        self.isLoading = true
        self.isLoadedAll = false
        let userID = ""
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
            
            let detailType:PublishDetailType = .HotPublish

            let vc = Moduler.module_publishDetail(self.selectedPublishID, publishArray: self.publishModelArray, delegate: self, type: detailType)
            let navi = UINavigationController(rootViewController: vc)
            navi.transitioningDelegate = ani
            navi.modalPresentationStyle = .Custom
            self.presentViewController(navi, animated: true, completion: {
            })
        }
    }
    
    //scroll view hide tool bar
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let toolBarViewframe = self.headerView.frame
        let collectViewFrame = self.collectionView.frame
        let size  = toolBarViewframe.height
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
        if scrollOffset <= self.scrollTop{
            if self.isFreshToTop{
                self.headerFresh.beginRefreshing()
                self.isFreshToTop = false
            }
        }
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
            self.animationNavBarTo((self.headerY-frame.size.height))
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
        let alpha:CGFloat = 1 - ((self.headerY-y) / toolBarViewframe.height)
        self.updateBarButtonsAlpha(alpha)
//        var s = "stat"
//        s += "usBar"
//        s += "Window"
//        
//        let statusBarWindow = UIApplication.sharedApplication().valueForKey(s) as! UIWindow
//        statusBarWindow.frame = CGRectMake(0, y, statusBarWindow.frame.size.width, statusBarWindow.frame.size.height)
//        
    }
}

extension RecommandViewController: CTALoadingProtocol{
    var loadingImageView:UIImageView?{
        return nil
    }
}

extension RecommandViewController: PublishDetailViewDelegate{
    
    func transitionComplete() {
        let cells = self.collectionView.visibleCells()
        for i in 0..<cells.count{
            let cell = cells[i]
            cell.alpha = 1
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
        let cellRect = self.getCellRect()
        let space = self.getCellSpace()
        let currentLineIndex = Int(currentIndex / self.cellHorCount)
        let currentColumnIndex = Int(currentIndex % self.cellHorCount)
        let totalLineIndex   = Int(totalIndex / self.cellHorCount)
        let currentY = CGFloat(currentLineIndex+1) * (space + cellRect.height) - cellRect.height/2
        let totalY = CGFloat(totalLineIndex+1) * (space + cellRect.height) + 44
        
        var scrollOffY:CGFloat = 0
        if (totalY - currentY) > boundsHeight/2{
            scrollOffY = currentY - boundsHeight/2
        }else {
            scrollOffY = totalY - boundsHeight
        }
        if scrollOffY < 0-self.headerY{
            scrollOffY = 0-self.headerY
        }
        self.isHideSelectedCell = true
        self.collectionView.reloadData()
        self.collectionView.contentOffset.y = scrollOffY
        self.changeColloetionNavBar(self.headerY)
        
        let cellY = CGFloat(currentLineIndex) * (space + cellRect.height) - scrollOffY + self.collectionView.frame.origin.y
        let currentRect = CGRect(x: CGFloat(currentColumnIndex)*(space + cellRect.width) + space, y: cellY, width: cellRect.width, height: cellRect.height)
        return currentRect
    }
}



