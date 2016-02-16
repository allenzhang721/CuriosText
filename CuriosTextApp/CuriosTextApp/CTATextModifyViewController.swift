//
//  CTATextModifyViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 2/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit
import KeyboardMan


class CTATextModifyViewController: UIViewController {
    
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    weak var bottomWithKeyBoardConstraint: NSLayoutConstraint?
    @IBOutlet weak var textView: UITextView!
    private var text = "Emiaostein"
    private var attri = [String: AnyObject]()
    let keyboardMan = KeyboardMan()
    
    var textModifyDidCompletion: ((text: String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        beganText()
        keyboardChangedNotification()
        
        textView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
        
        
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        textView.resignFirstResponder()
    }
    
    deinit {
        textView.removeObserver(self, forKeyPath: "contentSize")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        let height = textView.bounds.height
        let contentHeight = textView.contentSize.height
        
        if let t = object as? UITextView where t == textView && height > contentHeight && keyPath == "contentSize" {
            
            let topOffset = (height - contentHeight) / 2.0
            let aOffset = topOffset < 0.0 ? 0.0 : topOffset
            
//            textView.contentOffset = CGPoint(x: textView.contentOffset.x, y: -aOffset)
            textView.transform = CGAffineTransformMakeTranslation(0, aOffset)
            debug_print("height = \(height), contentHeight = \(contentHeight), offsetY = \(textView.contentOffset.y)")
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func beganWith(text: String, attributes: [String: AnyObject]?) {
        self.text = text
        if let attributes = attributes {
            self.attri = attributes
        }
        
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        cancel()
    }
    
    @IBAction func doneAction(sender: AnyObject) {
        done()
    }
    
    private func cancel() {
        
        dismissViewControllerAnimated(true) { 
            
            // dismiss and cancel completion
        }
    }
    
    private func done() {
        
        if textView.text != text {
            textModifyDidCompletion?(text: textView.text)
        }
        
        dismissViewControllerAnimated(true) { 
            
            // dismiss and done completion
        }
    }
    
    private func beganText() {
        
        let attributeText = NSAttributedString(string: self.text, attributes: self.attri)
        textView.attributedText = attributeText
        textView.textColor = UIColor.blackColor()
    }
    
    private func keyboardChangedNotification() {
        
        
        keyboardMan.animateWhenKeyboardAppear = { [weak self] appearPostIndex, keyboardHeight, keyboardHeightIncrement in
            
            print("appear \(appearPostIndex), \(keyboardHeight), \(keyboardHeightIncrement)\n")
            
            if let strongSelf = self {
                
                if let bott = strongSelf.bottomConstraint where bott.active == true {
                    bott.active = false
                }
                
                if let bottomWithKeyboard = strongSelf.bottomWithKeyBoardConstraint where bottomWithKeyboard.active == false {
                    
                    bottomWithKeyboard.active = true
                } else {
                    
                   strongSelf.bottomWithKeyBoardConstraint = strongSelf.textView.bottomAnchor.constraintEqualToAnchor(strongSelf.view.bottomAnchor, constant: -keyboardHeight)
                    
                    strongSelf.bottomWithKeyBoardConstraint?.active = true
                    
                }
//                
//                strongSelf.bottomConstraint.active = false
                strongSelf.textView.bottomAnchor.constraintEqualToAnchor(strongSelf.view.bottomAnchor, constant: -keyboardHeight).active = true
                strongSelf.view.layoutIfNeeded()
                
                let height = strongSelf.textView.bounds.height
                let contentHeight = strongSelf.textView.contentSize.height
                if height > contentHeight {
                    let topOffset = (height - contentHeight) / 2.0
                    let aOffset = topOffset < 0.0 ? 0.0 : topOffset
                    strongSelf.textView.contentOffset = CGPoint(x: strongSelf.textView.contentOffset.x, y: -aOffset)
                }
                
//                let bottom = strongSelf.textView.bounds.height / 2.0
//                let top = bottom
//                let left: CGFloat = 0
//                let right: CGFloat = 0
//                strongSelf.textView.contentInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
            }
        }
        
//        keyboardMan.animateWhenKeyboardDisappear = { [weak self] keyboardHeight in
//            
//            print("disappear \(keyboardHeight)\n")
//            
//            if let strongSelf = self {
//                
//                strongSelf.textView.bottomAnchor.constraintEqualToAnchor(strongSelf.view.bottomAnchor).active = true
//                strongSelf.view.layoutIfNeeded()
//            }
//        }
    }
}

extension CTATextModifyViewController: UITextViewDelegate {
    
//    func textViewDidChange(textView: UITextView) {
//        
//        let textSize = textView.layoutManager.textContainers.first?.size
//        textView.setContentOffset(CGPoint(x: 0, y: textView.contentSize.height + textSize!.height / 2.0), animated: false)
//    }
}
