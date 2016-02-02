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
        return NSUUID().UUIDString.characters.split("-").map{String($0)}.reduce("") {$0 + $1}
    }
}