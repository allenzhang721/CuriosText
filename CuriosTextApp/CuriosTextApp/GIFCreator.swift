//
//  GIFCreator.swift
//  GIFCreator
//
//  Created by Emiaostein on 5/2/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import Foundation
import ImageIO
import MobileCoreServices
import UIKit

class GIFCreator {
    
    enum CacheStatus {
        case Cached(GIFURL: NSURL, thumbURL: NSURL)
        case NoCached
    }
    
    static private var instance: GIFCreator?
    
    private let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
    
    private var thumbImage: UIImage?
    private var images = [UIImage]()
    private var delays = [CGFloat]()
    private var fileURL: NSURL!
    private var thumbURL: NSURL!
    
    private var cached = false
    private var thumbCached = false
    private var useCache = true
    private var completedBlock:((gifURL: NSURL, thumbURL: NSURL) -> ())?
    
    class func beganWith(ID: String, images: [UIImage] = [], delays: [CGFloat] = [], useCache: Bool = true) -> CacheStatus {
        GIFCreator.instance = GIFCreator()
        guard let instance = GIFCreator.instance
            where images.count == delays.count
            else { fatalError("The images count is not equal to the delays' count!")}
        
        let cacheDir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first!
        let gifURL = NSURL(fileURLWithPath: cacheDir + "/" + ID + ".gif", isDirectory: false)
        let thumbURL = NSURL(fileURLWithPath: cacheDir + "/" + ID + ".png", isDirectory: false)
        let cached = NSFileManager.defaultManager().fileExistsAtPath(gifURL.path!)
        let thumbCached = NSFileManager.defaultManager().fileExistsAtPath(thumbURL.path!)
        
        instance.fileURL = gifURL
        instance.thumbURL = thumbURL
        instance.cached = cached && thumbCached
        instance.useCache = useCache

        instance.images = images
        instance.delays = delays
        
        return cached && thumbCached && useCache ? CacheStatus.Cached(GIFURL: gifURL, thumbURL: thumbURL) : CacheStatus.NoCached
    }
    
    class func setThumbImage(image: UIImage) {
        guard let instance = GIFCreator.instance else {return}
        instance.thumbImage = image
    }
    
    class func addImage(image: UIImage, delay: CGFloat) {
        guard let instance = GIFCreator.instance else {return}
        instance.images.append(image)
        instance.delays.append(delay)
    }
    
    class func addImages(images: [UIImage], delays: [CGFloat]) {
        guard let instance = GIFCreator.instance where images.count == delays.count else {return}
        instance.images += images
        instance.delays += delays
    }
    
    class func commitWith(completed: ((url: NSURL, thumbURL: NSURL) -> ())?) {
        guard let instance = GIFCreator.instance else {return}
        if instance.cached && instance.useCache {
            completed?(url: instance.fileURL, thumbURL: instance.thumbURL)
            return
        }
        let count = instance.images.count
        
        let destination = CGImageDestinationCreateWithURL(instance.fileURL, kUTTypeGIF, count, nil)!
        let gifProperties = [(kCGImagePropertyGIFDictionary as String):[(kCGImagePropertyGIFLoopCount as String): 0]]
        CGImageDestinationSetProperties(destination, gifProperties)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            
            if instance.thumbImage == nil {
                instance.thumbImage = instance.images.last
            }
            
            if let thumbImage = instance.thumbImage {
                if NSFileManager.defaultManager().fileExistsAtPath(instance.thumbURL.path!) {
                try! NSFileManager.defaultManager().removeItemAtURL(instance.thumbURL)
                }
                let data = UIImagePNGRepresentation(thumbImage)
                data?.writeToURL(instance.thumbURL, atomically: false)
            }
            
            for i in 0..<count {
                autoreleasepool {
                    let image = instance.images[i]
                    let delay = instance.delays[i]
                    let frameProperties = [(kCGImagePropertyGIFDictionary as String): [(kCGImagePropertyGIFDelayTime as String): delay]]
                    CGImageDestinationAddImage(destination, image.CGImage!, frameProperties)
                }
            }
            
            if CGImageDestinationFinalize(destination) {
                print("gif at \(instance.fileURL.path)")
                dispatch_async(dispatch_get_main_queue(), { 
                    completed?(url: instance.fileURL, thumbURL: instance.thumbURL)
                    instance.images = []
                    instance.delays = []
                })
            } else {
                print("gif create failture")
            }
        }
    }
}