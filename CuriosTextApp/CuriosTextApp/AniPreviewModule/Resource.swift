//
//  AniResource.swift
//  PopApp
//
//  Created by Emiaostein on 4/1/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import Foundation

enum SourceType: String {
    case Text, Image
}

protocol ContentSource {
    var sourceType: SourceType { get }
}

protocol SourceText: ContentSource {
    var texts: String { get }
    var attribute: [String: AnyObject]? { get }
}

protocol SourceImage: ContentSource {
    var ImageName: String { get }
}

struct Source {
    
    fileprivate let type: String
    fileprivate let text: String
    fileprivate let attributes: [String: AnyObject]?
    init?(_ info: [String: AnyObject]) {
        guard let type = info["type"] as? String else { return nil }
        guard let text = info["text"] as? String else { return nil }
        let attributes = info["attributes"] as? [String: AnyObject]
        self.type = type
        self.text = text
        self.attributes = attributes
    }
    
    init(type: SourceType, text: String, attributes: [String: AnyObject]?) {
        self.type = type.rawValue
        self.text = text
        self.attributes = attributes
    }
}

extension Source: ContentSource {
    var sourceType: SourceType { return SourceType(rawValue: type)! }
}

extension Source: SourceText {
    var texts: String { return text }
    var attribute: [String: AnyObject]? { return attributes }
}

extension Source: SourceImage {
    var ImageName: String { return text }
}
