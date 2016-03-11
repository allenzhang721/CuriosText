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
        static let resource = "resource" // resource directory
        static let page = "page" // page file
    }
    
    var page: CTAPage?
    
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
    
    var resourcePath: String {
//        return fileURL.lastPathComponent! + "/" + "\(WrapperKey.resource)" + "/"
        return ""
    }
    
    var imagePath: NSURL {
        return fileURL.URLByAppendingPathComponent(WrapperKey.resource)
    }
    
    var documentName: String {
        return fileURL.lastPathComponent!
    }
    
    init(fileURL url: NSURL, page: CTAPage?) {
        self.page = page ?? CTAPage(containers: [])
        super.init(fileURL: url)
    }
    
    override func loadFromContents(contents: AnyObject, ofType typeName: String?) throws {
        
        guard let contents = contents as? NSFileWrapper where contents.directory else {
            throw NSError(domain: NSCocoaErrorDomain , code: 100, userInfo: nil)
        }
        
        rootWrapper = contents
        
        // Fetch the page file data
        let data = root.fileWrappers?[WrapperKey.page]?.regularFileContents
//        page?.retrivedPageData(root.fileWrappers?[WrapperKey.page]?.regularFileContents)
        
        page = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? CTAPage
    }
    
    /*
    The document data to be saved, or nil if you cannot return document data. 
    
    The returned object is typically an instance of the NSData class for flat files or the NSFileWrapper class for file packages. 
    
    If you return nil, you should also return an error object in outError.
    */
    override func contentsForType(typeName: String) throws -> AnyObject {
        
//        if root.fileWrappers?[WrapperKey.page] == nil {
        let cleanPage = page!.cleanEmptyContainers()
        let pageData = NSKeyedArchiver.archivedDataWithRootObject(cleanPage)
        let pageWrapper = NSFileWrapper(regularFileWithContents: pageData)
        if let prePage = root.fileWrappers?[WrapperKey.page] {
            root.removeFileWrapper(prePage)
        }
        pageWrapper.preferredFilename = WrapperKey.page
        root.addFileWrapper(pageWrapper)
        root.addFileWrapper(res)

        return rootWrapper
    }
    
    func storeResource(data: NSData, withName name: String) -> String {
        
        if let file = res.fileWrappers?[name] {
            res.removeFileWrapper(file)
        }
        let resWrap = NSFileWrapper(regularFileWithContents: data)
        resWrap.preferredFilename = name
        return res.addFileWrapper(resWrap)
    }

    // get
    func resourceBy(name: String) -> NSData? {
        
        return resWrapper.fileWrappers?[name]?.regularFileContents
    }
    
    func imageBy(name: String) -> UIImage? {
        
        if let data = resourceBy(name) {
            return UIImage(data: data)
        } else {
            return nil
        }
        
    }
}

extension CTADocument {
    
    func filePaths() -> (String , [String: String]) { // relativePath: filePath
        
    var filePaths = [String: String]()
        let url = fileURL
        let publishID = fileURL.lastPathComponent!
        let pageUrl = url.URLByAppendingPathComponent(WrapperKey.page)
        let resDirUrl = url.URLByAppendingPathComponent(WrapperKey.resource)
    
        let pagePath = publishID + "/" + WrapperKey.page
        
        
        filePaths[pagePath] = pageUrl.path!
        
        if let resourceFileWrappers = res.fileWrappers {
            
            for r in resourceFileWrappers.values {
                if let fileName = r.filename where r.regularFile {
                    let resUrl = resDirUrl.URLByAppendingPathComponent(fileName)
                    let resPath = publishID + "/" + fileName
                    
                    filePaths[resPath] = resUrl.path!
                }
            }
        }
        
        return (pagePath, filePaths)
    }
}