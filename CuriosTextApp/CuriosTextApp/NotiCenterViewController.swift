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
    var iconURL: String {
        return model.userModel.userIconURL
    }
    var date: String {
        return DateString(model.noticeDate)
    }
    
    let model: CTANoticeModel
    init(model: CTANoticeModel) {
        self.model = model
    }
}

private class LikeMessage: Message {
}

private class CommentMessage: Message {
    var previewIconURL: String {
        return model.previewIconURL
    }
    var comment: String {
        return model.noticeMessage
    }
}
private class FollowMessage: Message {
    var previewIconURL: String {
        return model.previewIconURL
    }
}

class NotiCenterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var messages = [Message]()
    private var myID: String {
        return ""
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
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func setupData() {
        CTANoticeDomain.getInstance().noticeList(myID, start: 0, size: 10) {[weak self] (info) in
            guard info.modelArray?.count > 0,  let notices = info.modelArray as? [CTANoticeModel] else {return}
            let ms = notices.map{MessageGenerator.makeMessage(by: $0)}
            self?.messages = ms
            dispatch_async(dispatch_get_main_queue(), { 
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
        
        let message = messages[indexPath.item]
        
        if let like = message as? LikeMessage {
            let cell = tableView.dequeueReusableCellWithIdentifier("NotiLikeCell")!
            
            return cell
            
        } else if let follow = message as? FollowMessage {
            let cell = tableView.dequeueReusableCellWithIdentifier("NotiFollowCell")!
            
            return cell
            
        } else if let comment = message as? CommentMessage {
            let cell = tableView.dequeueReusableCellWithIdentifier("NotiCommentCell")!
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("NotiCell")!
            return cell
        }
    }
}
