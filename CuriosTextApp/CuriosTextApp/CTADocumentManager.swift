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
    static var openedDocumentPublishID: String? {
        return CTADocumentManager.openedDocument?.fileURL.lastPathComponent
    }
    
    class func generateDocumentURL(_ fileRootURL: URL) -> URL {
        
        let publishID = CTAIDGenerator.generateID()
        let fileURL = fileRootURL.appendingPathComponent(publishID)
        return fileURL
    }
    
    class func createNewDocumentAt(_ docUrl: URL, page:CTAPage?, completedBlock:((Bool) -> Void)?) {
        
        let doc = CTADocument(fileURL: docUrl, page: page)
        doc.save(to: docUrl, for: .forCreating) { (success) -> Void in
            completedBlock?(success)
        }
    }
    
    class func openDocument(_ docUrl: URL, completedBlock:((Bool) -> Void)?) {
        
        let doc = CTADocument(fileURL: docUrl, page: nil)
        doc.open { (success) -> Void in
            
            if success {
                openedDocument = doc
            }
            
            completedBlock?(success)
        }
    }
    
    class func closeDoucment(_ completedBlock:((Bool) -> Void)?) {
        
        guard let openedDocument = openedDocument else {
            return
        }
        
        openedDocument.close { (success) -> Void in
            
            if success {
                self.openedDocument = nil
            }
            
            completedBlock?(success)
        }
    }
    
    class func saveDoucment(_ completedBlock:((Bool) -> Void)?) {
        
        guard let openedDocument = openedDocument else {
            completedBlock?(false)
            return
        }
        
        openedDocument.save(to: openedDocument.fileURL, for: .forOverwriting) { (success) in
            if success {
                
                let urls = try! FileManager.default.contentsOfDirectory(at: openedDocument.fileURL, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions(rawValue: 0))
                
                for u in urls {
                    
                    debug_print(u, context: previewConttext)
                    
                    if let data = try? Data(contentsOf: u), let apage = NSKeyedUnarchiver.unarchiveObject(with: data) as? CTAPage {
                        
                        for c in apage.containers {
                            if c.type == .text {
                                debug_print("didSavedData = \(c.textElement?.texts)", context: previewConttext)
                                //                    debugPrint(c.textElement?.texts, context: previewConttext)
                            }
                        }
                    }
                }
            }
            
            
            
            
            for c in openedDocument.page!.containers {
                if c.type == .text {
                    debug_print("saved page = \(c.textElement?.texts)", context: previewConttext)
//                    debugPrint(c.textElement?.texts, context: previewConttext)
                }
            }
            
            
            completedBlock?(success)
        }
    }
}

extension CTADocumentManager {
    
    class func uploadFiles(_ progressBlock:((String, Float) -> Void)?, completedBlock:((Bool, String, String) -> Void)?) { // success?, publishID, 'publishID' + 'Page'
        
        guard let openedDocument = openedDocument else {
            return
        }
        let publishID = openedDocument.fileURL.lastPathComponent
        let result = openedDocument.filePaths()
        let files = result.1
        let publishPath = result.0
        let tokenModels = Array(files.keys).map {CTAUpTokenModel(upTokenKey: $0)}
        
        debug_print(files)
        
        CTAUpTokenDomain().publishUpToken(tokenModels) { (domainListInfo) -> Void in
            
            if let models = domainListInfo.modelArray as? [CTAUpTokenModel] {
                
                let uploadModels = models.map {CTAUploadModel(key: $0.upTokenKey, token: $0.upToken, filePath: files[$0.upTokenKey]!)}
                CTAUploadAction().uploadFileArray(publishID, uploadArray: uploadModels, progress: { (uploadProgressInfo) in
                        progressBlock?(uploadProgressInfo.uploadID, uploadProgressInfo.progress)
                    }, complete: { (uploadInfo) in
                        completedBlock?(uploadInfo.result, publishID, publishPath)
                })
                
            } else {
                completedBlock?(false, publishID, publishPath)
            }
        }
    }
}
