//
//  extension+BlackCatManager.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 3/3/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
extension BlackCatManager {
    
    func storeData(data: NSData, byURL url: NSURL, completedHandler:((Bool) -> ())?) {
        let key = url.absoluteString
        let targetCache = self.cache
        targetCache.removeDataForKey(key, fromDisk: true, completionHandler: {
            targetCache.storeData(data, forKey: key, toDisk: true, completionHandler: {
                completedHandler?(true)
            })
        })
    }
}