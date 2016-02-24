//
//  CTADocumentManager.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 2/1/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

class CTADocumentManager {
    
    static var openedDocument: CTADocument?
    
    class func generateDocumentURL(fileRootURL: NSURL) -> NSURL {
        
        let publishID = CTAIDGenerator.generateID()
        let fileURL = fileRootURL.URLByAppendingPathComponent(publishID)
        return fileURL
    }
    
    class func createNewDocumentAt(docUrl: NSURL, page:CTAPage?, completedBlock:((Bool) -> Void)?) {
        
        let doc = CTADocument(fileURL: docUrl, page: page)
        doc.saveToURL(docUrl, forSaveOperation: .ForCreating) { (success) -> Void in
            completedBlock?(success)
        }
    }
    
    class func openDocument(docUrl: NSURL, completedBlock:((Bool) -> Void)?) {
        
        let doc = CTADocument(fileURL: docUrl, page: nil)
        doc.openWithCompletionHandler { (success) -> Void in
            
            if success {
                openedDocument = doc
            }
            
            completedBlock?(success)
        }
    }
    
    class func closeDoucment(completedBlock:((Bool) -> Void)?) {
        
        guard let openedDocument = openedDocument else {
            return
        }
        
        openedDocument.closeWithCompletionHandler { (success) -> Void in
            
            if success {
                self.openedDocument = nil
            }
            
            completedBlock?(success)
        }
    }
    
    class func saveDoucment(completedBlock:((Bool) -> Void)?) {
        
        guard let openedDocument = openedDocument else {
            completedBlock?(false)
            return
        }
        
        openedDocument.saveToURL(openedDocument.fileURL, forSaveOperation: .ForOverwriting) { (success) in
            if success {
                
                let urls = try! NSFileManager.defaultManager().contentsOfDirectoryAtURL(openedDocument.fileURL, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions(rawValue: 0))
                
                for u in urls {
                    
                    debug_print(u, context: previewConttext)
                    
                    if let data = NSData(contentsOfURL: u), let apage = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? CTAPage {
                        
                        for c in apage.containers {
                            if c.type == .Text {
                                debug_print("didSavedData = \(c.textElement?.texts)", context: previewConttext)
                                //                    debugPrint(c.textElement?.texts, context: previewConttext)
                            }
                        }
                    }
                }
            }
            
            
            
            
            for c in openedDocument.page!.containers {
                if c.type == .Text {
                    debug_print("saved page = \(c.textElement?.texts)", context: previewConttext)
//                    debugPrint(c.textElement?.texts, context: previewConttext)
                }
            }
            
            
            completedBlock?(success)
        }
    }
}

extension CTADocumentManager {
    
    class func uploadFiles(completedBlock:((Bool, String, String) -> Void)?) { // success?, publishID, 'publishID' + 'Page'
        
        guard let openedDocument = openedDocument else {
            return
        }
        let publishID = openedDocument.fileURL.lastPathComponent!
        let result = openedDocument.filePaths()
        let files = result.1
        let publishPath = result.0
        let tokenModels = Array(files.keys).map {CTAUpTokenModel(upTokenKey: $0)}
        
        debug_print(files)
        
        CTAUpTokenDomain().publishUpToken(tokenModels) { (domainListInfo) -> Void in
            
            if let models = domainListInfo.modelArray as? [CTAUpTokenModel] {
                
                let uploadModels = models.map {CTAUploadModel(key: $0.upTokenKey, token: $0.upToken, filePath: files[$0.upTokenKey]!)}
                
                CTAUploadAction().uploadFileArray(publishID, uploadArray: uploadModels, progress: { (uploadProgressInfo) -> Void in
                    
                    
                    }, complete: { (uploadInfo) -> Void in
                            
                        completedBlock?(uploadInfo.result, publishID, publishPath)
                })
                
            } else {
                completedBlock?(false, publishID, publishPath)
            }
        }
    }
}