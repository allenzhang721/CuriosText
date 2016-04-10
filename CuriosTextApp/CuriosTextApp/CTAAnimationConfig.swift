//
//  CTAAnimationConfig.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 1/18/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

class CTAAnimationConfig:NSObject, NSCoding {

    var duration: Float
    var delay: Float
    var repeatCount: Int
    var reverse: Bool
    var withFormer: Bool
    var loadStrategy: CTAContentLoadStrategy
    var generateStrategy: CTAContentGenerateStrategy
    
    static var defaultConfig: CTAAnimationConfig {
        return CTAAnimationConfig(duration: 1.0, delay: 0.0, repeatCount: 0, reverse: false, withFormer: false, loadStrategy: CTAContentLoadStrategy.defautlStrategy, generateStrategy: CTAContentGenerateStrategy.defaultStrategy)
    }
    
    init(duration: Float, delay: Float, repeatCount: Int, reverse: Bool, withFormer: Bool, loadStrategy: CTAContentLoadStrategy, generateStrategy: CTAContentGenerateStrategy) {
        self.duration = duration
        self.delay = delay
        self.repeatCount = repeatCount
        self.reverse = reverse
        self.withFormer = withFormer
        self.loadStrategy = loadStrategy
        self.generateStrategy = generateStrategy
    }
    
    private struct SerialKeys {
        static let duration = "duration"
        static let delay = "delay"
        static let repeatCount = "repeatCount"
        static let reverse = "reverse"
        static let withFormer = "withFormer"
        static let loadStrategy_loadAtAnimationBegan = "loadStrategy_loadAtAnimationBegan"
        static let loadStrategy_removeAtAnimationEnd = "loadStrategy_removeAtAnimationEnd"
        static let generateStrategy_textDelivery = "generateStrategy_textDelivery"
        static let generateStrategy_paragraphDelivery = "generateStrategy_paragraphDelivery"
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.duration = aDecoder.decodeFloatForKey(SerialKeys.duration)
        self.delay = aDecoder.decodeFloatForKey(SerialKeys.delay)
        self.repeatCount = aDecoder.decodeIntegerForKey(SerialKeys.repeatCount)
        self.reverse = aDecoder.decodeBoolForKey(SerialKeys.reverse)
        self.withFormer = aDecoder.decodeBoolForKey(SerialKeys.withFormer)
        let loadAnimationBegan = aDecoder.decodeBoolForKey(SerialKeys.loadStrategy_loadAtAnimationBegan)
        let removeAniamtionEnd = aDecoder.decodeBoolForKey(SerialKeys.loadStrategy_removeAtAnimationEnd)
        self.loadStrategy = CTAContentLoadStrategy(loadAtAnimationBegan: loadAnimationBegan, removeAtAnimationEnd: removeAniamtionEnd)
        let textDelivery = aDecoder.decodeIntegerForKey(SerialKeys.generateStrategy_textDelivery)
        let paragraphdelivery = aDecoder.decodeIntegerForKey(SerialKeys.generateStrategy_paragraphDelivery)
        self.generateStrategy = CTAContentGenerateStrategy(textDelivery: CTATextDelivery(rawValue: textDelivery)!, paragraphDelivery: CTAParagraphDelivery(rawValue: paragraphdelivery)!)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeFloat(duration, forKey: SerialKeys.duration)
        aCoder.encodeFloat(delay, forKey: SerialKeys.delay)
        aCoder.encodeInteger(repeatCount, forKey: SerialKeys.repeatCount)
        aCoder.encodeBool(reverse, forKey: SerialKeys.reverse)
        aCoder.encodeBool(withFormer, forKey: SerialKeys.withFormer)
        aCoder.encodeBool(loadStrategy.loadAtAnimationBegan, forKey: SerialKeys.loadStrategy_loadAtAnimationBegan)
        aCoder.encodeBool(loadStrategy.removeAtAnimationEnd, forKey: SerialKeys.loadStrategy_removeAtAnimationEnd)
        aCoder.encodeInteger(generateStrategy.textDelivery.rawValue, forKey: SerialKeys.generateStrategy_textDelivery)
        aCoder.encodeInteger(generateStrategy.paragraphDelivery.rawValue, forKey: SerialKeys.generateStrategy_paragraphDelivery)
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

enum CTATextDelivery: Int {
    
    case Object, Character, Word
}

enum CTAParagraphDelivery: Int {
    
    case AllAtOnce, Paragraph
}



