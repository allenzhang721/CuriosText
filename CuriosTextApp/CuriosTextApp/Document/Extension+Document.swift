//
//  Extension+Document.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 3/7/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
import PromiseKit
extension CTADocument {
    
    func accessImage(baseURL: NSURL, imageName: String) -> Promise<Result<CTAImageCache>> {
        
        let imageData = resourceBy(imageName)
        return Promise { fullfill, reject in
            
            if let imageData = imageData, let image = UIImage(data: imageData) {
                let imageCache = CTAImageCache(name: imageName, image: image)
                fullfill(.Success(imageCache))
            } else {
                fullfill(.Failure())
            }
            
        }
    }
}