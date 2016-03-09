//
//  LocalizationManager.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 3/9/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

enum LocalStrings: CustomStringConvertible {

    case EditTextPlaceHolder
    
    var description: String {
        
        switch self {
        case .EditTextPlaceHolder:
            return NSLocalizedString("EditTextPlaceHolder", comment: "")
        }
        
    }
}
