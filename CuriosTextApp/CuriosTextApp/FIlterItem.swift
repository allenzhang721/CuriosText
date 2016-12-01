//
//  FIlterItem.swift
//  FiltersSample
//
//  Created by Emiaostein on 6/23/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import Foundation
import UIKit

private let queue = DispatchQueue(label: "com.botai.curiosText.Filter.Queue", attributes: DispatchQueue.Attributes.concurrent)

class FilterItem: NSObject {
    let name: String
    var data: Data?
    fileprivate(set) var assetIdentifier: String
    fileprivate(set) var image: UIImage?
    
    init(name: String, data: Data?) {
        self.name = name
        self.data = data
        self.assetIdentifier = UUID().uuidString.characters.split(separator: "-").map{String($0)}.reduce("", {$0+$1})
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
        debug_print("\(#file) deinit", context: deinitContext)
    }
    
    func cleanImage() {
        image = nil
    }
    
    func createImage(from img: UIImage, complation:((UIImage) -> ())?) {
        let ciimage = CIImage(image: img)
        queue.async { [weak self] in
            guard let sf = self, let data = sf.data else {return}
            let img2 = Filter()
                .colorLUT(colorTableData: data, dimension: 64)
                .start(byImage: ciimage!)
                .tocgImage()
            DispatchQueue.main.async(execute: {[weak self] in
                guard let sf = self else {return}
                
                sf.image = UIImage(cgImage: img2)
                complation?(sf.image!)
                sf.data = nil
            })
        }
    }
    
    func createData(fromColorDirAt url: URL, filtering image: UIImage? = nil, complation:((UIImage) -> ())?) {
        
        queue.async { [weak self] in
            guard let sf = self else {return}
            let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let dataCache = cacheURL.appendingPathComponent("\(sf.name)")
            if FileManager.default.fileExists(atPath: dataCache.path) {
                if let image = image {
                    let data = try? Data(contentsOf: dataCache)
                    sf.data = data
                    sf.createImage(from: image, complation: complation)
                }
                
            } else {
                let imgURL = url.appendingPathComponent("\(sf.name).JPG")
                if let img = UIImage(contentsOfFile: imgURL.path)?.cgImage, let data = Filter.colorLUTData(byImage: img, dimensiton: 64) {
                    try? data.write(to: dataCache, options: [.atomic])
                    if let image = image {
                        sf.data = data as Data
                        sf.createImage(from: image, complation: complation)
                    }
                }
            }
        }
    }
}
