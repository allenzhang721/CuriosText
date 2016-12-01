import Foundation
import UIKit
import PromiseKit
import Kingfisher

open class CTAImageCache {
  
  let name: String
  let image: UIImage
  
  init(name: String, image: UIImage) {
    self.name = name
    self.image = image
  }
}

open class CTACache {
  
  let cache = NSCache<AnyObject, AnyObject>()
  open var cacheFinished = false
  open var cacheDidFinishedHandler: ((Bool) -> ())?
  
  func save(_ object: AnyObject, forKey key: String) {
    cache.setObject(object, forKey: key as AnyObject)
  }
  
  open func saveImage(_ image: UIImage, forKey key: String) {
    save(image, forKey: key)
  }
  
  open func saveText(_ text: NSAttributedString, forKey key: String) {
    save(text, forKey: key)
  }
  
  func objectForKey(_ key: String) -> AnyObject? {
    return cache.object(forKey: key as AnyObject)
  }
  
  open func imageForKey(_ key: String) -> UIImage? {
    return cache.object(forKey: key as AnyObject) as? UIImage
  }
  
  open func textForKey(_ key: String) -> NSAttributedString? {
    return cache.object(forKey: key as AnyObject) as? NSAttributedString
  }
  
  //    public func saveImageCache(c: CTAImageCache, forKey key: String) {
  //        save(c, forKey: key)
  //    }
  //
  //    public func imageCacheForKey(key: String) -> CTAImageCache? {
  //        return cache.objectForKey(key) as? CTAImageCache
  //    }
  
  open func cleanALLObject() {
    cacheFinished = false
    cache.removeAllObjects()
    
  }
  
  open func saveAsyncImagesForKeys(_ keys: [String], baseURL: URL, f: (URL, String) -> Promise<AResult<CTAImageCache>> ,completedHandler:((Bool) -> ())?) {
    
    var promises = [Promise<AResult<CTAImageCache>>]()
    for (_, k) in keys.enumerated() {
      let pro = f(baseURL, k)
      promises.append(pro)
    }
    
    when(resolved: promises).then {[weak self] (results: [Result<AResult<CTAImageCache>>]) -> () in
      guard let sf = self else { return }
      
      for r in results {
        switch r {
        case .fulfilled(let res):
          switch res {
          case .success(let imgCache):
            let image = imgCache.image
            let key = imgCache.name
            sf.saveImage(image, forKey: key)
          default:
            ()
          }
          
        default:
          ()
          
        }
      }
      
      DispatchQueue.main.async {
        sf.cacheFinished = true
        completedHandler?(true)
        sf.cacheDidFinishedHandler?(true)
      }
      
    }
    
    
    //      when(resolved:promises).then {[weak self] (results) -> () in
    //            guard let strongSelf = self else {
    //                return
    //            }
    //
    //            for r in results {
    //                switch r {
    //                case .success(let imageCache):
    //                    let image = imageCache.image
    //                    let key = imageCache.name
    //                    strongSelf.saveImage(image, forKey: key)
    //                default:
    //                    ()
    //                }
    //            }
    //
    ////            dispatch_async(dispatch_get_main_queue(), {
    ////                strongSelf.cacheFinished = true
    ////                completedHandler?(true)
    ////                strongSelf.cacheDidFinishedHandler?(true)
    ////            })
    //
    //          DispatchQueue.main.async {
    //            strongSelf.cacheFinished = true
    //            completedHandler?(true)
    //            strongSelf.cacheDidFinishedHandler?(true)
    //          }
    //
    //        }
  }
  
  public init() {
    
  }
  
  func dealloc() {
    cache.removeAllObjects()
  }
}

func downloadImage(_ baseURL: NSURL, imageName: String) -> Promise<AResult<CTAImageCache>> {
  
  let imageURL = baseURL.appendingPathComponent(imageName)
  return Promise { fullfill, reject in
    
    KingfisherManager.shared.retrieveImage(with: imageURL!, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
      
      if let image = image {
        let cache = CTAImageCache(name: imageName, image: image)
        fullfill(AResult.success(cache))
      } else {
        fullfill(AResult.failure())
      }
    })
    
  }
}



