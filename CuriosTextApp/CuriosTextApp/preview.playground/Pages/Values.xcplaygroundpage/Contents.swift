//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"



let size = CGSize(width: 134.345, height: 123.567)

let ceilSize = size.toCeil()
let floorSize = size.toFloor()

let point = CGPoint(x: 124.567, y: 123.567)
let ceilPoint = point.toCeil()
let floorPoint = point.toFloor()

let rect = CGRect(x: 123.345, y: 234.456 , width: 567.789, height: 345.432)
rect.toCeil()
rect.toFloor()

let d = 123.1234567234234
floor(((d % floor(d))) * 10000)

//size.toValue()







