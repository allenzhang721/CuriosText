//
//  DetailAction.swift
//  CuriosTextApp
//
//  Created by Emiaostein on 6/16/16.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

class PublishDetailAction: NSObject {
    
    class func publishDetailVieController(paras: [String: AnyObject]) -> UIViewController {
        guard let seletedPublishID = paras["selectedPublishID"] as? String else { fatalError() }
        guard let publishArray = paras["publishArray"] as? Array<CTAPublishModel> else { fatalError() }
        guard let type = paras["type"] as? String else { fatalError() }
        let userID = paras["viewUserID"] as? String
        
        let vc = PublishDetailViewController()
        vc.selectedPublishID = seletedPublishID
        vc.publishArray = publishArray
        vc.delegate = paras["delegate"] as? PublishDetailViewDelegate
        vc.type = PublishDetailType(rawValue: type)!
        vc.viewUserID = userID == nil ? "" : userID!
        
        return vc
    }
}
