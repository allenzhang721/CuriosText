//
//  CommentViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import KeyboardMan
import MJRefresh

private class Comment {
    var date: String {
        return DateString(model.commentData)
    }
    var author: (ID: String, nickName: String, icon: NSURL) {
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
    
    private let model: CTACommentModel
    private let iconURL: NSURL
    private let rendedMessage: (NSAttributedString, NSRange)
    
    init(model: CTACommentModel) {
        self.model = model
        let someoneNickname = model.beCommentUserModel?.nickName
        let message = model.commentMessage
        self.rendedMessage = comment(withUser: someoneNickname, message: message)
        self.iconURL = NSURL(string: CTAFilePath.userFilePath + model.userModel.userIconURL)!
    }
}

private extension CTACommentModel {
    class func toComment(model: CTACommentModel) -> Comment {
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
    
    private weak var inputVC: InputViewController!
    private var comments = [Comment]()
    private let keyborad = KeyboardMan()
    private var tempIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !self.notFresh {
            self.comments = []
            self.headerFresh.beginRefreshing()
            self.previousScrollViewYOffset = self.scrollTop
        }
        self.notFresh = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.destinationViewController {
        case let input as InputViewController:
            inputVC = input
        default:
            ()
        }
    }
    
    private func setup() {
        setupView()
        setupKeyboard()
        setupTableView()
    }
    
    private func setupTableView(){
        self.headerFresh = MJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(loadFirstData))
        
        let freshIcon1:UIImage = UIImage(named: "fresh-icon-1")!
        self.headerFresh.setImages([freshIcon1], forState: .Idle)
        self.headerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Pulling)
        self.headerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Refreshing)
        
        self.headerFresh.lastUpdatedTimeLabel?.hidden = true
        self.headerFresh.stateLabel?.hidden = true
        self.tableView.mj_header = self.headerFresh
        
        self.footerFresh = MJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(loadLastData))
        self.footerFresh.refreshingTitleHidden = true
        self.footerFresh.setTitle("", forState: .Idle)
        self.footerFresh.setTitle("", forState: .NoMoreData)
        self.footerFresh.setImages(self.getLoadingImages(), duration:1.0, forState: .Refreshing)
        self.tableView.mj_footer = footerFresh;
    }
    
    private func setupView() {
        
        titleLabel.text = title
        titleLabel.textColor = CTAStyleKit.normalColor
        
        navigationController?.navigationBarHidden = true
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        inputVC.resizeHandler = {[weak inputContainerView , heightConstraint] size in
            if heightConstraint.constant != size.height {
                heightConstraint?.constant = size.height
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
    
    private func setupData(start:Int, size:Int = 30) {
        CTACommentDomain.getInstance().publichCommentList(publishID, start: start, size: size) {[weak self] (listInfo) in
            let scucess = listInfo.result
            if scucess {
                if let models = listInfo.modelArray as? [CTACommentModel] {
                    let fetchedComments = models.map{CTACommentModel.toComment($0)}
                    self?.loadUsersComplete(fetchedComments, size: size)
                }
            }
        }
    }

    private func setupKeyboard() {
        
        keyborad.animateWhenKeyboardAppear = {[weak self, bottomConstraint, view, tableView] (appearPostIndex: Int, keyboardHeight: CGFloat, keyboardHeightIncrement: CGFloat) -> Void in
            if let i = self?.tempIndex where i != -1 {
                self?.tempIndex = -1
                tableView?.contentInset.bottom = keyboardHeight
                tableView?.scrollToRowAtIndexPath(NSIndexPath(forItem: i, inSection: 0), atScrollPosition: .Bottom, animated: true)
            }
            
            bottomConstraint?.constant = keyboardHeight
            view?.layoutIfNeeded()
        }
        
        keyborad.animateWhenKeyboardDisappear = { [weak bottomConstraint, view, tableView] keyboardHeight in
            tableView.contentInset.bottom = 0
            bottomConstraint?.constant = 0
            view?.layoutIfNeeded()
        }
    }
    
    @IBAction func closed(sender: AnyObject) {
        //FIXME:  正确方法应该是向上丢  -- Emiaostein, 7/13/16, 18:10
        self.closeHandler()
    }
    
    func closeHandler(){
        var toRect:CGRect? = nil
        if self.delegate != nil {
            toRect = self.delegate!.getDismisRect()
        }
        let view = self.bgView.snapshotViewAfterScreenUpdates(false)
        view.frame.origin.y = self.bgView.frame.origin.y
        let ani = CTAScaleTransition.getInstance()
        ani.toRect = toRect
        ani.transitionAlpha = 0.4
        ani.transitionView = view
        self.dismissViewControllerAnimated(true) {
            if self.delegate != nil {
                self.delegate!.disMisComplete()
                self.delegate = nil
            }
        }
    }
    
}

extension CommentViewController {
    
    private func configComment(at i: Int) {
        let comment = comments[i]
        let authorID = comment.author.ID
        myID == authorID ? deleteMessage(at: i) : commentMessage(at: i)
    }
    
    private func commentMessage(at i: Int) {
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
    
    private func commentPublisher() {
        inputVC.sendHandler = {[weak self] text in
            self?.comment(to: "", text: text)
        }
    }
    
    private func deleteMessage(at i: Int) {
        let commentID = comments[i].ID
        
        let delete = UIAlertAction(title: LocalStrings.Delete.description, style: .Destructive) { [weak self] (action) in
            CTACommentDomain.getInstance().deletePublishComment(commentID) { (info) in
                dispatch_async(dispatch_get_main_queue()) {[weak self] in
                    self?.comments.removeAtIndex(i)
                    self?.tableView.deleteRowsAtIndexPaths([NSIndexPath(forItem: i, inSection: 0)], withRowAnimation: .Left)
                }
            }
        }
        
        let cancel = UIAlertAction(title: LocalStrings.Cancel.description, style: .Cancel, handler: nil)
        let alert = UIAlertController(title: LocalStrings.Attension.description, message: nil, preferredStyle: .ActionSheet)
        alert.addAction(delete)
        alert.addAction(cancel)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    private func showUserInfo(by userModel: CTAViewUserModel) {
        if let navigationController = navigationController {
            let userPublish = UserViewController()
            userPublish.viewUser = userModel
            navigationController.pushViewController(userPublish, animated: true)
            self.notFresh = true
        }
    }
    
    private func comment(to someoneID: String, text: String) {
        let pid = publishID
        let iid = myID
        let sid = someoneID
        CTACommentDomain.getInstance().addPublishComment(iid, beUserID: sid, publishID: pid, commentMessage: text) {[weak self] (info) in
            if let model = (info.baseModel as? CTACommentModel) {
                dispatch_async(dispatch_get_main_queue(), {
                    let comment = CTACommentModel.toComment(model)
                    self?.comments.insert(comment, atIndex: 0)
                    self?.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Right)
                })
            }
        }
    }
    
    private func loadUsersComplete(loadComments: [Comment], size:Int){
        self.isLoading = false
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
    
    private func loadMoreModelArray(modelArray:[Comment]){
        for i in 0..<modelArray.count{
            let model = modelArray[i]
            if !self.checkModelIsHave(model, array: self.comments){
                self.comments.append(model)
            }
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    private func checkModelIsHave(model:Comment, array:Array<Comment>) -> Bool{
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
    
    func viewPanHandler(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began:
            self.beganLocation = sender.locationInView(view)
        case .Changed:
            let newLocation = sender.locationInView(view)
            self.viewVerPanHandler(newLocation)
        case .Ended, .Cancelled, .Failed:
            let velocity = sender.velocityInView(view)
            let newLocation = sender.locationInView(view)
            if velocity.y > 500 || velocity.y < -500{
                self.closeHandler()
            }else {
                self.viewVerComplete(newLocation)
            }
        default:
            ()
        }
    }
    
    func viewVerPanHandler(newLocation:CGPoint){
        if self.lastLocation == nil {
            self.lastLocation = self.beganLocation
        }
        let scrollDiff = newLocation.y - self.lastLocation!.y
        self.bgView.frame.origin.y = self.bgView.frame.origin.y + scrollDiff/4
        self.lastLocation = newLocation
    }
    
    func viewVerComplete(newLocation:CGPoint){
        let xRate = newLocation.y - self.beganLocation!.y
        if abs(xRate) >= DragDownHeight {
            self.closeHandler()
        }else {
            UIView.animateWithDuration(0.2, animations: {
                self.bgView.frame.origin.y = 0
                }, completion: { (_) in
            })
        }
    }
}

extension CommentViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell")!
        
        let com = comments[indexPath.item]
        if let textView = cell.contentView.viewWithTag(1000) as? TouchTextView {
            textView.contentInset.left = -5
            textView.textContainerInset.top = 0
            textView.attributedText = com.message
            textView.touchHandler = {[weak self, weak cell ,weak textView, weak tableView] (tv, state,index) -> TouchTextView.ActiveState in
                guard let cell = cell, i = self?.tableView.indexPathForCell(cell) else {return TouchTextView.ActiveState.Inactive}
                if tv == textView, let comment = self?.comments[i.item] {
                    if let someone = comment.someone {
                        let range = someone.range
                        if (range.location <= index && index < range.location + range.length) {
                            if state == .End {
                                self?.showUserInfo(by: comment.beUserModel!)
                            }
                            return TouchTextView.ActiveState.Actived(range)
                        } else {
                            if state == .End {
                                 tableView?.delegate?.tableView!(tableView!, didSelectRowAtIndexPath: i)
                            }
                            return TouchTextView.ActiveState.Inactive
                        }
                        
                    } else {
                        if state == .End {
                            tableView?.delegate?.tableView!(tableView!, didSelectRowAtIndexPath: i)
                        }
                        return TouchTextView.ActiveState.Inactive
                    }
                } else {
                    return TouchTextView.ActiveState.Inactive
                }
            }
        }
        
        if let nameLabel = cell.contentView.viewWithTag(1001) as? UILabel {
            nameLabel.text = com.author.nickName
        }
        
        if let dateLabel = cell.contentView.viewWithTag(1002) as? UILabel {
            dateLabel.text = com.date
        }
        
        if let imgView = cell.contentView.viewWithTag(1003) as? TouchImageView {
            if imgView.layer.mask == nil {
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = UIBezierPath(ovalInRect: imgView.bounds).CGPath
                imgView.layer.mask = shapeLayer
            }
            imgView.kf_setImageWithURL(com.author.icon, placeholderImage: UIImage(named: "default-usericon"))
            imgView.tapHandler = { [weak self, cell] in
                guard let i = self?.tableView.indexPathForCell(cell), comment = self?.comments[i.item] else {return}
                self?.showUserInfo(by: comment.userModel)
            }
        }
        
        return cell
    }
}

extension CommentViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        configComment(at: indexPath.item)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
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
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.scrollEnd()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView){
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
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
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
                UIView.animateWithDuration(0.2, animations: {
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
    let c = NSMutableAttributedString(string: name + amessage)
    let nameRange = NSMakeRange(0, name.characters.count)
    let messageRange = NSMakeRange(name.characters.count, amessage.characters.count)
    let nameFont = UIFont.boldSystemFontOfSize(14)
    let messageFont = UIFont.systemFontOfSize(14)
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
    func getDismisRect() -> CGRect?
    func disMisComplete()
}