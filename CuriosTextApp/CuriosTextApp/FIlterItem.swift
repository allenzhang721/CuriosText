//
//  FIlterItem.swift
//  FiltersSample
//
//  Created by Emiaostein on 6/23/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import Foundation
import UIKit

private let queue = dispatch_queue_create("com.botai.curiosText.Filter.Queue", DISPATCH_QUEUE_CONCURRENT)

class FilterItem: NSObject {
    let name: String
    var data: NSData?
    private(set) var assetIdentifier: String
    private(set) var image: UIImage?
    
    init(name: String, data: NSData?) {
        self.name = name
        self.data = data
        self.assetIdentifier = NSUUID().UUIDString.characters.split("-").map{String($0)}.reduce("", combine:{$0+$1})
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        self.name = aDecoder.decodeObjectForKey("name") as! String
//        self.data = aDecoder.decodeObjectForKey("data") as! NSData
//        self.assetIdentifier = aDecoder.decodeObjectForKey("ID") as! String
//    }
//    
//    func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encodeObject(name, forKey: "name")
//        aCoder.encodeObject(data, forKey: "data")
//        aCoder.encodeObject(assetIdentifier, forKey: "ID")
//    }
    
    deinit {
        print("\(#file) deinit")
    }
    
    func cleanImage() {
        image = nil
    }
    
    func createImage(from img: UIImage, complation:((UIImage) -> ())?) {
        let ciimage = CIImage(image: img)
        dispatch_async(queue) { [weak self] in
            guard let sf = self, let data = sf.data else {return}
            let img2 = Filter()
                .colorLUT(colorTableData: data, dimension: 64)
                .start(byImage: ciimage!)
                .tocgImage()
            dispatch_async(dispatch_get_main_queue(), {[weak self] in
                guard let sf = self else {return}
                sf.image = UIImage(CGImage: img2)
                complation?(sf.image!)
            })
        }
    }
    
    func createData(fromColorDirAt url: NSURL, filtering image: UIImage, complation:((UIImage) -> ())?) {
        
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            guard let sf = self else {return}
            let cacheURL = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask).first!
            let dataCache = cacheURL.URLByAppendingPathComponent("\(sf.name)")
            if NSFileManager.defaultManager().fileExistsAtPath(dataCache.path!) {
                let data = NSData(contentsOfURL: dataCache)
                sf.data = data
                sf.createImage(from: image, complation: complation)
            } else {
                let imgURL = url.URLByAppendingPathComponent("\(sf.name).JPG")
                if let img = UIImage(contentsOfFile: imgURL.path!)?.CGImage, data = Filter.colorLUTData(byImage: img, dimensiton: 64) {
                    sf.data = data
                    data.writeToURL(dataCache, atomically: true)
                    sf.createImage(from: image, complation: complation)
                }
            }
        }
    }
}
