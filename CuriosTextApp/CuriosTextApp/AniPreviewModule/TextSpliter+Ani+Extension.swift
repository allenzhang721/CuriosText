//
//  AniTextSpliter.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 4/15/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

extension TextSpliter {
    
    /*
     
     enum TextLineSpliteType {
     case AllatOnce
     case ByLine
     }
     
     enum TextSpliteType {
     case ByObject
     case ByCharacter
     }
     */
    
    class func defaultSpliteBy(_ type: CTAAnimationType) -> (TextSpliter.TextLineSpliteType, TextSpliter.TextSpliteType) {
        
        switch type {
        case .MoveIn, .MoveOut,.MoveInLeft, .MoveOutLeft, .CurlIn, .CurlOut, .FadeIn, .FadeOut, .FadeInOrder, .FadeOutOrder, .OrbitalIn, .OrbitalOut:
            return (TextLineSpliteType.byLine, TextSpliteType.byCharacter)
            
        default:
            return (TextLineSpliteType.allatOnce, TextSpliteType.byObject)
        }
    }
    
}
