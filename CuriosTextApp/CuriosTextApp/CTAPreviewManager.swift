//
//  CTAPreviewManager.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/19/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

final class CTAPreviewManager {
    
    let plays: [CTAPreviewPlay]
    
    init(animations: [CTAAnimationBinder]) {
       
        guard animations.count > 0 else {
            self.plays = [CTAPreviewPlay]()
            return
        }
        var plays = [CTAPreviewPlay]()
        let makersGroup = CTAPreviewManager.splits(animations)
        for makers in makersGroup {
            let play = CTAPreviewPlay(animations: makers)
            plays += [play]
        }
        
        self.plays = plays
    }
}

extension CTAPreviewManager {
    
    class func splits(_ array: [CTAAnimationBinder]) -> [[CTAAnimationBinder]] {
        
        let count = array.count
        guard count > 1 else {
            return [array]
        }
        
        var result = [[CTAAnimationBinder]]()
        var began = 0
        
        for (i, m) in array.enumerated() {
            
            let b = m.config.withFormer
            guard i > 0 else {
                continue
            }
            
            if i < count - 1 {
                
                guard b == false else {continue}
                
                let s = array[began..<i]
                began = i
                result += [Array(s)]
            } else {
                
                let s = ((b == false) ? [Array(array[began..<i]),[m]] : [Array(array[began...i])])
                result += s
            }
        }
        
        return result
    }
}
