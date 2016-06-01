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
        case .MoveInLeft:
            return CTAAnimationType.MoveInLeft
        case .MoveOutLeft:
            return CTAAnimationType.MoveOutLeft
        case .ScaleIn:
            return CTAAnimationType.ScaleIn
        case .ScaleOut:
            return CTAAnimationType.ScaleOut
        case .IrisIn:
            return CTAAnimationType.IrisIn
        case .IrisOut:
            return CTAAnimationType.IrisOut
        case .CurlIn:
            return CTAAnimationType.CurlIn
        case .CurlOut:
            return CTAAnimationType.CurlOut
        case .FadeIn:
            return CTAAnimationType.FadeIn
        case .FadeOut:
            return CTAAnimationType.FadeOut
        case .FadeInOrder:
            return CTAAnimationType.FadeInOrder
        case .FadeOutOrder:
            return CTAAnimationType.FadeOutOrder
        case .OrbitalIn:
            return CTAAnimationType.OrbitalIn
        case .OrbitalOut:
            return CTAAnimationType.OrbitalOut
        case .None:
            return CTAAnimationType.Unknown
        }
    }
}

 let mask = "mask."
 let position = "position"
 let opacity = "opacity"
 let transform = "transform"
 let transformRotationZ = "transform.rotation.z"
 let anchorPoint = "anchorPoint"
 let colors = "colors"
 let fillColor = "fillColor"
 let lineWidth = "lineWidth"

enum CTAAnimationType: String {
    case Unknown = "NONE"
    case MoveIn = "MOVE_IN", MoveOut = "MOVE_OUT"
    case MoveInLeft = "MOVE_IN_LEFT", MoveOutLeft = "MOVE_OUT_LEFT"
    case ScaleIn = "SCALE_IN", ScaleOut = "SCALE_OUT"
    case IrisIn = "IRIS_IN", IrisOut = "IRIS_OUT"
    case CurlIn = "CURL_IN", CurlOut = "CURL_OUT"
    case FadeIn = "FADE_IN", FadeOut = "FADE_OUT"
    case FadeInOrder = "FADE_IN_ORDER", FadeOutOrder = "FADE_OUT_ORDER"
    case OrbitalIn = "ORBITAL_IN", OrbitalOut = "ORBITAL_OUT"
    
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
        case .Unknown, .MoveIn, .MoveInLeft, .ScaleIn, .IrisIn, .CurlIn, .FadeIn, .FadeInOrder, .OrbitalIn:
            return true
        case .MoveOut, .ScaleOut, .MoveOutLeft, .IrisOut, .CurlOut, .FadeOut, .FadeOutOrder,.OrbitalOut:
            return false
        }
    }
    
    func displayAtBegan() -> Bool {
        switch self  {
        case .MoveIn, .MoveInLeft, .ScaleIn, .IrisIn, .CurlIn, .FadeIn, .FadeInOrder,.OrbitalIn:
            return false
        case.Unknown, .MoveOut, .MoveOutLeft, .ScaleOut, IrisOut, .CurlOut, .FadeOut, .FadeOutOrder,.OrbitalOut:
            return true
        }
    }
    
    func needMask() -> AnimationMaskType {
        switch self {
        case .Unknown, .MoveIn, .MoveInLeft, .MoveOut, .MoveOutLeft, .CurlIn, .CurlOut, .FadeIn, .FadeOut, .FadeInOrder, .FadeOutOrder, .OrbitalIn, .OrbitalOut:
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
        case .MoveIn, .MoveOut, .MoveInLeft, .MoveOutLeft:
            return [position, opacity, transform]
        case .ScaleIn, .ScaleOut:
            return [opacity, transform, mask+colors]
        case .IrisIn, .IrisOut:
            return [mask+transform, mask+fillColor]
//        case .IrisOut:
//            return [mask+lineWidth]
        case .CurlIn, .CurlOut:
            return [position, opacity, transform]
        case .FadeIn, .FadeInOrder, .FadeOut, .FadeOutOrder:
            return [transform, opacity]
        case .OrbitalIn, .OrbitalOut:
            return [opacity, position, anchorPoint, transformRotationZ]
        }
    }
}