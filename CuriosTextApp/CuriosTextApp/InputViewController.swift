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
    
    @IBOutlet weak var lowBoundConstraint: NSLayoutConstraint!
    @IBOutlet weak var upBoundConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    
    private var preCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        textView.removeObserver(self, forKeyPath: "contentSize", context: &contexts)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if context == &contexts {
            
            if  let newvalue = (change?[NSKeyValueChangeNewKey] as? NSValue)?.CGSizeValue() where !textView.dragging {
                let h = max(min(newvalue.height, 70), 33)
                resizeHandler?(CGSize(width: view.bounds.width, height: h + 12))
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        textView.addObserver(self, forKeyPath: "contentSize", options: .New, context: &contexts)
        textView.textContainerInset.left = 12
        textView.textContainerInset.right = 8
        textView.becomeFirstResponder()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        textView.center = view.center
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.center = view.center
        
        if textView.contentSize.height >= 70 {
            textView.scrollEnabled = true
            let selectedRange = textView.selectedRange
            textView.scrollRangeToVisible(selectedRange)
        } else {
            textView.scrollEnabled = false
        }
    }
}

extension InputViewController: UITextViewDelegate {
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if range.length > 1 || text.characters.count > 1 {
            
            let replaceCount = text.characters.count
            let selectedCount = range.length == 0 ? 1 : range.length
            let notEqual = replaceCount != selectedCount
            
            if notEqual {
                let manager = textView.layoutManager
                let glyrange = manager.glyphRangeForCharacterRange(range, actualCharacterRange: nil)
                let selectedRect = manager.boundingRectForGlyphRange(glyrange, inTextContainer: textView.textContainer)
                
                let estimateHeight = selectedRect.height * CGFloat(replaceCount) / CGFloat(selectedCount)
                let nexth = textView.contentSize.height - selectedRect.height + estimateHeight
                
                if nexth > 70 {
                    textView.scrollEnabled = false
                } else {
                    textView.scrollEnabled = false
                }
            }
        }
        
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        let count = textView.text.characters.count
        let h = textView.contentSize.height
        let he = textView.bounds.height
        let up = upBoundConstraint.constant
        let low = lowBoundConstraint.constant
        let minus = count < preCount
        
        if h > up {
            textView.scrollEnabled = true
        } else if h == up {
            textView.scrollEnabled = minus ? false : true
        } else if h < up && h > low {
            textView.scrollEnabled = false
        } else if h < low {
            textView.scrollEnabled = false
        } else {
            textView.scrollEnabled = false
        }
        
        preCount = count
    }
}
