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

enum CTAAnimationName: String {
    
    case None = "NONE"
    case MoveIn = "MOVE_IN" //FlyIn
    case MoveOut = "MOVE_OUT"//FlyOut
    case ScaleIn = "SCALE_IN"
    case ScaleOut = "SCALE_OUT"
    case IrisIn = "IRIS_IN"
    case IrisOut = "IRIS_OUT"
    case CurlIn = "CURL_IN"
    case CurlOut = "CURL_OUT"
    case FadeIn = "FADE_IN"
    case FadeOut = "FADE_OUT"
    case OrbitalIn = "ORBITAL_IN"
    case OrbitalOut = "ORBITAL_OUT"
    // new add
    case MoveInLeft = "MOVE_IN_LEFT" //FlyIn
    case MoveOutLeft = "MOVE_OUT_LEFT"//FlyOut
    case FadeInOrder = "FADE_IN_ORDER"
    case FadeOutOrder = "FADE_OUT_ORDER"
    
    static func nameByInt(i: Int) -> String {
        switch i {
        case 1:
            return CTAAnimationName.MoveIn.rawValue
        case 2:
            return CTAAnimationName.MoveOut.rawValue
        case 3:
            return CTAAnimationName.ScaleIn.rawValue
        case 4:
            return CTAAnimationName.ScaleOut.rawValue
        case 5:
            return CTAAnimationName.IrisIn.rawValue
        case 6:
            return CTAAnimationName.IrisOut.rawValue
        case 7:
            return CTAAnimationName.CurlIn.rawValue
        case 8:
            return CTAAnimationName.CurlOut.rawValue
        case 9:
            return CTAAnimationName.FadeIn.rawValue
        case 10:
            return CTAAnimationName.FadeOut.rawValue
        case 11:
            return CTAAnimationName.OrbitalIn.rawValue
        case 12:
            return CTAAnimationName.OrbitalOut.rawValue
        case 13:
            return CTAAnimationName.MoveInLeft.rawValue
        case 14:
            return CTAAnimationName.MoveOutLeft.rawValue
        case 15:
            return CTAAnimationName.FadeInOrder.rawValue
        case 16:
            return CTAAnimationName.FadeOutOrder.rawValue
        default:
            return i % 2 == 0 ? CTAAnimationName.MoveOut.rawValue : CTAAnimationName.MoveIn.rawValue
        }
    }
    
    func shouldVisalbeBeforeBegan() -> Bool {
        switch self {
        case .MoveIn, .MoveInLeft, .ScaleIn, IrisIn, .CurlIn, .FadeIn, .FadeInOrder, .OrbitalIn:
            return false
        case .MoveOut, .MoveOutLeft,.ScaleOut, IrisOut, .CurlOut, .FadeOut, .FadeOutOrder, .OrbitalOut:
            return true
        case .None:
            return true
        }
    }
    
    func shouldVisableAfterEnd() -> Bool {
        switch self {
        case .MoveIn, .MoveInLeft,.ScaleIn, IrisIn, .CurlIn, .FadeIn, .FadeInOrder, .OrbitalIn:
            return true
        case .MoveOut, .MoveOutLeft, .ScaleOut, IrisOut, .CurlOut, .FadeOut, .FadeOutOrder, .OrbitalOut:
            return false
        case .None:
            return true
        }
    }
    
    static var names: [CTAAnimationName] {
        return [.None,
                .MoveIn, .MoveInLeft,.FadeIn, .FadeInOrder, .ScaleIn, .IrisIn, .OrbitalIn, .CurlIn,
                .MoveOut, MoveOutLeft,.FadeOut, .FadeOutOrder, .ScaleOut, .IrisOut, .OrbitalOut, .CurlOut,]
    }
    
    var defaultDuration: Float {
        switch self {
        case .None:
            return 0.0
        case .MoveIn, .MoveInLeft, .MoveOut, .MoveOutLeft:
            return 1.6
        case .ScaleIn, .ScaleOut:
            return 1.6
        case .IrisIn, .IrisOut:
            return 1.6
        case .CurlIn, .CurlOut:
            return 1.6
        case .FadeIn, .FadeOut, .FadeInOrder, .FadeOutOrder:
            return 1.6
        case .OrbitalIn, .OrbitalOut:
            return 1.6
        
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



