//
//  EMBlackCatDownloader.swift
//  EMDownloadCacheManager
//
//  Created by Emiaostein on 7/31/15.
//  Copyright (c) 2015 botai. All rights reserved.
//

import Foundation

/// Progress update block of downloader.
public typealias DataDownloaderProgressBlock = DownloadProgressBlock

/// Completion block of downloader.
public typealias DataDownloaderCompletionHandler = ((_ data: Data?, _ error: NSError?, _ URL: URL?) -> ())

/// Download task.
public typealias RetrieveDataDownloadTask = URLSessionDataTask

private let defaultDownloaderName = "default"
private let downloaderBarrierName = "com.emiaostein.BlackCat.DataDownloader.Barrier."
private let imageProcessQueueName = "com.emiaostein.BlackCat.DataDownloader.Process."
private let instance = DataDownloader(name: defaultDownloaderName)


/**
The error code.

- BadData: The downloaded data is not an image or the data is corrupted.
- NotModified: The remote server responsed a 304 code. No image data downloaded.
- InvalidURL: The URL is invalid.
*/
public enum BlackCatError: Int {
  case badData = 10000
  case notModified = 10001
  case invalidURL = 20000
}

/**
*	Protocol of `ImageDownloader`.
*/
@objc public protocol DataDownloaderDelegate {
  /**
  Called when the `ImageDownloader` object successfully downloaded an image from specified URL.
  
  :param: downloader The `ImageDownloader` object finishes the downloading.
  :param: image      Downloaded image.
  :param: URL        URL of the original request URL.
  :param: response   The response object of the downloading process.
  */
  @objc optional func dataDownloader(_ downloader: DataDownloader, didDownloadData data: Data, forURL URL: URL, withResponse response: URLResponse)
}

/**
*	`ImageDownloader` represents a downloading manager for requesting the image with a URL from server.
*/
open class DataDownloader: NSObject {
  
  class DataFetchLoad {
    var callbacks = [CallbackPair]()
    var responseData = NSMutableData()
//    var shouldDecode = false
//    var scale = BlackCatManager.DefaultOptions.scale
  }
  
  // MARK: - Public property
  
  /// This closure will be applied to the image download request before it being sent. You can modify the request for some customizing purpose, like adding auth token to the header or do a url mapping.
  open var requestModifier: ((URLRequest) -> Void)?
  
  /// The duration before the download is timeout. Default is 15 seconds.
  open var downloadTimeout: TimeInterval = 15.0
  
  /// A set of trusted hosts when receiving server trust challenges. A challenge with host name contained in this set will be ignored. You can use this set to specify the self-signed site.
  open var trustedHosts: Set<String>?
  
  /// Delegate of this `ImageDownloader` object. See `ImageDownloaderDelegate` protocol for more.
  open weak var delegate: DataDownloaderDelegate?
  
  // MARK: - Internal property
  let barrierQueue: DispatchQueue
  let processQueue: DispatchQueue
  
  typealias CallbackPair = (progressBlock: DataDownloaderProgressBlock?, completionHander: DataDownloaderCompletionHandler?)
  
  var fetchLoads = [URL: DataFetchLoad]()
  
  // MARK: - Public method
  /// The default downloader.
  open class var defaultDownloader: DataDownloader {
    return instance
  }
  
  /**
  Init a downloader with name.
  
  :param: name The name for the downloader. It should not be empty.
  
  :returns: The downloader object.
  */
  public init(name: String) {
    if name.isEmpty {
      fatalError("[BlackCat] You should specify a name for the downloader. A downloader with empty name is not permitted.")
    }
    
    barrierQueue = DispatchQueue(label: downloaderBarrierName + name, attributes: DispatchQueue.Attributes.concurrent)
    processQueue = DispatchQueue(label: imageProcessQueueName + name, attributes: DispatchQueue.Attributes.concurrent)
  }
  
  func fetchLoadForKey(_ key: URL) -> DataFetchLoad? {
    var fetchLoad: DataFetchLoad?
    barrierQueue.sync(execute: { () -> Void in
      fetchLoad = self.fetchLoads[key]
    })
    return fetchLoad
  }
}

// MARK: - Download method
public extension DataDownloader {
  /**
  Download an image with a URL.
  
  :param: URL               Target URL.
  :param: progressBlock     Called when the download progress updated.
  :param: completionHandler Called when the download progress finishes.
  */
  public func downloadImageWithURL(_ URL: Foundation.URL,
    progressBlock: DataDownloaderProgressBlock?,
    completionHandler: DataDownloaderCompletionHandler?)
  {
    downloadDataWithURL(URL, options: BlackCatManager.DefaultOptions, progressBlock: progressBlock, completionHandler: completionHandler)
  }
  
  /**
  Download an image with a URL and option.
  
  :param: URL               Target URL.
  :param: options           The options could control download behavior. See `BlackCatManager.Options`
  :param: progressBlock     Called when the download progress updated.
  :param: completionHandler Called when the download progress finishes.
  */
  public func downloadDataWithURL(_ URL: Foundation.URL,
    options: BlackCatManager.Options,
    progressBlock: DataDownloaderProgressBlock?,
    completionHandler: DataDownloaderCompletionHandler?)
  {
    downloadDataWithURL(URL,
      retrieveImageTask: nil,
      options: options,
      progressBlock: progressBlock,
      completionHandler: completionHandler)
  }
  
  internal func downloadDataWithURL(_ URL: Foundation.URL,
    retrieveImageTask: RetrieveDataTask?,
    options: BlackCatManager.Options,
    progressBlock: DataDownloaderProgressBlock?,
    completionHandler: DataDownloaderCompletionHandler?)
  {
    let timeout = self.downloadTimeout == 0.0 ? 15.0 : self.downloadTimeout
    
    // We need to set the URL as the load key. So before setup progress, we need to ask the `requestModifier` for a final URL.
//    let request = NSMutableURLRequest(url: URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeout)
    var request = URLRequest(url: URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeout)
    request.httpShouldUsePipelining = true
    
    self.requestModifier?(request)
    
    // There is a possiblility that request modifier changed the url to `nil`
    if request.url == nil {
      completionHandler?(nil, NSError(domain: BlackCatErrorDomain, code: BlackCatError.invalidURL.rawValue, userInfo: nil), nil)
      return
    }
    
    setupProgressBlock(progressBlock, completionHandler: completionHandler, forURL: request.url!) {(session, fetchLoad) -> Void in
      
      let task = session.dataTask(with: request) as URLSessionDataTask
//      session.da
//      session.dataTask(with: <#T##URLRequest#>)
//      session.dataTask(with: request)
      
      task.priority = options.lowPriority ? URLSessionTask.lowPriority : URLSessionTask.defaultPriority
      task.resume()
      
      retrieveImageTask?.downloadTask = task
    }
  }
  
  // A single key may have multiple callbacks. Only download once.
  internal func setupProgressBlock(_ progressBlock: DataDownloaderProgressBlock?, completionHandler: DataDownloaderCompletionHandler?, forURL URL: Foundation.URL, started: ((Foundation.URLSession, DataFetchLoad) -> Void)) {
    
    barrierQueue.sync(flags: .barrier, execute: { () -> Void in
      
      var create = false
      var loadObjectForURL = self.fetchLoads[URL]
      if  loadObjectForURL == nil {
        create = true
        loadObjectForURL = DataFetchLoad()
      }
      
      let callbackPair = (progressBlock: progressBlock, completionHander: completionHandler)
      loadObjectForURL!.callbacks.append(callbackPair)
      self.fetchLoads[URL] = loadObjectForURL!
      
      if create {
        let session = Foundation.URLSession(configuration: URLSessionConfiguration.ephemeral, delegate: self, delegateQueue:OperationQueue.main)
        started(session, loadObjectForURL!)
      }
    })
  }
  
  func cleanForURL(_ URL: Foundation.URL) {
    barrierQueue.sync(flags: .barrier, execute: { () -> Void in
      self.fetchLoads.removeValue(forKey: URL)
      return
    })
  }
}

// MARK: - NSURLSessionTaskDelegate
extension DataDownloader: URLSessionDataDelegate {
  /**
  This method is exposed since the compiler requests. Do not call it.
  */
  public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
    
    if let URL = dataTask.originalRequest?.url, let callbackPairs = fetchLoadForKey(URL)?.callbacks {
      for callbackPair in callbackPairs {
        callbackPair.progressBlock?(0, response.expectedContentLength)
      }
    }
    completionHandler(Foundation.URLSession.ResponseDisposition.allow)
  }
  
  /**
  This method is exposed since the compiler requests. Do not call it.
  */
  public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    
    if let URL = dataTask.originalRequest?.url, let fetchLoad = fetchLoadForKey(URL) {
      fetchLoad.responseData.append(data)
      for callbackPair in fetchLoad.callbacks {
        callbackPair.progressBlock?(Int64(fetchLoad.responseData.length), dataTask.response!.expectedContentLength)
      }
    }
  }
  
  fileprivate func callbackWithData(_ data: Data?, error: NSError?, URL: Foundation.URL) {
    if let callbackPairs = fetchLoadForKey(URL)?.callbacks {
      
      self.cleanForURL(URL)
      
      for callbackPair in callbackPairs {
        callbackPair.completionHander?(data, error, URL)
      }
    }
  }
  
  /**
  This method is exposed since the compiler requests. Do not call it.
  */
  public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    
    if let URL = task.originalRequest?.url {
      if let error = error { // Error happened
        callbackWithData(nil, error: error as NSError?, URL: URL)
      } else { //Download finished without error
        
        // We are on main queue when receiving this.
        processQueue.async(execute: { () -> Void in
          
          if let fetchLoad = self.fetchLoadForKey(URL) {
            let data = fetchLoad.responseData
            if data.length > 0 {
              self.delegate?.dataDownloader?(self, didDownloadData: data as Data, forURL: URL, withResponse: task.response!)
              
//              if fetchLoad.shouldDecode {
//                self.callbackWithImage(image.kf_decodedImage(scale: fetchLoad.scale), error: nil, imageURL: URL)
//              } else {
                self.callbackWithData(data as Data, error: nil, URL: URL)
//              }
              
            } else {
              // If server response is 304 (Not Modified), inform the callback handler with NotModified error.
              // It should be handled to get an image from cache, which is response of a manager object.
              if let res = task.response as? HTTPURLResponse, res.statusCode == 304 {
                self.callbackWithData(nil, error: NSError(domain: BlackCatErrorDomain, code: BlackCatError.notModified.rawValue, userInfo: nil), URL: URL)
                return
              }
              
              self.callbackWithData(nil, error: NSError(domain: BlackCatErrorDomain, code: BlackCatError.badData.rawValue, userInfo: nil), URL: URL)
            }
          } else {
            self.callbackWithData(nil, error: NSError(domain: BlackCatErrorDomain, code: BlackCatError.badData.rawValue, userInfo: nil), URL: URL)
          }
        })
      }
    }
  }
  
  /**
  This method is exposed since the compiler requests. Do not call it.
  */
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let trustedHosts = trustedHosts, trustedHosts.contains(challenge.protectionSpace.host) {
                let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                completionHandler(.useCredential, credential)
                return
            }
        }
        
        completionHandler(.performDefaultHandling, nil)
        
    }
    
//  public func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) {
//    
//    if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
//      if let trustedHosts = trustedHosts where trustedHosts.contains(challenge.protectionSpace.host) {
//        let credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
//        completionHandler(.UseCredential, credential)
//        return
//      }
//    }
//    
//    completionHandler(.PerformDefaultHandling, nil)
//  }
  
}
