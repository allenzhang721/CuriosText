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
    
    fileprivate var currentIndex: Int = 0
    
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
    
    fileprivate var segments = ContiguousArray<UIButton>()
    
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
        
        for (i, b) in segments.enumerated() {
            
            let height = bounds.size.height
            let x = width * CGFloat(i)
            b.frame = CGRect(x: x, y: 0, width: width, height: height)
        }
    }
    
    fileprivate func setupSegments(_ size: CGSize, normal: [UIImage], highlighted: [UIImage]?, selected: [UIImage]?) {
        
        for b in segments {
            b.layer.removeFromSuperlayer()
        }
        segments.removeAll()
        
        let count = normal.count
        let width = size.width / CGFloat(count)
        let height = size.height
        
        for i in 0..<count {
            
            let x = width * CGFloat(i)
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: x, y: 0, width: width, height: height)
            button.setImage(normal[i], for: UIControlState())
//            button.addTarget(self, action: "click:", forControlEvents: .tou)
            button.addTarget(self, action: #selector(CTASegmentControl.click(_:)), for: .touchUpInside)
            
            if let h = highlighted, i < h.count {
                button.setImage(h[i], for: .highlighted)
            }
            
            if let s = selected, i < s.count {
                button.setImage(s[i], for: .selected)
            }
            
            layer.addSublayer(button.layer)
            segments.append(button)
        }
    }
    
    fileprivate func addGestures() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CTASegmentControl.tap(_:)))
        addGestureRecognizer(tap)
    }
    
    fileprivate func updateUI() {
        
        for (i, b) in segments.enumerated() {
            if b.isSelected == true {
                b.isSelected = false
            }
            
            if i == currentIndex {
                b.isSelected = !momentary
            }
        }
    }
    
    func click(_ sender: UIButton) {
        
            if let index = segments.index(of: sender), index != selectedIndex  {
                    selectedIndex = index
                    sendActions(for: .valueChanged)
            }
    }
    
    func tap(_ sender: UITapGestureRecognizer) {

        switch sender.state {
        case .ended:
            for (i, b) in segments.enumerated() {
                let location = sender.location(in: b)
                if b.point(inside: location, with: nil)  {
                    if i != selectedIndex {
                        selectedIndex = i
                        sendActions(for: .valueChanged)
                        break
                    }
                }
            }
        default:
            ()
        }
    }
}
