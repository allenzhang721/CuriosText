//
//  CTAImageCropAttributes.swift
//  ImagePickerApp
//
//  Created by Emiaostein on 2/28/16.
//  Copyright © 2016 Emiaostein. All rights reserved.
//

import Foundation
import UIKit

enum CTAImageCropAspectRatio: CustomStringConvertible {
    case original
    case square
    case r3x2, r5x4, r5x3, r4x3, r7x5, r16x9
    case r2x3, r4x5, r3x5, r3x4, r5x7, r9x16
    
    func minumSize() -> CGSize {
        
        switch self {
        case .square:
            return CGSize(width: 1, height: 1)
        case .r3x2:
            return CGSize(width: 3, height: 2)
        case .r5x4:
            return CGSize(width: 5, height: 4)
        case .r5x3:
            return CGSize(width: 5, height: 3)
        case .r4x3:
            return CGSize(width: 3, height: 3)
        case .r7x5:
            return CGSize(width: 7, height: 5)
        case .r16x9:
            return CGSize(width: 16, height: 9)
        case .r2x3:
            return CGSize(width: 2, height: 3)
        case .r4x5:
            return CGSize(width: 4, height: 5)
        case .r3x5:
            return CGSize(width: 3, height: 5)
        case .r3x4:
            return CGSize(width: 3, height: 4)
        case .r5x7:
            return CGSize(width: 5, height: 7)
        case .r9x16:
            return CGSize(width: 9, height: 16)
        case .original:
            return CGSize(width: 1, height: 1)
        }
    }
    
    var description: String {
        
        switch self {
        case .square:
            return "1:1"
        case .r3x2:
            return "3:2"
        case .r5x4:
            return "5:4"
        case .r5x3:
            return "5:3"
        case .r4x3:
            return "4:3"
        case .r7x5:
            return "7:5"
        case .r16x9:
            return "16:9"
        case .r2x3:
            return "2:3"
        case .r4x5:
            return "4:5"
        case .r3x5:
            return "3:5"
        case .r3x4:
            return "3:4"
        case .r5x7:
            return "5:7"
        case .r9x16:
            return "9:16"
        case .original:
            return "1:1"
        }
    }
    
    static let defaultRatio = [square, r3x2, r5x4, r5x3, r4x3, r7x5, r16x9, r2x3, r4x5, r3x5, r3x4, r5x7, r9x16]
    
    static func randomRatio() -> CTAImageCropAspectRatio {
        let ratios: [CTAImageCropAspectRatio] = [square, r3x2, r5x4, r5x3, r4x3, r7x5, r16x9, r2x3, r4x5, r3x5, r3x4, r5x7, r9x16]
        
        let i = arc4random() % UInt32(ratios.count)
        return ratios[Int(i)]
    }
}
