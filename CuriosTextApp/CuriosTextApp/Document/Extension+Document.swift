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
    
    func accessImage(_ baseURL: NSURL, imageName: String) -> Promise<AResult<CTAImageCache>> {
        
        let imageData = resourceBy(imageName)
        return Promise { fullfill, reject in
            
            if let imageData = imageData, let image = UIImage(data: imageData) {
                let imageCache = CTAImageCache(name: imageName, image: image)
                fullfill(.success(imageCache))
            } else {
                fullfill(.failure())
            }
            
        }
    }
}
