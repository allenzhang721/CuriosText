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
    fileprivate var text = "Emiaostein"
    fileprivate var attri = [String: AnyObject]()
    let keyboardMan = KeyboardMan()
    
    var textModifyDidCompletion: ((_ text: String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        beganText()
        keyboardChangedNotification()
        
//        textView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    func beganWith(_ text: String, attributes: [String: AnyObject]?) {
        self.text = text
        if let attributes = attributes {
            self.attri = attributes
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        textView.resignFirstResponder()
    }
    
    deinit {
//        textView.removeObserver(self, forKeyPath: "contentSize")
//        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let height = textView.bounds.height
        let contentHeight = textView.contentSize.height
        
        if let t = object as? UITextView, t == textView && height > contentHeight && keyPath == "contentSize" {
            
            let topOffset = (height - contentHeight) / 2.0 - 10
            let aOffset = topOffset < 0.0 ? 0.0 : topOffset
            
            textView.setContentOffset(CGPoint(x: textView.contentOffset.x, y: -aOffset), animated: false)
            textView.contentOffset = CGPoint(x: textView.contentOffset.x, y: -aOffset)
//            textView.transform = CGAffineTransformMakeTranslation(0, aOffset)
//            debug_print("height = \(height), contentHeight = \(contentHeight), offsetY = \(aOffset)")
            
            debug_print("height = \(height), contentHeight = \(contentHeight), offsetY = \(textView.contentOffset.y)")
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    
    @IBAction func cancelAction(_ sender: AnyObject) {
        cancel()
    }
    
    @IBAction func doneAction(_ sender: AnyObject) {
        done()
    }
    
    fileprivate func cancel() {
        
        dismiss(animated: true) { 
            
            // dismiss and cancel completion
        }
    }
    
    fileprivate func done() {
        
        if textView.text != text {
            textModifyDidCompletion?(textView.text)
        }
        
        dismiss(animated: true) { 
            
            // dismiss and done completion
        }
    }
    
    fileprivate func beganText() {
        
        let attributeText = NSAttributedString(string: self.text, attributes: self.attri)
        textView.attributedText = attributeText
        textView.textColor = UIColor.black
    }
    
    fileprivate func keyboardChangedNotification() {
        
        keyboardMan.animateWhenKeyboardAppear = { [weak self] appearPostIndex, keyboardHeight, keyboardHeightIncrement in
            
            if let strongSelf = self {
                if let bott = strongSelf.bottomConstraint, bott.isActive == true {
                    bott.isActive = false
                }
                
                if let bottomWithKeyboard = strongSelf.bottomWithKeyBoardConstraint, bottomWithKeyboard.isActive == true {
                    
                    bottomWithKeyboard.isActive = false
                    strongSelf.textView.removeConstraint(bottomWithKeyboard)
                    strongSelf.bottomWithKeyBoardConstraint = strongSelf.textView.bottomAnchor.constraint(equalTo: strongSelf.view.bottomAnchor, constant: -keyboardHeight)
                    strongSelf.bottomWithKeyBoardConstraint?.isActive = true
                    
                } else {
                    
                   strongSelf.bottomWithKeyBoardConstraint = strongSelf.textView.bottomAnchor.constraint(equalTo: strongSelf.view.bottomAnchor, constant: -keyboardHeight)
                    strongSelf.bottomWithKeyBoardConstraint?.isActive = true
                }

                strongSelf.view.layoutIfNeeded()
            }
        }
    }
}
