//
//  Moduler+Image.swift
//  ModuleManager
//
//  Created by Emiaostein on 5/25/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import Foundation

extension Moduler {
    
    class func image_compressTo(size: CGSize, opaque: Bool = true, scale: CGFloat = 0) -> (image: UIImage) -> UIImage {
        
        func compressImage(image: UIImage) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
            image.drawInRect(CGRect(origin: CGPoint.zero, size: size))
            let compressedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return compressedImage
        }
        
        return compressImage
    }
}