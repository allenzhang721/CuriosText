//
//  CuriosTextAppTextHelper.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/15/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation
@testable import CuriosTextApp
import UIKit

//class TestHelper {

//    class func generateTextElement(
//        text: String,
//        attributes: [String: AnyObject])
//        -> CTATextElement {
//            
//        return CTATextElement(
//            text: text,
//            //attributes: attributes
//            )
//            
//    }
//    
//    class func generateImageElement(
//        imageName: String,
//        attributes: [String: AnyObject])
//        -> CTAImageElement {
//            
//        return CTAImageElement(
//            imageName: imageName,
//            attributes: attributes
//            )
//    }
//    
//    class func generateTextContainer(
//        x: Double,
//        y: Double,
//        pageWidth: Double,
//        pageHeigh: Double,
//        text: String,
//        attributes: [String: AnyObject])
//        -> CTAContainer {
//            
//        let textElement = TestHelper.generateTextElement(text, attributes: attributes)
//        
//        func textBounds() -> CGSize {
//            return CGSize(width: 50, height: 50)
//        }
//        
//        let size = textBounds()
//        
//        return CTAContainer(
//            x: x,
//            y: y,
//            width: Double(size.width),
//            height: Double(size.height),
//            rotation: 0.0,
//            alpha: 1.0,
//            scale: 1.0,
//            element: textElement
//        )
//    }
//    
//    class func generateImageContainer(
//        x: Double,
//        y: Double,
//        pageWidth: Double,
//        pageHeigh: Double,
//        imageName: String,
//        attributes: [String: AnyObject])
//        -> CTAContainer {
//            
//        let imageElement = TestHelper.generateImageElement(imageName, attributes: attributes)
//        
//        func textBounds() -> CGSize {
//            return CGSize(width: 50, height: 50)
//        }
//        
//        let size = textBounds()
//        
//        return CTAContainer(
//            x: x,
//            y: y,
//            width: Double(size.width),
//            height: Double(size.height),
//            rotation: 0.0,
//            alpha: 1.0,
//            scale: 1.0,
//            element: imageElement)
//    }
//}
//
//// MARK: - Generate Document URL
//extension TestHelper {
//    
//    class func documentsURL() ->  NSURL {
//        return try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
//    }
//    
//    class func documentFileURL() -> NSURL {
//        let fileName = CTAIDGenerator.generateID()
//        return documentsURL().URLByAppendingPathComponent("\(fileName).card", isDirectory: false)
//    }
//    
//}