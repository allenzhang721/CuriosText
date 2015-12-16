//
//  CTAImageElement.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/15/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation

struct ImageAttributeName {
}

final class CTAImageElement: NSObject, CTAElement {
    
    private struct SerialKeys {
        static let imageName = "imageName"  // xxx.jpg, xxx.png
        static let attributes = "attributes"
    }
    
    private(set) var imageName = ""
    private(set) var attributes = [String: AnyObject]()
    
    var resourceName: String {
        return imageName
    }
    
    required init?(coder aDecoder: NSCoder) {
        imageName = aDecoder.decodeObjectForKey(SerialKeys.imageName) as! String
        attributes = aDecoder.decodeObjectForKey(SerialKeys.attributes) as! [String: AnyObject]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(imageName, forKey: SerialKeys.imageName)
        aCoder.encodeObject(attributes, forKey: SerialKeys.attributes)
    }
    
    init(imageName: String, attributes: [String: AnyObject] = [:]) {
        
        self.imageName = imageName
        self.attributes = attributes
    }
}