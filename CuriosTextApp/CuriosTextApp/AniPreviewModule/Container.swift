//
//  AniContainer.swift
//  PopApp
//
//  Created by Emiaostein on 4/1/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import Foundation
struct Container {
    let contents: [Content]
    let height: CGFloat
    let identifier: String
    let positionX: CGFloat
    let positionY: CGFloat
    var rotation: CGFloat
    let width: CGFloat
    init?(_ info: [String: AnyObject]) {
        guard let contentsJSONArray = info["contents"] as? [[String: AnyObject]] else { return nil }
        let contents = contentsJSONArray.map({ Content($0) }).flatMap({ $0 })
        guard let height = info["height"] as? CGFloat else { return nil }
        guard let identifier = info["identifier"] as? String else { return nil }
        guard let positionX = info["positionX"] as? CGFloat else { return nil }
        guard let positionY = info["positionY"] as? CGFloat else { return nil }
        guard let rotation = info["rotation"] as? CGFloat else { return nil }
        guard let width = info["width"] as? CGFloat else { return nil }
        self.contents = contents
        self.height = height
        self.identifier = identifier
        self.positionX = positionX
        self.positionY = positionY
        self.rotation = rotation
        self.width = width
    }
    
    init(cx: CGFloat, cy: CGFloat, width: CGFloat, height: CGFloat, rotation: CGFloat, identifier: String, contents: [Content]) {
        
        self.contents = contents
        self.height = height
        self.identifier = identifier
        self.positionX = cx
        self.positionY = cy
        self.rotation = rotation
        self.width = width
    }
}