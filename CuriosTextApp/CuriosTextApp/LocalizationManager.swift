//
//  LocalizationManager.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 3/9/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

enum LocalStrings: CustomStringConvertible {

    case Cancel, Done         // Common
    case Camera, Photo  // Image Picker
    case Publish , EditTextPlaceHolder  // Editor
    case Size, Rotation, Font, Spacing, Alignment, Color, Animation, AnimationType, AnimationDuration, AnimationDelay    // Edior Tab
    case MoveIn, MoveOut //Animations
    
    var description: String {
        
        switch self {
            // Common
        case .Cancel:
            return NSLocalizedString("Cancel", comment: "")
        case .Done:
            return NSLocalizedString("Done", comment: "")
            
            // Image Picker
        case .Camera:
            return NSLocalizedString("Camera", comment: "")
        case .Photo:
            return NSLocalizedString("Photo", comment: "")
            
            // Editor
        case .Publish:
            return NSLocalizedString("Publish", comment: "")
        case .EditTextPlaceHolder:
            return NSLocalizedString("EditTextPlaceHolder", comment: "")
            
            // Edior Tab
        case .Size:
            return NSLocalizedString("Size", comment: "")
        case .Rotation:
            return NSLocalizedString("Rotation", comment: "")
        case .Font:
            return NSLocalizedString("Font", comment: "")
        case .Spacing:
            return NSLocalizedString("Spacing", comment: "")
        case .Alignment:
            return NSLocalizedString("Alignment", comment: "")
        case .Color:
            return NSLocalizedString("Color", comment: "")
        case .Animation:
            return NSLocalizedString("Animation", comment: "")
        case .AnimationType:
            return NSLocalizedString("AnimationType", comment: "")
        case .AnimationDuration:
            return NSLocalizedString("AnimationDuration", comment: "")
        case .AnimationDelay:
            return NSLocalizedString("AnimationDelay", comment: "")
            
            // Animation
        case .MoveIn:
            return NSLocalizedString("MoveIn", comment: "")
        case .MoveOut:
            return NSLocalizedString("MoveOut", comment: "")
        }
        
    }
}
