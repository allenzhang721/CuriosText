//
//  CTASelectorShadowAndStrokeCell.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 7/7/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTASelectorShadowAndStrokeCell: CTASelectorCell {

    weak var target: AnyObject?
    var action: Selector?
    var shadowSwitch: UISwitch!
    var strokeSwitch: UISwitch!
    var shadowLabel: UILabel!
    var strokeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        shadowSwitch = UISwitch(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        strokeSwitch = UISwitch(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        shadowLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        strokeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        
        shadowLabel.text = LocalStrings.shadow.description
        strokeLabel.text = LocalStrings.outline.description
        shadowLabel.font = UIFont.systemFont(ofSize: 12)
        strokeLabel.font = UIFont.systemFont(ofSize: 12)
        shadowLabel.textAlignment = .center
        strokeLabel.textAlignment = .center
        
        shadowSwitch.addTarget(self, action: #selector(CTASelectorShadowAndStrokeCell.needShadowChanged(_:)), for: .valueChanged)
        strokeSwitch.addTarget(self, action: #selector(CTASelectorShadowAndStrokeCell.needStrokeChanged(_:)), for: .valueChanged)
        contentView.addSubview(shadowSwitch)
        contentView.addSubview(strokeSwitch)
        contentView.addSubview(shadowLabel)
        contentView.addSubview(strokeLabel)
    }
    
    func needShadowChanged(_ sender: UISwitch) {
        if let target = target, let action = action {
            target.perform(action, with: [sender.isOn, strokeSwitch.isOn])
        }
    }
    
    func needStrokeChanged(_ sender: UISwitch) {
        if let target = target, let action = action {
            target.perform(action, with: [shadowSwitch.isOn, sender.isOn])
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w = bounds.width
        let h = bounds.height
        shadowSwitch.center.x = w / 4.0
        shadowSwitch.center.y = h / 2.0
        strokeSwitch.center.x = w / 4.0 * 3.0
        strokeSwitch.center.y = h / 2.0
        shadowLabel.center = CGPoint(x: w / 4.0, y: h / 2.0 + 30)
        strokeLabel.center = CGPoint(x: w / 4.0 * 3.0, y: h / 2.0 + 30)
    }
    
    override func retriveBeganValue() {
        
        guard let dataSource = dataSource else {
            return
        }
        let began = dataSource.selectorBeganNeedShadowAndStroke(self)
        shadowSwitch.isOn = began.0
        strokeSwitch.isOn = began.1
    }
    
    override func addTarget(_ target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        self.target = target
        self.action = action
//        view.addTarget(target, action: action, forControlEvents: controlEvents)
    }
    
    override func removeAllTarget() {
        target = nil
        action = nil
    }

}
