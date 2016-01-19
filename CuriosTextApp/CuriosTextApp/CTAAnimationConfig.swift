//
//  CTAAnimationConfig.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/18/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

struct CTAAnimationConfig {
    
    let duration: Float
    let delay: Float
    let repeatCount: Int
    let reverse: Bool
    let withFormer: Bool
    let loadStrategy: CTAContentLoadStrategy
    let generateStrategy: CTAContentGenerateStrategy
}

struct CTAContentLoadStrategy {
    
    let loadAtAnimationBegan: Bool
    let removeAtAnimationEnd: Bool
}

struct CTAContentGenerateStrategy {
    
    let textDelivery: CTATextDelivery
    let paragraphDelivery: CTAParagraphDelivery
    static var defaultStrategy: CTAContentGenerateStrategy {
        return CTAContentGenerateStrategy(textDelivery: .Object, paragraphDelivery: .AllAtOnce)
    }
}

enum CTATextDelivery {
    
    case Object, Character, Word
}

enum CTAParagraphDelivery {
    
    case AllAtOnce, Paragraph
}



