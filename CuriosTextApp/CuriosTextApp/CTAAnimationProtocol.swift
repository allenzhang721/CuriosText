//
//  CTAAnimationProtocol.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/18/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
import UIKit
import pop

enum CTAAnimationName: Int {
    
    case None
    case MoveIn //FlyIn
    case MoveOut //FlyOut
    case ScaleIn
    case ScaleOut
    case IrisIn, IrisOut
    case CurlIn, CurlOut
    
    func shouldVisalbeBeforeBegan() -> Bool {
        switch self {
        case .MoveIn, .ScaleIn, IrisIn, .CurlIn:
            return false
        case .MoveOut, .ScaleOut, IrisOut, .CurlOut:
            return true
        case .None:
            return true
        }
    }
    
    func shouldVisableAfterEnd() -> Bool {
        switch self {
        case .MoveIn, .ScaleIn, IrisIn, .CurlIn:
            return true
        case .MoveOut, .ScaleOut, IrisOut, .CurlOut:
            return false
        case .None:
            return true
        }
    }
    
    static var names: [CTAAnimationName] {
        return [.None, .MoveIn, .CurlIn,.ScaleIn, .IrisIn, .MoveOut, .CurlOut,.ScaleOut, .IrisOut]
    }
    
    var description: String {
        return LocalStrings.AniType(self.toType()).description
    }
}

protocol CTAAnimationBinder {
    
    var iD: String { get }
    var targetiD: String { get }
    var name: CTAAnimationName { get set }
    var config: CTAAnimationConfig { get set }
}

extension CTAAnimationBinder {
    
    mutating func updateAnimationName(a: CTAAnimationName) {
        name = a
    }
    
    var animationName: CTAAnimationName {
        get {
            return name
        }
        
        set {
            name = newValue
        }
    }
    var duration: Float {
        get {
            return config.duration
        }
        
        set {
            config.duration = newValue
        }
    }
    var delay: Float {
        get {
            return config.delay
        }
        
        set {
            config.delay = newValue
        }
    }
}



