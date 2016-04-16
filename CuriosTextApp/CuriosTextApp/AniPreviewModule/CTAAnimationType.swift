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
        case .IrisIn:
            return CTAAnimationType.IrisIn
        case .IrisOut:
            return CTAAnimationType.IrisOut
        case .None:
            return CTAAnimationType.Unknown
        }
    }
}

enum CTAAnimationType: String {
    case Unknown = "NONE"
    case MoveIn = "MOVE_IN", MoveOut = "MOVE_OUT"
    case ScaleIn = "SCALE_IN", ScaleOut = "SCALE_OUT"
    case IrisIn = "IRIS_IN", IrisOut = "IRIS_OUT"
    
    enum AnimationMaskShapeType {
        case Rect
        case Oval
    }
    
    enum AnimationMaskType {
        case None
        case Normal(AnimationMaskShapeType)
        case Gradient(AnimationMaskShapeType)
    }
    
    func displayAtEnd() -> Bool {
        switch self {
        case .Unknown, .MoveIn, .ScaleIn, .IrisIn:
            return true
        case .MoveOut, .ScaleOut, .IrisOut:
            return false
        }
    }
    
    func displayAtBegan() -> Bool {
        switch self  {
        case .MoveIn, .ScaleIn, .IrisIn:
            return false
        case.Unknown, .MoveOut, .ScaleOut, IrisOut:
            return true
        }
    }
    
    func needMask() -> AnimationMaskType {
        switch self {
        case .Unknown, .MoveIn, .MoveOut:
            return .None
        case .ScaleIn, .ScaleOut:
            return .Gradient(.Rect)
        case .IrisIn, .IrisOut:
            return .Normal(.Oval)
        }
    }
    
    func AnimationKeys() -> [String] {
        switch self {
        case .Unknown:
            return []
        case .MoveIn, .MoveOut:
            return ["position", "opacity", "transform"]
        case .ScaleIn, .ScaleOut:
            return ["opacity", "transform", "mask.colors"]
        case .IrisIn:
            return ["mask.transform", "mask.fillColor"]
        case .IrisOut:
            return ["mask.lineWidth"]
        }
    }
}