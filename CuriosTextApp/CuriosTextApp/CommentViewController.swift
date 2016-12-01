//
//  CommentViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import SVProgressHUD
import KeyboardMan
import MJRefresh

private class Comment {
    var date: String {
        return DateString(model.commentData)
    }
    var author: (ID: String, nickName: String, icon: URL) {
        let id = model.userModel.userID
        let nick = model.userModel.nickName
        let icon = iconURL
        return (id, nick, icon)
    }
    var someone: (ID: String, nickName: String, range: NSRange)? {
        guard let someOne = model.beCommentUserModel else {return nil}
        let id = someOne.userID
        let nick = someOne.nickName
        let range = rendedMessage.1
        return (id, nick, range)
    }
    
    var message: NSAttributedString {
        return rendedMessage.0
    }
    
    var ID: String {
        return model.commentID
    }
    
    var userModel: CTAViewUserModel {
        return model.userModel
    }
    
    var beUserModel: CTAViewUserModel? {
        return model.beCommentUserModel
    }
    
    fileprivate let model: CTACommentModel
    fileprivate let iconURL: URL
    fileprivate let rendedMessage: (NSAttributedString, NSRange)
    
    init(model: CTACommentModel) {
        self.model = model
        let someoneNickname = model.beCommentUserModel?.nickName
        let message = model.commentMessage
        self.rendedMessage = comment(withUser: someoneNickname, message: message)
        self.iconURL = URL(string: CTAFilePath.userFilePath + model.userModel.userIconURL)!
    }
}

private extension CTACommentModel {
    class func toComment(_ model: CTACommentModel) -> Comment {
        return Comment(model: model)
    }
}

class CommentViewController: UIViewController {
    
    var myID: String!
    var publishID: String!
    
    var headerFresh:MJRefreshGifHeader!
    var footerFresh:MJRefreshAutoGifFooter!
    var isLoadingFirstData:Bool = false
    var notFresh:Bool = false
    
    var isLoading:Bool = false
    var isLoadedAll:Bool = false
    var previousScrollViewYOffset:CGFloat = 0.0
    var isTopScroll:Bool = false
    var isBottomScroll:Bool = false
    var isDragMove:Bool = false
    let scrollTop:CGFloat = -20.00
    
    var beganLocation:CGPoint?
    var lastLocation:CGPoint?
    
    var delegate:CommentViewDelegate?
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    fileprivate weak var inputVC: InputViewController!
    fileprivate var comments = [Comment]()
    fileprivate let keyborad = KeyboardMan()
    fileprivate var tempIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
//        if tableView.tableFooterView == nil {
            tableView.tableFooterView = UIView()
//        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.notFresh {
            self.comments = []
            self.headerFresh.beginRefreshing()
            self.previousScrollViewYOffset = self.scrollTop
        }
        self.notFresh = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let input as InputViewController:
            inputVC = input
        default:
            ()
        }
    }
    
    fileprivate func setup() {
        setupView()
        setupKeyboard()
        setupTableView()
    }
    
    fileprivate func setupTableView(){
        self.headerFresh = MJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(loadFirstData))
        
        let freshIcon1:UIImage = UIImage(named: "fresh-icon-1")!
        self.headerFresh.setImages([freshIcon1], for: .idle)
        self.headerFresh.setImages(self.getLoadingImages(), duration:1.0, for: .pulling)
        self.headerFresh.setImages(self.getLoadingImages(), duration:1.0, for: .refreshing)
        
        self.headerFresh.lastUpdatedTimeLabel?.isHidden = true
        self.headerFresh.stateLabel?.isHidden = true
        self.tableView.mj_header = self.headerFresh
        
        self.footerFresh = MJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(loadLastData))
        self.footerFresh.isRefreshingTitleHidden = true
        self.footerFresh.setTitle("", for: .idle)
        self.footerFresh.setTitle("", for: .noMoreData)
        self.footerFresh.setImages(self.getLoadingImages(), duration:1.0, for: .refreshing)
        self.tableView.mj_footer = footerFresh;
    }
    
    fileprivate func setupView() {
        
        titleLabel.text = title
        titleLabel.textColor = CTAStyleKit.normalColor
        
        navigationController?.isNavigationBarHidden = true
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        inputVC.resizeHandler = {[weak self, inputContainerView , heightConstraint] size in
            if heightConstraint?.constant != size.height {
                heightConstraint?.constant = size.height
                self?.tableView.contentInset.bottom = (size.height - 44)
                inputContainerView?.layoutIfNeeded()
            }
        }
        commentPublisher()
        
        
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanHandler(_:)))
        pan.maximumNumberOfTouches = 1
        pan.minimumNumberOfTouches = 1
        self.view.addGestureRecognizer(pan)
    }
    
    func loadFirstData(){
        self.isLoadingFirstData = true
        self.setupData(0)
    }
    
    func loadLastData() {
        self.isLoadingFirstData = false
        self.setupData(self.comments.count)
    }
    
    fileprivate func setupData(_ start:Int, size:Int = 30) {
        if self.isLoading{
            self.freshComplete();
            return
        }
        self.isLoading = true
        self.isLoadedAll = false
        CTACommentDomain.getInstance().publichCommentList(publishID, userID: myID, start: start, size: size) {[weak self] (listInfo) in
            self?.isLoading = false
            let scucess = listInfo.result
            if scucess {
                if let models = listInfo.modelArray as? [CTACommentModel] {
                    let fetchedComments = models.map{CTACommentModel.toComment($0)}
                    self?.loadCommentsComplete(fetchedComments, size: size)
                }else {
                    self?.freshComplete()
                }
            }else {
                self?.freshComplete()
            }
        }
    }

    fileprivate func setupKeyboard() {
        
        keyborad.animateWhenKeyboardAppear = {[weak self, bottomConstraint, view, tableView] (appearPostIndex: Int, keyboardHeight: CGFloat, keyboardHeightIncrement: CGFloat) -> Void in
            if let i = self?.tempIndex, i != -1 {
                self?.tempIndex = -1
                tableView?.contentInset.bottom = keyboardHeight
                tableView?.scrollToRow(at: IndexPath(item: i, section: 0), at: .bottom, animated: true)
            }
            
            bottomConstraint?.constant = keyboardHeight
            view?.layoutIfNeeded()
        }
        
        keyborad.animateWhenKeyboardDisappear = { [weak bottomConstraint, view, tableView, inputContainerView] keyboardHeight in
            tableView?.contentInset.bottom = inputContainerView!.bounds.height - 44
            bottomConstraint?.constant = 0
            view?.layoutIfNeeded()
        }
    }
    
    @IBAction func closed(_ sender: AnyObject) {
        //FIXME:  正确方法应该是向上丢  -- Emiaostein, 7/13/16, 18:10
        self.closeHandler()
    }
    
    func closeHandler(){
        var toRect:CGRect? = nil
        if self.delegate != nil {
            toRect = self.delegate!.getCommentDismisRect(self.publishID)
        }
        let view = self.bgView.snapshotView(afterScreenUpdates: false)
        view?.frame.origin.y = self.bgView.frame.origin.y
        let ani = CTAScaleTransition.getInstance()
        ani.toRect = toRect
        ani.transitionAlpha = 0.4
        ani.transitionView = view
        self.dismiss(animated: true) {
            if self.delegate != nil {
                self.delegate!.disCommentMisComplete(self.publishID)
                self.delegate = nil
            }
        }
    }
    
    func commentFeedBack(_ sucess: Bool) {
        DispatchQueue.main.async {
            sucess ? SVProgressHUD.showSuccess(withStatus: LocalStrings.commentSuccess.description) : SVProgressHUD.showError(withStatus: LocalStrings.commentFail.description)
        }
    }
}

extension CommentViewController {
    
    fileprivate func configComment(at i: Int) {
        let comment = comments[i]
        let authorID = comment.author.ID
        myID == authorID ? deleteMessage(at: i) : commentMessage(at: i)
    }
    
    fileprivate func commentMessage(at i: Int) {
        let comment = comments[i]
        let sid = comment.author.ID
        inputVC.changePlaceholder("@\(comment.author.nickName)")
            inputVC.sendHandler = {[weak self] text in
                self?.comment(to: sid, text: text)
                self?.commentPublisher()
            }
        tempIndex = i
            inputVC.beganEdit()
    }
    
    fileprivate func commentPublisher() {
        inputVC.sendHandler = {[weak self] text in
            self?.comment(to: "", text: text)
        }
    }
    
    fileprivate func deleteMessage(at i: Int) {
        let commentID = comments[i].ID
        
        let delete = UIAlertAction(title: LocalStrings.delete.description, style: .destructive) { [weak self] (action) in
            CTACommentDomain.getInstance().deletePublishComment(commentID) { (info) in
                DispatchQueue.main.async {[weak self] in
                    self?.comments.remove(at: i)
                    self?.tableView.deleteRows(at: [IndexPath(item: i, section: 0)], with: .left)
                }
            }
        }
        
        let cancel = UIAlertAction(title: LocalStrings.cancel.description, style: .cancel, handler: nil)
        let alert = UIAlertController(title: LocalStrings.attension.description, message: nil, preferredStyle: .actionSheet)
        alert.addAction(delete)
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
    
    fileprivate func comment(to someoneID: String, text: String) {
        let pid = publishID
        let iid = myID
        let sid = someoneID
        CTACommentDomain.getInstance().addPublishComment(iid!, beUserID: sid, publishID: pid!, commentMessage: text) {[weak self] (info) in
            if let model = (info.baseModel as? CTACommentModel) {
                DispatchQueue.main.async(execute: {
                    let comment = CTACommentModel.toComment(model)
//                    self?.commentFeedBack(true)
                    self?.comments.insert(comment, at: 0)
                    self?.tableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .right)
                    
                })
            } else {
//                self?.commentFeedBack(false)
            }
        }
    }
    
    fileprivate func loadCommentsComplete(_ loadComments: [Comment], size:Int){
        if loadComments.count < size {
            self.isLoadedAll = true
        }
        if self.isLoadingFirstData{
            var isChange:Bool = false
            if loadComments.count > 0{
                if self.comments.count > 0{
                    for i in 0..<loadComments.count{
                        let newmodel = loadComments[i]
                        if !self.checkModelIsHave(newmodel, array: self.comments){
                            isChange = true
                            break
                        }
                    }
                    if !isChange{
                        for j in 0..<loadComments.count{
                            if j < self.comments.count{
                                let oldModel = self.comments[j]
                                if !self.checkModelIsHave(oldModel, array: self.comments){
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
                self.comments.removeAll()
                self.loadMoreModelArray(loadComments)
            }
        }else {
            self.loadMoreModelArray(loadComments)
        }
        self.freshComplete()
    }
    
    fileprivate func loadMoreModelArray(_ modelArray:[Comment]){
        for i in 0..<modelArray.count{
            let model = modelArray[i]
            if !self.checkModelIsHave(model, array: self.comments){
                self.comments.append(model)
            }
        }
        DispatchQueue.main.async(execute: {[weak self] in
            self?.tableView.reloadData()
        })
    }
    
    fileprivate func checkModelIsHave(_ model:Comment, array:Array<Comment>) -> Bool{
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

extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell")!
        
        let com = comments[indexPath.item]
        if let textView = cell.contentView.viewWithTag(1000) as? TouchTextView {
            textView.contentInset.left = -5
            textView.textContainerInset.bottom = 0
            textView.textContainerInset.top = 0
            textView.attributedText = com.message
            textView.touchHandler = {[weak self, weak cell ,weak textView, weak tableView] (tv, state,index) -> TouchTextView.ActiveState in
                guard let cell = cell, let i = self?.tableView.indexPath(for: cell) else {return TouchTextView.ActiveState.inactive}
                if tv == textView, let comment = self?.comments[i.item] {
                    if let someone = comment.someone {
                        let range = someone.range
                        if (range.location <= index && index < range.location + range.length) {
                            if state == .end {
                                self?.showUserInfo(by: comment.beUserModel!)
                            }
                            return TouchTextView.ActiveState.actived(range)
                        } else {
                            if state == .end {
                                 tableView?.delegate?.tableView!(tableView!, didSelectRowAt: i)
                            }
                            return TouchTextView.ActiveState.inactive
                        }
                        
                    } else {
                        if state == .end {
                            tableView?.delegate?.tableView!(tableView!, didSelectRowAt: i)
                        }
                        return TouchTextView.ActiveState.inactive
                    }
                } else {
                    return TouchTextView.ActiveState.inactive
                }
            }
        }
        
        if let nameLabel = cell.contentView.viewWithTag(1001) as? TouchLabel {
            nameLabel.text = com.author.nickName
            nameLabel.tapHandler = { [weak self, cell] in
                guard let i = self?.tableView.indexPath(for: cell), let comment = self?.comments[i.item] else {return}
                self?.showUserInfo(by: comment.userModel)
            }
        }
        
        if let dateLabel = cell.contentView.viewWithTag(1002) as? UILabel {
            dateLabel.text = com.date
        }
        
        if let imgView = cell.contentView.viewWithTag(1003) as? TouchImageView {
            if imgView.layer.mask == nil {
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = UIBezierPath(ovalIn: imgView.bounds).cgPath
                imgView.layer.mask = shapeLayer
            }
          imgView.kf.setImage(with: com.author.icon, placeholder: UIImage(named: "default-usericon"))
            imgView.tapHandler = { [weak self, cell] in
                guard let i = self?.tableView.indexPath(for: cell), let comment = self?.comments[i.item] else {return}
                self?.showUserInfo(by: comment.userModel)
            }
        }
        
        return cell
    }
}

extension CommentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if inputVC.inputting {
            inputVC.resign()
        } else {
            configComment(at: indexPath.item)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offY = self.tableView.contentOffset.y
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
            self.tableView.contentOffset.y = self.previousScrollViewYOffset
            self.bgView.frame.origin.y = self.bgView.frame.origin.y - scrollDiff/4
        }
        
        self.previousScrollViewYOffset = self.tableView.contentOffset.y
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollEnd()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        if !self.inputVC.inputting {
            let offY = self.tableView.contentOffset.y
            if offY <= self.scrollTop{
                self.isTopScroll = true
            }
            
            let offSize = self.tableView.contentSize
            let maxOffY = offSize.height - self.tableView.frame.height + self.scrollTop
            if maxOffY > 0 {
                if offY > maxOffY && self.isLoadedAll{
                    self.isBottomScroll = true
                }
            }else {
                self.isBottomScroll = true
            }
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

extension CommentViewController:CTALoadingProtocol{
    var loadingImageView:UIImageView?{
        return nil
    }
}

private func comment(withUser userName: String?, message: String) -> (NSAttributedString, NSRange) {
    let name = userName != nil ? "@" + userName! : ""
    let amessage = userName != nil ? " " + message : message
    let n = NSAttributedString(string: name)
    let m = NSAttributedString(string: amessage)
    let c = NSMutableAttributedString(string: name + amessage)
    let nameRange = NSMakeRange(0, n.length)
    let messageRange = NSMakeRange(n.length, m.length)
    let nameFont = UIFont.boldSystemFont(ofSize: 14)
    let messageFont = UIFont.systemFont(ofSize: 14)
    let nameColor = UIColor(red:0.08, green:0.20, blue:0.37, alpha:1.00)
    let messageColor = UIColor(red:0, green:0, blue:0, alpha:1.00)
    //
    c.addAttribute(NSFontAttributeName, value: nameFont, range: nameRange)
    c.addAttribute(NSFontAttributeName, value: messageFont, range: messageRange)
    c.addAttribute(NSForegroundColorAttributeName, value:nameColor, range:nameRange)
    c.addAttribute(NSForegroundColorAttributeName, value:messageColor, range:messageRange)
    
    return (c, nameRange)
}

protocol CommentViewDelegate: AnyObject {
    func getCommentDismisRect(_ publishID:String) -> CGRect?
    func disCommentMisComplete(_ publishID:String)
}
