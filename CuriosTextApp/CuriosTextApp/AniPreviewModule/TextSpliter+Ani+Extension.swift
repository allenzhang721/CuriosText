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
    
    class func defaultSpliteBy(type: CTAAnimationType) -> (TextSpliter.TextLineSpliteType, TextSpliter.TextSpliteType) {
        
        switch type {
        case .MoveIn, .MoveOut, .CurlIn, .CurlOut, .FadeIn, .FadeOut:
            return (TextLineSpliteType.ByLine, TextSpliteType.ByCharacter)
            
        default:
            return (TextLineSpliteType.AllatOnce, TextSpliteType.ByObject)
        }
    }
    
}