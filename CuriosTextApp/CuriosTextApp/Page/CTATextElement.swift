//
//  CTAStringElement.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/15/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation

struct TextAttributeName {
    static let FontName = "FontName"
    static let fontSize = "fontSize"
}


final class CTATextElement: NSObject, CTAElement {
    
    private struct SerialKeys {
        static let text = "text"
        static let attributes = "attributes"
    }
    
    private(set) var text = ""
    private(set) var attributes = [String: AnyObject]()
    
    var resourceName: String {
        return ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey(SerialKeys.text) as! String
        attributes = aDecoder.decodeObjectForKey(SerialKeys.attributes) as! [String: AnyObject]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: SerialKeys.text)
        aCoder.encodeObject(attributes, forKey: SerialKeys.attributes)
    }
    
    init(text: String, attributes: [String: AnyObject] = [TextAttributeName.FontName: "Helvetica", TextAttributeName.fontSize: 17]) {
        
        self.text = text
        self.attributes = attributes
    }
    
}