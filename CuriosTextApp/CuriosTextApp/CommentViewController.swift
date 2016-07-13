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
    
    var myID = "29db92c8e00149c8ad36c4c5e3602fae"
    var publishID: String!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    private weak var inputVC: InputViewController!
    private var comments = [Comment]()
    private let keyborad = KeyboardMan()
    private var tempIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        publishID = "AC0DD367334A40D7A00B21731CAAA24E"
        setup()
    }
    
    override func viewDidAppear(animated: Bool) {
        
//        CTACommentDomain.getInstance().addPublishComment(CTAUserManager.user!.userID, beUserID: "", publishID: publishID, commentMessage: "EMiaostein") { (info) in
//            print(info)
//        }
//
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
    
    private func showUserInfo(by userID: String) {
        print(userID)
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
                                self?.showUserInfo(by: someone.ID)
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
                guard let i = self?.tableView.indexPathForCell(cell), authorID = self?.comments[i.item].author.ID else {return}
                self?.showUserInfo(by: authorID)
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












































let demo = [
    comment(withUser: demoString[0].0, message: demoString[0].1),
    comment(withUser: demoString[1].0, message: demoString[1].1),
    comment(withUser: demoString[2].0, message: demoString[2].1),
]

let demoString = [
    ("Emiaostein", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
    ("Allen", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."),
    ("Jennifer", "Lorem ipsum dolor sit amet, consectetur adipisicing elit.")
]


func comment(withUser userName: String?, message: String) -> (NSAttributedString, NSRange) {
    
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




func longComment() -> NSAttributedString
{
    // Create the attributed string
    let longComment = NSMutableAttributedString(string:"@Emiaostein Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
    
    // Declare the fonts
    let longCommentFont1 = UIFont(name:"Helvetica-Bold", size:14.0)
    let longCommentFont2 = UIFont(name:"Helvetica-Light", size:14.0)
    
    // Declare the colors
    let longCommentColor1 = UIColor(red: 0.000000, green: 0.266667, blue: 0.996078, alpha: 1.000000)
    let longCommentColor2 = UIColor(red: 0.000000, green: 0.000000, blue: 0.000000, alpha: 1.000000)
    
    // Declare the paragraph styles
    let longCommentParaStyle1 = NSMutableParagraphStyle()
    longCommentParaStyle1.defaultTabInterval = 40.8
    longCommentParaStyle1.tabStops = [NSTextTab(textAlignment: NSTextAlignment.Left, location: 40.800000, options: [:]), ]
    
    
    // Create the attributes and add them to the string
    longComment.addAttribute(NSLigatureAttributeName, value:0, range:NSMakeRange(0,11))
    longComment.addAttribute(NSParagraphStyleAttributeName, value:longCommentParaStyle1, range:NSMakeRange(0,11))
    longComment.addAttribute(NSFontAttributeName, value:longCommentFont1!, range:NSMakeRange(0,11))
    longComment.addAttribute(NSForegroundColorAttributeName, value:longCommentColor1, range:NSMakeRange(0,11))
    longComment.addAttribute(NSLigatureAttributeName, value:0, range:NSMakeRange(11,447))
    longComment.addAttribute(NSParagraphStyleAttributeName, value:longCommentParaStyle1, range:NSMakeRange(11,447))
    longComment.addAttribute(NSFontAttributeName, value:longCommentFont2!, range:NSMakeRange(11,447))
    longComment.addAttribute(NSForegroundColorAttributeName, value:longCommentColor2, range:NSMakeRange(11,447))
    
    return NSAttributedString(attributedString:longComment)
}

func middleComment() -> NSAttributedString
{
    // Create the attributed string
    let middleComment = NSMutableAttributedString(string:"@Allen Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
    
    // Declare the fonts
    let middleCommentFont1 = UIFont(name:"Helvetica-Bold", size:14.0)
    let middleCommentFont2 = UIFont(name:"Helvetica-Light", size:14.0)
    
    // Declare the colors
    let middleCommentColor1 = UIColor(red: 0.000000, green: 0.266667, blue: 0.996078, alpha: 1.000000)
    let middleCommentColor2 = UIColor(red: 0.000000, green: 0.000000, blue: 0.000000, alpha: 1.000000)
    
    // Declare the paragraph styles
    let middleCommentParaStyle1 = NSMutableParagraphStyle()
    middleCommentParaStyle1.defaultTabInterval = 40.8
    middleCommentParaStyle1.tabStops = [NSTextTab(textAlignment: NSTextAlignment.Left, location: 40.800000, options: [:]), ]
    
    
    // Create the attributes and add them to the string
    middleComment.addAttribute(NSLigatureAttributeName, value:0, range:NSMakeRange(0,6))
    middleComment.addAttribute(NSParagraphStyleAttributeName, value:middleCommentParaStyle1, range:NSMakeRange(0,6))
    middleComment.addAttribute(NSFontAttributeName, value:middleCommentFont1!, range:NSMakeRange(0,6))
    middleComment.addAttribute(NSForegroundColorAttributeName, value:middleCommentColor1, range:NSMakeRange(0,6))
    middleComment.addAttribute(NSLigatureAttributeName, value:0, range:NSMakeRange(6,233))
    middleComment.addAttribute(NSParagraphStyleAttributeName, value:middleCommentParaStyle1, range:NSMakeRange(6,233))
    middleComment.addAttribute(NSFontAttributeName, value:middleCommentFont2!, range:NSMakeRange(6,233))
    middleComment.addAttribute(NSForegroundColorAttributeName, value:middleCommentColor2, range:NSMakeRange(6,233))
    
    return NSAttributedString(attributedString:middleComment)
}

func shortComment() -> NSAttributedString
{
    // Create the attributed string
    let shortComment = NSMutableAttributedString(string:"@Jennifer Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
    
    // Declare the fonts
    let shortCommentFont1 = UIFont(name:"Helvetica-Bold", size:14.0)
    let shortCommentFont2 = UIFont(name:"Helvetica-Light", size:14.0)
    
    // Declare the colors
    let shortCommentColor1 = UIColor(red: 0.000000, green: 0.266667, blue: 0.996078, alpha: 1.000000)
    let shortCommentColor2 = UIColor(red: 0.000000, green: 0.000000, blue: 0.000000, alpha: 1.000000)
    
    // Declare the paragraph styles
    let shortCommentParaStyle1 = NSMutableParagraphStyle()
    shortCommentParaStyle1.defaultTabInterval = 40.8
    shortCommentParaStyle1.tabStops = [NSTextTab(textAlignment: NSTextAlignment.Left, location: 40.800000, options: [:]), ]
    
    
    // Create the attributes and add them to the string
    shortComment.addAttribute(NSLigatureAttributeName, value:0, range:NSMakeRange(0,9))
    shortComment.addAttribute(NSParagraphStyleAttributeName, value:shortCommentParaStyle1, range:NSMakeRange(0,9))
    shortComment.addAttribute(NSFontAttributeName, value:shortCommentFont1!, range:NSMakeRange(0,9))
    shortComment.addAttribute(NSForegroundColorAttributeName, value:shortCommentColor1, range:NSMakeRange(0,9))
    shortComment.addAttribute(NSLigatureAttributeName, value:0, range:NSMakeRange(9,125))
    shortComment.addAttribute(NSParagraphStyleAttributeName, value:shortCommentParaStyle1, range:NSMakeRange(9,125))
    shortComment.addAttribute(NSFontAttributeName, value:shortCommentFont2!, range:NSMakeRange(9,125))
    shortComment.addAttribute(NSForegroundColorAttributeName, value:shortCommentColor2, range:NSMakeRange(9,125))
    
    return NSAttributedString(attributedString:shortComment)
}

func singleComment() -> NSAttributedString
{
    // Create the attributed string
    let singleComment = NSMutableAttributedString(string:"@Jennifer Lorem ipsum")
    
    // Declare the fonts
    let singleCommentFont1 = UIFont(name:"Helvetica-Bold", size:14.0)
    let singleCommentFont2 = UIFont(name:"Helvetica-Light", size:14.0)
    
    // Declare the colors
    let singleCommentColor1 = UIColor(red: 0.000000, green: 0.266667, blue: 0.996078, alpha: 1.000000)
    let singleCommentColor2 = UIColor(red: 0.000000, green: 0.000000, blue: 0.000000, alpha: 1.000000)
    
    // Declare the paragraph styles
    let singleCommentParaStyle1 = NSMutableParagraphStyle()
    singleCommentParaStyle1.defaultTabInterval = 40.8
    singleCommentParaStyle1.tabStops = [NSTextTab(textAlignment: NSTextAlignment.Left, location: 40.800000, options: [:]), ]
    
    
    // Create the attributes and add them to the string
    singleComment.addAttribute(NSLigatureAttributeName, value:0, range:NSMakeRange(0,9))
    singleComment.addAttribute(NSParagraphStyleAttributeName, value:singleCommentParaStyle1, range:NSMakeRange(0,9))
    singleComment.addAttribute(NSFontAttributeName, value:singleCommentFont1!, range:NSMakeRange(0,9))
    singleComment.addAttribute(NSForegroundColorAttributeName, value:singleCommentColor1, range:NSMakeRange(0,9))
    singleComment.addAttribute(NSLigatureAttributeName, value:0, range:NSMakeRange(9,12))
    singleComment.addAttribute(NSParagraphStyleAttributeName, value:singleCommentParaStyle1, range:NSMakeRange(9,12))
    singleComment.addAttribute(NSFontAttributeName, value:singleCommentFont2!, range:NSMakeRange(9,12))
    singleComment.addAttribute(NSForegroundColorAttributeName, value:singleCommentColor2, range:NSMakeRange(9,12))
    
    return NSAttributedString(attributedString:singleComment)
}
