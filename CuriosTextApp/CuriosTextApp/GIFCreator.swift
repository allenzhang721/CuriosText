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
        case cached(GIFURL: URL, thumbURL: URL)
        case noCached
    }
    
    static fileprivate var instance: GIFCreator?
    
    fileprivate let queue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background)
    
    fileprivate var thumbImage: UIImage?
    fileprivate var images = [UIImage]()
    fileprivate var delays = [CGFloat]()
    fileprivate var fileURL: URL!
    fileprivate var thumbURL: URL!
    
    fileprivate var cached = false
    fileprivate var thumbCached = false
    fileprivate var useCache = true
    fileprivate var completedBlock:((_ gifURL: URL, _ thumbURL: URL) -> ())?
    
    class func beganWith(_ ID: String, images: [UIImage] = [], delays: [CGFloat] = [], useCache: Bool = true) -> CacheStatus {
        GIFCreator.instance = GIFCreator()
        guard let instance = GIFCreator.instance, images.count == delays.count
            else { fatalError("The images count is not equal to the delays' count!")}
        
        let cacheDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        let gifURL = URL(fileURLWithPath: cacheDir + "/" + ID + ".gif", isDirectory: false)
        let thumbURL = URL(fileURLWithPath: cacheDir + "/" + ID + ".png", isDirectory: false)
        let cached = FileManager.default.fileExists(atPath: gifURL.path)
        let thumbCached = FileManager.default.fileExists(atPath: thumbURL.path)
        
        instance.fileURL = gifURL
        instance.thumbURL = thumbURL
        instance.cached = cached && thumbCached
        instance.useCache = useCache

        instance.images = images
        instance.delays = delays
        
        return cached && thumbCached && useCache ? CacheStatus.cached(GIFURL: gifURL, thumbURL: thumbURL) : CacheStatus.noCached
    }
    
    class func setThumbImage(_ image: UIImage) {
        guard let instance = GIFCreator.instance else {return}
        instance.thumbImage = image
    }
    
    class func addImage(_ image: UIImage, delay: CGFloat) {
        guard let instance = GIFCreator.instance else {return}
        instance.images.append(image)
        instance.delays.append(delay)
    }
    
    class func addImages(_ images: [UIImage], delays: [CGFloat]) {
        guard let instance = GIFCreator.instance, images.count == delays.count else {return}
        instance.images += images
        instance.delays += delays
    }
    
    class func commitWith(_ completed: ((_ url: URL, _ thumbURL: URL) -> ())?) {
        guard let instance = GIFCreator.instance else {return}
        if instance.cached && instance.useCache {
            completed?(instance.fileURL, instance.thumbURL)
            return
        }
        let count = instance.images.count
        
        let destination = CGImageDestinationCreateWithURL(instance.fileURL as CFURL, kUTTypeGIF, count, nil)!
        let gifProperties = [(kCGImagePropertyGIFDictionary as String):[(kCGImagePropertyGIFLoopCount as String): 0]]
        CGImageDestinationSetProperties(destination, gifProperties as CFDictionary?)
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async {
            
            if instance.thumbImage == nil {
                instance.thumbImage = instance.images.last
            }
            
            if let thumbImage = instance.thumbImage {
                if FileManager.default.fileExists(atPath: instance.thumbURL.path) {
                try! FileManager.default.removeItem(at: instance.thumbURL)
                }
                let data = UIImagePNGRepresentation(thumbImage)
                try? data?.write(to: instance.thumbURL, options: [])
            }
            
            for i in 0..<count {
                autoreleasepool {
                    let image = instance.images[i]
                    let delay = instance.delays[i]
                    let frameProperties = [(kCGImagePropertyGIFDictionary as String): [(kCGImagePropertyGIFDelayTime as String): delay]]
                    CGImageDestinationAddImage(destination, image.cgImage!, frameProperties as CFDictionary?)
                }
            }
            
            if CGImageDestinationFinalize(destination) {
                print("gif at \(instance.fileURL.path)")
                DispatchQueue.main.async(execute: { 
                    completed?(instance.fileURL, instance.thumbURL)
                    instance.images = []
                    instance.delays = []
                })
            } else {
                print("gif create failture")
            }
        }
    }
}
