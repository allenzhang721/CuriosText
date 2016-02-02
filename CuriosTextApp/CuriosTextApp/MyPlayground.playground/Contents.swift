//: Playground - noun: a place where people can play

import Cocoa

//var str = "Hello, playground"
let uuid = NSUUID().UUIDString.characters.split("-").map {String($0)}.reduce("") {$0 + $1}

uuid