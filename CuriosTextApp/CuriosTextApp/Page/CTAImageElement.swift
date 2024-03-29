//
//  CTAImageElement.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/15/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation

final class CTAImgElement: NSObject, NSCoding {
    
    struct ImgElementKey {
        static let imageName = "imageName"
        static let filterName = "filterName"
    }
    
    private let imageName: String
    private var filterName: String = ""
    
    init?(coder aDecoder: NSCoder) {
        imageName = aDecoder.decodeObjectForKey(ImgElementKey.imageName) as! String
        filterName = aDecoder.decodeObjectForKey(ImgElementKey.filterName) as? String ?? ""

    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(imageName, forKey: ImgElementKey.imageName)
        aCoder.encodeObject(filterName, forKey: ImgElementKey.filterName)
    }
    
    // TODO: need ImgElement init parameter -- Emiaostein, 15/02/16, 14:31
    init(imageName: String, filterName: String = "") {
        self.imageName = imageName
        self.filterName = filterName
        super.init()
    }
}

extension CTAImgElement: CTAElement {
    
    var resourceName: String {
        return imageName
    }
    var scale: CGFloat {
        get {
            return 1.0
        }
        
        set {
            
        }
    }
    //    var x: Double { get }
    //    var y: Double { get }
    //    var width: Double { get }
    //    var height: Double { get }
    
    func resultWithScale(
        scale: CGFloat,
        preScale: CGFloat,
        containerSize: CGSize,
        constraintSzie: CGSize) -> (inset: CGPoint, size: CGSize) {
        
        let originWidth = containerSize.width / preScale
        let originHeight = containerSize.height / preScale

        let nextSize = CGSize(width: originWidth * scale, height: originHeight * scale)
        let inset = CGPoint.zero
        
        return (inset, nextSize)
    }
    
    func resultWithImgSize(originSize: CGSize, scale: CGFloat, containerSize: CGSize, constraintSize: CGSize) -> (inset: CGPoint, size: CGSize) {
        
        let s: CGFloat
        if containerSize.width >= constraintSize.width && containerSize.height >= constraintSize.height {
            s = min(
                containerSize.width / originSize.width,
                containerSize.height / originSize.height)
        } else {
             s = max(
                containerSize.width / originSize.width,
                containerSize.height / originSize.height)
        }

        let nextWidth = originSize.width * s
        let nextHeight = originSize.height * s
        
        let nextSize = CGSize(width: nextWidth, height: nextHeight)
        let inset = CGPoint.zero
        
        return (inset, nextSize)
    }
}

extension CTAImgElement: ImageModifiable {
    
    
}

//
//final class CTAImageElement: NSObject, CTAElement {
//    
//    private struct SerialKeys {
//        static let imageName = "imageName"  // xxx.jpg, xxx.png
//        static let attributes = "attributes"
//    }
//    
//    private(set) var imageName = ""
//    private(set) var attributes = [String: AnyObject]()
//    
//    var resourceName: String {
//        return imageName
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        imageName = aDecoder.decodeObjectForKey(SerialKeys.imageName) as! String
//        attributes = aDecoder.decodeObjectForKey(SerialKeys.attributes) as! [String: AnyObject]
//    }
//    
//    func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encodeObject(imageName, forKey: SerialKeys.imageName)
//        aCoder.encodeObject(attributes, forKey: SerialKeys.attributes)
//    }
//    
//    init(imageName: String, attributes: [String: AnyObject] = [:]) {
//        
//        self.imageName = imageName
//        self.attributes = attributes
//    }
//}