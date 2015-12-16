//
//  CTADocument.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/15/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation
import UIKit

class CTADocument: UIDocument {
    
    private struct WrapperKey {
        static let resource = "resource" // directory
        static let page = "page"
    }
    
    weak var accesser: CTADocumentAccesser?
    
    private var rootWrapper: NSFileWrapper!
    private var resWrapper: NSFileWrapper!
    
    var root: NSFileWrapper {
        rootWrapper = rootWrapper ?? NSFileWrapper(directoryWithFileWrappers: [String : NSFileWrapper]())
        return rootWrapper
    }
    
    var res: NSFileWrapper {
        
        if resWrapper == nil {
            
            if let resWrapper = rootWrapper.fileWrappers?[WrapperKey.resource] {
                
                self.resWrapper = resWrapper
                return resWrapper
            } else {
                
                resWrapper = NSFileWrapper(directoryWithFileWrappers: [String : NSFileWrapper]())
                resWrapper.preferredFilename = WrapperKey.resource
                return resWrapper
            }
        } else {
            return resWrapper
        }
    }
    
    init(fileURL url: NSURL, accesser: CTADocumentAccesser?) {
        self.accesser = accesser
        super.init(fileURL: url)
    }
    
    override func loadFromContents(contents: AnyObject, ofType typeName: String?) throws {
        
        guard let contents = contents as? NSFileWrapper where contents.directory else {
            throw NSError(domain: NSCocoaErrorDomain , code: 100, userInfo: nil)
        }
        
        rootWrapper = contents
        
        // Fetch the page file data
        accesser?.retrivedPageData(root.fileWrappers?[WrapperKey.page]?.regularFileContents)
    }
    
    /*
    The document data to be saved, or nil if you cannot return document data. 
    
    The returned object is typically an instance of the NSData class for flat files or the NSFileWrapper class for file packages. 
    
    If you return nil, you should also return an error object in outError.
    */
    override func contentsForType(typeName: String) throws -> AnyObject {
        
        if let pageData = accesser?.pageData {
            let pageWrapper = NSFileWrapper(regularFileWithContents: pageData)
            pageWrapper.preferredFilename = WrapperKey.page
            root.addFileWrapper(pageWrapper)
        }
        
        root.addFileWrapper(res)

        return rootWrapper
    }
    
    func storeResource(data: NSData, withName name: String) -> String {
        
        let resWrap = NSFileWrapper(regularFileWithContents: data)
        resWrap.preferredFilename = name
        return res.addFileWrapper(resWrap)
    }

    // get
    func resourceBy(name: String) -> NSData? {
        
        return resWrapper.fileWrappers?[name]?.regularFileContents
    }
}