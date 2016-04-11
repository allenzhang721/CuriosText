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
    
    enum AnimationType: String {
        case MoveIn = "MOVE_IN"
        case MoveOut = "MOVE_OUT"
        
        func displayAtEnd() -> Bool {
            switch self {
            case .MoveIn:
                return true
            case .MoveOut:
                return false
            }
        }
        
        func displayAtBegan() -> Bool {
            switch self  {
            case .MoveIn:
                return false
            case .MoveOut:
                return true
            }
        }
    }
    
    class func animationWith(name: String, canvasSize: CGSize, container: Container, content: Content, contentsCount: Int, index: Int, descriptor: Descriptor, addBeganTime: Float) -> AniDescriptor {
        
        switch name {
        case "MOVE_IN":
            return moveIn(canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, descriptor: descriptor, beganTime: addBeganTime)
        case "MOVE_OUT":
            return moveOut(canvasSize, container: container, content: content, contentsCount: contentsCount, index: index, descriptor: descriptor, beganTime: addBeganTime)
        default:
            fatalError("Not Support Animation \(name)")
        }
        
    }
    
}