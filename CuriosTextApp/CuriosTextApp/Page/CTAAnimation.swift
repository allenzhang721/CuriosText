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
    
    fileprivate struct SerialKeys {
        static let config = "config"
        static let name = "name"
        static let targetID = "targetiD"
        static let iD = "iD"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(iD, forKey: SerialKeys.iD)
        aCoder.encode(targetiD, forKey: SerialKeys.targetID)
        aCoder.encode(aniName, forKey: SerialKeys.name)
        aCoder.encode(config, forKey: SerialKeys.config)
    }
    
     required init?(coder aDecoder: NSCoder) {
        self.iD = aDecoder.decodeObject(forKey: SerialKeys.iD) as! String
        self.targetiD = aDecoder.decodeObject(forKey: SerialKeys.targetID) as! String
        if let nameRawValue = aDecoder.decodeObject(forKey: SerialKeys.name) as? String {
           self.aniName = nameRawValue
        } else {
            let nameRawValue = aDecoder.decodeInteger(forKey: SerialKeys.name)
            
            self.aniName = CTAAnimationName.nameByInt(nameRawValue)
        }
        
        self.config = aDecoder.decodeObject(forKey: SerialKeys.config) as! CTAAnimationConfig
        
    }
}
