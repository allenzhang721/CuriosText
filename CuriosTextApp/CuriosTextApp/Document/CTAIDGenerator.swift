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
    
        let uuid = NSUUID().UUIDString
        return uuid.substringWithRange(Range(start: uuid.endIndex.advancedBy(-12), end: uuid.endIndex))
    }
}