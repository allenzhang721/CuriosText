//
//  AniContent.swift
//  PopApp
//
//  Created by Emiaostein on 4/1/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import Foundation
struct Content {
    let height: CGFloat
    let positionX: CGFloat
    let positionY: CGFloat
    let source: Source
    let width: CGFloat
    init?(_ info: [String: AnyObject]) {
        guard let height = info["height"] as? CGFloat else { return nil }
        guard let positionX = info["positionX"] as? CGFloat else { return nil }
        guard let positionY = info["positionY"] as? CGFloat else { return nil }
        guard let sourceJSONDictionary = info["source"] as? [String: AnyObject] else { return nil }
        guard let source = Source(sourceJSONDictionary) else { return nil }
        guard let width = info["width"] as? CGFloat else { return nil }
        self.height = height
        self.positionX = positionX
        self.positionY = positionY
        self.source = source
        self.width = width
    }
    
    init(cx: CGFloat, cy: CGFloat, width: CGFloat, height: CGFloat, source: Source) {
        self.height = height
        self.positionX = cx
        self.positionY = cy
        self.width = width
        self.source = source
    }
}