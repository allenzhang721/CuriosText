//
//  CommentViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import KeyboardMan

private struct Comment {
    let sender: String
    let reciver: String
    let message: String
    let renderedMessage: NSAttributedString
}

class CommentViewController: UIViewController {
    
    var publishID: String!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    private weak var inputVC: InputViewController!
    private var comments = [Comment]()
    private let keyborad = KeyboardMan()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
//        view.backgroundColor = UIColor.lightGrayColor()
//        
//        let closeButton = UIButton(frame: CGRect(x: 0, y: 22, width: 40, height: 40))
//        closeButton.setImage(UIImage(named: "close-button"), forState: .Normal)
//        closeButton.setImage(UIImage(named: "close-selected-button"), forState: .Highlighted)
//        closeButton.addTarget(self, action: #selector(closeButtonClick(_:)), forControlEvents: .TouchUpInside)
//        self.view.addSubview(closeButton)
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        
        inputVC.resizeHandler = {[weak inputContainerView , heightConstraint] size in
            if heightConstraint.constant != size.height {
                heightConstraint?.constant = size.height
                inputContainerView?.layoutIfNeeded()
            }
        }
    }
    
    private func setupData() {
        CTACommentDomain.getInstance().publichCommentList(publishID, start: 0, size: 10) { (listInfo) in
            print((listInfo.modelArray![0] as! CTACommentModel).commentMessage)
        }
    }
    
    
    
    private func setupKeyboard() {
        
        keyborad.animateWhenKeyboardAppear = {[weak bottomConstraint, view] (appearPostIndex: Int, keyboardHeight: CGFloat, keyboardHeightIncrement: CGFloat) -> Void in
            bottomConstraint?.constant = -keyboardHeight
            view?.layoutIfNeeded()
        }
        
        keyborad.animateWhenKeyboardDisappear = { [weak bottomConstraint, view] keyboardHeight in
            bottomConstraint?.constant = 0
            view?.layoutIfNeeded()
        }
        
    }
    
    func closeButtonClick(sender: UIButton){
        self.dismissViewControllerAnimated(true) {
            
        }
    }
}

extension CommentViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell")!
        
        if let textView = cell.contentView.viewWithTag(1000) as? TouchTextView {
            textView.contentInset.left = -5
            textView.textContainerInset.top = 0
            let i = indexPath.item % 3
            let r = demo[i]
            textView.attributedText = r.0
            textView.touchHandler = {[weak textView] (tv, index) -> TouchTextView.ActiveState in
                if tv == textView {
                    let range = r.1
                    return (range.location <= index && index < range.location + range.length) ? TouchTextView.ActiveState.Actived(range) : TouchTextView.ActiveState.Inactive
                } else {
                    return TouchTextView.ActiveState.Inactive
                }
            }
        }
        return cell
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


func comment(withUser userName: String, message: String) -> (NSAttributedString, NSRange) {
    
    let name = "@" + userName
    let amessage = " " + message
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
