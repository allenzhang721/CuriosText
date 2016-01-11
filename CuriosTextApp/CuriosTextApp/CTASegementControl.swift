//
//  CTASegementControl.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/11/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

//class CTASegmentControlAttributes {
//
//    let backgroundColor: UIColor = UIColor.whiteColor()
//}

class CTASegmentControl: UIControl {
    
    private var currentIndex: Int = 0
    
    var momentary: Bool = false
    
    var selectedIndex: Int {
        
        get {
            return currentIndex
        }
        
        set {
            let count = segments.count
            let nextIndex = min(max(0, newValue), count)
            currentIndex = nextIndex
            updateUI()
        }
    }
    
    private var segments = ContiguousArray<UIButton>()
    
    init(frame: CGRect, normal: [UIImage], highlighted: [UIImage]?, selected: [UIImage]?) {
        super.init(frame: frame)
        setupSegments(frame.size, normal: normal, highlighted: highlighted, selected: selected)
        addGestures()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let count = segments.count
        let width = bounds.size.width / CGFloat(count)
        
        for (i, b) in segments.enumerate() {
            
            let height = bounds.size.height
            let x = width * CGFloat(i)
            b.frame = CGRect(x: x, y: 0, width: width, height: height)
        }
    }
    
    private func setupSegments(size: CGSize, normal: [UIImage], highlighted: [UIImage]?, selected: [UIImage]?) {
        
        for b in segments {
            b.layer.removeFromSuperlayer()
        }
        segments.removeAll()
        
        let count = normal.count
        let width = size.width / CGFloat(count)
        let height = size.height
        
        for i in 0..<count {
            
            let x = width * CGFloat(i)
            let button = UIButton(type: .Custom)
            button.frame = CGRect(x: x, y: 0, width: width, height: height)
            button.setImage(normal[i], forState: .Normal)
//            button.addTarget(self, action: "click:", forControlEvents: .tou)
            button.addTarget(self, action: "click:", forControlEvents: .TouchUpInside)
            
            if let h = highlighted where i < h.count {
                button.setImage(h[i], forState: .Highlighted)
            }
            
            if let s = selected where i < s.count {
                button.setImage(s[i], forState: .Selected)
            }
            
            layer.addSublayer(button.layer)
            segments.append(button)
        }
    }
    
    private func addGestures() {
        
        let tap = UITapGestureRecognizer(target: self, action: "tap:")
        addGestureRecognizer(tap)
    }
    
    private func updateUI() {
        
        for (i, b) in segments.enumerate() {
            if b.selected == true {
                b.selected = false
            }
            
            if i == currentIndex {
                b.selected = !momentary
            }
        }
    }
    
    func click(sender: UIButton) {
        
            if let index = segments.indexOf(sender) where index != selectedIndex  {
                    selectedIndex = index
                    sendActionsForControlEvents(.ValueChanged)
            }
    }
    
    func tap(sender: UITapGestureRecognizer) {

        switch sender.state {
        case .Ended:
            for (i, b) in segments.enumerate() {
                let location = sender.locationInView(b)
                if b.pointInside(location, withEvent: nil)  {
                    if i != selectedIndex {
                        selectedIndex = i
                        sendActionsForControlEvents(.ValueChanged)
                        break
                    }
                }
            }
        default:
            ()
        }
    }
}
