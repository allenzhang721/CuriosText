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
    
    class func animationWith(name: String, canvasSize: CGSize, container: Container, content: Content, contentsCount: Int, index: Int, inSection section: Int, rowAtSection row: Int, sectionCount: Int, rowCountAtSection: Int, descriptor: Descriptor, addBeganTime: Float, randomIndexs: [Int]? = nil) -> AniDescriptor? {
        
        guard let type = CTAAnimationType(rawValue: name) else {
            print("Not Support \(name) Animation Type!")
            return nil
        }
        
        switch type {
        case .Unknown:
             return nil
        case .MoveIn:
            return moveIn(canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, inSection: section, rowAtSection: row, sectionCount: sectionCount, rowCountAtSection: rowCountAtSection, descriptor: descriptor, beganTime: addBeganTime)
        case .MoveOut:
            return moveOut(canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, inSection: section, rowAtSection: row, sectionCount: sectionCount, rowCountAtSection: rowCountAtSection, descriptor: descriptor, beganTime: addBeganTime)
            
        case .MoveInLeft:
            return moveIn(canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, inSection: section, rowAtSection: row, sectionCount: sectionCount, rowCountAtSection: rowCountAtSection, descriptor: descriptor, beganTime: addBeganTime, direction: 1)
        case .MoveOutLeft:
            return moveOut(canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, inSection: section, rowAtSection: row, sectionCount: sectionCount, rowCountAtSection: rowCountAtSection, descriptor: descriptor, beganTime: addBeganTime, direction: 1)
            
        case .ScaleIn:
            return scaleIn(canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, descriptor: descriptor, beganTime: addBeganTime)
            
        case .ScaleOut:
            return scaleOut(canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, descriptor: descriptor, beganTime: addBeganTime)
            
        case .IrisIn:
            return iris(true, canvasSize: canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, descriptor: descriptor, beganTime: addBeganTime)
            
        case .IrisOut:
            return iris(false, canvasSize: canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, descriptor: descriptor, beganTime: addBeganTime)
            
        case .CurlIn:
            return curl(true, canvasSize: canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, descriptor: descriptor, beganTime: addBeganTime)
        case .CurlOut:
            return curl(false, canvasSize: canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, descriptor: descriptor, beganTime: addBeganTime)
            
        case .FadeIn:
            if let randomIndexs = randomIndexs where index < randomIndexs.count {
                return fade(true, canvasSize: canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, descriptor: descriptor, beganTime: addBeganTime)
            } else {
                return fade(true, canvasSize: canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, descriptor: descriptor, beganTime: addBeganTime)
            }
            
        case .FadeOut:
            if let randomIndexs = randomIndexs where index < randomIndexs.count {
                return fade(false, canvasSize: canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, descriptor: descriptor, beganTime: addBeganTime)
            } else {
                return fade(false, canvasSize: canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, descriptor: descriptor, beganTime: addBeganTime)
            }
            
        case .FadeInOrder:
            if let randomIndexs = randomIndexs where index < randomIndexs.count {
                return fade(true, canvasSize: canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, descriptor: descriptor, beganTime: addBeganTime, isRandom: false)
            } else {
                return fade(true, canvasSize: canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, descriptor: descriptor, beganTime: addBeganTime)
            }
            
        case .FadeOutOrder:
            if let randomIndexs = randomIndexs where index < randomIndexs.count {
                return fade(false, canvasSize: canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, descriptor: descriptor, beganTime: addBeganTime, isRandom: false)
            } else {
                return fade(false, canvasSize: canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, descriptor: descriptor, beganTime: addBeganTime)
            }
            
        case .OrbitalIn:
            return orbital(true, canvasSize: canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, descriptor: descriptor, beganTime: addBeganTime)
            
        case .OrbitalOut:
            return orbital(false, canvasSize: canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, descriptor: descriptor, beganTime: addBeganTime)
//        default:
//            return nil
//            fatalError("Not Support Animation \(name)")
        }
        
    }
    
}