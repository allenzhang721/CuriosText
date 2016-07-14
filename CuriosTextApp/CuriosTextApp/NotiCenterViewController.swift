//
//  NotiCenterViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

private class MessageGenerator {
    class func makeMessage(with model: CTANoticeModel) -> Message {// 0 follow   1  like    2 comment
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
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension NotiCenterViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NotiLikeCell")!
        
        if let textView = cell.contentView.viewWithTag(1000) as? UITextView {
            textView.text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        }
        return cell
    }
}
