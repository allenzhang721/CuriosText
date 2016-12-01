//
//  InputViewController.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 7/11/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

private var contexts = 0
class InputViewController: UIViewController {
    
    var resizeHandler: ((CGSize) -> ())?
    var sendHandler:((String) -> ())?
    var inputting: Bool {return textView.isFirstResponder}
    
    @IBOutlet weak var lowBoundConstraint: NSLayoutConstraint!
    @IBOutlet weak var upBoundConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    fileprivate var preCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.layer.borderColor = CTAStyleKit.labelShowColor.cgColor
        textView.addObserver(self, forKeyPath: "contentSize", options: .new, context: &contexts)
        textView.textContainerInset.left = 12
        textView.textContainerInset.right = 8
    }
    
    deinit {
        textView.removeObserver(self, forKeyPath: "contentSize", context: &contexts)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if context == &contexts {
            if  let newvalue = (change?[NSKeyValueChangeKey.newKey] as? NSValue)?.cgSizeValue, !textView.isDragging {
                let h = max(min(newvalue.height, 70), 33)
                resizeHandler?(CGSize(width: view.bounds.width, height: h + 12))
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        textView.center = view.center
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.center = view.center
        
        if textView.contentSize.height >= 70 {
            textView.isScrollEnabled = true
            let selectedRange = textView.selectedRange
            textView.scrollRangeToVisible(selectedRange)
        } else {
            textView.isScrollEnabled = false
        }
    }
    
    func beganEdit() {
        textView.text = ""
        placeholderLabel.isHidden = false
        textView.becomeFirstResponder()
    }
    
    func resign() {
        textView.resignFirstResponder()
    }
    
    func changePlaceholder(_ text: String) {
        placeholderLabel.text = text
    }
}

extension InputViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.characters.count <= 0 {
            placeholderLabel.text = LocalStrings.publishComment.description
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            sendHandler?(textView.text)
            textView.text = ""
            placeholderLabel.text = LocalStrings.publishComment.description
            placeholderLabel.isHidden = false
            return false
        }
        
        if range.length > 1 || text.characters.count > 1 {
            
            let replaceCount = text.characters.count
            let selectedCount = range.length == 0 ? 1 : range.length
            let notEqual = replaceCount != selectedCount
            
            if notEqual {
                let manager = textView.layoutManager
                let glyrange = manager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
                let selectedRect = manager.boundingRect(forGlyphRange: glyrange, in: textView.textContainer)
                
                let estimateHeight = selectedRect.height * CGFloat(replaceCount) / CGFloat(selectedCount)
                let nexth = textView.contentSize.height - selectedRect.height + estimateHeight
                
                if nexth > 70 {
                    textView.isScrollEnabled = false
                } else {
                    textView.isScrollEnabled = false
                }
            }
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.characters.count
        let h = textView.contentSize.height
        let he = textView.bounds.height
        let up = upBoundConstraint.constant
        let low = lowBoundConstraint.constant
        let minus = count < preCount
        
        placeholderLabel.isHidden = (count > 0)
        
        if h > up {
            textView.isScrollEnabled = true
        } else if h == up {
            textView.isScrollEnabled = minus ? false : true
        } else if h < up && h > low {
            textView.isScrollEnabled = false
        } else if h < low {
            textView.isScrollEnabled = false
        } else {
            textView.isScrollEnabled = false
        }
        
        preCount = count
    }
}
