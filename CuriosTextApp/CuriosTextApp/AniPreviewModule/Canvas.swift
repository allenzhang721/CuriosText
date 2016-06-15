//
//  AniPage.swift
//  PopApp
//
//  Created by Emiaostein on 4/1/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import Foundation

struct Canvas {
    let animations: [Animation]
    let containers: [Container]
    let height: Float
    let width: Float
    let backgroundColor: String
    init?(_ info: [String: AnyObject]) {
        guard let animationsJSONArray = info["animations"] as? [[String: AnyObject]] else { return nil }
        let animations = animationsJSONArray.map({ Animation($0) }).flatMap({ $0 })
        guard let containersJSONArray = info["containers"] as? [[String: AnyObject]] else { return nil }
        let containers = containersJSONArray.map({ Container($0) }).flatMap({ $0 })
        guard let height = info["height"] as? Float else { return nil }
        guard let width = info["width"] as? Float else { return nil }
        let color = info["backgroundColor"] as? String ?? "FF0000"
        self.animations = animations
        self.containers = containers
        self.height = height
        self.width = width
        self.backgroundColor = color
    }
    
    init(width: Float, height: Float, containers: [Container], animations: [Animation], backgroundColor: String) {
        self.animations = animations
        self.containers = containers
        self.height = height
        self.width = width
        self.backgroundColor = backgroundColor
    }
}