//
//  EMBlackCatCache.swift
//  EMDownloadCacheManager
//
//  Created by Emiaostein on 7/31/15.
//  Copyright (c) 2015 botai. All rights reserved.
//

import Foundation
import UIKit

public let BlackCatDidCleanDiskCacheNotification = "com.emiaostein.BlackCat.BlackCatDidCleanDiskCacheNotification"

/**
Key for array of cleaned hashes in `userInfo` of `BlackCatDidCleanDiskCacheNotification`.
*/
public let BlackCatDiskCacheCleanedHashKey = "com.emiaostein.BlackCat.cleanedHash"

private let defaultCacheName = "default"
private let cacheReverseDNS = "com.emiaostein.BlackCat.DataCache."
private let ioQueueName = "com.emiaostein.BlackCat.DataCache.ioQueue."
private let processQueueName = "com.emiaostein.BlackCat.DataCache.processQueue."

private let defaultCacheInstance = DataCache(name: defaultCacheName)
private let defaultMaxCachePeriodInSecond: TimeInterval = 60 * 60 * 24 * 7 //Cache exists for 1 week

public typealias RetrieveDataDiskTask = DispatchWorkItem

/**
Cache type of a cached image.

- Memory: The image is cached in memory.
- Disk:   The image is cached in disk.
*/
public enum CacheType {
  case none, memory, disk
}

/**
*	`ImageCache` represents both the memory and disk cache system of BlackCat. While a default image cache object will be used if you prefer the extension methods of BlackCat, you can create your own cache object and configure it as your need. You should use an `ImageCache` object to manipulate memory and disk cache for BlackCat.
*/
open class DataCache {
  
  //Memory
  fileprivate let memoryCache = NSCache<AnyObject, AnyObject>()
  
  /// The largest cache cost of memory cache. The total cost is pixel count of all cached images in memory.
  open var maxMemoryCost: UInt = 0 {
    didSet {
      self.memoryCache.totalCostLimit = Int(maxMemoryCost)
    }
  }
  
  //Disk
  fileprivate let ioQueue: DispatchQueue
  fileprivate let diskCachePath: String
  fileprivate var fileManager: FileManager!
  
  /// The longest time duration of the cache being stored in disk. Default is 1 week.
  open var maxCachePeriodInSecond = defaultMaxCachePeriodInSecond
  
  /// The largest disk size can be taken for the cache. It is the total allocated size of cached files in bytes. Default is 0, which means no limit.
  open var maxDiskCacheSize: UInt = 0
  
  fileprivate let processQueue: DispatchQueue
  
  /// The default cache.
  open class var defaultCache: DataCache {
    return defaultCacheInstance
  }
  
  /**
  Init method. Passing a name for the cache. It represents a cache folder in the memory and disk.
  
  :param: name Name of the cache. It will be used as the memory cache name and the disk cache folder name. This value should not be an empty string.
  
  :returns: The cache object.
  */
  public init(name: String) {
    
    if name.isEmpty {
      fatalError("[BlackCat] You should specify a name for the cache. A cache with empty name is not permitted.")
    }
    
    let cacheName = cacheReverseDNS + name
    memoryCache.name = cacheName
    
    let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    diskCachePath = (paths.first! as NSString).appendingPathComponent(cacheName)
    
    ioQueue = DispatchQueue(label: ioQueueName + name, attributes: [])
    processQueue = DispatchQueue(label: processQueueName + name, attributes: DispatchQueue.Attributes.concurrent)
    
    ioQueue.sync(execute: { () -> Void in
      self.fileManager = FileManager()
    })
    
    NotificationCenter.default.addObserver(self, selector: #selector(DataCache.clearMemoryCache), name: NSNotification.Name.UIApplicationDidReceiveMemoryWarning, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(DataCache.cleanExpiredDiskCache), name:NSNotification.Name.UIApplicationWillTerminate, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(DataCache.backgroundCleanExpiredDiskCache), name:NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

// MARK: - Store & Remove
public extension DataCache {
  /**
  Store an image to cache. It will be saved to both memory and disk.
  It is an async operation, if you need to do something about the stored image, use `-storeImage:forKey:toDisk:completionHandler:`
  instead.
  
  :param: image The image will be stored.
  :param: key   Key for the image.
  */
  public func storeData(_ data: Data, forKey key: String) {
    storeData(data, forKey: key, toDisk: true, completionHandler: nil)
  }
  
  /**
  Store an image to cache. It is an async operation.
  
  :param: image             The image will be stored.
  :param: key               Key for the image.
  :param: toDisk            Whether this image should be cached to disk or not. If false, the image will be only cached in memory.
  :param: completionHandler Called when stroe operation completes.
  */
  public func storeData(_ data: Data, forKey key: String, toDisk: Bool, completionHandler: (() -> ())?) {
    memoryCache.setObject(data as AnyObject, forKey: key as AnyObject, cost: data.count)
    
    if toDisk {
      ioQueue.async(execute: { () -> Void in
//        if let data = data {
          if !self.fileManager.fileExists(atPath: self.diskCachePath) {
           try! self.fileManager.createDirectory(atPath: self.diskCachePath, withIntermediateDirectories: true, attributes: nil)
          }
          
          self.fileManager.createFile(atPath: self.cachePathForKey(key), contents: data, attributes: nil)
          
          if let handler = completionHandler {
            DispatchQueue.main.async {
              handler()
            }
          }
          
//        } else {
//          if let handler = completionHandler {
//            dispatch_async(dispatch_get_main_queue()) {
//              handler()
//            }
//          }
//        }
      })
    } else {
      if let handler = completionHandler {
        handler()
      }
    }
  }
  
  /**
  Remove the image for key for the cache. It will be opted out from both memory and disk.
  It is an async operation, if you need to do something about the stored image, use `-removeImageForKey:fromDisk:completionHandler:`
  instead.
  
  :param: key Key for the image.
  */
  public func removeDataForKey(_ key: String) {
    removeDataForKey(key, fromDisk: true, completionHandler: nil)
  }
  
  /**
  Remove the image for key for the cache. It is an async operation.
  
  :param: key               Key for the image.
  :param: fromDisk          Whether this image should be removed from disk or not. If false, the image will be only removed from memory.
  :param: completionHandler Called when removal operation completes.
  */
  public func removeDataForKey(_ key: String, fromDisk: Bool, completionHandler: (() -> ())?) {
    memoryCache.removeObject(forKey: key as AnyObject)
    
    if fromDisk {
      ioQueue.async(execute: { () -> Void in
        try! self.fileManager.removeItem(atPath: self.cachePathForKey(key))
        if let handler = completionHandler {
          DispatchQueue.main.async {
            handler()
          }
        }
      })
    } else {
      if let handler = completionHandler {
        handler()
      }
    }
  }
  
}

// MARK: - Get data from cache
extension DataCache {
  /**
  Get an image for a key from memory or disk.
  
  :param: key               Key for the image.
  :param: options           Options of retriving image.
  :param: completionHandler Called when getting operation completes with image result and cached type of this image. If there is no such key cached, the image will be `nil`.
  
  :returns: The retriving task.
  */
  public func retrieveDataForKey(_ key: String, options:BlackCatManager.Options, completionHandler: ((Data?, CacheType?) -> ())?) -> DispatchWorkItem? {
    // No completion handler. Not start working and early return.
    if (completionHandler == nil) {
//      return dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS) {}
//      return DispatchWorkItem(qos: DISPATCH_BLOCK_INHERIT_QOS_CLASS, flags: DispatchWorkItemFlags, block: <#T##() -> ()#>)
      
      return DispatchWorkItem(qos: DispatchQoS.default, flags: DispatchWorkItemFlags.inheritQoS, block: {})
      
    }
    
//    let block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS) {
    let block = DispatchWorkItem(qos: DispatchQoS.default, flags: DispatchWorkItemFlags.inheritQoS) {
      if let data = self.retrieveDataInMemoryCacheForKey(key) {
          completionHandler?(data, .memory)
      } else {
        //Begin to load image from disk
        self.ioQueue.async(execute: { () -> Void in
          
          if let data = self.retrieveDataInDiskCacheForKey(key) {
              self.storeData(data, forKey: key, toDisk: false, completionHandler: nil)
              (options.queue).async(execute: { () -> Void in
                if let completionHandler = completionHandler {
                  completionHandler(data, .disk)
                }
              })
            
          } else {
            // No data found from either memory or disk
            (options.queue).async(execute: { () -> Void in
              if let completionHandler = completionHandler {
                completionHandler(nil, nil)
              }
            })
          }
        })
      }
    }
    
    (options.queue).async(execute: block)
    return block
  }
  
  /**
  Get an image for a key from memory.
  
  :param: key Key for the image.
  
  :returns: The image object if it is cached, or `nil` if there is no such key in the cache.
  */
  public func retrieveDataInMemoryCacheForKey(_ key: String) -> Data? {
    return memoryCache.object(forKey: key as AnyObject) as? Data
  }
  
  /**
  Get an image for a key from disk.
  
  :param: key Key for the image.
  :param: scale The scale factor to assume when interpreting the image data.
  
  :returns: The image object if it is cached, or `nil` if there is no such key in the cache.
  */
  public func retrieveDataInDiskCacheForKey(_ key: String) -> Data? {
    return diskDataForKey(key)
  }
}

// MARK: - Clear & Clean
extension DataCache {
  /**
  Clear memory cache.
  */
  @objc public func clearMemoryCache() {
    memoryCache.removeAllObjects()
  }
  
  /**
  Clear disk cache. This is an async operation.
  */
  public func clearDiskCache() {
    clearDiskCacheWithCompletionHandler(nil)
  }
  
  /**
  Clear disk cache. This is an async operation.
  
  :param: completionHander Called after the operation completes.
  */
  public func clearDiskCacheWithCompletionHandler(_ completionHander: (()->())?) {
    ioQueue.async(execute: { () -> Void in
      try! self.fileManager.removeItem(atPath: self.diskCachePath)
      try! self.fileManager.createDirectory(atPath: self.diskCachePath, withIntermediateDirectories: true, attributes: nil)
      
      if let completionHander = completionHander {
        DispatchQueue.main.async(execute: { () -> Void in
          completionHander()
        })
      }
    })
  }
  
  /**
  Clean expired disk cache. This is an async operation.
  */
  @objc public func cleanExpiredDiskCache() {
    cleanExpiredDiskCacheWithCompletionHander(nil)
  }
  
  /**
  Clean expired disk cache. This is an async operation.
  
  :param: completionHandler Called after the operation completes.
  */
  public func cleanExpiredDiskCacheWithCompletionHander(_ completionHandler: (()->())?) {
    // Do things in cocurrent io queue
    ioQueue.async(execute: { () -> Void in
        
        let diskCacheURL = URL(fileURLWithPath: self.diskCachePath)
//      if let diskCacheURL = NSURL(fileURLWithPath: self.diskCachePath) {
        
        let resourceKeys = [URLResourceKey.isDirectoryKey, URLResourceKey.contentModificationDateKey, URLResourceKey.totalFileAllocatedSizeKey]
        let expiredDate = Date(timeIntervalSinceNow: -self.maxCachePeriodInSecond)
        var cachedFiles = [URL: [AnyHashable: Any]]()
        var URLsToDelete = [URL]()
        
        var diskCacheSize: UInt = 0
        
        if let fileEnumerator = self.fileManager.enumerator(at: diskCacheURL,
          includingPropertiesForKeys: resourceKeys,
          options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles,
          errorHandler: nil) {
            
            for fileURL in fileEnumerator.allObjects as! [URL] {
              
              if let resourceValues = try? (fileURL as NSURL).resourceValues(forKeys: resourceKeys) {
                // If it is a Directory. Continue to next file URL.
                if let isDirectory = (resourceValues[URLResourceKey.isDirectoryKey] as AnyObject).boolValue {
                  if isDirectory {
                    continue
                  }
                }
                
                // If this file is expired, add it to URLsToDelete
                if let modificationDate = resourceValues[URLResourceKey.contentModificationDateKey] as? Date {
                  if (modificationDate as NSDate).laterDate(expiredDate) == expiredDate {
                    URLsToDelete.append(fileURL)
                    continue
                  }
                }
                
                if let fileSize = resourceValues[URLResourceKey.totalFileAllocatedSizeKey] as? NSNumber {
                  diskCacheSize += fileSize.uintValue
                  cachedFiles[fileURL] = resourceValues
                }
              }
              
            }
        }
        
        for fileURL in URLsToDelete {
          try! self.fileManager.removeItem(at: fileURL)
        }
        
        if self.maxDiskCacheSize > 0 && diskCacheSize > self.maxDiskCacheSize {
          let targetSize = self.maxDiskCacheSize / 2
          
          // Sort files by last modify date. We want to clean from the oldest files.
          let sortedFiles = cachedFiles.keysSortedByValue({ (resourceValue1, resourceValue2) -> Bool in
            
            if let date1 = resourceValue1[URLResourceKey.contentModificationDateKey] as? Date {
              if let date2 = resourceValue2[URLResourceKey.contentModificationDateKey] as? Date {
                return date1.compare(date2) == .orderedAscending
              }
            }
            // Not valid date information. This should not happen. Just in case.
            return true
          })
          
          for fileURL in sortedFiles {
            if ((try? self.fileManager.removeItem(at: fileURL)) != nil) {
              
              URLsToDelete.append(fileURL)
              
              if let fileSize = cachedFiles[fileURL]?[URLResourceKey.totalFileAllocatedSizeKey] as? NSNumber {
                diskCacheSize -= fileSize.uintValue
              }
              
              if diskCacheSize < targetSize {
                break
              }
            }
          }
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
          
          if URLsToDelete.count != 0 {
            let cleanedHashes = URLsToDelete.map({ (url) -> String in
              return url.lastPathComponent
            })
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: BlackCatDidCleanDiskCacheNotification), object: self, userInfo: [BlackCatDiskCacheCleanedHashKey: cleanedHashes])
          }
          
          if let completionHandler = completionHandler {
            completionHandler()
          }
        })
        
//      } else {
//        print("Bad disk cache path. \(self.diskCachePath) is not a valid local directory path.")
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//          if let completionHandler = completionHandler {
//            completionHandler()
//          }
//        })
//      }
    })
  }
  
  /**
  Clean expired disk cache when app in background. This is an async operation.
  In most cases, you should not call this method explicitly.
  It will be called automatically when `UIApplicationDidEnterBackgroundNotification` received.
  */
  @objc public func backgroundCleanExpiredDiskCache() {
    
    func endBackgroundTask(_ task: inout UIBackgroundTaskIdentifier) {
      UIApplication.shared.endBackgroundTask(task)
      task = UIBackgroundTaskInvalid
    }
    
    var backgroundTask: UIBackgroundTaskIdentifier!
    
    backgroundTask = UIApplication.shared.beginBackgroundTask (expirationHandler: { () -> Void in
      endBackgroundTask(&backgroundTask!)
    })
    
    cleanExpiredDiskCacheWithCompletionHander { () -> () in
      endBackgroundTask(&backgroundTask!)
    }
  }
}


// MARK: - Check cache status
public extension DataCache {
  
  /**
  *  Cache result for checking whether an image is cached for a key.
  */
  public struct CacheCheckResult {
    public let cached: Bool
    public let cacheType: CacheType?
  }
  
  /**
  Check whether an image is cached for a key.
  
  :param: key Key for the image.
  
  :returns: The check result.
  */
  public func isImageCachedForKey(_ key: String) -> CacheCheckResult {
    
    if memoryCache.object(forKey: key as AnyObject) != nil {
      return CacheCheckResult(cached: true, cacheType: .memory)
    }
    
    let filePath = cachePathForKey(key)
    
    if fileManager.fileExists(atPath: filePath) {
      return CacheCheckResult(cached: true, cacheType: .disk)
    }
    
    return CacheCheckResult(cached: false, cacheType: nil)
  }
  
  /**
  Get the hash for the key. This could be used for matching files.
  
  :param: key The key which is used for caching.
  
  :returns: Corresponding hash.
  */
  public func hashForKey(_ key: String) -> String {
    return cacheFileNameForKey(key)
  }
  
  /**
  Calculate the disk size taken by cache.
  It is the total allocated size of the cached files in bytes.
  
  :param: completionHandler Called with the calculated size when finishes.
  */
  public func calculateDiskCacheSizeWithCompletionHandler(_ completionHandler: ((_ size: UInt) -> ())?) {
    ioQueue.async(execute: { () -> Void in
        
        let diskCacheURL = URL(fileURLWithPath: self.diskCachePath)
//      if diskCacheURL != nil {
        
        let resourceKeys = [URLResourceKey.isDirectoryKey, URLResourceKey.totalFileAllocatedSizeKey]
        var diskCacheSize: UInt = 0
        
        if let fileEnumerator = self.fileManager.enumerator(at: diskCacheURL,
          includingPropertiesForKeys: resourceKeys,
          options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles,
          errorHandler: nil) {
            
            for fileURL in fileEnumerator.allObjects as! [URL] {
              
              if let resourceValues = try? (fileURL as NSURL).resourceValues(forKeys: resourceKeys) {
                // If it is a Directory. Continue to next file URL.
                if let isDirectory = (resourceValues[URLResourceKey.isDirectoryKey] as AnyObject).boolValue {
                  if isDirectory {
                    continue
                  }
                }
                
                if let fileSize = resourceValues[URLResourceKey.totalFileAllocatedSizeKey] as? NSNumber {
                  diskCacheSize += fileSize.uintValue
                }
              }
              
            }
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
          if let completionHandler = completionHandler {
            completionHandler(diskCacheSize)
          }
        })
        
//      } else {
//        print("Bad disk cache path. \(self.diskCachePath) is not a valid local directory path.")
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//          if let completionHandler = completionHandler {
//            completionHandler(size: 0)
//          }
//        })
//      }
    })
  }
}

// MARK: - Internal Helper
extension DataCache {
  
//  func diskDataForKey(key: String) -> NSData? {
//    if let data = diskImageDataForKey(key) {
//        return data
//    } else {
//        return nil
//    }
//  }
  
  func diskDataForKey(_ key: String) -> Data? {
    let filePath = cachePathForKey(key)
    return (try? Data(contentsOf: URL(fileURLWithPath: filePath)))
  }
  
  func cachePathForKey(_ key: String) -> String {
    let fileName = cacheFileNameForKey(key)
    return (diskCachePath as NSString).appendingPathComponent(fileName)
  }
  
  func cacheFileNameForKey(_ key: String) -> String {
    return key.bc_MD5()
  }
}

//extension UIImage {
//  var kf_imageCost: Int {
//    return Int(size.height * size.width * scale * scale)
//  }
//}

extension Dictionary {
  func keysSortedByValue(_ isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
    var array = Array(self)
    array.sort {
      let (_, lv) = $0
      let (_, rv) = $1
      return isOrderedBefore(lv, rv)
    }
    return array.map {
      let (k, _) = $0
      return k
    }
  }
}
