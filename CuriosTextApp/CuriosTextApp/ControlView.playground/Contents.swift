//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

var str = "Hello, playground"

var colors: [UIColor] = {
    var c = [UIColor]()
    for _ in 0..<9 {
        c.append(UIColor(red: CGFloat(random() % 255) / 255.0, green: CGFloat(random() % 255) / 255.0, blue: CGFloat(random() % 255) / 255.0, alpha: 1))
    }
    return c
}()
let l = CTAColorPickerNodeView(frame: CGRect(x: 0, y: 0, width: 414, height: 88), colors: colors)

XCPlaygroundPage.currentPage.liveView = l