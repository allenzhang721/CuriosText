//
//  TouchTextView.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 7/11/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class TouchTextView: UITextView {
    enum TouchState {
        case began, end, cancel
    }
    
    enum ActiveState {
        case actived(NSRange), inactive
    }
    
    var touchHandler: ((TouchTextView, TouchState ,Int) -> ActiveState)?
    fileprivate var overlayView: UIView {
        if let v = viewWithTag(999) {
            return v
        } else {
            let v = UIView()
            v.tag = 999
            v.alpha = 0
            v.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            addSubview(v)
            return v
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {return}
        let p = CGPoint(x: point.x - textContainerInset.left, y: point.y - textContainerInset.top)
        let index = layoutManager.characterIndex(for: p, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if let state = touchHandler?(self, .began,index) {
            if case let .actived(range) = state {
                let rect = layoutManager.boundingRect(forGlyphRange: range, in: textContainer)
                overlayView.frame = rect
                overlayView.alpha = 0
                overlayView.frame.origin.y += textContainerInset.top
                UIView.animate(withDuration: 0.1, animations: {[weak overlayView] in overlayView?.alpha = 1})
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.5, animations: {[weak overlayView] in overlayView?.alpha = 0})
        
        guard let point = touches.first?.location(in: self) else {return}
        let p = CGPoint(x: point.x - textContainerInset.left, y: point.y - textContainerInset.top)
        let index = layoutManager.characterIndex(for: p, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        touchHandler?(self, .end, index)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.5, animations: {[weak overlayView] in overlayView?.alpha = 0})
        
        guard let point = touches.first?.location(in: self) else {return}
        let p = CGPoint(x: point.x - textContainerInset.left, y: point.y - textContainerInset.top)
        let index = layoutManager.characterIndex(for: p, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        touchHandler?(self, .cancel, index)
    }
}
