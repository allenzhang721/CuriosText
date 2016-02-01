//
//  CTAEncryptManager.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 2/1/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

class CTAEncryptManager {
    
    class func hash256(string: String) -> String {
        
       return AESCrypt.hash256(string)
    }
}