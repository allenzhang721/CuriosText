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
    case Original
    case Square
    case R3x2, R5x4, R5x3, R4x3, R7x5, R16x9
    case R2x3, R4x5, R3x5, R3x4, R5x7, R9x16
    
    func minumSize() -> CGSize {
        
        switch self {
        case .Square:
            return CGSize(width: 1, height: 1)
        case .R3x2:
            return CGSize(width: 3, height: 2)
        case .R5x4:
            return CGSize(width: 5, height: 4)
        case .R5x3:
            return CGSize(width: 5, height: 3)
        case .R4x3:
            return CGSize(width: 3, height: 3)
        case .R7x5:
            return CGSize(width: 7, height: 5)
        case .R16x9:
            return CGSize(width: 16, height: 9)
        case .R2x3:
            return CGSize(width: 2, height: 3)
        case .R4x5:
            return CGSize(width: 4, height: 5)
        case .R3x5:
            return CGSize(width: 3, height: 5)
        case .R3x4:
            return CGSize(width: 3, height: 4)
        case .R5x7:
            return CGSize(width: 5, height: 7)
        case .R9x16:
            return CGSize(width: 9, height: 16)
        case .Original:
            return CGSize(width: 1, height: 1)
        }
    }
    
    var description: String {
        
        switch self {
        case .Square:
            return "1:1"
        case .R3x2:
            return "3:2"
        case .R5x4:
            return "5:4"
        case .R5x3:
            return "5:3"
        case .R4x3:
            return "4:3"
        case .R7x5:
            return "7:5"
        case .R16x9:
            return "16:9"
        case .R2x3:
            return "2:3"
        case .R4x5:
            return "4:5"
        case .R3x5:
            return "3:5"
        case .R3x4:
            return "3:4"
        case .R5x7:
            return "5:7"
        case .R9x16:
            return "9:16"
        case .Original:
            return "1:1"
        }
    }
    
    static let defaultRatio = [Square, R3x2, R5x4, R5x3, R4x3, R7x5, R16x9, R2x3, R4x5, R3x5, R3x4, R5x7, R9x16]
    
    static func randomRatio() -> CTAImageCropAspectRatio {
        let ratios: [CTAImageCropAspectRatio] = [Square, R3x2, R5x4, R5x3, R4x3, R7x5, R16x9, R2x3, R4x5, R3x5, R3x4, R5x7, R9x16]
        
        let i = random() % ratios.count
        return ratios[i]
    }
}