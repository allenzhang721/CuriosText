//
//  CTAAnimation.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/20/16.
//  Copyright © 2016 botai. All rights reserved.
//

import UIKit

class CTAAnimation: NSObject, CTAAnimationBinder {

    var iD: String = ""
    var targetiD: String = ""
    var name: CTAAnimationName = .MoveIn
    var config: CTAAnimationConfig = CTAAnimationConfig.defaultConfig
    
    init(targetID: String, animationName name: CTAAnimationName, animationConfig config: CTAAnimationConfig = CTAAnimationConfig.defaultConfig) {
        
        self.targetiD = targetID
        self.name = name
        self.config = config
        super.init()
    }
}
