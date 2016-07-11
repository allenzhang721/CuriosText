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
        case Began, End, Cancel
    }
    
    enum ActiveState {
        case Actived(NSRange), Inactive
    }
    
    var touchHandler: ((TouchTextView, Int) -> ActiveState)?
    private var overlayView: UIView {
        if let v = viewWithTag(999) {
            return v
        } else {
            let v = UIView()
            v.tag = 999
            v.alpha = 0
            v.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
            addSubview(v)
            return v
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let point = touches.first?.locationInView(self) else {return}
        let p = CGPoint(x: point.x - textContainerInset.left, y: point.y - textContainerInset.top)
        let index = layoutManager.characterIndexForPoint(p, inTextContainer: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if let state = touchHandler?(self, index) {
            if case let .Actived(range) = state {
                let rect = layoutManager.boundingRectForGlyphRange(range, inTextContainer: textContainer)
                overlayView.frame = rect
                overlayView.alpha = 0
                overlayView.frame.origin.y += textContainerInset.top
                UIView.animateWithDuration(0.1){[weak overlayView] in overlayView?.alpha = 1}
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        UIView.animateWithDuration(0.5){[weak overlayView] in overlayView?.alpha = 0}
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        UIView.animateWithDuration(0.5){[weak overlayView] in overlayView?.alpha = 0}
    }
}
