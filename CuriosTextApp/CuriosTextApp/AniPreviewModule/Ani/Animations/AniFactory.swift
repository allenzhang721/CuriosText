//
//  AniFactory.swift
//  PopApp
//
//  Created by Emiaostein on 4/7/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import Foundation
import UIKit

class AniFactory {
    
//    enum AnimationType: String {
//        case MoveIn = "MOVE_IN"
//        case ScaleIn = "SCALE_IN"
//        case MoveOut = "MOVE_OUT"
//        case ScaleOut = "SCALE_OUT"
//        
//        func displayAtEnd() -> Bool {
//            switch self {
//            case .MoveIn, .ScaleIn:
//                return true
//            case .MoveOut, .ScaleOut:
//                return false
//            }
//        }
//        
//        func displayAtBegan() -> Bool {
//            switch self  {
//            case .MoveIn, .ScaleIn:
//                return false
//            case .MoveOut, .ScaleOut:
//                return true
//            }
//        }
//        
//        func needMask() -> Bool {
//            switch self {
//            case .MoveIn, .MoveOut:
//                return false
//            case .ScaleIn, .ScaleOut:
//                return true
//            }
//        }
//        
//        func AnimationKeys() -> [String] {
//            switch self {
//            case .MoveIn, .MoveOut:
//                return ["position", "opacity", "transform"]
//            case .ScaleIn, .ScaleOut:
//                return ["opacity", "transform", "maskGradient.colors"]
//            }
//        }
//    }
    
    class func animationWith(name: String, canvasSize: CGSize, container: Container, content: Content, contentsCount: Int, index: Int, descriptor: Descriptor, addBeganTime: Float) -> AniDescriptor? {
        
        guard let type = CTAAnimationType(rawValue: name) else {
            print("Not Support \(name) Animation Type!")
            return nil
        }
        
        switch type {
        case .MoveIn:
            return moveIn(canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, descriptor: descriptor, beganTime: addBeganTime)
        case .MoveOut:
            return moveOut(canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, descriptor: descriptor, beganTime: addBeganTime)
            
        case .ScaleIn:
            return scaleIn(canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, descriptor: descriptor, beganTime: addBeganTime)
            
        case .ScaleOut:
            return scaleOut(canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, descriptor: descriptor, beganTime: addBeganTime)
        default:
            return nil
//            fatalError("Not Support Animation \(name)")
        }
        
    }
    
}