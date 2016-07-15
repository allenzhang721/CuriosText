//
//  NotiCenterViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

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
        return NSURL(string: CTAFilePath.publishFilePath + model.previewIconURL)!
    }
    var userModel: CTAViewUserModel {
        return model.userModel
    }
    
    var publishID: String {
        return model.publishID
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

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    
    private var messages = [Message]()
    private var myID: String {
        return CTAUserManager.user?.userID ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !myID.isEmpty {
            setup()
        }
    }

    private func setup() {
        setupView()
        setupData()
    }
    
    private func setupView() {
        navigationController?.navigationBarHidden = true
        
        titleLabel.text = LocalStrings.NotificationTitle.description
        clearButton.setTitle(LocalStrings.Clear.description, forState: .Normal)
        
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
    }
    
    private func setupData() {
        CTANoticeDomain.getInstance().noticeList(myID, start: 0, size: 99) {[weak self] (info) in
            guard info.modelArray?.count > 0,  let notices = info.modelArray as? [CTANoticeModel] else {return}
            let ms = notices.map{MessageGenerator.makeMessage(by: $0)}
            self?.messages = ms
            dispatch_async(dispatch_get_main_queue(), { 
                self?.tableView.reloadData()
            })
        }
    }
    
    private func showUserInfo(by userModel: CTAViewUserModel) {
        if let navigationController = navigationController {
            let userPublish = UserViewController()
            userPublish.viewUser = userModel
            navigationController.pushViewController(userPublish, animated: true)
//            self.notFresh = true
        }
    }
    
    private func showPublishDetail(withPublishID publishID: String) {
        CTAPublishDomain.getInstance().publishDetai(myID, publishID: publishID) {[weak self] (info) in
            
                dispatch_async(dispatch_get_main_queue(), {
                    if let model = info?.baseModel as? CTAPublishModel {
                    self?.showDetailView(model)
                    }
                })
        }
    }
    
    private func showDetailView(withModel: CTAPublishModel) {
        //TODO:  -- Emiaostein, 7/15/16, 17:01
        
    }
    
    private func followUser() {
        //TODO:  -- Emiaostein, 7/15/16, 17:41
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
        CTANoticeDomain.getInstance().clearNotices(myID) {[weak self] (info) in
            dispatch_async(dispatch_get_main_queue(), { 
                self?.messages = []
                self?.tableView.reloadData()
            })
        }
    }
}

extension NotiCenterViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cell(for: tableView, at: indexPath)
    }
}

private var tempRect: CGRect?
extension NotiCenterViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let message = messages[indexPath.item]
        
        if message is CommentMessage {
            if let rect = tableView.cellForRowAtIndexPath(indexPath)?.frame {
                let r = view.convertRect(rect, fromView: tableView)
                showComment(withPublishID: message.publishID, beganRect: r)
            }
        } else if message is FollowMessage {
            showUserInfo(by: message.userModel)
        } else if message is LikeMessage {
            showPublishDetail(withPublishID: message.publishID)
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
}

extension NotiCenterViewController: CommentViewDelegate {
    func getDismisRect() -> CGRect? {
        return tempRect
    }
    func disMisComplete() {
        
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
                switch follow.relationship {
                case .CanFollowHe:
                    imgView.image = UIImage(named: "liker_follow_btn")
                    imgView.tapHandler = { [weak self, cell] in
                        guard let i = self?.tableView.indexPathForCell(cell), amessage = self?.messages[i.item] else {return}
                        self?.followUser()
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
                textView.text = comment.text
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
            
            previewView.tapHandler = { [weak self, cell] in
                guard let i = self?.tableView.indexPathForCell(cell), amessage = self?.messages[i.item] else {return}
                self?.showPublishDetail(withPublishID: amessage.publishID)
            }
        }
        
        return cell
    }
}
