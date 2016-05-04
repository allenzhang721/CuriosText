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
    //    var propgressBlock: ((CGFloat) -> ())?
    // DISPATCH_QUEUE_SERIAL
    // DISPATCH_QUEUE_CONCURRENT
    static private var instance: GIFCreator?
    
    private let queue = dispatch_queue_create("com.emiaostein.GIFCreator.Queue", DISPATCH_QUEUE_SERIAL)
    private let cacheDir = "com.botai.gifCache"
    private var images = [UIImage]()
    private var delays = [CGFloat]()
    private var fileURL: NSURL!
    private var destination: CGImageDestination?
    private var cached = false
    private var ignoreCache = false
    private var completedBlock:((url: NSURL) -> ())?
    
    class func beganWith(ID: String, images: [UIImage] = [], delays: [CGFloat] = [], ignoreCache: Bool = false) {
        GIFCreator.instance = GIFCreator()
        guard let instance = GIFCreator.instance else {return}
        
        let cacheDir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first!
        let gifURL = NSURL(fileURLWithPath: cacheDir + "/" + ID + ".gif", isDirectory: false)
        let cached = NSFileManager.defaultManager().fileExistsAtPath(gifURL.path!)
        
        instance.fileURL = gifURL
        instance.cached = cached
        instance.ignoreCache = ignoreCache
    
        guard images.count == delays.count else {
            print("The images count is not equal to the delays' count!")
            return
        }
        
        instance.images = images
        instance.delays = delays
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
    
    class func commitWith(completed: ((url: NSURL) -> ())?) {
        guard let instance = GIFCreator.instance else {return}
        if instance.cached && !instance.ignoreCache {
            completed?(url: instance.fileURL)
            return
        }
        let count = instance.images.count
        
        let destination = CGImageDestinationCreateWithURL(instance.fileURL, kUTTypeGIF, count, nil)!
        let gifProperties = [(kCGImagePropertyGIFLoopCount as String): 0]
        CGImageDestinationSetProperties(destination, gifProperties)
        
        dispatch_async(instance.queue) {
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
                    completed?(url: instance.fileURL)
                    instance.images = []
                    instance.delays = []
                })
            } else {
                print("gif create failture")
            }
        }
    }
}