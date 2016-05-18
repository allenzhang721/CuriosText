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
    var bottomWithKeyBoardConstraint: NSLayoutConstraint?
    @IBOutlet weak var textView: UITextView!
    private var text = "Emiaostein"
    private var attri = [String: AnyObject]()
    let keyboardMan = KeyboardMan()
    
    var textModifyDidCompletion: ((text: String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        beganText()
        keyboardChangedNotification()
        
//        textView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    func beganWith(text: String, attributes: [String: AnyObject]?) {
        self.text = text
        if let attributes = attributes {
            self.attri = attributes
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        textView.resignFirstResponder()
    }
    
    deinit {
//        textView.removeObserver(self, forKeyPath: "contentSize")
//        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        let height = textView.bounds.height
        let contentHeight = textView.contentSize.height
        
        if let t = object as? UITextView where t == textView && height > contentHeight && keyPath == "contentSize" {
            
            let topOffset = (height - contentHeight) / 2.0 - 10
            let aOffset = topOffset < 0.0 ? 0.0 : topOffset
            
            textView.setContentOffset(CGPoint(x: textView.contentOffset.x, y: -aOffset), animated: false)
            textView.contentOffset = CGPoint(x: textView.contentOffset.x, y: -aOffset)
//            textView.transform = CGAffineTransformMakeTranslation(0, aOffset)
//            debug_print("height = \(height), contentHeight = \(contentHeight), offsetY = \(aOffset)")
            
            debug_print("height = \(height), contentHeight = \(contentHeight), offsetY = \(textView.contentOffset.y)")
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
            
            if let strongSelf = self {
                if let bott = strongSelf.bottomConstraint where bott.active == true {
                    bott.active = false
                }
                
                if let bottomWithKeyboard = strongSelf.bottomWithKeyBoardConstraint where bottomWithKeyboard.active == true {
                    
                    bottomWithKeyboard.active = false
                    strongSelf.textView.removeConstraint(bottomWithKeyboard)
                    strongSelf.bottomWithKeyBoardConstraint = strongSelf.textView.bottomAnchor.constraintEqualToAnchor(strongSelf.view.bottomAnchor, constant: -keyboardHeight)
                    strongSelf.bottomWithKeyBoardConstraint?.active = true
                    
                } else {
                    
                   strongSelf.bottomWithKeyBoardConstraint = strongSelf.textView.bottomAnchor.constraintEqualToAnchor(strongSelf.view.bottomAnchor, constant: -keyboardHeight)
                    strongSelf.bottomWithKeyBoardConstraint?.active = true
                }

                strongSelf.view.layoutIfNeeded()
            }
        }
    }
}
