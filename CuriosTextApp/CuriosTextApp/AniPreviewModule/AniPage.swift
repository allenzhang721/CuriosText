//
//  AniPage.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 4/8/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

extension PageVMProtocol {
    
    func toAniCanvas() -> AniCanvas {
        
        let canvas = toCanvas()
        return AniCanvas(canvas: canvas)
    }
    
    func toCanvas() -> Canvas {
        
        let containers = self.containerVMs.map { (containerVM) -> Container in
            
            switch containerVM.type {
            case .Text:
               return (containerVM as! TextContainerVMProtocol).toContainer()
            default:
                return (containerVM as! ImageContainerVMProtocol).toContainer()
            }
        }
        
        let animations = self.animationBinders.map{ $0.toAnimation() }
        
        return Canvas(width: Float(size.width), height: Float(size.height), containers: containers, animations: animations)
    }
}

extension CTAAnimationBinder {
    
    func toAnimation() -> Animation {
        
        let duration = self.duration
        let delay = self.delay
        let direction = "FROM_LEFT"
        let bounce = false
        
        let delivery: String
        switch self.config.generateStrategy.paragraphDelivery {
        case .AllAtOnce:
            delivery = "ALL_AT_ONCE"
        case .Paragraph:
            delivery = "BY_LINE"
        }
        
        let deliveryFrom = 0
        let deliveryTo = -1
        let textDelivery: String
        switch self.config.generateStrategy.textDelivery {
        case .Object:
            textDelivery = "BY_OBJECT"
        case .Character, .Word:
            textDelivery = "BY_CHARACTER"
        }
        let textDeliveryFrom = "FORWORD"
        
        // config
        let config = Descriptor.Config.init(
            duration: duration,
            delay: delay,
            direction: direction,
            bounce: bounce,
            delivery: delivery,
            deliveryFrom: deliveryFrom,
            deliveryTo: deliveryTo,
            textDelivery: textDelivery,
            textDeliveryFrom: textDeliveryFrom)
        
        let type: String = animationName.toType().rawValue
        
        // descriptor
        let descriptor = Descriptor.init(type: type, config: config)
        
        
        //animation
        let ID = self.iD
        let targetID = self.targetiD
        let animation = Animation.init(ID: ID, targetID: targetID, descriptor: descriptor)
        
        return animation
    }
}

extension TextContainerVMProtocol {

     func toContainer() -> Container {
        
        let text = self.textElement!.texts
        let attributes = self.textElement!.textAttributes
        
        // source
        let source = Source.init(type: .Text, text: text, attributes: attributes)
        
        //content
        let cwidth = self.size.width
        let cheight = self.size.height
        let cpositionX = self.size.width / 2.0
        let cpositionY = self.size.height / 2.0
        let content = Content.init(cx: cpositionX, cy: cpositionY, width: cwidth, height: cheight, source: source)
        
        // container
        let ID = self.iD
        let width = self.size.width
        let height = self.size.height
        let positionX = self.center.x
        let positionY = self.center.y
        let radian = self.radius / CGFloat(M_PI) * 180.0
        
        let container = Container.init(cx: positionX, cy: positionY, width: width, height: height, rotation: radian, identifier: ID, contents: [content])
        
        return container
    }
}

extension ImageContainerVMProtocol {
    
    func toContainer() -> Container {
        
        let text = self.imageElement!.resourceName
//        let attributes = nil
        
        // source
        let source = Source.init(type: .Image, text: text, attributes: nil)
        
        //content
        let cwidth = self.size.width
        let cheight = self.size.height
        let cpositionX = self.size.width / 2.0
        let cpositionY = self.size.height / 2.0
        let content = Content.init(cx: cpositionX, cy: cpositionY, width: cwidth, height: cheight, source: source)
        
        // container
        let ID = self.iD
        let width = self.size.width
        let height = self.size.height
        let positionX = self.center.x
        let positionY = self.center.y
        let radian = self.radius / CGFloat(M_PI) * 180.0
        
        let container = Container.init(cx: positionX, cy: positionY, width: width, height: height, rotation: radian, identifier: ID, contents: [content])
        
        return container
    }
}




