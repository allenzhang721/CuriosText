//
//  CTADocumentProtocol.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 2/1/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

protocol CTADocumentAccessable {
    
    func filePaths() -> [String: String]
    
}