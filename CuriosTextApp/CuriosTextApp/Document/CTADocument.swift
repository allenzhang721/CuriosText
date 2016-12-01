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
    
    fileprivate struct WrapperKey {
        static let resource = "resource" // resource directory
        static let page = "page" // page file
    }
    
    var page: CTAPage?
    
    fileprivate var rootWrapper: FileWrapper!
    fileprivate var resWrapper: FileWrapper!
    
    fileprivate var cacheFileName: String?
    
    var root: FileWrapper {
        rootWrapper = rootWrapper ?? FileWrapper(directoryWithFileWrappers: [String : FileWrapper]())
        return rootWrapper
    }
    
    var res: FileWrapper {
        
        if resWrapper == nil {
            
            if let resWrapper = rootWrapper.fileWrappers?[WrapperKey.resource] {
                
                self.resWrapper = resWrapper
                return resWrapper
            } else {
                
                resWrapper = FileWrapper(directoryWithFileWrappers: [String : FileWrapper]())
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
    
    var cacheImagePath: URL {
        let fileManager = FileManager.default
        let cache = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cache
    }
    
    var imagePath: URL {
        return fileURL.appendingPathComponent(WrapperKey.resource)
    }
    
    var documentName: String {
        return fileURL.lastPathComponent
    }
    
    init(fileURL url: URL, page: CTAPage?) {
        self.page = page ?? CTAPage(containers: [])
        super.init(fileURL: url)
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        
        guard let contents = contents as? FileWrapper, contents.isDirectory else {
            throw NSError(domain: NSCocoaErrorDomain , code: 100, userInfo: nil)
        }
        
        rootWrapper = contents
        
        // Fetch the page file data
        let data = root.fileWrappers?[WrapperKey.page]?.regularFileContents
//        page?.retrivedPageData(root.fileWrappers?[WrapperKey.page]?.regularFileContents)
        
        page = NSKeyedUnarchiver.unarchiveObject(with: data!) as? CTAPage
    }
    
    /*
    The document data to be saved, or nil if you cannot return document data. 
    
    The returned object is typically an instance of the NSData class for flat files or the NSFileWrapper class for file packages. 
    
    If you return nil, you should also return an error object in outError.
    */
    override func contents(forType typeName: String) throws -> Any {
        
//        if root.fileWrappers?[WrapperKey.page] == nil {
        let cleanPage = page!.cleanEmptyContainers()
        let pageData = NSKeyedArchiver.archivedData(withRootObject: cleanPage)
        let pageWrapper = FileWrapper(regularFileWithContents: pageData)
        if let prePage = root.fileWrappers?[WrapperKey.page] {
            root.removeFileWrapper(prePage)
        }
        pageWrapper.preferredFilename = WrapperKey.page
        root.addFileWrapper(pageWrapper)
        root.addFileWrapper(res)

        return rootWrapper
    }
    
    func replaceOriginResourceIfNeed() {
        
        if let name = cacheFileName, let data = cacheResourceBy(name) {
            storeResource(data, withName: name)
        }
    }
    
    func storeResource(_ data: Data, withName name: String) -> String {
        
        if let file = res.fileWrappers?[name] {
            res.removeFileWrapper(file)
        }
        let resWrap = FileWrapper(regularFileWithContents: data)
        resWrap.preferredFilename = name
        return res.addFileWrapper(resWrap)
    }
    
    func storeCacheResource(_ data: Data, withName name: String) {
        
        let fileManager = FileManager.default
        let cache = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let cacheFile = cache.appendingPathComponent(name)
        if fileManager.fileExists(atPath: cacheFile.path) {
            do {
                try fileManager.removeItem(at: cacheFile)
                cacheFileName = name
                try? data.write(to: cacheFile, options: [])
            } catch {
                print("Store Cache Resource fail")
            }
        } else {
            cacheFileName = name
            try? data.write(to: cacheFile, options: [])
        }
    }

    // get
    func resourceBy(_ name: String) -> Data? {
        
        return resWrapper.fileWrappers?[name]?.regularFileContents
    }
    
    func resourceImageBy(_ name: String) -> UIImage? {
        if let data = resourceBy(name) {
            return UIImage(data: data)
        } else {
            return nil
        }
        
    }
    
    func imageBy(_ name: String) -> UIImage? {
        
        if let data = cacheResourceBy(name) {
            return UIImage(data: data)
        } else {
            return nil
        }
        
    }

    func cacheResourceBy(_ name: String) -> Data? {
        
        let fileManager = FileManager.default
        let cache = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let cacheFile = cache.appendingPathComponent(name)
        if fileManager.fileExists(atPath: cacheFile.path) {
            return (try? Data(contentsOf: cacheFile))
        } else {
            return resourceBy(name)
        }
    }
    
//    func filteredImageWithName(name: String) -> UIImage? {
//        
//    }
}

extension CTADocument {
    
    func filePaths() -> (String , [String: String]) { // relativePath: filePath
        
    var filePaths = [String: String]()
        let url = fileURL
        let publishID = fileURL.lastPathComponent
        let pageUrl = url.appendingPathComponent(WrapperKey.page)
        let resDirUrl = url.appendingPathComponent(WrapperKey.resource)
    
        let pagePath = publishID + "/" + WrapperKey.page
        
        
        filePaths[pagePath] = pageUrl.path
        
        if let resourceFileWrappers = res.fileWrappers {
            
            for r in resourceFileWrappers.values {
                if let fileName = r.filename, r.isRegularFile {
                    let resUrl = resDirUrl.appendingPathComponent(fileName)
                    let resPath = publishID + "/" + fileName
                    
                    filePaths[resPath] = resUrl.path
                }
            }
        }
        
        return (pagePath, filePaths)
    }
}
