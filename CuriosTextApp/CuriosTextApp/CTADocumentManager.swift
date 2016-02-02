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
        
        openedDocument.savePresentedItemChangesWithCompletionHandler { (error) -> Void in
            
            if let _ = error {
                completedBlock?(false)
            } else {
                completedBlock?(true)
            }
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