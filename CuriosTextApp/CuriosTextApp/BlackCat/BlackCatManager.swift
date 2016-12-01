//
//  EMDownloadCacheManager.swift
//  EMDownloadCacheManager
//
//  Created by Emiaostein on 7/30/15.
//  Copyright (c) 2015 botai. All rights reserved.
//

import Foundation

public typealias DownloadProgressBlock = ((_ receivedSize: Int64, _ totalSize: Int64) -> ())
public typealias CompletionHandler = ((_ data: Data?, _ error: NSError?, _ cacheType: CacheType, _ URL: URL?) -> ())

/**
*  RetrieveImageTask represents a task of image retrieving process.
*  It contains an async task of getting image from disk and from network.
*/
open class RetrieveDataTask {
  
  var diskRetrieveTask: DispatchWorkItem?
  var downloadTask: RetrieveDataDownloadTask?
  
  /**
  Cancel current task. If this task does not begin or already done, do nothing.
  */
  open func cancel() {
    if let diskRetrieveTask = diskRetrieveTask {
//      dispatch_block_cancel(diskRetrieveTask)
      diskRetrieveTask.cancel()
//      DispatchWorkItem
    }
    
    if let downloadTask = downloadTask {
      downloadTask.cancel()
    }
  }
}

public let BlackCatErrorDomain = "com.emiaostein.BlackCat.Error"


private let instance = BlackCatManager()

/**
*  Main manager class of BlackCat
*/
open class BlackCatManager {
  
  /**
  *	Options to control some downloader and cache behaviors.
  */
  public typealias Options = (forceRefresh: Bool, lowPriority: Bool, cacheMemoryOnly: Bool, queue: DispatchQueue)
  
  /// A preset option tuple with all value set to `false`.
  open static let OptionsNone: Options = {
    return (forceRefresh: false, lowPriority: false, cacheMemoryOnly: false, queue: DispatchQueue.main)
    }()
  
  /// The default set of options to be used by the manager to control some downloader and cache behaviors.
  open static var DefaultOptions: Options = OptionsNone
  
  /// Shared manager used by the extensions across BlackCat.
  open class var sharedManager: BlackCatManager {
    return instance
  }
  
  /// Cache used by this manager
  open var cache: DataCache
  
  /// Downloader used by this manager
  open var downloader: DataDownloader
  
  /**
  Default init method
  
  :returns: A BlackCat manager object with default cache and default downloader.
  */
  public init() {
    cache = DataCache.defaultCache
    downloader = DataDownloader.defaultDownloader
  }
  
  /**
  Get an image with URL as the key.
  If BlackCatOptions.None is used as `options`, BlackCat will seek the image in memory and disk first.
  If not found, it will download the image at URL and cache it.
  These default behaviors could be adjusted by passing different options. See `BlackCatOptions` for more.
  
  :param: URL               The image URL.
  :param: optionsInfo       A dictionary could control some behaviors. See `BlackCatOptionsInfo` for more.
  :param: progressBlock     Called every time downloaded data changed. This could be used as a progress UI.
  :param: completionHandler Called when the whole retriving process finished.
  
  :returns: A `RetrieveImageTask` task object. You can use this object to cancel the task.
  */
  open func retrieveDataWithURL(_ URL: Foundation.URL,
    optionsInfo: BlackCatOptionsInfo?,
    progressBlock: DownloadProgressBlock?,
    completionHandler: CompletionHandler?) -> RetrieveDataTask
  {
    func parseOptionsInfo(_ optionsInfo: BlackCatOptionsInfo?) -> (Options, DataCache, DataDownloader) {
      let options: Options
      if let optionsInOptionsInfo = optionsInfo?[.options] as? BlackCatOptions {
        let queue = (optionsInOptionsInfo == .BackgroundCallback) ? DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default) : BlackCatManager.DefaultOptions.queue
        options = (forceRefresh: (optionsInOptionsInfo == .ForceRefresh),
          lowPriority: (optionsInOptionsInfo == .LowPriority),
          cacheMemoryOnly: (optionsInOptionsInfo == .CacheMemoryOnly),
          queue: queue)
      } else {
        options = BlackCatManager.DefaultOptions
      }
      
      let targetCache = optionsInfo?[.targetCache] as? DataCache ?? self.cache
      let usedDownloader = optionsInfo?[.downloader] as? DataDownloader ?? self.downloader
      
      return (options, targetCache, usedDownloader)
    }
    
    let task = RetrieveDataTask()
    
    // There is a bug in Swift compiler which prevents to write `let (options, targetCache) = parseOptionsInfo(optionsInfo)`
    // It will cause a compiler error.
    let parsedOptions = parseOptionsInfo(optionsInfo)
    let (options, targetCache, downloader) = (parsedOptions.0, parsedOptions.1, parsedOptions.2)
    
    if let key = URL.absoluteString as? String{
      if options.forceRefresh {
        downloadAndCacheDataWithURL(URL,
          forKey: key,
          retrieveDataTask: task,
          progressBlock: progressBlock,
          completionHandler: completionHandler,
          options: options,
          targetCache: targetCache,
          downloader: downloader)
      } else {
        let diskTaskCompletionHandler: CompletionHandler = { (data, error, cacheType, URL) -> () in
          // Break retain cycle created inside diskTask closure below
          task.diskRetrieveTask = nil
          completionHandler?(data, error, cacheType, URL)
        }
        let diskTask = targetCache.retrieveDataForKey(key, options: options, completionHandler: { (data, cacheType) -> () in
          if data != nil {
            diskTaskCompletionHandler(data, nil, cacheType!, URL)
          } else {
            self.downloadAndCacheDataWithURL(URL,
              forKey: key,
              retrieveDataTask: task,
              progressBlock: progressBlock,
              completionHandler: diskTaskCompletionHandler,
              options: options,
              targetCache: targetCache,
              downloader: downloader)
          }
        })
        task.diskRetrieveTask = diskTask
      }
    }
    
    return task
  }
  
  func downloadAndCacheDataWithURL(_ URL: Foundation.URL,
    forKey key: String,
    retrieveDataTask: RetrieveDataTask,
    progressBlock: DownloadProgressBlock?,
    completionHandler: CompletionHandler?,
    options: Options,
    targetCache: DataCache,
    downloader: DataDownloader)
  {
    downloader.downloadDataWithURL(URL, retrieveImageTask: retrieveDataTask, options: options, progressBlock: { (receivedSize, totalSize) -> () in
      progressBlock?(receivedSize, totalSize)
      return
      }) { (aData, error, imageURL) -> () in
        
        if let error = error, error.code == BlackCatError.notModified.rawValue {
          // Not modified. Try to find the image from cache.
          // (The image should be in cache. It should be ensured by the framework users.)
          targetCache.retrieveDataForKey(key, options: options, completionHandler: { (cacheImage, cacheType) -> () in
            completionHandler?(cacheImage, nil, cacheType!, URL)
            
          })
          return
        }
        
        if let data = aData {
          targetCache.storeData(data, forKey: key, toDisk: !options.cacheMemoryOnly, completionHandler: nil)
        }
        
        completionHandler?(aData, error, .none, URL)
    }
  }
}
