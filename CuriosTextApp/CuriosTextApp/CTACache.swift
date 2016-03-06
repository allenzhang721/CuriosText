import Foundation
import UIKit
import PromiseKit

public class CTAImageCache {
    
    let name: String
    let image: UIImage
    
    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }
}

public class CTACache {
    
    let cache = NSCache()
    public var cacheFinished = false
    public var cacheDidFinishedHandler: ((Bool) -> ())?
    
    func save(object: AnyObject, forKey key: String) {
        cache.setObject(object, forKey: key)
    }
    
    public func saveImage(image: UIImage, forKey key: String) {
        save(image, forKey: key)
    }
    
    public func saveText(text: NSAttributedString, forKey key: String) {
        save(text, forKey: key)
    }
    
    func objectForKey(key: String) -> AnyObject? {
        return cache.objectForKey(key)
    }
    
    public func imageForKey(key: String) -> UIImage? {
        return cache.objectForKey(key) as? UIImage
    }
    
    public func textForKey(key: String) -> NSAttributedString? {
        return cache.objectForKey(key) as? NSAttributedString
    }
    
//    public func saveImageCache(c: CTAImageCache, forKey key: String) {
//        save(c, forKey: key)
//    }
//    
//    public func imageCacheForKey(key: String) -> CTAImageCache? {
//        return cache.objectForKey(key) as? CTAImageCache
//    }
    
    public func cleanALLObject() {
        cacheFinished = false
        cache.removeAllObjects()
        
    }
    
    public func saveAsyncImagesForKeys(keys: [String], baseURL: NSURL, f: (NSURL, String) -> Promise<Result<CTAImageCache>> ,completedHandler:((Bool) -> ())?) {
        
        var promises = [Promise<Result<CTAImageCache>>]()
        for (_, k) in keys.enumerate() {
           let pro = f(baseURL, k)
            promises.append(pro)
        }
        
        when(promises).then {[weak self] (results) -> () in
            guard let strongSelf = self else {
                return
            }
            
            for r in results {
                switch r {
                case .Success(let imageCache):
                    let image = imageCache.image
                    let key = imageCache.name
                    strongSelf.saveImage(image, forKey: key)
                default:
                    ()
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                strongSelf.cacheFinished = true
                completedHandler?(true)
                strongSelf.cacheDidFinishedHandler?(true)
            })
        }
    }
    
    public init() {
        
    }
    
    func dealloc() {
        cache.removeAllObjects()
    }
}



