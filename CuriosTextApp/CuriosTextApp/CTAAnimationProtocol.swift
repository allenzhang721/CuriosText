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

protocol CTAAnimationBinder {
    
    var iD: String { get }
    var targetiD: String { get }
    var name: CTAAnimationName { get }
    var config: CTAAnimationConfig { get }
}

enum CTAAnimationName {
    
    case MoveIn, FlyIn
    case MoveOut, FlyOut
    
    func shouldVisalbeBeforeBegan() -> Bool {
        switch self {
        case .MoveIn, .FlyIn:
            return false
        case .MoveOut, .FlyOut:
            return true
        }
    }
}

extension CTAAnimationBinder {
    
    func configAnimationFor(view: UIView, index: Int) {
        
        switch name {
        case .MoveIn:
            moveIn(view, index: index)
        case .FlyIn:
            flyIn(view, index: index)
        case .MoveOut:
            moveOut(view, index: index)
        case .FlyOut:
            flyOut(view, index: index)
        }
        
    }
}

extension CTAAnimationBinder {
    
    func moveIn(view: UIView, index: Int) {
        
        let translationX = POPLayerGetTranslationX(view.layer)
        POPLayerSetTranslationX(view.layer, -300 - translationX)
        
        let ani = POPBasicAnimation(propertyNamed: kPOPLayerTranslationX)
        ani.beginTime = CACurrentMediaTime() + CFTimeInterval(config.delay)
        ani.duration = CFTimeInterval(config.duration)
//        ani.fromValue = NSNumber(float: -300)
        ani.toValue = NSNumber(float: 0)
        view.layer.pop_addAnimation(ani, forKey: "MOVE_IN")
    }
    
    func flyIn(view: UIView, index: Int) {
        
    }
    
    func moveOut(view: UIView, index: Int) {
        
        let ani = POPBasicAnimation(propertyNamed: kPOPLayerTranslationX)
        ani.beginTime = CACurrentMediaTime() + CFTimeInterval(config.delay)
        ani.duration = CFTimeInterval(config.duration)
        ani.fromValue = NSNumber(float: 0)
        ani.toValue = NSNumber(float: 300)
        view.layer.pop_addAnimation(ani, forKey: "MOVE_Out")
    }
    
    func flyOut(view: UIView, index: Int) {
        
    }
}



