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
    var iconURL: URL {
        return URL(string: CTAFilePath.userFilePath + model.userModel.userIconURL)!
    }
    var date: String {
        return DateString(model.noticeDate)
    }
    var previewIconURL: URL {
        var previewURL = model.previewIconURL
        if previewURL == "" {
            previewURL = model.publishIconURL
        }
        return URL(string: CTAFilePath.publishFilePath + previewURL)!
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
        case canFollowHe
        case hadFollowHe
        case canNotFollowHe
    }

    var relationship: Relationship {
        switch  model.userModel.relationType{
        case -1:
            return .canNotFollowHe
        case 0, 3:
            return .canFollowHe
        case 1, 5:
            return .hadFollowHe
        case 2, 4, 6:
            return .canNotFollowHe
        default:
            return .canNotFollowHe
        }
    }
}

class NotiCenterViewController: UIViewController {
    
    var headerFresh:MJRefreshGifHeader!
    var footerFresh:MJRefreshAutoGifFooter!
    var isLoadingFirstData:Bool = false
    var notFresh:Bool = false
    
    let scrollTop:CGFloat = -20.00
    
    var isLoadedAll:Bool = false
    var isLoading:Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    
    fileprivate var messages = [Message]()
    fileprivate var tempRect: CGRect?
    fileprivate var tempView: TouchImageView?
    
    fileprivate var myID: String {
        return CTAUserManager.user?.userID ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(reNewView(_:)), name: NSNotification.Name(rawValue: "haveNewNotice"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reNewView(_:)), name: NSNotification.Name(rawValue: "loginComplete"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(NotiCenterViewController.refreshView(_:)), name: NSNotification.Name(rawValue: "refreshSelf"), object: nil)
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.notFresh {
            self.headerFresh.beginRefreshing()
        }
        self.notFresh = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "refreshSelf"), object: nil)
    }

    fileprivate func setup() {
        setupView()
        setupTableView()
    }
    
    fileprivate func setupView() {
        navigationController?.isNavigationBarHidden = true
        
        titleLabel.text = LocalStrings.notificationTitle.description
        clearButton.setTitle(LocalStrings.clear.description, for: UIControlState())
        
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    fileprivate func setupTableView(){
        
        self.headerFresh = MJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(NotiCenterViewController.loadFirstData))
        
        let freshIcon1:UIImage = UIImage(named: "fresh-icon-1")!
        self.headerFresh.setImages([freshIcon1], for: .idle)
        self.headerFresh.setImages(self.getLoadingImages(), duration:1.0, for: .pulling)
        self.headerFresh.setImages(self.getLoadingImages(), duration:1.0, for: .refreshing)
        
        self.headerFresh.lastUpdatedTimeLabel?.isHidden = true
        self.headerFresh.stateLabel?.isHidden = true
        self.tableView.mj_header = self.headerFresh
        
        self.footerFresh = MJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(NotiCenterViewController.loadLastData))
        self.footerFresh.isRefreshingTitleHidden = true
        self.footerFresh.setTitle("", for: .idle)
        self.footerFresh.setTitle("", for: .noMoreData)
        self.footerFresh.setImages(self.getLoadingImages(), duration:1.0, for: .refreshing)
        self.tableView.mj_footer = footerFresh;
    }
    
    fileprivate func showAlert() {
        let clean = UIAlertAction(title: LocalStrings.needClearAll.description, style: .destructive) {[weak self] (action) in
            self?.clearAll(1 as AnyObject)
        }
        
        let cancel = UIAlertAction(title: LocalStrings.cancel.description, style: .cancel, handler: nil)
        
        let alert = UIAlertController(title: LocalStrings.attension.description, message: nil, preferredStyle: .actionSheet)
        alert.addAction(clean)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func showUserInfo(by userModel: CTAViewUserModel) {
        if let navigationController = navigationController {
            let userPublish = UserViewController()
            userPublish.viewUser = userModel
            navigationController.pushViewController(userPublish, animated: true)
        }
    }
    
    fileprivate func showPublishDetail(withPublishID publishID: String, cell:UITableViewCell) {
        CTAPublishDomain.getInstance().publishDetai(myID, publishID: publishID) {[weak self] (info) in
            if info.result{
                DispatchQueue.main.async(execute: {
                    if let model = info?.baseModel as? CTAPublishModel {
                        self?.showDetailView(model, cell: cell)
                    }
                })
            }
        }
    }
    
    fileprivate func showDetailView(_ withModel: CTAPublishModel, cell:UITableViewCell) {
        //TODO:  -- Emiaostein, 7/15/16, 17:01
        let bounds = UIScreen.main.bounds
        var cellFrame:CGRect!
        var transitionView:UIView
        var preview:TouchImageView?
        if let previewView = cell.viewWithTag(1004) as? TouchImageView {
            preview = previewView
            cellFrame = previewView.frame
            let zorePt = previewView.convert(CGPoint(x: 0, y: 0), to: self.view)
            cellFrame.origin.y = zorePt.y
            cellFrame.origin.x = zorePt.x
            transitionView = previewView.snapshotView(afterScreenUpdates: false)!
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
        tempRect = cellFrame
        tempView = preview
        let vc = Moduler.module_publishDetail(withModel.publishID, publishArray: [withModel], delegate: self, type: .Single)
        let navi = UINavigationController(rootViewController: vc)
        navi.transitioningDelegate = ani
        navi.modalPresentationStyle = .custom
        self.present(navi, animated: true, completion: {
        })
    }
    
    fileprivate func followUser(by userModel: CTAViewUserModel, cell:UITableViewCell) {
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
                        guard let i = self?.tableView.indexPath(for: cell), let amessage = self?.messages[i.item] else {return}
                        self?.showUserInfo(by: amessage.userModel)
                    }
                }
                self.hideLoadingViewInView(imgView)
            }
        }
    }
    
    fileprivate func showComment(withPublishID publishID: String, beganRect: CGRect) {
        let userID = myID
        let vc = Moduler.module_comment(publishID, userID: userID, delegate: self)
        let navi = UINavigationController(rootViewController: vc)
        let ani = CTAScaleTransition.getInstance()

        let bound = UIScreen.main.bounds
        ani.fromRect = self.getViewFromRect(beganRect, viewRect: bound)
        tempRect = ani.fromRect
        navi.transitioningDelegate = ani
        navi.modalPresentationStyle = .custom
        self.present(navi, animated: true, completion: {
        })
    }
    
    @IBAction func clearAll(_ sender: AnyObject) {
        showAlert()
    }
}


extension NotiCenterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell(for: tableView, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let message = messages[indexPath.item]
        CTANoticeDomain.getInstance().deleteNotice(message.ID) {[weak self] (info) in
            if info.result {
                self?.messages.remove(at: indexPath.item)
                self?.tableView.deleteRows(at: [indexPath], with: .left)
            }
        }
    }
}

extension NotiCenterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.item]
        
        if message is CommentMessage {
            if message.noticeTypeID == 0 {
                if let cell = tableView.cellForRow(at: indexPath) {
                    showPublishDetail(withPublishID: message.publishID, cell: cell)
                }
            }else {
                if let rect = tableView.cellForRow(at: indexPath)?.frame {
                    let r = view.convert(rect, from: tableView)
                    showComment(withPublishID: message.publishID, beganRect: r)
                }
            }
        } else if message is FollowMessage {
            showUserInfo(by: message.userModel)
        } else if message is LikeMessage {
            if let cell = tableView.cellForRow(at: indexPath) {
                showPublishDetail(withPublishID: message.publishID, cell: cell)
            }
        }
    }
    
    fileprivate func getViewFromRect(_ smallRect:CGRect, viewRect:CGRect) -> CGRect{
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
    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        let scrollOffset = self.tableView.contentOffset.y
//        if scrollOffset <= self.scrollTop{
//            if self.isFreshToTop{
//                self.headerFresh.beginRefreshing()
//                self.isFreshToTop = false
//            }
//        }
//    }
}

extension NotiCenterViewController: CommentViewDelegate {
    func getCommentDismisRect(_ publishID:String) -> CGRect? {
        return tempRect
    }
    func disCommentMisComplete(_ publishID:String) {
        
    }
}

extension NotiCenterViewController: CTALoadingProtocol{
    var loadingImageView:UIImageView?{
        return nil
    }
}

extension NotiCenterViewController: PublishDetailViewDelegate{
    
    func getPublishCell(_ selectedID:String, publishArray:Array<CTAPublishModel>) -> CGRect?{
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
    func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.item]
        let cell: UITableViewCell
        if message is LikeMessage {
            cell = tableView.dequeueReusableCell(withIdentifier: "NotiLikeCell")!
            if let label = cell.viewWithTag(1002) as? UILabel {
                label.text = LocalStrings.stared.description
            }
            
        } else if let follow = message as? FollowMessage {
            cell = tableView.dequeueReusableCell(withIdentifier: "NotiFollowCell")!
            if let imgView = cell.viewWithTag(1005) as? TouchImageView {
                imgView.isUserInteractionEnabled = true
                switch follow.relationship {
                case .canFollowHe:
                    imgView.image = UIImage(named: "liker_follow_btn")
                    imgView.tapHandler = { [weak self, cell] in
                        guard let i = self?.tableView.indexPath(for: cell), let amessage = self?.messages[i.item] else {return}
                        self?.followUser(by: amessage.userModel, cell: cell)
                    }
                case .hadFollowHe:
                    imgView.image = UIImage(named: "liker_following_btn")
                    imgView.tapHandler = { [weak self, cell] in
                        guard let i = self?.tableView.indexPath(for: cell), let amessage = self?.messages[i.item] else {return}
                        self?.showUserInfo(by: amessage.userModel)
                    }
                case .canNotFollowHe:
                    imgView.image = nil
                }
            }
            
        } else if let comment = message as? CommentMessage {
            cell = tableView.dequeueReusableCell(withIdentifier: "NotiCommentCell")!
            if let textView = cell.viewWithTag(1002) as? UITextView {
                textView.contentInset.left = -5
//                textView.textContainerInset.bottom = 0
//                textView.textContainerInset.top = 0
                if comment.noticeTypeID == 0{
                    textView.text = LocalStrings.deleteComment.description
                    textView.textColor = CTAStyleKit.disableColor
                }else {
                    textView.text = comment.text
                    textView.textColor = CTAStyleKit.normalColor
                }
            }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "NotiCell")!
        }
        
        // Common Cell UI
        if let imgView = cell.viewWithTag(1000) as? TouchImageView {
            if imgView.layer.mask == nil {
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = UIBezierPath(ovalIn: imgView.bounds).cgPath
                imgView.layer.mask = shapeLayer
            }
            imgView.kf.setImage(with: message.iconURL, placeholder: UIImage(named: "default-usericon"))
            
            imgView.tapHandler = { [weak self, cell] in
                guard let i = self?.tableView.indexPath(for: cell), let amessage = self?.messages[i.item] else {return}
                self?.showUserInfo(by: amessage.userModel)
            }
        }
        
        if let nameLabel = cell.viewWithTag(1001) as? TouchLabel {
            nameLabel.text = message.nickName
            nameLabel.tapHandler = { [weak self, cell] in
                guard let i = self?.tableView.indexPath(for: cell), let amessage = self?.messages[i.item] else {return}
                self?.showUserInfo(by: amessage.userModel)
            }
        }
        
        if let dateLabel = cell.viewWithTag(1003) as? UILabel {
            dateLabel.text = message.date
        }
        
        if let previewView = cell.viewWithTag(1004) as? TouchImageView {
            previewView.kf.setImage(with: message.previewIconURL)
            previewView.isUserInteractionEnabled = true
            previewView.tapHandler = { [weak self, cell] in
                guard let i = self?.tableView.indexPath(for: cell), let amessage = self?.messages[i.item] else {return}
                self?.showPublishDetail(withPublishID: amessage.publishID, cell: cell)
            }
        }
        
        return cell
    }
    
    func setNoticeReaded(){
        CTANoticeDomain.getInstance().setNoticesReaded(myID) { (info) in
            if info.result{
                NotificationCenter.default.post(name: Notification.Name(rawValue: "setNoticeReaded"), object: nil)
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
    
    func refreshView(_ noti: Notification){
        if self.tableView.contentOffset.y > self.scrollTop{
            self.tableView.setContentOffset(CGPoint(x: 0, y: self.scrollTop), animated: true)
        }else {
            self.headerFresh.beginRefreshing()
        }
    }
    
    func reNewView(_ noti: Notification){
        self.notFresh = false
    }
    
    fileprivate func setupData(_ start:Int, size:Int = 30) {
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
                    if notices.count > 0{
                        let firstN = notices[0]
                        if firstN.noticeReaded == 0{
                            self?.setNoticeReaded()
                        }
                    }
                }else {
                    self?.freshComplete()
                }
            }else {
                self?.freshComplete()
            }
        }
    }
    
    fileprivate func loadMessagesComplete(_ loadMessages: [Message], size:Int){
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
    
    fileprivate func loadMoreModelArray(_ modelArray:[Message]){
        for i in 0..<modelArray.count{
            let model = modelArray[i]
            if !self.checkModelIsHave(model, array: self.messages){
                self.messages.append(model)
            }
        }
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    fileprivate func checkModelIsHave(_ model:Message, array:Array<Message>) -> Bool{
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
