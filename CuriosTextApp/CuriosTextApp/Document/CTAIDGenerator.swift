//
//  CTAIDGenerator.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/15/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation

class CTAIDGenerator {
    
    class func generateID() -> String {
        return UUID().uuidString.characters.split(separator: "-").map{String($0)}.reduce("") {$0 + $1}
    }
    
    class func fileID() -> String{
        let id = UUID().uuidString.characters.split(separator: "-").map{String($0)}.reduce("") {$0 + $1}
        return id.substring(to: id.characters.index(id.startIndex, offsetBy: 5))
    }
}
