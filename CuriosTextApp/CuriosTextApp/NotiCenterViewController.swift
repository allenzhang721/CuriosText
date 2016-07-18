//
//  NotiCenterViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import MJRefresh

private class MessageGenerator {
    class func makeMessage(by model: CTANoticeModel) -> Message {// 0 follow   1  like    2 comment
        switch model.noticeType {
        case 0:
            return FollowMessage(model: model)
        case 1:
            return LikeMessage(model: model)
        case 2:
            return CommentMessage(model: model)
        default:
            return Message(model: model)
        }
    }
}

private class Message {
    var ID:String{
        return model.noticeID
    }
    var nickName: String {
        return model.userModel.nickName
    }
    var iconURL: NSURL {
        return NSURL(string: CTAFilePath.userFilePath + model.userModel.userIconURL)!
    }
    var date: String {
        return DateString(model.noticeDate)
    }
    var previewIconURL: NSURL {
        var previewURL = model.previewIconURL
        if previewURL == "" {
            previewURL = model.publishIconURL
        }
        return NSURL(string: CTAFilePath.publishFilePath + previewURL)!
    }
    var userModel: CTAViewUserModel {
        return model.userModel
    }
    
    var publishID: String {
        return model.publishID
    }
    
    var noticeTypeID:Int{
        return model.noticeTypeID
    }
    
    let model: CTANoticeModel
    init(model: CTANoticeModel) {
        self.model = model
    }
}

private class LikeMessage: Message {
}

private class CommentMessage: Message {
    var text: String {
        return model.noticeMessage
    }
}
private class FollowMessage: Message {
    enum Relationship {
        case CanFollowHe
        case HadFollowHe
        case CanNotFollowHe
    }

    var relationship: Relationship {
        switch  model.userModel.relationType{
        case -1:
            return .CanNotFollowHe
        case 0, 3:
            return .CanFollowHe
        case 1, 5:
            return .HadFollowHe
        case 2, 4, 6:
            return .CanNotFollowHe
        default:
            return .CanNotFollowHe
        }
    }
}

class NotiCenterViewController: UIViewController {
    
    var headerFresh:MJRefreshGifHeader!
    var footerFresh:MJRefreshAutoGifFooter!
    var isLoadingFirstData:Bool = false
    var notFresh:Bool = false
    
    let scrollTop:CGFloat = -20.00
    var isFreshToTop:Bool = false
    
    var isLoadedAll:Bool = false
    var isLoading:Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    
    private var messages = [Message]()
    private var tempRect: CGRect?
    private var tempView: TouchImageView?
    
    private var myID: String {
        return CTAUserManager.user?.userID ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reNewView(_:)), name: "haveNewNotice", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reNewView(_:)), name: "loginComplete", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NotiCenterViewController.refreshView(_:)), name: "refreshSelf", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !self.notFresh {
            self.messages = []
            self.headerFresh.beginRefreshing()
            self.setNoticeReaded()
        }
        self.notFresh = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "refreshSelf", object: nil)
    }

    private func setup() {
        setupView()
        setupTableView()
    }
    
    private func setupView() {
        navigationController?.navigationBarHidden = true
        
        titleLabel.text = LocalStrings.NotificationTitle.description
        clearButton.setTitle(LocalStrings.Clear.description, forState: .Normal)
        
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    }
    
    private func setupTableView(){
        
        self.headerFresh = MJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(NotiCenterViewController.loadFirstData))
        
        let freshIcon1:UIImage = UIImage(named: "fresh-icon-1")!
        self.headerFresh.setImages([freshIcon1], forState: .Idle)
        self.headerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Pulling)
        self.headerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Refreshing)
        
        self.headerFresh.lastUpdatedTimeLabel?.hidden = true
        self.headerFresh.stateLabel?.hidden = true
        self.tableView.mj_header = self.headerFresh
        
        self.footerFresh = MJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(NotiCenterViewController.loadLastData))
        self.footerFresh.refreshingTitleHidden = true
        self.footerFresh.setTitle("", forState: .Idle)
        self.footerFresh.setTitle("", forState: .NoMoreData)
        self.footerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Refreshing)
        self.tableView.mj_footer = footerFresh;
    }
    
    private func showAlert() {
        let clean = UIAlertAction(title: LocalStrings.Done.description, style: .Destructive) {[weak self] (action) in
            self?.clearAll(1)
        }
        
        let cancel = UIAlertAction(title: LocalStrings.Cancel.description, style: .Cancel, handler: nil)
        
        let alert = UIAlertController(title: LocalStrings.Attension.description, message: LocalStrings.NeedClearAll.description, preferredStyle: .Alert)
        alert.addAction(clean)
        alert.addAction(cancel)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    private func showUserInfo(by userModel: CTAViewUserModel) {
        if let navigationController = navigationController {
            let userPublish = UserViewController()
            userPublish.viewUser = userModel
            navigationController.pushViewController(userPublish, animated: true)
        }
    }
    
    private func showPublishDetail(withPublishID publishID: String, cell:UITableViewCell) {
        CTAPublishDomain.getInstance().publishDetai(myID, publishID: publishID) {[weak self] (info) in
            if info.result{
                dispatch_async(dispatch_get_main_queue(), {
                    if let model = info?.baseModel as? CTAPublishModel {
                        self?.showDetailView(model, cell: cell)
                    }
                })
            }
        }
    }
    
    private func showDetailView(withModel: CTAPublishModel, cell:UITableViewCell) {
        //TODO:  -- Emiaostein, 7/15/16, 17:01
        let bounds = UIScreen.mainScreen().bounds
        var cellFrame:CGRect!
        var transitionView:UIView
        var preview:TouchImageView?
        if let previewView = cell.viewWithTag(1004) as? TouchImageView {
            preview = previewView
            cellFrame = previewView.frame
            let offY = self.tableView!.contentOffset.y
            cellFrame.origin.y = cellFrame.origin.y + cell.frame.origin.y - offY + self.tableView.frame.origin.y
            cellFrame.origin.x = cellFrame.origin.x + cell.frame.origin.x
            transitionView = previewView.snapshotViewAfterScreenUpdates(true)
        }else {
            cellFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
            transitionView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            transitionView.backgroundColor = CTAStyleKit.commonBackgroundColor
        }
        let bgView = UIScreen.mainScreen().snapshotViewAfterScreenUpdates(false)
        let ani = CTAScaleTransition.getInstance()
        ani.bgView = bgView
        ani.alphaView = preview
        ani.transitionView = transitionView
        ani.transitionAlpha = 1
        ani.fromRect = cellFrame
        ani.toRect = CGRect(x: 0, y: (bounds.height - bounds.width )/2 - Detail_Space, width: bounds.width, height: bounds.width)
        tempRect = cellFrame
        tempView = preview
        let vc = Moduler.module_publishDetail(withModel.publishID, publishArray: [withModel], delegate: self, type: .Single)
        let navi = UINavigationController(rootViewController: vc)
        navi.transitioningDelegate = ani
        navi.modalPresentationStyle = .Custom
        self.presentViewController(navi, animated: true, completion: {
        })
    }
    
    private func followUser(by userModel: CTAViewUserModel, cell:UITableViewCell) {
        //TODO:  -- Emiaostein, 7/15/16, 17:41
        if let imgView = cell.viewWithTag(1005) as? TouchImageView {
            self.showLoadingViewInView(imgView)
            CTAUserRelationDomain.getInstance().followUser(myID, relationUserID: userModel.userID) { (info) -> Void in
                if info.result {
                    let relationType:Int = userModel.relationType
                    userModel.relationType = (relationType==0 ? 1 : 5)
                    userModel.beFollowCount += 1
                    imgView.image = UIImage(named: "liker_following_btn")
                    imgView.tapHandler = { [weak self, cell] in
                        guard let i = self?.tableView.indexPathForCell(cell), amessage = self?.messages[i.item] else {return}
                        self?.showUserInfo(by: amessage.userModel)
                    }
                }
                self.hideLoadingViewInView(imgView)
            }
        }
    }
    
    private func showComment(withPublishID publishID: String, beganRect: CGRect) {
        let userID = myID
        let vc = Moduler.module_comment(publishID, userID: userID, delegate: self)
        let navi = UINavigationController(rootViewController: vc)
        let ani = CTAScaleTransition.getInstance()

        let bound = UIScreen.mainScreen().bounds
        ani.fromRect = self.getViewFromRect(beganRect, viewRect: bound)
        tempRect = ani.fromRect
        navi.transitioningDelegate = ani
        navi.modalPresentationStyle = .Custom
        self.presentViewController(navi, animated: true, completion: {
        })
    }
    
    @IBAction func clearAll(sender: AnyObject) {
        showAlert()
    }
}


extension NotiCenterViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cell(for: tableView, at: indexPath)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        messages.removeAtIndex(indexPath.item)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
    }
}

extension NotiCenterViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let message = messages[indexPath.item]
        
        if message is CommentMessage {
            if message.noticeTypeID == 0 {
                if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                    showPublishDetail(withPublishID: message.publishID, cell: cell)
                }
            }else {
                if let rect = tableView.cellForRowAtIndexPath(indexPath)?.frame {
                    let r = view.convertRect(rect, fromView: tableView)
                    showComment(withPublishID: message.publishID, beganRect: r)
                }
            }
        } else if message is FollowMessage {
            showUserInfo(by: message.userModel)
        } else if message is LikeMessage {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                showPublishDetail(withPublishID: message.publishID, cell: cell)
            }
        }
    }
    
    private func getViewFromRect(smallRect:CGRect, viewRect:CGRect) -> CGRect{
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let scrollOffset = self.tableView.contentOffset.y
        if scrollOffset <= self.scrollTop{
            if self.isFreshToTop{
                self.headerFresh.beginRefreshing()
                self.isFreshToTop = false
            }
        }
    }
}

extension NotiCenterViewController: CommentViewDelegate {
    func getCommentDismisRect(publishID:String) -> CGRect? {
        return tempRect
    }
    func disCommentMisComplete(publishID:String) {
        
    }
}

extension NotiCenterViewController: CTALoadingProtocol{
    var loadingImageView:UIImageView?{
        return nil
    }
}

extension NotiCenterViewController: PublishDetailViewDelegate{
    
    func getPublishCell(selectedID:String, publishArray:Array<CTAPublishModel>) -> CGRect?{
        self.tempView?.alpha = 0
        return tempRect
    }
    
    func transitionComplete(){
        self.tempView?.alpha = 1
        self.tempRect = nil
        self.tempView = nil
    }
}

extension NotiCenterViewController {
    func cell(for tableView: UITableView, at indexPath: NSIndexPath) -> UITableViewCell {
        let message = messages[indexPath.item]
        let cell: UITableViewCell
        if message is LikeMessage {
            cell = tableView.dequeueReusableCellWithIdentifier("NotiLikeCell")!
            if let label = cell.viewWithTag(1002) as? UILabel {
                label.text = LocalStrings.Stared.description
            }
            
        } else if let follow = message as? FollowMessage {
            cell = tableView.dequeueReusableCellWithIdentifier("NotiFollowCell")!
            if let imgView = cell.viewWithTag(1005) as? TouchImageView {
                imgView.userInteractionEnabled = true
                switch follow.relationship {
                case .CanFollowHe:
                    imgView.image = UIImage(named: "liker_follow_btn")
                    imgView.tapHandler = { [weak self, cell] in
                        guard let i = self?.tableView.indexPathForCell(cell), amessage = self?.messages[i.item] else {return}
                        self?.followUser(by: amessage.userModel, cell: cell)
                    }
                case .HadFollowHe:
                    imgView.image = UIImage(named: "liker_following_btn")
                    imgView.tapHandler = { [weak self, cell] in
                        guard let i = self?.tableView.indexPathForCell(cell), amessage = self?.messages[i.item] else {return}
                        self?.showUserInfo(by: amessage.userModel)
                    }
                case .CanNotFollowHe:
                    imgView.image = nil
                }
            }
            
        } else if let comment = message as? CommentMessage {
            cell = tableView.dequeueReusableCellWithIdentifier("NotiCommentCell")!
            if let textView = cell.viewWithTag(1002) as? UITextView {
                textView.contentInset.left = -5
//                textView.textContainerInset.bottom = 0
//                textView.textContainerInset.top = 0
                if comment.noticeTypeID == 0{
                    textView.textColor = CTAStyleKit.disableColor
                    textView.text = LocalStrings.DeleteComment.description
                }else {
                    textView.textColor = CTAStyleKit.normalColor
                    textView.text = comment.text
                }
            }
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("NotiCell")!
        }
        
        // Common Cell UI
        if let imgView = cell.viewWithTag(1000) as? TouchImageView {
            if imgView.layer.mask == nil {
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = UIBezierPath(ovalInRect: imgView.bounds).CGPath
                imgView.layer.mask = shapeLayer
            }
            imgView.kf_setImageWithURL(message.iconURL, placeholderImage: UIImage(named: "default-usericon"))
            
            imgView.tapHandler = { [weak self, cell] in
                guard let i = self?.tableView.indexPathForCell(cell), amessage = self?.messages[i.item] else {return}
                self?.showUserInfo(by: amessage.userModel)
            }
        }
        
        if let nameLabel = cell.viewWithTag(1001) as? TouchLabel {
            nameLabel.text = message.nickName
            nameLabel.tapHandler = { [weak self, cell] in
                guard let i = self?.tableView.indexPathForCell(cell), amessage = self?.messages[i.item] else {return}
                self?.showUserInfo(by: amessage.userModel)
            }
        }
        
        if let dateLabel = cell.viewWithTag(1003) as? UILabel {
            dateLabel.text = message.date
        }
        
        if let previewView = cell.viewWithTag(1004) as? TouchImageView {
            previewView.kf_setImageWithURL(message.previewIconURL)
            previewView.userInteractionEnabled = true
            previewView.tapHandler = { [weak self, cell] in
                guard let i = self?.tableView.indexPathForCell(cell), amessage = self?.messages[i.item] else {return}
                self?.showPublishDetail(withPublishID: amessage.publishID, cell: cell)
            }
        }
        
        return cell
    }
    
    func setNoticeReaded(){
        CTANoticeDomain.getInstance().setNoticesReaded(myID) { (info) in
            if info.result{
                NSNotificationCenter.defaultCenter().postNotificationName("setNoticeReaded", object: nil)
            }
        }
    }
    
    func loadFirstData(){
        self.isLoadingFirstData = true
        self.setupData(0)
    }
    
    func loadLastData() {
        self.isLoadingFirstData = false
        self.setupData(self.messages.count)
    }
    
    func refreshView(noti: NSNotification){
        if self.tableView.contentOffset.y > self.scrollTop{
            self.isFreshToTop = true
            self.tableView.setContentOffset(CGPoint(x: 0, y: self.scrollTop), animated: true)
        }else {
            self.headerFresh.beginRefreshing()
        }
    }
    
    func reNewView(noti: NSNotification){
        self.notFresh = false
    }
    
    private func setupData(start:Int, size:Int = 30) {
        if self.isLoading{
            self.freshComplete();
            return
        }
        self.isLoading = true
        self.isLoadedAll = false
        CTANoticeDomain.getInstance().noticeList(myID, start: start, size: size) {[weak self] (info) in
            self?.isLoading = false
            let scucess = info.result
            if scucess {
                if let notices = info.modelArray as? [CTANoticeModel] {
                    let ms = notices.map{MessageGenerator.makeMessage(by: $0)}
                    self?.loadMessagesComplete(ms, size: size)
                }else {
                    self?.freshComplete()
                }
            }else {
                self?.freshComplete()
            }
        }
    }
    
    private func loadMessagesComplete(loadMessages: [Message], size:Int){
        if loadMessages.count < size {
            self.isLoadedAll = true
        }
        if self.isLoadingFirstData{
            var isChange:Bool = false
            if loadMessages.count > 0{
                if self.messages.count > 0{
                    for i in 0..<loadMessages.count{
                        let newmodel = loadMessages[i]
                        if !self.checkModelIsHave(newmodel, array: self.messages){
                            isChange = true
                            break
                        }
                    }
                    if !isChange{
                        for j in 0..<loadMessages.count{
                            if j < self.messages.count{
                                let oldModel = self.messages[j]
                                if !self.checkModelIsHave(oldModel, array: self.messages){
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
                self.messages.removeAll()
                self.loadMoreModelArray(loadMessages)
            }
        }else {
            self.loadMoreModelArray(loadMessages)
        }
        self.freshComplete()
    }
    
    private func loadMoreModelArray(modelArray:[Message]){
        for i in 0..<modelArray.count{
            let model = modelArray[i]
            if !self.checkModelIsHave(model, array: self.messages){
                self.messages.append(model)
            }
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    private func checkModelIsHave(model:Message, array:Array<Message>) -> Bool{
        for i in 0..<array.count{
            let oldModel = array[i]
            if oldModel.ID == model.ID {
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

}
