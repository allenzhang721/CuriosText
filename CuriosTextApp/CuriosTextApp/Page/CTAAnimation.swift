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
    var aniName: String
    var config: CTAAnimationConfig = CTAAnimationConfig.defaultConfig
    var name: CTAAnimationName {
        get {
            return CTAAnimationName(rawValue: aniName) ?? .MoveIn
        }
        
        set {
            aniName = newValue.rawValue
        }
    }
    
    init(targetID: String, animationName name: String, animationConfig config: CTAAnimationConfig = CTAAnimationConfig.defaultConfig) {
        
        self.targetiD = targetID
        self.aniName = name
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
        aCoder.encodeObject(aniName, forKey: SerialKeys.name)
        aCoder.encodeObject(config, forKey: SerialKeys.config)
    }
    
     required init?(coder aDecoder: NSCoder) {
        self.iD = aDecoder.decodeObjectForKey(SerialKeys.iD) as! String
        self.targetiD = aDecoder.decodeObjectForKey(SerialKeys.targetID) as! String
        if let nameRawValue = aDecoder.decodeObjectForKey(SerialKeys.name) as? String {
           self.aniName = nameRawValue
        } else {
            let nameRawValue = aDecoder.decodeIntegerForKey(SerialKeys.name)
            
            self.aniName = CTAAnimationName.nameByInt(nameRawValue)
        }
        
        self.config = aDecoder.decodeObjectForKey(SerialKeys.config) as! CTAAnimationConfig
        
    }
}
