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
    
    static var defaultConfig: CTAAnimationConfig {
        return CTAAnimationConfig(duration: 3.0, delay: 1.0, repeatCount: 0, reverse: false, withFormer: false, loadStrategy: CTAContentLoadStrategy.defautlStrategy, generateStrategy: CTAContentGenerateStrategy.defaultStrategy)
    }
}

struct CTAContentLoadStrategy {
    
    let loadAtAnimationBegan: Bool
    let removeAtAnimationEnd: Bool
    
    static var defautlStrategy: CTAContentLoadStrategy {
        return CTAContentLoadStrategy(loadAtAnimationBegan: false, removeAtAnimationEnd: false)
    }
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



