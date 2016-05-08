//
//  CTAPhotoPickerDelegate.swift
//  ImagePickerApp
//
//  Created by Emiaostein on 3/1/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import Foundation
import UIKit

protocol CTAPhotoPickerDelegate: class {
    
    weak var pickerDelegate: CTAPhotoPickerProtocol? { get set }
}

protocol CTAPhotoPickerProtocol: class {
    
    func pickerDidSelectedImage(image: UIImage)
}

protocol CTAPhotoPickerTemplateable: class {
    var templateImage: UIImage? {get set}
}