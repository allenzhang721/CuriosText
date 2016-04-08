//
//  AniDescriptor.swift
//  PopApp
//
//  Created by Emiaostein on 4/3/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import Foundation
struct Descriptor {
    struct Config {
        
        let bounce: Bool
        let deliveryFrom: Int
        let delivery: String
        let deliveryTo: Int
        let direction: String
        let delay: Float
        let duration: Float
        let textDelivery: String
        let textDeliveryFrom: String
        init?(_ info: [String: AnyObject]) {
            guard let bounce = info["bounce"] as? Bool else { return nil }
            guard let deiveryFrom = info["deliveryFrom"] as? Int else { return nil }
            guard let delivery = info["delivery"] as? String else { return nil }
            guard let deliveryTo = info["deliveryTo"] as? Int else { return nil }
            guard let direction = info["direction"] as? String else { return nil }
            guard let delay = info["delay"] as? Float else { return nil }
            guard let duration = info["duration"] as? Float else { return nil }
            guard let textDelivery = info["textDelivery"] as? String else { return nil }
            guard let textDeliveryFrom = info["textDeliveryFrom"] as? String else { return nil }
            self.bounce = bounce
            self.deliveryFrom = deiveryFrom
            self.delivery = delivery
            self.deliveryTo = deliveryTo
            self.direction = direction
            self.delay = delay
            self.duration = duration
            self.textDelivery = textDelivery
            self.textDeliveryFrom = textDeliveryFrom
        }
        
        init(duration: Float, delay: Float, direction: String, bounce: Bool, delivery: String, deliveryFrom: Int, deliveryTo: Int, textDelivery: String, textDeliveryFrom: String) {
            self.bounce = bounce
            self.deliveryFrom = deliveryFrom
            self.delivery = delivery
            self.deliveryTo = deliveryTo
            self.direction = direction
            self.delay = delay
            self.duration = duration
            self.textDelivery = textDelivery
            self.textDeliveryFrom = textDeliveryFrom
        }
    }
    let config: Config
    let type: String
    init?(_ info: [String: AnyObject]) {
        guard let configJSONDictionary = info["config"] as? [String: AnyObject] else { return nil }
        guard let config = Config(configJSONDictionary) else { return nil }
        guard let type = info["type"] as? String else { return nil }
        self.config = config
        self.type = type
    }
    
    init(type: String, config: Config) {
        self.config = config
        self.type = type
    }
}
