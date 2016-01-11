//: Playground - noun: a place where people can play

import UIKit
import XCPlayground
var str = "Hello, playground"

let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))


let button = UIButton(type: .Custom)
button.frame = CGRect(x: 0, y: 0, width: 88, height: 88)
button.backgroundColor = UIColor.whiteColor()

button.setImage(UIImage(named: "aligement0"), forState: .Normal)
button.setImage(UIImage(named: "aligement1"), forState: .Selected)
button.setImage(UIImage(named: "aligement2"), forState: .Highlighted)
//button.highlighted = true
button.selected = true

view.layer.addSublayer(button.layer)
//button.tintColor = UIColor.

XCPlaygroundPage.currentPage.liveView = view
