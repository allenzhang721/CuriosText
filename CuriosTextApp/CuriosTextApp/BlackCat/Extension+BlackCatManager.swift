//
//  extension+BlackCatManager.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 3/3/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation
extension BlackCatManager {
    
    func retriveDataForURL(urlString:String, completedHandler: ((NSData?) -> ())?) {
        
        let key = urlString
        let targetCache = self.cache
        let data = targetCache.retrieveDataInDiskCacheForKey(key)
        completedHandler?(data)
    }
    
    func storeData(data: NSData, byURL urlString:String, completedHandler:((Bool) -> ())?) {
        let key = urlString
//        let key = url.absoluteString
        let targetCache = self.cache
        let oldData = targetCache.retrieveDataInDiskCacheForKey(key)
        if oldData == nil {
            targetCache.storeData(data, forKey: key, toDisk: true, completionHandler: {
                completedHandler?(true)
            })
        }else {
            targetCache.removeDataForKey(key, fromDisk: true, completionHandler: {
                targetCache.storeData(data, forKey: key, toDisk: true, completionHandler: {
                    completedHandler?(true)
                })
            })
        }
    }
}