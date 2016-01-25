import Foundation


//extension CollectionType {

//    func splits(ignoreFirst: Bool, @noescape isSeparator: (Self.Generator.Element) throws -> Bool) rethrows -> [Self.SubSequence] {
    
//        let count = self.count
//        
//        if count == 1 {
//            return self.
//        }
        
//        guard count > 1 else {
//            return self[0]
//        }
//    }
    
//    func splits(containSeperator: Bool) -> [[Bool]] {
//        
//        let count = array.count
//        guard count > 1 else {
//            return [array]
//        }
//        
//        var result = [[Bool]]()
//        var began = 0
//        
//        for (i, b) in array.enumerate() {
//            
//            guard i > 0 else {
//                continue
//            }
//            
//            if i < count - 1 {
//                
//                guard b == false else {continue}
//                
//                let s = array[began..<i]
//                began = i
//                result += [Array(s)]
//            } else {
//                
//                let s = ((b == false) ? [Array(array[began..<i]),[b]] : [Array(array[began...i])])
//                result += s
//            }
//        }
//        
//        return result
//    }
//}