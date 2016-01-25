//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

let bools = [true, false, true, false, false, true, false, true, true, false]

let split = bools.split(true)
let split2 = bools.split(false)

func splits(array: [Bool]) -> [[Bool]] {
    
    let count = array.count
    guard count > 1 else {
        return [array]
    }
    
    var result = [[Bool]]()
    var began = 0
    
    for (i, b) in array.enumerate() {
        
        guard i > 0 else {
            continue
        }
        
        if i < count - 1 {
            
            guard b == false else {continue}
            
            let s = array[began..<i]
            began = i
            result += [Array(s)]
        } else {
            
            let s = ((b == false) ? [Array(array[began..<i]),[b]] : [Array(array[began...i])])
            result += s
        }
    }
    
    return result
}


let split3 = splits(bools)

//: [Next](@next)
