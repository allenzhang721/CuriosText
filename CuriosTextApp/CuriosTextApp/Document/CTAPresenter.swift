//
//  CTAPresenter.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 12/15/15.
//  Copyright © 2015 botai. All rights reserved.
//

import Foundation

final class CTAPresenter: CTADocumentAccesser {
    
    var page = CTAPage(containers: [CTAContainer]())
    
    internal var pageData: Data {
        return NSKeyedArchiver.archivedData(withRootObject: page)
    }
    
    internal func retrivedPageData(_ data: Data?) {
        
        guard let data = data, let page = NSKeyedUnarchiver.unarchiveObject(with: data) as? CTAPage else {
            return
        }
        updatePage(page)
    }
    
    func updatePage(_ page: CTAPage) {
        self.page = page
    }
    
    init(page: CTAPage?) {
        if let page = page {
            self.page = page
        }
    }
}
