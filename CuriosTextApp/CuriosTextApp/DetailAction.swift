//
//  DetailAction.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

class DetailAction: NSObject {
    
    class func publishDetailVieController(paras: [String: AnyObject]) -> UIViewController {
        guard let seletedPublishID = paras["selectedPublishID"] as? String else { fatalError() }
        guard let publishArray = paras["publishArray"] as? Array<CTAPublishModel> else { fatalError() }
        
        let vc = DetailViewController()
        vc.selectedPublishID = seletedPublishID
        vc.publishArray = publishArray
        return vc
    }
}
