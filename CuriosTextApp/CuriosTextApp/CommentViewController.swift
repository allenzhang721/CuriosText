//
//  CommentViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import KeyboardMan

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
    
    var snapshotView: UIView?
    var myID: String!
    var publishID: String!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    private weak var inputVC: InputViewController!
    private var comments = [Comment]()
    private let keyborad = KeyboardMan()
    private var tempIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
        setupData()
    }
    
    private func setupView() {
        
        titleLabel.text = title
        
        if let snapshotView = snapshotView {
            view.insertSubview(snapshotView, atIndex: 0)
        }
        
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
        

    }
    
    private func setupData() {
        CTACommentDomain.getInstance().publichCommentList(publishID, start: 0, size: 10) {[weak self] (listInfo) in
            let scucess = listInfo.result
            if scucess {
                if let models = listInfo.modelArray as? [CTACommentModel] {
                    let fetchedComments = models.map{CTACommentModel.toComment($0)}
                    self?.comments = fetchedComments
                    dispatch_async(dispatch_get_main_queue(), { 
                        self?.tableView.reloadData()
                    })
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
            
            bottomConstraint?.constant = -keyboardHeight
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
        dismissViewControllerAnimated(true, completion: nil)
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