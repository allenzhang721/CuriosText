//
//  CTADocumentAccesser.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/15/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation

protocol CTADocumentAccesser: class {
    
    var pageData: NSData { get }
    func retrivedPageData(data: NSData?)
}