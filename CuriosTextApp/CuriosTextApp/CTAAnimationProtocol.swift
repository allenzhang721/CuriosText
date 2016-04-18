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
    case FadeIn, FadeOut
    case OrbitalIn, OrbitalOut
    
    func shouldVisalbeBeforeBegan() -> Bool {
        switch self {
        case .MoveIn, .ScaleIn, IrisIn, .CurlIn, .FadeIn, .OrbitalIn:
            return false
        case .MoveOut, .ScaleOut, IrisOut, .CurlOut, .FadeOut, .OrbitalOut:
            return true
        case .None:
            return true
        }
    }
    
    func shouldVisableAfterEnd() -> Bool {
        switch self {
        case .MoveIn, .ScaleIn, IrisIn, .CurlIn, .FadeIn, .OrbitalIn:
            return true
        case .MoveOut, .ScaleOut, IrisOut, .CurlOut, .FadeOut, .OrbitalOut:
            return false
        case .None:
            return true
        }
    }
    
    static var names: [CTAAnimationName] {
        return [.None,
                .MoveIn, .OrbitalIn, .CurlIn, .FadeIn, .ScaleIn, .IrisIn,
                .MoveOut, .OrbitalOut, .CurlOut, .FadeOut, .ScaleOut, .IrisOut]
    }
    
    var defaultDuration: Float {
        switch self {
        case .None:
            return 0.0
        case .MoveIn, .MoveOut:
            return 2.0
        case .ScaleIn, .ScaleOut:
            return 2.5
        case .IrisIn, .IrisOut:
            return 2.0
        case .CurlIn, .CurlOut:
            return 2.0
        case .FadeIn, .FadeOut:
            return 1.0
        case .OrbitalIn, .OrbitalOut:
            return 2.0
        
        }
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



