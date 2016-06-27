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

class FilterItem: NSObject, NSCoding {
    let name: String
    let data: NSData
    private(set) var assetIdentifier: String
    private(set) var image: UIImage?
    
    init(name: String, data: NSData) {
        self.name = name
        self.data = data
        self.assetIdentifier = NSUUID().UUIDString.characters.split("-").map{String($0)}.reduce("", combine:{$0+$1})
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.data = aDecoder.decodeObjectForKey("data") as! NSData
        self.assetIdentifier = aDecoder.decodeObjectForKey("ID") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(data, forKey: "data")
        aCoder.encodeObject(assetIdentifier, forKey: "ID")
    }
    
    func cleanImage() {
        image = nil
    }
    
    func createImage(from img: UIImage, complation:(UIImage) -> ()) {
        let ciimage = CIImage(image: img)
        dispatch_async(queue) { [weak self] in
            guard let sf = self else {return}
            let img2 = Filter()
                .colorLUT(colorTableData: sf.data, dimension: 64)
                .start(byImage: ciimage!)
                .tocgImage()
            dispatch_async(dispatch_get_main_queue(), {[weak self] in
                guard let sf = self else {return}
                sf.image = UIImage(CGImage: img2)
                complation(sf.image!)
            })
        }
    }
}
