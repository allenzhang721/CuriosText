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
    
    class func defaultConfigWithDuration(_ duration: Float) -> CTAAnimationConfig {
        return CTAAnimationConfig(duration: duration, delay: 0.0, repeatCount: 0, reverse: false, withFormer: false, loadStrategy: CTAContentLoadStrategy.defautlStrategy, generateStrategy: CTAContentGenerateStrategy.defaultStrategy)
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
    
    fileprivate struct SerialKeys {
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
        
        self.duration = aDecoder.decodeFloat(forKey: SerialKeys.duration)
        self.delay = aDecoder.decodeFloat(forKey: SerialKeys.delay)
        self.repeatCount = aDecoder.decodeInteger(forKey: SerialKeys.repeatCount)
        self.reverse = aDecoder.decodeBool(forKey: SerialKeys.reverse)
        self.withFormer = aDecoder.decodeBool(forKey: SerialKeys.withFormer)
        let loadAnimationBegan = aDecoder.decodeBool(forKey: SerialKeys.loadStrategy_loadAtAnimationBegan)
        let removeAniamtionEnd = aDecoder.decodeBool(forKey: SerialKeys.loadStrategy_removeAtAnimationEnd)
        self.loadStrategy = CTAContentLoadStrategy(loadAtAnimationBegan: loadAnimationBegan, removeAtAnimationEnd: removeAniamtionEnd)
        let textDelivery = aDecoder.decodeInteger(forKey: SerialKeys.generateStrategy_textDelivery)
        let paragraphdelivery = aDecoder.decodeInteger(forKey: SerialKeys.generateStrategy_paragraphDelivery)
        self.generateStrategy = CTAContentGenerateStrategy(textDelivery: CTATextDelivery(rawValue: textDelivery)!, paragraphDelivery: CTAParagraphDelivery(rawValue: paragraphdelivery)!)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(duration, forKey: SerialKeys.duration)
        aCoder.encode(delay, forKey: SerialKeys.delay)
        aCoder.encode(repeatCount, forKey: SerialKeys.repeatCount)
        aCoder.encode(reverse, forKey: SerialKeys.reverse)
        aCoder.encode(withFormer, forKey: SerialKeys.withFormer)
        aCoder.encode(loadStrategy.loadAtAnimationBegan, forKey: SerialKeys.loadStrategy_loadAtAnimationBegan)
        aCoder.encode(loadStrategy.removeAtAnimationEnd, forKey: SerialKeys.loadStrategy_removeAtAnimationEnd)
        aCoder.encode(generateStrategy.textDelivery.rawValue, forKey: SerialKeys.generateStrategy_textDelivery)
        aCoder.encode(generateStrategy.paragraphDelivery.rawValue, forKey: SerialKeys.generateStrategy_paragraphDelivery)
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
        return CTAContentGenerateStrategy(textDelivery: .object, paragraphDelivery: .allAtOnce)
    }
}

enum CTATextDelivery: Int {
    
    case object, character, word
}

enum CTAParagraphDelivery: Int {
    
    case allAtOnce, paragraph
}



