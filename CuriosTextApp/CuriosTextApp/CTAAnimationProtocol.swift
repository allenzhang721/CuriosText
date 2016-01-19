//
//  CTAAnimationProtocol.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/18/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

protocol CTAAnimation {
    
    var iD: String { get }
    var targetiD: String { get }
    var name: CTAAnimationName { get }
    var config: CTAAnimationConfig { get }
}

enum CTAAnimationName {
    
    case MoveIn
    case MoveOut
}



