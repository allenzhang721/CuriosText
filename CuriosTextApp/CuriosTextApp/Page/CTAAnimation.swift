//
//  CTAAnimation.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/20/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAAnimation: NSObject, NSCoding, CTAAnimationBinder {

    var iD: String = CTAIDGenerator.fileID()
    var targetiD: String = ""
    var name: CTAAnimationName = .MoveIn
    var config: CTAAnimationConfig = CTAAnimationConfig.defaultConfig
    
    init(targetID: String, animationName name: CTAAnimationName, animationConfig config: CTAAnimationConfig = CTAAnimationConfig.defaultConfig) {
        
        self.targetiD = targetID
        self.name = name
        self.config = config
        super.init()
    }
    
    private struct SerialKeys {
        static let config = "config"
        static let name = "name"
        static let targetID = "targetiD"
        static let iD = "iD"
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(iD, forKey: SerialKeys.iD)
        aCoder.encodeObject(targetiD, forKey: SerialKeys.targetID)
        aCoder.encodeInteger(name.rawValue, forKey: SerialKeys.name)
        aCoder.encodeObject(config, forKey: SerialKeys.config)
    }
    
     required init?(coder aDecoder: NSCoder) {
        self.iD = aDecoder.decodeObjectForKey(SerialKeys.iD) as! String
        self.targetiD = aDecoder.decodeObjectForKey(SerialKeys.targetID) as! String
        let nameRawValue = aDecoder.decodeIntegerForKey(SerialKeys.name)
        self.name = CTAAnimationName(rawValue: nameRawValue)!
        self.config = aDecoder.decodeObjectForKey(SerialKeys.config) as! CTAAnimationConfig
        
    }
}
