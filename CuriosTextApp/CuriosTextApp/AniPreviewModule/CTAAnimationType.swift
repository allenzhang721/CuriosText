//
//  CTAAnimationType.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 4/15/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

protocol CTAAnimationTypeable {
    
    var type: CTAAnimationType { get }
}

extension CTAAnimationName {
    
    func toType() -> CTAAnimationType {
        switch self {
        case .MoveIn:
            return CTAAnimationType.MoveIn
        case .MoveOut:
            return CTAAnimationType.MoveOut
        case .ScaleIn:
            return CTAAnimationType.ScaleIn
        case .ScaleOut:
            return CTAAnimationType.ScaleOut
        case .None:
            return CTAAnimationType.Unknown
        }
    }
}

enum CTAAnimationType: String {
    case Unknown
    case MoveIn = "MOVE_IN", MoveOut = "MOVE_OUT"
    case ScaleIn = "SCALE_IN", ScaleOut = "SCALE_OUT"
    
    func displayAtEnd() -> Bool {
        switch self {
        case .Unknown, .MoveIn, .ScaleIn:
            return true
        case .MoveOut, .ScaleOut:
            return false
        }
    }
    
    func displayAtBegan() -> Bool {
        switch self  {
        case .MoveIn, .ScaleIn:
            return false
        case.Unknown, .MoveOut, .ScaleOut:
            return true
        }
    }
    
    func needMask() -> Bool {
        switch self {
        case.Unknown, .MoveIn, .MoveOut:
            return false
        case .ScaleIn, .ScaleOut:
            return true
        }
    }
    
    func AnimationKeys() -> [String] {
        switch self {
        case .Unknown:
            return []
        case .MoveIn, .MoveOut:
            return ["position", "opacity", "transform"]
        case .ScaleIn, .ScaleOut:
            return ["opacity", "transform", "maskGradient.colors"]
        }
    }
}