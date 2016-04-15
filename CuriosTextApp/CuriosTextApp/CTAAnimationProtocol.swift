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

enum CTAAnimationName: Int, CustomStringConvertible {
    
    case None
    case MoveIn //FlyIn
    case MoveOut //FlyOut
    case ScaleIn
    case ScaleOut
    
    func shouldVisalbeBeforeBegan() -> Bool {
        switch self {
        case .MoveIn, .ScaleIn:
            return false
        case .MoveOut, .ScaleOut:
            return true
        case .None:
            return true
        }
    }
    
    func shouldVisableAfterEnd() -> Bool {
        switch self {
        case .MoveIn, .ScaleIn:
            return true
        case .MoveOut, .ScaleOut:
            return false
        case .None:
            return true
        }
    }
    
    static var names: [CTAAnimationName] {
        return [.None, .MoveIn, .ScaleIn, .MoveOut, .ScaleOut]
    }
    
    var description: String {
        switch self {
        case .None:
            return LocalStrings.None.description
        case .MoveIn:
            return LocalStrings.MoveIn.description
//        case .FlyIn:
//            return "Fly In"
        case .MoveOut:
            return LocalStrings.MoveOut.description
//        case .FlyOut:
//            return "Fly Out"
        case .ScaleIn:
            return LocalStrings.ScaleIn.description
            
        case .ScaleOut:
            return LocalStrings.ScaleOut.description
        }
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

//protocol CTAAnimationRetriveable: CTAAnimationBinder {
//    
//    var animationName: CTAAnimationName { get }
//    var duration: Float { get }
//    var delay: Float { get }
//}

//extension CTAAnimationBinder {
//    
//    func configAnimationFor(view: UIView, index: Int) {
//        
//        switch name {
//        case .MoveIn:
//            moveIn(view, index: index)
////        case .FlyIn:
////            flyIn(view, index: index)
//        case .MoveOut:
//            moveOut(view, index: index)
////        case .FlyOut:
////            flyOut(view, index: index)
//        case .None:
//            ()
//        }
//    }
//}

//extension CTAAnimationBinder {
//    
//    func moveIn(view: UIView, index: Int, pageSize: CGSize = CGSize(width: 414, height: 414)) {
//        
//        let translationX = POPLayerGetTranslationX(view.layer)
//        POPLayerSetTranslationX(view.layer, -pageSize.width - translationX)
//        
//        let ani = POPBasicAnimation(propertyNamed: kPOPLayerTranslationX)
//        ani.beginTime = CACurrentMediaTime() + CFTimeInterval(config.delay)
//        ani.duration = CFTimeInterval(config.duration)
////        ani.fromValue = NSNumber(float: -300)
//        ani.toValue = NSNumber(float: 0)
//        view.layer.pop_addAnimation(ani, forKey: "MOVE_IN")
//    }
//    
//    func flyIn(view: UIView, index: Int) {
//        
//    }
//    
//    func moveOut(view: UIView, index: Int, pageSize: CGSize = CGSize(width: 414, height: 414)) {
//        
//        let ani = POPBasicAnimation(propertyNamed: kPOPLayerTranslationX)
//        ani.beginTime = CACurrentMediaTime() + CFTimeInterval(config.delay)
//        ani.duration = CFTimeInterval(config.duration)
//        ani.fromValue = NSNumber(float: 0)
//        ani.toValue = NSNumber(float: Float(pageSize.width) + Float(view.bounds.width))
//        view.layer.pop_addAnimation(ani, forKey: "MOVE_OUT")
//    }
//    
//    func flyOut(view: UIView, index: Int) {
//        
//    }
//}



